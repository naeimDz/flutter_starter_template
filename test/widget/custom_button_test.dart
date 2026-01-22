import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_template/shared/widgets/custom_button.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('CustomButton displays text and triggers callback',
        (WidgetTester tester) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      // Verify text
      expect(find.text('Test Button'), findsOneWidget);

      // Tap the button
      await tester.tap(find.byType(CustomButton));
      await tester.pump();

      // Verify callback
      expect(pressed, true);
    });

    testWidgets('CustomButton shows loading indicator when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CustomButton(
              text: 'Test Button',
              isLoading: true,
              onPressed: null,
            ),
          ),
        ),
      );

      // Verify loading indicator instead of text (depending on implementation)
      // Usually CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
