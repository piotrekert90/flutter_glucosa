@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/features/export/presentation/screens/export_screen.dart';
import 'helpers/screenshot_test_helper.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final effectiveLocales = getEffectiveLocales();
  final prefix = getScreenshotPrefix();

  late ScreenshotMockData mockData;

  setUpAll(() async {
    mockData = await initScreenshotEnvironment(binding);
  });

  tearDownAll(() {
    mockData.dispose();
  });

  group('10_export Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final locale = Locale(localeCode);

        // 10_export / 01_export_screen
        testWidgets(
          'Capture 10_export/01_export_screen [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                child: const ExportScreen(),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/10_export/01_export_screen_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
