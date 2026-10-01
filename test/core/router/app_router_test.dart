import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/router/app_router.dart';
import 'package:flutter_glucosa/core/router/app_routes.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/presentation/screens/add_edit_glucose_reading_screen.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/licenses_screen.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_glucose_reading_repository.dart';
import '../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeUserProfileRepository fakeUserProfileRepository;
  late FakeGlucoseReadingRepository fakeGlucoseReadingRepository;

  setUp(() {
    fakeUserProfileRepository = FakeUserProfileRepository();
    fakeGlucoseReadingRepository = FakeGlucoseReadingRepository();
  });

  tearDown(() {
    fakeUserProfileRepository.dispose();
    fakeGlucoseReadingRepository.dispose();
  });

  Widget createTestApp({String? initialLocation}) {
    return ProviderScope(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(
          fakeUserProfileRepository,
        ),
        glucoseReadingRepositoryProvider.overrideWithValue(
          fakeGlucoseReadingRepository,
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(appRouterProvider);
          if (initialLocation != null) {
            router.go(initialLocation);
          }
          return MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }

  group('AppRouter Tests', () {
    test('AppRoute enum definitions have correct paths and names', () {
      expect(AppRoute.overview.path, '/');
      expect(AppRoute.overview.name, 'overview');
      expect(AppRoute.history.path, '/history');
      expect(AppRoute.history.name, 'history');
      expect(AppRoute.settings.path, '/settings');
      expect(AppRoute.settings.name, 'settings');
      expect(AppRoute.licenses.path, 'licenses');
      expect(AppRoute.licenses.name, 'licenses');
      expect(AppRoute.privacyPolicy.path, 'privacy-policy');
      expect(AppRoute.privacyPolicy.name, 'privacy_policy');
      expect(AppRoute.addGlucose.path, '/glucose/add');
      expect(AppRoute.addGlucose.name, 'add_glucose');
      expect(AppRoute.editGlucose.path, '/glucose/edit/:id');
      expect(AppRoute.editGlucose.name, 'edit_glucose');
      expect(AppRoute.addBloodPressure.path, '/blood-pressure/add');
      expect(AppRoute.addBloodPressure.name, 'add_blood_pressure');
      expect(AppRoute.editBloodPressure.path, '/blood-pressure/edit/:id');
      expect(AppRoute.editBloodPressure.name, 'edit_blood_pressure');
      expect(AppRoute.addKetones.path, '/ketones/add');
      expect(AppRoute.addKetones.name, 'add_ketones');
      expect(AppRoute.editKetones.path, '/ketones/edit/:id');
      expect(AppRoute.editKetones.name, 'edit_ketones');
      expect(AppRoute.addCholesterol.path, '/cholesterol/add');
      expect(AppRoute.addCholesterol.name, 'add_cholesterol');
      expect(AppRoute.editCholesterol.path, '/cholesterol/edit/:id');
      expect(AppRoute.editCholesterol.name, 'edit_cholesterol');
    });

    testWidgets('Renders OverviewScreen on initial "/" route', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(OverviewScreen), findsOneWidget);
    });

    testWidgets('Navigates to HistoryScreen on "/history" route', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialLocation: '/history'));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryScreen), findsOneWidget);
    });

    testWidgets('Navigates to SettingsScreen on "/settings" route', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialLocation: '/settings'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('Navigates to LicensesScreen on "/settings/licenses" route', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(initialLocation: '/settings/licenses'),
      );
      await tester.pump();

      expect(find.byType(LicensesScreen), findsOneWidget);
    });

    testWidgets(
      'Navigates to PrivacyPolicyScreen on "/settings/privacy-policy" route',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/settings/privacy-policy'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
      },
    );

    testWidgets('Navigates to AddEditGlucoseReadingScreen on "/glucose/add"', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialLocation: '/glucose/add'));
      await tester.pumpAndSettle();

      expect(find.byType(AddEditGlucoseReadingScreen), findsOneWidget);
      expect(find.text('Add Glucose Reading'), findsOneWidget);
    });

    testWidgets(
      'Navigates to AddEditGlucoseReadingScreen on "/glucose/edit/1"',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/glucose/edit/1'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AddEditGlucoseReadingScreen), findsOneWidget);
      },
    );

    testWidgets('Navigates to AddEditHbA1cReadingScreen on "/hba1c/add"', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialLocation: '/hba1c/add'));
      await tester.pumpAndSettle();

      expect(find.text('Log HbA1c'), findsOneWidget);
    });

    testWidgets('Navigates to AddEditHbA1cReadingScreen on "/hba1c/edit/1"', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialLocation: '/hba1c/edit/1'));
      await tester.pumpAndSettle();

      expect(find.text('Edit HbA1c'), findsOneWidget);
    });

    testWidgets(
      'Navigates to AddEditBloodPressureReadingScreen on "/blood-pressure/add"',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/blood-pressure/add'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Log Blood Pressure'), findsOneWidget);
      },
    );

    testWidgets(
      'Navigates to AddEditBloodPressureReadingScreen on "/blood-pressure/edit/1"',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/blood-pressure/edit/1'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Edit Blood Pressure'), findsOneWidget);
      },
    );

    testWidgets('Navigates to AddEditKetoneReadingScreen on "/ketones/add"', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialLocation: '/ketones/add'));
      await tester.pumpAndSettle();

      expect(find.text('Log Ketones'), findsOneWidget);
    });

    testWidgets(
      'Navigates to AddEditKetoneReadingScreen on "/ketones/edit/1"',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/ketones/edit/1'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Edit Ketones'), findsOneWidget);
      },
    );

    testWidgets(
      'Navigates to AddEditCholesterolReadingScreen on "/cholesterol/add"',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/cholesterol/add'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Log Cholesterol'), findsOneWidget);
      },
    );

    testWidgets(
      'Navigates to AddEditCholesterolReadingScreen on "/cholesterol/edit/1"',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/cholesterol/edit/1'),
        );
        await tester.pumpAndSettle();

        expect(find.text('Edit Cholesterol'), findsOneWidget);
      },
    );

    testWidgets('Renders error screen on unknown route', (tester) async {
      await tester.pumpWidget(
        createTestApp(initialLocation: '/unknown-route-404'),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Page not found'), findsOneWidget);
    });
  });
}
