// This is a basic Flutter widget test.
//
// A simple smoke test to ensure the app widget builds without exceptions.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:logitech_mobile/core/config/app_config.dart';
import 'package:logitech_mobile/main_common.dart';

void main() {
  setUpAll(() {
    AppConfig.initialize(AppEnvironment.dev);
  });
  testWidgets('App builds', (WidgetTester tester) async {
    // Build the app widget and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: LogiTechApp()));

    // Verify the app widget is present.
    expect(find.byType(LogiTechApp), findsOneWidget);
  });
}
