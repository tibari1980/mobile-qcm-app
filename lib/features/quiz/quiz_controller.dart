import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/services/quiz_service.dart';
import '../../core/services/stats_service.dart';
import '../results/quiz_result_model.dart';
import 'quiz_model.dart';

class QuizController extends ChangeNotifier {
  final String theme;
  final bool isExamMode;
  
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  int? _selectedAnswerIndex;
  bool _hasAnswered = false;
  
  // Dynamic Stats
  int _timeLeft = 45; // 45 seconds per question
  int _sessionXp = 0;
  int _globalXp = 1250;
  Timer? _timer;
  final String sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool _isSaved = false;
  DateTime? _startTime;
  final Map<String, int> _correctThemeCounts = {}; // {theme: correct_count}
  
  QuizController({required this.theme}) : isExamMode = theme.toLowerCase() == 'examen_blanc' {
    _init();
  }

  // Getters
  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get isLoading => _isLoading;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get hasAnswered => _hasAnswered;
  int get timeLeft => _timeLeft;
  int get sessionXp => _sessionXp;
  int get globalXp => _globalXp;
  bool get isFinished => _currentIndex >= _questions.length - 1 && _hasAnswered;
  DateTime? get startTime => _startTime;
  bool get wasTimeout => _selectedAnswerIndex == -1;

  Future<void> _init() async {
    _globalXp = await StatsService.getGlobalXp();
    _questions = await QuizService.loadByTheme(theme);
    _isLoading = false;
    _startTime = DateTime.now(); // START TRACKING TIME
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_hasAnswered) {
        _timeLeft--;
        notifyListeners();
      } else if (_timeLeft == 0 && !_hasAnswered) {
        answerQuestion(-1); // Fail on timeout
      } else {
        _timer?.cancel();
      }
    });
  }

  void answerQuestion(int index) {
    if (_hasAnswered || _questions.isEmpty) return; // Safety check for empty questions
    
    _timer?.cancel();
    _selectedAnswerIndex = index;
    _hasAnswered = true;
    
    final question = _questions[_currentIndex];
    final bool isCorrect = index != -1 && index == question.answerIndex;
    
    if (isCorrect) {
      _score++;
      _sessionXp += 50; 
      StatsService.addXp(50);
      _globalXp += 50;

      final themeCategory = QuizService.getCategoryForTheme(question.theme);
      _correctThemeCounts[themeCategory] = (_correctThemeCounts[themeCategory] ?? 0) + 1;
      
      // PERSISTENT MASTERY: Mark this specific question as mastered
      StatsService.markQuestionAsMastered(question.id);
      
      // Remove from failed list if it was there (Now corrected)
      StatsService.removeQuestionFromFailed(question.id);
    } else {
      // TRACK FAILURE for adaptive learning
      StatsService.markQuestionAsFailed(question.id);
    }
    
    if (isFinished) {
      _autoSaveResult();
    }
    
    notifyListeners();
  }

  /// Returns a map of theme names to [correct, total] for the current session
  Map<String, List<int>> getSessionThemeStats() {
    final Map<String, List<int>> stats = {};
    final limit = _hasAnswered ? _currentIndex + 1 : _currentIndex;
    
    for (int i = 0; i < limit && i < _questions.length; i++) {
        final q = _questions[i];
        final theme = QuizService.getCategoryForTheme(q.theme);
        stats.putIfAbsent(theme, () => [0, 0]);
        stats[theme]![1]++; // Increment total
    }
    
    // Add correct counts
    _correctThemeCounts.forEach((theme, count) {
      if (stats.containsKey(theme)) {
        stats[theme]![0] = count;
      }
    });

    return stats;
  }

  Future<void> _autoSaveResult() async {
    if (_isSaved || _startTime == null) return;
    _isSaved = true;

    final int durationSeconds = DateTime.now().difference(_startTime!).inSeconds;

    final result = QuizResult(
      id: sessionId,
      date: DateTime.now(),
      score: _score,
      total: _questions.length,
      theme: theme,
      path: QuizService.currentPathCode,
      durationSeconds: durationSeconds,
    );
    await StatsService.saveResult(result);
  }

  bool nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswerIndex = null;
      _hasAnswered = false;
      _startTimer();
      notifyListeners();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
