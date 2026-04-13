import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../features/quiz/quiz_model.dart';
import 'stats_service.dart';

class QuizService {
  // --- SESSION STATE (Triple Path) ---
  static String currentPathName = 'Non défini';
  static String currentPathCode = 'NONE'; 
  static int currentThreshold = 0;

  // Notifier to allow UI to react to pathway changes
  static final ValueNotifier<String> pathNotifier = ValueNotifier<String>('NONE');
  
  static void setPath(String name, String code, int threshold) {
    currentPathName = name;
    currentPathCode = code.toUpperCase();
    currentThreshold = threshold;
    _cachedCounts = null; 
    pathNotifier.value = currentPathCode; // Notify listeners
    resetSessionHistory(); // Resets history when starting a new pathway
  }

  /// Expert Pre-loading: Load all questions in background to ensure zero lag 
  /// when starting a quiz.
  static Future<void> init() async {
    // Restore pathway
    final savedPath = await StatsService.getSelectedPathway();
    if (savedPath != null) {
      currentPathName = savedPath['name'] ?? 'Non défini';
      currentPathCode = savedPath['code'] ?? 'NONE';
      currentThreshold = savedPath['threshold'] ?? 80;
    }

    await loadQuestions();
    await getThemeCounts();
  }

  // UPDATED: Official 5-Theme Mapping + Alias Flexibility
  // Mapping: UI Category (key) -> Database Themes (values)
  static const Map<String, List<String>> themeAliases = {
    'principes': ['vals_principes', 'principes', 'valeurs', 'democratie'],
    'institutions': ['institutions'],
    'droits': ['droits'],
    'histoire': ['histoire', 'culture', 'histoire_culture'],
    'vie_pratique': ['vie_pratique', 'vie_france', 'vie_quotidienne'],
    'geographie': ['geographie', 'géographie'],
    'europe': ['europe'],
  };

  static const Map<String, String> themeLabels = {
    'principes': 'VALEURS & PRINCIPES',
    'institutions': 'INSTITUTIONS',
    'droits': 'DROITS & CITOYENNETÉ',
    'histoire': 'HISTOIRE & CULTURE',
    'vie_pratique': 'VIE QUOTIDIENNE',
    'geographie': 'GÉOGRAPHIE',
    'europe': 'UNION EUROPÉENNE',
    'random': 'RÉVISION GÉNÉRALE',
    'general': 'RÉVISION GÉNÉRALE',
    'examen_blanc': 'EXAMEN BLANC',
  };

  /// Returns the professional UI label for a given database theme string.
  static String getCategoryForTheme(String dbTheme) {
    final t = dbTheme.toLowerCase();
    
    // 1. Check aliases first
    for (var entry in themeAliases.entries) {
      if (entry.value.contains(t)) {
        return themeLabels[entry.key] ?? entry.key.toUpperCase();
      }
    }
    
    // 2. Direct map check
    if (themeLabels.containsKey(t)) return themeLabels[t]!;
    
    // 3. Fallback
    return t.toUpperCase();
  }

  static List<QuizQuestion>? _cachedQuestions;
  static Map<String, int>? _cachedCounts;
  
  // Track seen questions during the current session
  static final Set<String> _seenQuestionIds = {};

  static Future<List<QuizQuestion>> loadQuestions() async {
    if (_cachedQuestions != null) return _cachedQuestions!;
    
    try {
      final String response = await rootBundle.loadString('assets/data/questions.json');
      final List<dynamic> data = json.decode(response);
      _cachedQuestions = data.map((json) => QuizQuestion.fromJson(json)).toList();
      return _cachedQuestions!;
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, int>> getThemeCounts() async {
    if (_cachedCounts != null) return _cachedCounts!;
    
    final all = await loadQuestions();
    final counts = <String, int>{};
    for (var q in all) {
      if (currentPathCode == 'NONE' || q.parcours.contains(currentPathCode)) {
        final category = getCategoryForTheme(q.theme);
        counts[category] = (counts[category] ?? 0) + 1;
      }
    }
    _cachedCounts = counts;
    return counts;
  }

  static void resetSessionHistory() {
    _seenQuestionIds.clear();
  }

  static Future<List<QuizQuestion>> loadByTheme(String theme) async {
    final allQuestions = await loadQuestions();
    
    // 1. Initial Filtering (Pathway & Basic Uniqueness)
    final List<QuizQuestion> eligibleQuestions = _filterEligible(allQuestions);
    
    // 2. Load Heuristics
    final masteredIds = await StatsService.getMasteredIds();
    final failedIds = await StatsService.getFailedIds();
    final exposure = await StatsService.getExposureCounts();

    // 3. Theme Resolution
    final isGeneral = ['general', 'random', 'examen_blanc'].contains(theme.toLowerCase());
    final List<String> targetAliases = themeAliases[theme.toLowerCase()] ?? [theme.toLowerCase()];
    int limit = isGeneral && theme.toLowerCase() == 'examen_blanc' ? 40 : 20;

    final List<QuizQuestion> themePool = isGeneral 
        ? eligibleQuestions 
        : eligibleQuestions.where((q) => targetAliases.contains(q.theme.toLowerCase())).toList();

    if (themePool.isEmpty) return [];

    // 4. Partition into Strictly Disjoint Learning Pools
    // Pool A: Recently Failed (High Priority)
    final List<QuizQuestion> failedPool = themePool.where((q) => failedIds.contains(q.id)).toList();
    
    // Pool B: Unseen / New (Medium-High Priority) - Strictly excluding failed and mastered
    final List<QuizQuestion> unseenPool = themePool.where((q) => 
      !failedIds.contains(q.id) && 
      !masteredIds.contains(q.id)
    ).toList();
    
    // Pool C: Mastered (Maintenance / Rotation) - Excluding if they are also in failed (should not happen but for safety)
    final List<QuizQuestion> masteredPool = themePool.where((q) => 
      masteredIds.contains(q.id) && 
      !failedIds.contains(q.id)
    ).toList();

    // 5. Apply Session-Level Rotation (Penalize questions already seen in this session)
    // We sort such that session-unseen items come first
    int sessionSort(QuizQuestion a, QuizQuestion b) {
      final seenA = _seenQuestionIds.contains(a.id) ? 1 : 0;
      final seenB = _seenQuestionIds.contains(b.id) ? 1 : 0;
      if (seenA != seenB) return seenA.compareTo(seenB);
      // Secondary sort by global exposure
      return (exposure[a.id] ?? 0).compareTo(exposure[b.id] ?? 0);
    }

    failedPool.sort(sessionSort);
    unseenPool.sort(sessionSort);
    masteredPool.sort(sessionSort);

    // 6. Assembly with Balanced Distribution (Weights)
    final List<QuizQuestion> finalSelection = [];
    final int targetFailed = (limit * 0.4).ceil();
    final int targetUnseen = (limit * 0.4).ceil();

    void fillBalanced(List<QuizQuestion> source, int count) {
      final available = source.where((q) => !finalSelection.contains(q)).toList();
      final toTake = available.length < count ? available.length : count;
      finalSelection.addAll(available.take(toTake));
    }

    fillBalanced(failedPool, targetFailed);
    fillBalanced(unseenPool, targetUnseen);
    
    // Fill remaining with mastered or whatever is left
    final leftToFill = limit - finalSelection.length;
    if (leftToFill > 0) {
      final remainder = [
        ...masteredPool, 
        ...unseenPool,
        ...failedPool,
      ].where((q) => !finalSelection.contains(q)).toList();
      
      // Sort remainder by session-seen state before taking
      remainder.sort(sessionSort);
      finalSelection.addAll(remainder.take(leftToFill));
    }

    // 7. Track newly selected for session uniqueness
    for (var q in finalSelection) {
      _seenQuestionIds.add(q.id);
      StatsService.incrementExposure(q.id);
    }

    return finalSelection.map((q) => q.getShuffledCopy()).toList()..shuffle();
  }

  static List<QuizQuestion> _filterEligible(List<QuizQuestion> source) {
    final Map<String, QuizQuestion> uniqueMap = {};
    for (var q in source) {
      final matchesPath = currentPathCode == 'NONE' || q.parcours.contains(currentPathCode);
      if (!matchesPath) continue;

      // ADVANCED NORMALIZATION: Detect duplicates even with different punctuation or spacing
      final normalizedText = q.question
          .toLowerCase()
          .replaceAll(RegExp(r'[^\w\s]'), '') // Remove punctuation
          .replaceAll(RegExp(r'\s+'), ' ')   // Collapse spaces
          .trim();

      if (!uniqueMap.containsKey(q.id) && !uniqueMap.containsKey(normalizedText)) {
        uniqueMap[q.id] = q;
        uniqueMap[normalizedText] = q;
      }
    }
    return uniqueMap.values.toSet().toList();
  }
}
