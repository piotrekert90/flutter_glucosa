import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_glucosa/core/router/app_router.dart';
import 'package:flutter_glucosa/core/router/app_routes.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/licenses_screen.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeUserProfileRepository fakeUserProfileRepository;

  setUp(() {
    fakeUserProfileRepository = FakeUserProfileRepository();
  });

  tearDown(() {
    fakeUserProfileRepository.dispose();
  });

  Widget createTestApp({String? initialLocation}) {
    return ProviderScope(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(
          fakeUserProfileRepository,
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(appRouterProvider);
          if (initialLocation != null) {
            router.go(initialLocation);
          }
          return MaterialApp.router(routerConfig: router);
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

    testWidgets('Renders error screen on unknown route', (tester) async {
      await tester.pumpWidget(
        createTestApp(initialLocation: '/unknown-route-404'),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Page not found'), findsOneWidget);
    });
  });
}
