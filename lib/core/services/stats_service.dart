import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/results/quiz_result_model.dart';
import '../../core/services/quiz_service.dart';

/// Expert Persistence Service: Uses a hybrid approach with Memory Caching, 
/// SharedPreferences (Fast), and FlutterSecureStorage (Secure) to ensure 
/// maximum fluidity and performance.
class StatsService {
  static const String _xpKey = 'user_xp';
  static const String _historyKey = 'quiz_history';
  static const String _firstRunKey = 'first_run_complete';
  static const String _masteredKey = 'mastered_question_ids';
  static const String _failedKey = 'failed_question_ids';
  static const String _exposureKey = 'question_exposure_counts';
  static const String _eligibilityKey = 'eligibility_verified';
  
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static SharedPreferences? _prefs;

  // --- EXPERT CACHE LAYER ---
  static Set<String>? _cacheMastered;
  static Set<String>? _cacheFailed;
  static Map<String, int>? _cacheExposure;
  static int? _cacheXp;
  static List<QuizResult>? _cacheHistory;

  static Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Global cold start: Call this in main() to eliminate all first-access jank.
  static Future<void> init() async {
    await _ensurePrefs();
    // Warm up all caches
    await getGlobalXp();
    await getMasteredIds();
    await getFailedIds();
    await getExposureCounts();
    await getHistory();
  }

  static Future<bool> isFirstRun() async {
    await _ensurePrefs();
    return !(_prefs!.getBool(_firstRunKey) ?? false);
  }

  static Future<void> setFirstRunComplete() async {
    await _ensurePrefs();
    await _prefs!.setBool(_firstRunKey, true);
  }

  // --- ELIGIBILITY ---
  static Future<bool> isEligibilityVerified() async {
    await _ensurePrefs();
    return _prefs!.getBool(_eligibilityKey) ?? false;
  }

  static Future<void> setEligibilityVerified(bool value) async {
    await _ensurePrefs();
    await _prefs!.setBool(_eligibilityKey, value);
  }

  // --- XP (Optimized) ---
  static Future<int> getGlobalXp() async {
    if (_cacheXp != null) return _cacheXp!;
    await _ensurePrefs();
    _cacheXp = _prefs!.getInt(_xpKey) ?? 0;
    return _cacheXp!;
  }

  static Future<void> addXp(int amount) async {
    int current = await getGlobalXp();
    _cacheXp = current + amount;
    // Fast Async write to Prefs
    await _ensurePrefs();
    _prefs!.setInt(_xpKey, _cacheXp!);
  }

  // --- MASTERY (Optimized with Set Cache) ---
  static Future<Set<String>> getMasteredIds() async {
    if (_cacheMastered != null) return _cacheMastered!;
    await _ensurePrefs();
    final List<String> data = _prefs!.getStringList(_masteredKey) ?? [];
    _cacheMastered = data.toSet();
    return _cacheMastered!;
  }

  static Future<void> markQuestionAsMastered(String id) async {
    final Set<String> current = await getMasteredIds();
    if (current.add(id)) {
      _cacheMastered = current;
      await _ensurePrefs();
      _prefs!.setStringList(_masteredKey, current.toList());
      await addXp(5);
    }
  }

  // --- ADAPTIVE TRACKING (Fast Rotation) ---
  static Future<Set<String>> getFailedIds() async {
    if (_cacheFailed != null) return _cacheFailed!;
    await _ensurePrefs();
    final List<String> data = _prefs!.getStringList(_failedKey) ?? [];
    _cacheFailed = data.toSet();
    return _cacheFailed!;
  }

  static Future<void> markQuestionAsFailed(String id) async {
    final Set<String> current = await getFailedIds();
    if (current.add(id)) {
      _cacheFailed = current;
      await _ensurePrefs();
      _prefs!.setStringList(_failedKey, current.toList());
    }
  }

  static Future<void> removeQuestionFromFailed(String id) async {
    final Set<String> current = await getFailedIds();
    if (current.remove(id)) {
      _cacheFailed = current;
      await _ensurePrefs();
      _prefs!.setStringList(_failedKey, current.toList());
    }
  }

  static Future<Map<String, int>> getExposureCounts() async {
    if (_cacheExposure != null) return _cacheExposure!;
    await _ensurePrefs();
    final String? data = _prefs!.getString(_exposureKey);
    if (data == null) {
      _cacheExposure = {};
    } else {
      try {
        final Map<String, dynamic> decoded = json.decode(data);
        _cacheExposure = decoded.map((k, v) => MapEntry(k, v as int));
      } catch (_) {
        _cacheExposure = {};
      }
    }
    return _cacheExposure!;
  }

  static Future<void> incrementExposure(String id) async {
    final Map<String, int> counts = await getExposureCounts();
    counts[id] = (counts[id] ?? 0) + 1;
    _cacheExposure = counts;
    await _ensurePrefs();
    _prefs!.setString(_exposureKey, json.encode(counts));
  }

  // --- ANALYTICS & STATS ---
  static Future<int> getTotalQuestions() async {
    final history = await getHistory();
    return history.fold<int>(0, (sum, res) => sum + res.total);
  }

  static Future<Map<String, double>> getThemeProficiency() async {
    final history = await getHistory();
    if (history.isEmpty) return {};

    final Map<String, List<double>> groups = {};
    for (final res in history) {
      final theme = res.theme.toUpperCase();
      groups.putIfAbsent(theme, () => []).add(res.precision.toDouble());
    }

    final Map<String, double> averages = {};
    groups.forEach((theme, scores) {
      averages[theme] = scores.reduce((a, b) => a + b) / scores.length;
    });

    return averages;
  }

  static Future<List<double>> getPrecisionHistory() async {
    final history = await getHistory();
    return history.reversed.take(10).toList().reversed.map((e) => e.precision.toDouble()).toList();
  }

  // --- HISTORY (Batched Result Saving) ---
  static Future<List<QuizResult>> getHistory() async {
    if (_cacheHistory != null) return _cacheHistory!;
    await _ensurePrefs();
    final String? data = _prefs!.getString(_historyKey);
    if (data == null) {
      _cacheHistory = [];
    } else {
      try {
        final List<dynamic> decoded = json.decode(data);
        _cacheHistory = decoded.map((j) => QuizResult.fromJson(Map<String, dynamic>.from(j))).toList();
      } catch (_) {
        _cacheHistory = [];
      }
    }
    return _cacheHistory!;
  }

  static Future<void> saveResult(QuizResult result) async {
    final List<QuizResult> history = await getHistory();
    if (history.any((r) => r.id == result.id)) return;
    history.insert(0, result);
    _cacheHistory = history.take(50).toList();
    
    await _ensurePrefs();
    _prefs!.setString(_historyKey, json.encode(_cacheHistory!.map((r) => r.toJson()).toList()));
  }

  // --- CLEANUP ---
  static Future<void> resetData() async {
    await _ensurePrefs();
    await _prefs!.clear();
    await _storage.deleteAll();
    _cacheMastered = null;
    _cacheFailed = null;
    _cacheExposure = null;
    _cacheXp = null;
    _cacheHistory = null;
  }

  // --- PATHWAY PERSISTENCE ---
  static Future<void> saveSelectedPathway(String name, String code, int threshold) async {
    try {
      await _storage.write(key: 'path_name', value: name);
      await _storage.write(key: 'path_code', value: code);
      await _storage.write(key: 'path_threshold', value: threshold.toString());
    } catch (e) {
      debugPrint('Error saving pathway to secure storage: $e');
    }
  }

  static Future<Map<String, dynamic>?> getSelectedPathway() async {
    try {
      final String? code = await _storage.read(key: 'path_code');
      if (code == null) return null;

      final String? threshStr = await _storage.read(key: 'path_threshold');

      return {
        'name': await _storage.read(key: 'path_name') ?? 'INCONNU',
        'code': code,
        'threshold': threshStr != null ? (int.tryParse(threshStr) ?? 80) : 80,
      };
    } catch (e) {
      debugPrint('Error reading pathway from secure storage: $e');
      return null;
    }
  }

  static Future<void> clearSelectedPathway() async {
    try {
      await _storage.delete(key: 'path_name');
      await _storage.delete(key: 'path_code');
      await _storage.delete(key: 'path_threshold');
    } catch (e) {
      debugPrint('Error clearing pathway from secure storage: $e');
    }
  }

  static Future<Map<String, dynamic>> getGlobalPerformance() async {
    final history = await getHistory();
    if (history.isEmpty) return {'average': 0, 'totalQuizzes': 0, 'avgTime': 0};
    
    double totalPrecision = 0;
    int totalSeconds = 0;
    for (var r in history) {
      totalPrecision += r.precision;
      totalSeconds += r.durationSeconds;
    }
    
    final int totalQuestions = history.fold<int>(0, (sum, r) => sum + r.total);
    final int average = (totalPrecision / history.length).toInt();
    final int avgTime = totalQuestions <= 0 ? 0 : (totalSeconds / totalQuestions).toInt();
    
    return {
      'average': average.clamp(0, 100),
      'totalQuizzes': history.length,
      'avgTime': avgTime,
    };
  }

  static Future<Map<String, int>> getGlobalProgression() async {
    final masteredIds = await getMasteredIds();
    final totalCorrect = masteredIds.length;
    
    final themeCounts = await QuizService.getThemeCounts();
    final totalInPath = themeCounts.values.fold(0, (sum, count) => sum + count);
    
    return {
      'answered': totalCorrect,
      'total': totalInPath <= 0 ? 1 : totalInPath,
    };
  }

  static Future<double> getThemeProgression(String themeKey) async {
    final mastered = await getMasteredIds();
    final allQuestions = await QuizService.loadQuestions();
    
    final List<String> targetAliases = QuizService.themeAliases[themeKey.toLowerCase()] ?? [themeKey.toLowerCase()];
    
    final themeQuestions = allQuestions.where((q) {
      final matchesPath = QuizService.currentPathCode == 'NONE' || q.parcours.contains(QuizService.currentPathCode);
      final matchesTheme = targetAliases.contains(q.theme.toLowerCase());
      return matchesPath && matchesTheme;
    }).toList();

    if (themeQuestions.isEmpty) return 0.0;
    
    int masteredInTheme = 0;
    for (var q in themeQuestions) {
      if (mastered.contains(q.id)) masteredInTheme++;
    }
    
    return (masteredInTheme / themeQuestions.length).clamp(0.0, 1.0);
  }
}
