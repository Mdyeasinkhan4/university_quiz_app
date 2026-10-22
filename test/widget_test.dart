import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:university_quiz_app/app/app.dart';

void main() {
  testWidgets('University Quiz App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: UniversityQuizApp(),
      ),
    );

    // Verify that the login screen is displayed.
    expect(find.text('Welcome to UniQuiz Pro'), findsOneWidget);
  });
}
