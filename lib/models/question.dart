import '../utils/html_decoder.dart';

/// Question Model representing a Trivia Question from OpenTDB API.
/// Clean, robust, and viva-friendly.
class Question {
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> allAnswers;

  Question({
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.allAnswers,
  });

  /// Factory constructor to parse OpenTDB JSON result, decode HTML entities, and shuffle answers.
  factory Question.fromJson(Map<String, dynamic> json) {
    // Decode HTML entities in question and answers
    final decodedCategory = HtmlDecoder.decode(json['category']?.toString() ?? '');
    final decodedType = json['type']?.toString() ?? 'multiple';
    final decodedDifficulty = json['difficulty']?.toString() ?? 'easy';
    final decodedQuestion = HtmlDecoder.decode(json['question']?.toString() ?? '');
    final decodedCorrectAnswer = HtmlDecoder.decode(json['correct_answer']?.toString() ?? '');

    final rawIncorrect = (json['incorrect_answers'] as List<dynamic>?) ?? [];
    final decodedIncorrectAnswers = rawIncorrect
        .map((e) => HtmlDecoder.decode(e.toString()))
        .toList();

    // Combine all answers and shuffle them so the correct answer is in random position
    final combinedAnswers = <String>[
      decodedCorrectAnswer,
      ...decodedIncorrectAnswers,
    ];
    combinedAnswers.shuffle();

    return Question(
      category: decodedCategory,
      type: decodedType,
      difficulty: decodedDifficulty,
      question: decodedQuestion,
      correctAnswer: decodedCorrectAnswer,
      incorrectAnswers: decodedIncorrectAnswers,
      allAnswers: combinedAnswers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'type': type,
      'difficulty': difficulty,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
      'all_answers': allAnswers,
    };
  }

  @override
  String toString() => 'Question(question: $question, correct: $correctAnswer)';
}
