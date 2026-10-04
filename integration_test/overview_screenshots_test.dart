@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/core/presentation/navigation/adaptive_navigation_scaffold.dart';
import 'package:flutter_glucosa/core/presentation/widgets/add_reading_bottom_sheet.dart';
import 'package:flutter_glucosa/features/glucose/presentation/screens/add_edit_glucose_reading_screen.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return AdaptiveNavigationScaffold(
      body: body,
      currentIndex: index,
      onDestinationSelected: (_) {},
      destinations: [
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.dashboard_outlined),
          selectedIcon: const Icon(Icons.dashboard),
          label: l10n.navOverview,
        ),
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.calendar_month_outlined),
          selectedIcon: const Icon(Icons.calendar_month),
          label: l10n.tabCalendar,
        ),
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history),
          label: l10n.navHistory,
        ),
        AdaptiveNavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: l10n.navSettings,
        ),
      ],
    );
  }

  group('02_overview Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final locale = Locale(localeCode);

        // 02_overview / 01_dashboard
        testWidgets(
          'Capture 02_overview/01_dashboard [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: Builder(
                  builder: (context) =>
                      buildAdaptiveScaffold(context, const OverviewScreen(), 0),
                ),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/02_overview/01_dashboard_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 02_overview / 02_add_metric_sheet
        testWidgets(
          'Capture 02_overview/02_add_metric_sheet [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: Builder(
                  builder: (context) => Stack(
                    children: [
                      buildAdaptiveScaffold(context, const OverviewScreen(), 0),
                      const ModalBarrier(
                        dismissible: false,
                        color: Colors.black54,
                      ),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: ScreenshotBottomSheetContainer(
                          child: AddReadingBottomSheet(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/02_overview/02_add_metric_sheet_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 02_overview / 03_add_glucose_sheet
        testWidgets(
          'Capture 02_overview/03_add_glucose_sheet [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: const AddEditGlucoseReadingScreen(),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/02_overview/03_add_glucose_sheet_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
