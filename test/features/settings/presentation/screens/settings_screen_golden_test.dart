@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:package_info_plus/package_info_plus.dart';

import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeUserProfileRepository repository;

  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'Glucosa',
      packageName: 'com.ekerstudio.glucosa',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  tearDown(() {
    repository.dispose();
  });

  testWidgets('Settings screen selected dark theme state', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;

    repository = FakeUserProfileRepository(
      initialProfile: const UserProfile(
        themeMode: UserThemeMode.dark,
        isNotificationsEnabled: false,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
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
