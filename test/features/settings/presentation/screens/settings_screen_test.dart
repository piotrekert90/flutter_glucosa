import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/custom_settings_toggle.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

import '../../../../helpers/fake_user_profile_repository.dart';

Widget _buildSettingsApp(FakeUserProfileRepository repository) {
  return ProviderScope(
    overrides: [userProfileRepositoryProvider.overrideWithValue(repository)],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SettingsScreen(),
    ),
  );
}

void main() {
  late FakeUserProfileRepository repository;

  setUp(() {
    repository = FakeUserProfileRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  testWidgets('Settings screen renders all headers and tiles correctly', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Diabetes Type'), findsOneWidget);
    expect(find.text('Units'), findsOneWidget);
    expect(find.text('Glucose Unit'), findsOneWidget);
    expect(find.text('HbA1c Unit'), findsOneWidget);
    expect(find.text('Weight Unit'), findsOneWidget);
    expect(find.text('Target Range'), findsWidgets);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('First Day of Week'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Security & Privacy'), findsOneWidget);
    expect(find.text('Biometric Lock'), findsOneWidget);
    expect(find.text('Wipe All Data'), findsOneWidget);
    expect(find.text('Tools'), findsOneWidget);
    expect(find.text('Reminders'), findsOneWidget);
    expect(find.text('Export Data'), findsOneWidget);
    expect(find.text('HbA1c Calculator'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Licenses'), findsOneWidget);
    expect(find.text('Rate App'), findsOneWidget);
  });

  testWidgets('Updates profile name via EditNameDialog', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Name'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Name'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Alice Smith');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect((await repository.get()).name, 'Alice Smith');
    expect(find.text('Alice Smith'), findsOneWidget);
  });

  testWidgets('Updates diabetes type via SelectionDialog', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Diabetes Type'));
    await tester.pumpAndSettle();

    expect(find.text('Select Diabetes Type'), findsOneWidget);
    expect(find.text('Type 1'), findsOneWidget);

    await tester.tap(find.text('Type 1'));
    await tester.pumpAndSettle();

    expect((await repository.get()).diabetesType, DiabetesType.type1);
  });

  testWidgets('Updates glucose unit via SelectionDialog', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Glucose Unit'));
    await tester.pumpAndSettle();

    expect(find.text('Select Glucose Unit'), findsOneWidget);
    await tester.tap(find.text('mmol/L'));
    await tester.pumpAndSettle();

    expect((await repository.get()).preferredGlucoseUnit, GlucoseUnit.mmolL);
  });

  testWidgets('Updates HbA1c unit via SelectionDialog', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('HbA1c Unit'));
    await tester.pumpAndSettle();

    expect(find.text('Select HbA1c Unit'), findsOneWidget);
    await tester.tap(find.text('mmol/mol'));
    await tester.pumpAndSettle();

    expect((await repository.get()).preferredHbA1cUnit, HbA1cUnit.mmolMol);
  });

  testWidgets('Updates weight unit via SelectionDialog', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Weight Unit'));
    await tester.pumpAndSettle();

    expect(find.text('Select Weight Unit'), findsOneWidget);
    await tester.tap(find.text('lbs'));
    await tester.pumpAndSettle();

    expect((await repository.get()).preferredWeightUnit, WeightUnit.pounds);
  });

  testWidgets('Updates target range via TargetRangeDialog', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    // Tap on target range tile
    await tester.tap(find.widgetWithText(ListTile, 'Target Range').first);
    await tester.pumpAndSettle();

    expect(find.text('Target Glucose Range'), findsOneWidget);
    await tester.tap(find.text('AACE (110–140 mg/dL)'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final profile = await repository.get();
    expect(profile.targetRange.preset, GlucoseRangePreset.aace);
    expect(profile.targetRange.minMgDl, 110);
    expect(profile.targetRange.maxMgDl, 140);
  });

  testWidgets('Updates theme mode and notifications toggle', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Theme'));
    await tester.pumpAndSettle();

    expect(find.text('Dark Mode'), findsOneWidget);
    await tester.tap(find.text('Dark Mode'));
    await tester.pumpAndSettle();

    expect((await repository.get()).themeMode, UserThemeMode.dark);

    final notificationSwitch = find.descendant(
      of: find.widgetWithText(CustomSettingsToggle, 'Notifications'),
      matching: find.byType(Switch),
    );
    await tester.tap(notificationSwitch);
    await tester.pumpAndSettle();

    expect((await repository.get()).isNotificationsEnabled, isFalse);
  });

  testWidgets('Updates first day of week via SelectionDialog', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Day of Week'));
    await tester.pumpAndSettle();

    expect(find.text('Select First Day of Week'), findsOneWidget);
    await tester.tap(find.text('Monday').last);
    await tester.pumpAndSettle();

    expect((await repository.get()).firstDayOfWeek, FirstDayOfWeek.monday);
  });

  testWidgets('Wipe all data shows dialog and cancels without wiping', (
    tester,
  ) async {
    await repository.save(const UserProfile(name: 'Jane Doe'));
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wipe All Data'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsNothing);
    expect((await repository.get()).name, 'Jane Doe');
  });

  testWidgets('Wipe all data confirms and triggers data wipe', (tester) async {
    await repository.save(const UserProfile(name: 'Jane Doe'));
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_buildSettingsApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wipe All Data'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsOneWidget);
    await tester.tap(find.text('Wipe Everything'));
    await tester.pumpAndSettle();

    expect(find.text('Are you sure?'), findsNothing);
    expect(find.text('All data has been wiped successfully.'), findsOneWidget);
    expect((await repository.get()).name, '');
  });
}
