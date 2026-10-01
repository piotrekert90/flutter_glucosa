import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeUserProfileRepository repository;

  setUp(() {
    repository = FakeUserProfileRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  testWidgets(
    'Settings screen renders and updates theme mode and notifications',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(repository),
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
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Diabetes Type'), findsOneWidget);
      expect(find.text('Glucose Unit'), findsOneWidget);
      expect(find.text('Target Range'), findsOneWidget);
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
