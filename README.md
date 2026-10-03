# Quizzical

<div align="center">
  <img src="assets/branding/quizzical_logo.png" alt="Quizzical logo" width="140" />
  <br />
  <strong>A friendly, category-based trivia quiz built with Flutter.</strong>
  <br /><br />
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-Dart-02569B?logo=flutter&logoColor=white" alt="Flutter and Dart" /></a>
  <a href="https://opentdb.com"><img src="https://img.shields.io/badge/Questions-OpenTDB-orange" alt="Questions from OpenTDB" /></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green" alt="MIT license" /></a>
</div>

## Try it

Choose a trivia category, set the quiz length, difficulty and question format, then answer before the 30-second timer runs out. Review your score at the end and play again.

**Highlights**
- Browse, search, alphabetize and filter categories by favorites or recently played.
- Save favorite categories, recent activity, personal scores, name and preferences on your device.
- Take a daily challenge and build a quiz streak.
- Pick 1–50 questions, a difficulty, and multiple-choice or true/false questions.
- See shuffled answer choices, timed questions, answer feedback and a final score.

## Run locally

You’ll need the Flutter SDK compatible with the constraint in `pubspec.yaml`, plus a device or emulator.

```bash
git clone https://github.com/SOURAVcse9/quizzical-flutter-app.git
cd quizzical-flutter-app
flutter pub get
flutter run
```

Run the tests with:

```bash
flutter test
```

An internet connection is needed to load categories and questions from OpenTDB. The app does not include Firebase, sign-in, or a custom backend; saved preferences and quiz statistics are local to the device.

## How it is organized

| Location | Role |
| --- | --- |
| `lib/main.dart` | App startup, theme and Provider setup |
| `lib/screens/` | Welcome, category, quiz setup, quiz and results screens |
| `lib/providers/quiz_provider.dart` | Shared app state, quiz rules, timer and local preferences |
| `lib/services/trivia_service.dart` | OpenTDB HTTP requests and response/error handling |
| `lib/models/` | Category and question data models |
| `lib/widgets/` | Reusable buttons, answer choices, category cards and illustrations |
| `lib/utils/` | Colors, category visuals and HTML-entity decoding |
| `assets/` | Branding and screen/category artwork |
| `test/` | Model, helper, provider and widget tests |

The screens read and update `QuizProvider`. It calls `TriviaService` for remote trivia data and uses `SharedPreferences` for local persistence.

## Project report

See [Quizzical Project Documentation](Quizzical_Project_Documentation.pdf) for the source-based project overview, file inventory, data flow and viva notes.

## License

This project is available under the [MIT License](LICENSE).
