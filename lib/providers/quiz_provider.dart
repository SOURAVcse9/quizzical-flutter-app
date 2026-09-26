import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/question.dart';
import '../services/trivia_service.dart';

/// Represents a quiz attempt record for answer review.
class QuizAnswerRecord {
  final Question question;
  final String? selectedAnswer;
  final bool isCorrect;
  final int timeSpentSeconds;

  const QuizAnswerRecord({
    required this.question,
    required this.selectedAnswer,
    required this.isCorrect,
    required this.timeSpentSeconds,
  });
}

/// Statistics per category: quizzes played, best score percentage, last score
class CategoryStats {
  final int categoryId;
  final int quizzesPlayed;
  final int bestScore;
  final int lastScore;

  const CategoryStats({
    required this.categoryId,
    this.quizzesPlayed = 0,
    this.bestScore = 0,
    this.lastScore = 0,
  });

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'quizzesPlayed': quizzesPlayed,
    'bestScore': bestScore,
    'lastScore': lastScore,
  };

  factory CategoryStats.fromJson(Map<String, dynamic> json) => CategoryStats(
    categoryId: json['categoryId'] as int? ?? 0,
    quizzesPlayed: json['quizzesPlayed'] as int? ?? 0,
    bestScore: json['bestScore'] as int? ?? 0,
    lastScore: json['lastScore'] as int? ?? 0,
  );
}

/// Central state management for Quizzical application with SharedPreferences persistence,
/// favorites, recently played, category stats, daily challenge, streak tracking, and exam features.
class QuizProvider extends ChangeNotifier {
  final TriviaService _triviaService = TriviaService();

  // User Profile
  String _userName = 'Your_Name';
  int _bestScorePercentage = 0;
  int? _lastPlayedCategoryId;

  // Favorites & Recently Played
  Set<int> _favoriteCategoryIds = {};
  List<int> _recentlyPlayedCategoryIds = [];

  // Category Personal Stats (categoryId -> CategoryStats)
  Map<int, CategoryStats> _categoryStats = {};

  // Daily Streak & Challenge
  int _dailyStreak = 1;
  String _lastStreakDate = '';
  bool _dailyChallengeCompletedToday = false;
  int? _dailyChallengeScore;
  bool _isDailyChallengeActive = false;

  // Category State
  List<Category> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoriesError;
  Category? _selectedCategory;

  // Configuration State
  int _numberOfQuestions = 10;
  String _difficulty = 'Any Difficulty'; // 'Any Difficulty', 'Easy', 'Medium', 'Hard'
  String _questionType = 'multiple'; // 'multiple' or 'boolean'

  // Quiz Execution State
  List<Question> _questions = [];
  bool _isLoadingQuestions = false;
  String? _questionsError;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _isAnswerSubmitted = false;
  int _correctAnswers = 0;
  int _currentStreak = 0;
  int _bestStreakInSession = 0;

  // Answer Records for Post-Quiz Review
  final List<QuizAnswerRecord> _answerRecords = [];

  // Timer per question (30 seconds)
  Timer? _timer;
  int _remainingSeconds = 30;
  static const int questionDuration = 30;
  int _totalTimeSpentSeconds = 0;

  QuizProvider() {
    _loadPreferences();
  }

  // --- Getters ---
  String get userName => _userName;
  int get bestScorePercentage => _bestScorePercentage;
  int? get lastPlayedCategoryId => _lastPlayedCategoryId;

  Set<int> get favoriteCategoryIds => Set.unmodifiable(_favoriteCategoryIds);
  List<int> get recentlyPlayedCategoryIds => List.unmodifiable(_recentlyPlayedCategoryIds);
  int get dailyStreak => _dailyStreak;
  bool get isDailyChallengeCompletedToday => _dailyChallengeCompletedToday;
  int? get dailyChallengeScore => _dailyChallengeScore;
  bool get isDailyChallengeActive => _isDailyChallengeActive;

  List<Category> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoriesError => _categoriesError;
  Category? get selectedCategory => _selectedCategory;

  int get numberOfQuestions => _numberOfQuestions;
  String get difficulty => _difficulty;
  String get questionType => _questionType;

  List<Question> get questions => _questions;
  bool get isLoadingQuestions => _isLoadingQuestions;
  String? get questionsError => _questionsError;
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get selectedAnswer => _selectedAnswer;
  bool get isAnswerSubmitted => _isAnswerSubmitted;
  int get correctAnswers => _correctAnswers;
  int get incorrectAnswers => _questions.length - _correctAnswers;
  int get currentStreak => _currentStreak;
  int get bestStreakInSession => _bestStreakInSession;
  int get remainingSeconds => _remainingSeconds;
  int get totalTimeSpentSeconds => _totalTimeSpentSeconds;
  List<QuizAnswerRecord> get answerRecords => List.unmodifiable(_answerRecords);

  int get totalQuestions => _questions.length;

  Question? get currentQuestion {
    if (_questions.isNotEmpty && _currentQuestionIndex < _questions.length) {
      return _questions[_currentQuestionIndex];
    }
    return null;
  }

  bool get isLastQuestion =>
      _questions.isNotEmpty && _currentQuestionIndex == _questions.length - 1;

  double get quizProgress {
    if (_questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _questions.length;
  }

  int get scorePercentage {
    if (_questions.isEmpty) return 0;
    return ((_correctAnswers / _questions.length) * 100).round();
  }

  // --- Favorites & Category Stats Methods ---
  bool isFavorite(int categoryId) => _favoriteCategoryIds.contains(categoryId);

  Future<void> toggleFavorite(int categoryId) async {
    if (_favoriteCategoryIds.contains(categoryId)) {
      _favoriteCategoryIds.remove(categoryId);
    } else {
      _favoriteCategoryIds.add(categoryId);
    }
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'favorite_categories',
        _favoriteCategoryIds.map((id) => id.toString()).toList(),
      );
    } catch (_) {}
  }

  CategoryStats getCategoryStats(int categoryId) {
    return _categoryStats[categoryId] ?? CategoryStats(categoryId: categoryId);
  }

  /// Deterministic Daily Challenge calculation for the current day
  Category? getTodaysChallengeCategory() {
    if (_categories.isEmpty) return null;
    final now = DateTime.now();
    final dayIndex = (now.year * 1000 + now.month * 50 + now.day) % _categories.length;
    return _categories[dayIndex];
  }

  Future<bool> startDailyChallenge() async {
    final cat = getTodaysChallengeCategory();
    if (cat == null) return false;
    _selectedCategory = cat;
    _numberOfQuestions = 10;
    _difficulty = 'Medium';
    _questionType = 'multiple';
    _isDailyChallengeActive = true;
    return startQuiz();
  }

  // --- Preferences Persistence ---
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _userName = prefs.getString('user_name') ?? 'Your_Name';
      _bestScorePercentage = prefs.getInt('best_score_percentage') ?? 0;
      _lastPlayedCategoryId = prefs.getInt('last_category_id');
      _numberOfQuestions = prefs.getInt('saved_amount') ?? 10;
      _difficulty = prefs.getString('saved_difficulty') ?? 'Any Difficulty';
      _questionType = prefs.getString('saved_type') ?? 'multiple';

      // Load favorites
      final favList = prefs.getStringList('favorite_categories');
      if (favList != null) {
        _favoriteCategoryIds = favList.map((id) => int.tryParse(id) ?? 0).where((id) => id > 0).toSet();
      }

      // Load recently played
      final recentList = prefs.getStringList('recently_played_categories');
      if (recentList != null) {
        _recentlyPlayedCategoryIds = recentList.map((id) => int.tryParse(id) ?? 0).where((id) => id > 0).toList();
      }

      // Load category stats
      final statsString = prefs.getString('category_stats_map');
      if (statsString != null) {
        final decoded = json.decode(statsString) as Map<String, dynamic>;
        _categoryStats = decoded.map(
          (k, v) => MapEntry(int.parse(k), CategoryStats.fromJson(v as Map<String, dynamic>)),
        );
      }

      // Load daily streak & challenge
      _dailyStreak = prefs.getInt('daily_streak_count') ?? 1;
      _lastStreakDate = prefs.getString('last_streak_date') ?? '';
      final todayStr = _formatDate(DateTime.now());
      final lastChallengeDate = prefs.getString('last_challenge_date') ?? '';
      if (lastChallengeDate == todayStr) {
        _dailyChallengeCompletedToday = true;
        _dailyChallengeScore = prefs.getInt('daily_challenge_score');
      }

      notifyListeners();
    } catch (_) {}
  }

  String _formatDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  Future<void> setUserName(String name) async {
    _userName = name.trim().isEmpty ? 'Your_Name' : name.trim();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _userName);
    } catch (_) {}
  }

  Future<void> _saveConfigPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('saved_amount', _numberOfQuestions);
      await prefs.setString('saved_difficulty', _difficulty);
      await prefs.setString('saved_type', _questionType);
      if (_selectedCategory != null) {
        await prefs.setInt('last_category_id', _selectedCategory!.id);
      }
    } catch (_) {}
  }

  Future<void> _saveBestScore(int newScore) async {
    if (newScore > _bestScorePercentage) {
      _bestScorePercentage = newScore;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('best_score_percentage', _bestScorePercentage);
      } catch (_) {}
    }
  }

  Future<void> _recordQuizCompleted(int finalScore) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final todayStr = _formatDate(now);

      // Streak update
      if (_lastStreakDate != todayStr) {
        final yesterday = now.subtract(const Duration(days: 1));
        final yesterdayStr = _formatDate(yesterday);
        if (_lastStreakDate == yesterdayStr) {
          _dailyStreak++;
        } else if (_lastStreakDate.isNotEmpty) {
          _dailyStreak = 1;
        }
        _lastStreakDate = todayStr;
        await prefs.setInt('daily_streak_count', _dailyStreak);
        await prefs.setString('last_streak_date', _lastStreakDate);
      }

      // Category Stats & Recently Played update
      if (_selectedCategory != null) {
        final catId = _selectedCategory!.id;
        final existing = _categoryStats[catId];
        final newBest = (existing != null && existing.bestScore > finalScore)
            ? existing.bestScore
            : finalScore;
        _categoryStats[catId] = CategoryStats(
          categoryId: catId,
          quizzesPlayed: (existing?.quizzesPlayed ?? 0) + 1,
          bestScore: newBest,
          lastScore: finalScore,
        );

        // Save category stats map
        final encoded = json.encode(
          _categoryStats.map((k, v) => MapEntry(k.toString(), v.toJson())),
        );
        await prefs.setString('category_stats_map', encoded);

        // Update recently played
        _recentlyPlayedCategoryIds.remove(catId);
        _recentlyPlayedCategoryIds.insert(0, catId);
        if (_recentlyPlayedCategoryIds.length > 5) {
          _recentlyPlayedCategoryIds = _recentlyPlayedCategoryIds.sublist(0, 5);
        }
        await prefs.setStringList(
          'recently_played_categories',
          _recentlyPlayedCategoryIds.map((id) => id.toString()).toList(),
        );
      }

      // Daily Challenge update
      if (_isDailyChallengeActive) {
        _dailyChallengeCompletedToday = true;
        _dailyChallengeScore = finalScore;
        await prefs.setString('last_challenge_date', todayStr);
        await prefs.setInt('daily_challenge_score', finalScore);
      }
    } catch (_) {}
  }

  // --- Category Actions ---

  Future<void> fetchCategories({bool forceRefresh = false}) async {
    if (_categories.isNotEmpty && !forceRefresh) return;

    _isLoadingCategories = true;
    _categoriesError = null;
    notifyListeners();

    try {
      _categories = await _triviaService.fetchCategories();
      _categoriesError = null;
    } catch (e) {
      _categoriesError = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  void setSelectedCategory(Category category) {
    _selectedCategory = category;
    _lastPlayedCategoryId = category.id;
    _isDailyChallengeActive = false;
    _saveConfigPreferences();
    notifyListeners();
  }

  // --- Configuration Actions ---

  void setNumberOfQuestions(int count) {
    _numberOfQuestions = count;
    _saveConfigPreferences();
    notifyListeners();
  }

  void setDifficulty(String diff) {
    _difficulty = diff;
    _saveConfigPreferences();
    notifyListeners();
  }

  void setQuestionType(String type) {
    _questionType = type;
    _saveConfigPreferences();
    notifyListeners();
  }

  // --- Quiz Actions ---

  Future<bool> startQuiz() async {
    _isLoadingQuestions = true;
    _questionsError = null;
    _questions = [];
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _isAnswerSubmitted = false;
    _correctAnswers = 0;
    _currentStreak = 0;
    _bestStreakInSession = 0;
    _totalTimeSpentSeconds = 0;
    _answerRecords.clear();
    _cancelTimer();
    notifyListeners();

    try {
      final categoryId = _selectedCategory?.id;
      final fetchedQuestions = await _triviaService.fetchQuestions(
        amount: _numberOfQuestions,
        categoryId: categoryId,
        difficulty: _difficulty,
        type: _questionType,
      );

      if (fetchedQuestions.isEmpty) {
        throw Exception('No questions returned for the selected options.');
      }

      _questions = fetchedQuestions;
      _isLoadingQuestions = false;
      _startQuestionTimer();
      notifyListeners();
      return true;
    } catch (e) {
      _questionsError = e.toString().replaceAll('Exception: ', '');
      _isLoadingQuestions = false;
      notifyListeners();
      return false;
    }
  }

  void selectAnswer(String answer) => submitAnswer(answer);

  void submitAnswer(String answer) {
    if (_isAnswerSubmitted || currentQuestion == null) return;

    _cancelTimer();
    _isAnswerSubmitted = true;
    _selectedAnswer = answer;

    final spent = questionDuration - _remainingSeconds;
    _totalTimeSpentSeconds += spent;

    final isCorrect = answer == currentQuestion!.correctAnswer;
    if (isCorrect) {
      _correctAnswers++;
      _currentStreak++;
      if (_currentStreak > _bestStreakInSession) {
        _bestStreakInSession = _currentStreak;
      }
    } else {
      _currentStreak = 0;
    }

    _answerRecords.add(
      QuizAnswerRecord(
        question: currentQuestion!,
        selectedAnswer: answer,
        isCorrect: isCorrect,
        timeSpentSeconds: spent,
      ),
    );

    notifyListeners();
  }

  bool nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _isAnswerSubmitted = false;
      _startQuestionTimer();
      notifyListeners();
      return true;
    } else {
      _cancelTimer();
      final finalScore = scorePercentage;
      _saveBestScore(finalScore);
      _recordQuizCompleted(finalScore);
      notifyListeners();
      return false;
    }
  }

  void resetQuizForReplay() {
    _cancelTimer();
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _isAnswerSubmitted = false;
    _correctAnswers = 0;
    _currentStreak = 0;
    _bestStreakInSession = 0;
    _totalTimeSpentSeconds = 0;
    _answerRecords.clear();
    _questions = [];
    _questionsError = null;
    notifyListeners();
  }

  void resetAll() {
    _cancelTimer();
    _selectedCategory = null;
    _isDailyChallengeActive = false;
    _questions = [];
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _isAnswerSubmitted = false;
    _correctAnswers = 0;
    _currentStreak = 0;
    _bestStreakInSession = 0;
    _totalTimeSpentSeconds = 0;
    _answerRecords.clear();
    _questionsError = null;
    notifyListeners();
  }

  // --- Timer Handling ---

  void _startQuestionTimer() {
    _cancelTimer();
    _remainingSeconds = questionDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _cancelTimer();
        if (!_isAnswerSubmitted && currentQuestion != null) {
          _isAnswerSubmitted = true;
          _selectedAnswer = '__timeout__';
          _currentStreak = 0;
          _totalTimeSpentSeconds += questionDuration;
          _answerRecords.add(
            QuizAnswerRecord(
              question: currentQuestion!,
              selectedAnswer: 'Time Out (No Answer)',
              isCorrect: false,
              timeSpentSeconds: questionDuration,
            ),
          );
          notifyListeners();
        }
      }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
}
