import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_riverpod_boilerplate/features/settings/data/providers/user_preferences_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations.dart';

import '../../../../helpers/fake_user_preferences_repository.dart';

void main() {
  late FakeUserPreferencesRepository repository;

  setUp(() {
    repository = FakeUserPreferencesRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  testWidgets(
    'Settings screen renders and updates theme mode and notifications',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userPreferencesRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Licenses'), findsOneWidget);
      expect(find.text('Rate App'), findsOneWidget);

      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();

      expect(find.text('Dark Mode'), findsOneWidget);
      await tester.tap(find.text('Dark Mode'));
      await tester.pumpAndSettle();

      expect((await repository.get()).themeMode, UserThemeMode.dark);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect((await repository.get()).isNotificationsEnabled, isFalse);
    },
  );
}
