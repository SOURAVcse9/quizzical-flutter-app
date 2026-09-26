import 'package:flutter_test/flutter_test.dart';
import 'package:quizzical/main.dart';

void main() {
  testWidgets('QuizzicalApp renders HomeScreen with title and CTA', (WidgetTester tester) async {
    await tester.pumpWidget(const QuizzicalApp());

    // Verify app title and button exist
    expect(find.text('Quizzical'), findsOneWidget);
    expect(find.text('GET STARTED'), findsOneWidget);
  });
}
