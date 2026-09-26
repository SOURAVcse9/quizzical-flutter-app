import 'dart:async';
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

/// Central state management for Quizzical application with SharedPreferences persistence,
/// streak tracking, best score memory, and exam-level features.
class QuizProvider extends ChangeNotifier {
  final TriviaService _triviaService = TriviaService();

  // User Profile
  String _userName = 'Your_Name';
  int _bestScorePercentage = 0;
  int? _lastPlayedCategoryId;

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
      notifyListeners();
    } catch (_) {}
  }

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
    _correctAnswers = 0;
    _currentStreak = 0;
    _bestStreakInSession = 0;
    _selectedAnswer = null;
    _isAnswerSubmitted = false;
    _totalTimeSpentSeconds = 0;
    _answerRecords.clear();
    _cancelTimer();
    notifyListeners();

    try {
      _questions = await _triviaService.fetchQuestions(
        amount: _numberOfQuestions,
        categoryId: _selectedCategory?.id,
        difficulty: _difficulty,
        type: _questionType,
      );

      _questionsError = null;
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

  void selectAnswer(String answer) {
    if (_isAnswerSubmitted || currentQuestion == null) return;

    _cancelTimer();
    _selectedAnswer = answer;
    _isAnswerSubmitted = true;

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

    final timeSpent = questionDuration - _remainingSeconds;
    _totalTimeSpentSeconds += timeSpent;

    _answerRecords.add(
      QuizAnswerRecord(
        question: currentQuestion!,
        selectedAnswer: answer,
        isCorrect: isCorrect,
        timeSpentSeconds: timeSpent,
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
      _saveBestScore(scorePercentage);
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
          _currentStreak = 0; // Reset streak on timeout
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
