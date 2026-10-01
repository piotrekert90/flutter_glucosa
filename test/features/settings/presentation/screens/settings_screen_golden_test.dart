@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod_boilerplate/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/data/providers/user_preferences_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_riverpod_boilerplate/core/presentation/theme/app_theme.dart';

import '../../../../helpers/fake_user_preferences_repository.dart';

void main() {
  late FakeUserPreferencesRepository repository;

  tearDown(() {
    repository.dispose();
  });

  testWidgets('Settings screen selected dark theme state', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    repository = FakeUserPreferencesRepository(
      initialPreferences: const UserPreferences(
        themeMode: UserThemeMode.dark,
        isNotificationsEnabled: false,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userPreferencesRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.darkTheme,
          home: const SettingsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(SettingsScreen),
      matchesGoldenFile('goldens/settings_screen_dark.png'),
    );

    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }, skip: !Platform.isMacOS);
}
