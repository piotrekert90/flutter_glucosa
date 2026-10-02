import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserProfile.defaults());
  });

  group('OnboardingScreen flow', () {
    testWidgets('completes all four steps and saves the profile', (
      tester,
    ) async {
      final mockRepo = MockUserProfileRepository();
      when(() => mockRepo.save(any())).thenAnswer((_) async => (true, null));

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => ProviderScope(
              overrides: [
                userProfileRepositoryProvider.overrideWithValue(mockRepo),
              ],
              child: const OnboardingScreen(),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: AppTheme.lightTheme,
        ),
      );
      await tester.pumpAndSettle();

      // Step 1: enter name and continue.
      expect(find.text('Step 1 of 4'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Alex');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 2: pick diabetes type and continue.
      expect(find.text('Step 2 of 4'), findsOneWidget);
      await tester.tap(find.text('Type 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 3: pick unit and range, then continue.
      expect(find.text('Step 3 of 4'), findsOneWidget);
      await tester.tap(find.text('mmol/L'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('AACE'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Step 4: confirm summary and finish.
      expect(find.text('Step 4 of 4'), findsOneWidget);
      expect(find.text('Alex'), findsOneWidget);
      expect(find.text('Type 1'), findsOneWidget);
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      final captured =
          verify(() => mockRepo.save(captureAny())).captured.single
              as UserProfile;
      expect(captured.name, equals('Alex'));
      expect(captured.diabetesType.name, equals('type1'));
      expect(captured.preferredGlucoseUnit.name, equals('mmolL'));
      expect(captured.targetRange.minMgDl, equals(110));
      expect(captured.isOnboardingCompleted, isTrue);
      // The harness maps '/' back to onboarding, so a successful
      // context.go(AppRoute.overview.path) rebuilds step 4 without errors.
      expect(find.text('Step 4 of 4'), findsOneWidget);
    });

    testWidgets('AppBar back returns to the previous step', (tester) async {
      final mockRepo = MockUserProfileRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Alex');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Step 2 of 4'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Step 1 of 4'), findsOneWidget);
    });

    testWidgets('blocks Next on step 1 when name is empty', (tester) async {
      final mockRepo = MockUserProfileRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: const OnboardingScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.text('Some fields contain invalid values.'), findsOneWidget);
      verifyNever(() => mockRepo.save(any()));
    });
  });
}
