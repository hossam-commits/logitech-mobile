// This is a basic Flutter widget test.
//
// A simple smoke test to ensure the app widget builds without exceptions.

import 'package:flutter_test/flutter_test.dart';

import 'package:logitech_mobile/main.dart';

void main() {
  testWidgets('App builds', (WidgetTester tester) async {
    // Build the app widget and trigger a frame.
    await tester.pumpWidget(const LogiTechApp());

    // Verify the app widget is present.
    expect(find.byType(LogiTechApp), findsOneWidget);
  });
}
