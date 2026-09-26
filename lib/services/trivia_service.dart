import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/question.dart';

/// Service class handling all OpenTDB REST API communication.
class TriviaService {
  static const String _baseUrl = 'opentdb.com';
  static const Duration _timeoutDuration = Duration(seconds: 12);

  /// Fetches the list of all categories from https://opentdb.com/api_category.php
  Future<List<Category>> fetchCategories() async {
    final uri = Uri.https(_baseUrl, '/api_category.php');

    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> rawCategories = data['trivia_categories'] ?? [];

        return rawCategories.map((item) => Category.fromJson(item)).toList();
      } else {
        throw Exception('Server returned error code ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please check your network.');
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      throw Exception('Failed to load categories: ${e.toString().replaceAll('Exception: ', '')}');
    }
  }

  /// Fetches quiz questions based on selected parameters:
  /// - [amount]: Number of questions (1 - 50)
  /// - [categoryId]: Specific category ID, or null for Any
  /// - [difficulty]: 'easy', 'medium', 'hard', or null for Any
  /// - [type]: 'multiple' or 'boolean'
  Future<List<Question>> fetchQuestions({
    required int amount,
    int? categoryId,
    String? difficulty,
    String? type = 'multiple',
  }) async {
    final Map<String, String> queryParams = {
      'amount': amount.toString(),
    };

    if (categoryId != null && categoryId > 0) {
      queryParams['category'] = categoryId.toString();
    }

    if (difficulty != null &&
        difficulty.isNotEmpty &&
        difficulty.toLowerCase() != 'any' &&
        difficulty.toLowerCase() != 'any difficulty') {
      queryParams['difficulty'] = difficulty.toLowerCase();
    }

    if (type != null && type.isNotEmpty) {
      queryParams['type'] = type;
    }

    final uri = Uri.https(_baseUrl, '/api.php', queryParams);

    try {
      final response = await http.get(uri).timeout(_timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final int responseCode = data['response_code'] ?? 0;

        switch (responseCode) {
          case 0:
            final List<dynamic> results = data['results'] ?? [];
            if (results.isEmpty) {
              throw Exception('No questions returned. Try lowering the question count.');
            }
            return results.map((item) => Question.fromJson(item)).toList();

          case 1:
            throw Exception('Not enough questions available for this combination. Please choose a lower question amount or "Any Difficulty".');

          case 2:
            throw Exception('Invalid query parameter provided.');

          case 3:
          case 4:
            throw Exception('Session token error. Please retry.');

          case 5:
            throw Exception('Rate limit exceeded. OpenTDB allows 1 request every 5 seconds. Please wait a moment and tap Retry.');

          default:
            throw Exception('Unknown API response code: $responseCode');
        }
      } else {
        throw Exception('Server returned status ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection. Please verify your network.');
    } on TimeoutException {
      throw Exception('Connection timed out while fetching questions. Please retry.');
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
