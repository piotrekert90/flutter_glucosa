@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/helpers/fake_user_profile_repository.dart';
import 'helpers/screenshot_test_helper.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initScreenshotEnvironment(binding);
  });

  group('App Screenshots', () {
    final prefix = getScreenshotPrefix();
    final locales = getEffectiveLocales();

    for (final localeStr in locales) {
      final locale = Locale(localeStr);

      testWidgets('Capture Overview and Settings screens ($localeStr)', (
        tester,
      ) async {
        final profileRepo = FakeUserProfileRepository(
          initialProfile: const UserProfile(
            themeMode: UserThemeMode.system,
            isNotificationsEnabled: true,
          ),
        );

        final overrides = [
          userProfileRepositoryProvider.overrideWithValue(profileRepo),
        ];

        try {
          // 1. Overview Screen (Light)
          await tester.pumpWidget(
            buildScreenshotAppWrapper(
              locale: locale,
              isDark: false,
              overrides: overrides,
              child: const OverviewScreen(),
            ),
          );
          await tester.pumpAndSettle();
          await binding.takeScreenshot('${prefix}01_overview_light_$localeStr');

          // 2. Settings Screen (Dark)
          await tester.pumpWidget(
            buildScreenshotAppWrapper(
              locale: locale,
              isDark: true,
              overrides: overrides,
              child: const SettingsScreen(),
            ),
          );
          await tester.pumpAndSettle();
          await binding.takeScreenshot('${prefix}02_settings_dark_$localeStr');
        } finally {
          profileRepo.dispose();
        }
      });
    }
  });
}
