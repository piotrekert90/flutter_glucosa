@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/providers/onboarding_notifier.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'helpers/screenshot_test_helper.dart';

class _ScreenshotOnboardingNotifier extends Onboarding {
  final OnboardingDraft initialDraft;
  _ScreenshotOnboardingNotifier(this.initialDraft);

  @override
  OnboardingDraft build() => initialDraft;
}

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

  group('01_onboarding Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final locale = Locale(localeCode);

        // 01_welcome
        testWidgets(
          'Capture 01_onboarding/01_welcome [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(step: 0, name: 'Alex');
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/01_welcome_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 02_units
        testWidgets(
          'Capture 01_onboarding/02_units [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(
              step: 1,
              name: 'Alex',
              glucoseUnit: GlucoseUnit.mgDl,
            );
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/02_units_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 03_diabetes
        testWidgets(
          'Capture 01_onboarding/03_diabetes [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(
              step: 2,
              name: 'Alex',
              diabetesType: DiabetesType.type2,
              baselineMgDl: 110,
            );
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/03_diabetes_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 04_target_range
        testWidgets(
          'Capture 01_onboarding/04_target_range [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(
              step: 3,
              name: 'Alex',
              rangePreset: GlucoseRangePreset.ada,
            );
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/04_target_range_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 05_health_sync
        testWidgets(
          'Capture 01_onboarding/05_health_sync [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(
              step: 4,
              name: 'Alex',
              healthSyncEnabled: true,
            );
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/05_health_sync_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 06_reminder
        testWidgets(
          'Capture 01_onboarding/06_reminder [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(
              step: 5,
              name: 'Alex',
              reminderEnabled: true,
              reminderHour: 8,
              reminderMinute: 0,
            );
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/06_reminder_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 07_biometric
        testWidgets(
          'Capture 01_onboarding/07_biometric [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(
              step: 6,
              name: 'Alex',
              biometricEnabled: true,
            );
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/07_biometric_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 08_privacy
        testWidgets(
          'Capture 01_onboarding/08_privacy [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(
              step: 7,
              name: 'Alex',
              privacyAcknowledged: true,
            );
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/08_privacy_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 09_csv_import
        testWidgets(
          'Capture 01_onboarding/09_csv_import [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            const draft = OnboardingDraft(step: 8, name: 'Alex');
            await tester.pumpWidget(
              buildScreenshotAppWrapper(
                locale: locale,
                isDark: isDark,
                mockData: mockData,
                overrides: [
                  onboardingProvider.overrideWith(
                    () => _ScreenshotOnboardingNotifier(draft),
                  ),
                ],
                child: const OnboardingScreen(),
              ),
            );

            await tester.pumpAndSettle();
            await binding.takeScreenshot(
              '$prefix$localeCode/01_onboarding/09_csv_import_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
