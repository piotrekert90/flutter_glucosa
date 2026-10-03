@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/core/presentation/navigation/adaptive_navigation_scaffold.dart';
import 'package:flutter_glucosa/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:flutter_glucosa/features/glucose/presentation/screens/add_edit_glucose_reading_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
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

  Widget buildAdaptiveScaffold(BuildContext context, Widget body, int index) {
    final l10n = AppLocalizations.of(context);
    return AdaptiveNavigationScaffold(
      body: body,
      currentIndex: index,
      onDestinationSelected: (_) {},
      destinations: [
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: l10n?.navOverview ?? 'Overview',
        ),
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: const Icon(Icons.calendar_month),
          label: l10n?.tabCalendar ?? 'Calendar',
        ),
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history),
          label: l10n?.navHistory ?? 'History',
        ),
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: l10n?.navSettings ?? 'Settings',
        ),
      ],
    );
  }

  group('03_calendar Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final locale = Locale(localeCode);

        // 03_calendar / 01_month_view
        testWidgets(
          'Capture 03_calendar/01_month_view [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: Builder(
                  builder: (context) => buildAdaptiveScaffold(
                    context,
                    CalendarScreen(initialDate: DateTime(2026, 8, 26)),
                    1,
                  ),
                ),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/03_calendar/01_month_view_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 03_calendar / 02_edit_measurement
        testWidgets(
          'Capture 03_calendar/02_edit_measurement [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: const AddEditGlucoseReadingScreen(readingId: 1),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/03_calendar/02_edit_measurement_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
