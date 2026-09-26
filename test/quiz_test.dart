import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/models/category.dart';
import 'package:quizzical/models/question.dart';
import 'package:quizzical/providers/quiz_provider.dart';
import 'package:quizzical/utils/html_decoder.dart';

void main() {
  group('HtmlDecoder Unit Tests', () {
    test('Decodes basic named HTML entities correctly', () {
      expect(HtmlDecoder.decode('What is &quot;Flutter&quot;?'), 'What is "Flutter"?');
      expect(HtmlDecoder.decode('Tom &amp; Jerry'), 'Tom & Jerry');
      expect(HtmlDecoder.decode('It&#039;s sunny &gt; rainy'), "It's sunny > rainy");
    });

    test('Decodes numeric HTML entities correctly', () {
      expect(HtmlDecoder.decode('&#65;&#66;&#67;'), 'ABC');
      expect(HtmlDecoder.decode('&#x41;&#x42;&#x43;'), 'ABC');
    });
  });

  group('Model Serialization Tests', () {
    test('Category.fromJson parses properly', () {
      final json = {'id': 9, 'name': 'General Knowledge'};
      final category = Category.fromJson(json);

      expect(category.id, 9);
      expect(category.name, 'General Knowledge');
    });

    test('Question.fromJson parses and combines answers', () {
      final json = {
        'category': 'General Knowledge',
        'type': 'multiple',
        'difficulty': 'easy',
        'question': 'What is the capital of &quot;France&quot;?',
        'correct_answer': 'Paris',
        'incorrect_answers': ['London', 'Berlin', 'Madrid'],
      };

      final question = Question.fromJson(json);

      expect(question.question, 'What is the capital of "France"?');
      expect(question.correctAnswer, 'Paris');
      expect(question.allAnswers.length, 4);
      expect(question.allAnswers.contains('Paris'), true);
      expect(question.allAnswers.contains('London'), true);
    });
  });

  group('QuizProvider Logic & Feature Tests', () {
    test('Configuration and defaults work properly', () {
      final provider = QuizProvider();

      expect(provider.numberOfQuestions, 10);

      provider.setNumberOfQuestions(15);
      expect(provider.numberOfQuestions, 15);

      provider.setDifficulty('Easy');
      expect(provider.difficulty, 'Easy');

      provider.setUserName('John Doe');
      expect(provider.userName, 'John Doe');
    });
  });
}
