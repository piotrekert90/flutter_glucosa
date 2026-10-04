@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/user_theme_mode.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/presentation/navigation/adaptive_navigation_scaffold.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/selection_dialog.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/target_range_dialog.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/theme_selection_dialog.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/wipe_data_dialog.dart';
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

  group('05_settings Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final locale = Locale(localeCode);

        // 05_settings / 01_preferences
        testWidgets(
          'Capture 05_settings/01_preferences [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: Builder(
                  builder: (context) =>
                      buildAdaptiveScaffold(context, const SettingsScreen(), 3),
                ),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/05_settings/01_preferences_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 05_settings / 02_target_range_dialog
        testWidgets(
          'Capture 05_settings/02_target_range_dialog [$localeCode] [$themeLabel]',
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
                      buildAdaptiveScaffold(context, const SettingsScreen(), 3),
                      const ModalBarrier(
                        dismissible: false,
                        color: Colors.black54,
                      ),
                      Center(
                        child: TargetRangeDialog(
                          currentRange: const GlucoseTargetRange.ada(),
                          preferredUnit: GlucoseUnit.mgDl,
                          onSaved: (_) {},
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
              '$prefix$localeCode/05_settings/02_target_range_dialog_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 05_settings / 03_unit_selection
        testWidgets(
          'Capture 05_settings/03_unit_selection [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Stack(
                      children: [
                        buildAdaptiveScaffold(
                          context,
                          const SettingsScreen(),
                          3,
                        ),
                        const ModalBarrier(
                          dismissible: false,
                          color: Colors.black54,
                        ),
                        Center(
                          child: SelectionDialog<GlucoseUnit>(
                            title: l10n.selectGlucoseUnit,
                            currentValue: GlucoseUnit.mgDl,
                            items: GlucoseUnit.values,
                            itemLabel: (u) => u.displayName,
                            itemSubtitle: (u) => u == GlucoseUnit.mgDl
                                ? (l10n.glucoseUnitMgDlDescription)
                                : l10n.glucoseUnitMmolLDescription,
                            onSelected: (_) {},
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/05_settings/03_unit_selection_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 05_settings / 04_theme_selection
        testWidgets(
          'Capture 05_settings/04_theme_selection [$localeCode] [$themeLabel]',
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
                      buildAdaptiveScaffold(context, const SettingsScreen(), 3),
                      const ModalBarrier(
                        dismissible: false,
                        color: Colors.black54,
                      ),
                      Center(
                        child: ThemeSelectionDialog(
                          currentMode: UserThemeMode.system,
                          onSelected: (_) {},
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
              '$prefix$localeCode/05_settings/04_theme_selection_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 05_settings / 05_wipe_data_dialog
        testWidgets(
          'Capture 05_settings/05_wipe_data_dialog [$localeCode] [$themeLabel]',
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
                      buildAdaptiveScaffold(context, const SettingsScreen(), 3),
                      const ModalBarrier(
                        dismissible: false,
                        color: Colors.black54,
                      ),
                      const Center(child: WipeDataDialog()),
                    ],
                  ),
                ),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/05_settings/05_wipe_data_dialog_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 05_settings / 06_privacy_policy
        testWidgets(
          'Capture 05_settings/06_privacy_policy [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                showNotificationIcon: true,
                child: const PrivacyPolicyScreen(),
              ),
            );

            await tester.pumpAndSettle();

            await binding.takeScreenshot(
              '$prefix$localeCode/05_settings/06_privacy_policy_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
