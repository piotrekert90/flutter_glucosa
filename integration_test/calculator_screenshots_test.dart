@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/features/hba1c/presentation/screens/hba1c_calculator_screen.dart';
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

  group('11_calculator Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final locale = Locale(localeCode);

        // 11_calculator / 01_hba1c_calculator
        testWidgets(
          'Capture 11_calculator/01_hba1c_calculator [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                child: const HbA1cCalculatorScreen(),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 200));

            // Enter a sample average glucose to show computed HbA1c and clinical ranges
            final textFields = find.byType(TextField);
            if (textFields.evaluate().isNotEmpty) {
              await tester.enterText(textFields.first, '138');
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 200));
            }

            await binding.takeScreenshot(
              '$prefix$localeCode/11_calculator/01_hba1c_calculator_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
