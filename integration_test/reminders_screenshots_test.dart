@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/features/reminders/presentation/screens/reminders_screen.dart';
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

  group('09_reminders Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final locale = Locale(localeCode);

        // 09_reminders / 01_reminders_list
        testWidgets(
          'Capture 09_reminders/01_reminders_list [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                child: const RemindersScreen(),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/09_reminders/01_reminders_list_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 09_reminders / 02_add_reminder_sheet
        testWidgets(
          'Capture 09_reminders/02_add_reminder_sheet [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                child: const RemindersScreen(),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 200));

            final fab = find.byType(FloatingActionButton);
            if (fab.evaluate().isNotEmpty) {
              await tester.tap(fab);
              await tester.pump();
              await tester.pump(const Duration(milliseconds: 350));
            }

            await binding.takeScreenshot(
              '$prefix$localeCode/09_reminders/02_add_reminder_sheet_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
