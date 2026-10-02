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
    testWidgets('completes all nine steps and saves the profile', (
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

      Future<void> next() async {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      // Step 1: enter name and continue.
      expect(find.text('Step 1 of 9'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Alex');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      await next();

      // Step 2: pick unit and continue.
      expect(find.text('Step 2 of 9'), findsOneWidget);
      await tester.tap(find.text('mmol/L'));
      await tester.pumpAndSettle();
      await next();

      // Step 3: pick diabetes type and continue.
      expect(find.text('Step 3 of 9'), findsOneWidget);
      await tester.tap(find.text('Type 1'));
      await tester.pumpAndSettle();
      await next();

      // Step 4: pick target range and continue.
      expect(find.text('Step 4 of 9'), findsOneWidget);
      await tester.tap(find.textContaining('AACE'));
      await tester.pumpAndSettle();
      await next();

      // Step 5: skip health sync and continue.
      expect(find.text('Step 5 of 9'), findsOneWidget);
      await next();

      // Step 6: skip reminder and continue.
      expect(find.text('Step 6 of 9'), findsOneWidget);
      await next();

      // Step 7: skip biometric lock and continue.
      expect(find.text('Step 7 of 9'), findsOneWidget);
      await next();

      // Step 8: acknowledge privacy and continue.
      expect(find.text('Step 8 of 9'), findsOneWidget);
      await tester.tap(find.text('I understand'));
      await tester.pumpAndSettle();
      await next();

      // Step 9: review and finish.
      expect(find.text('Step 9 of 9'), findsOneWidget);
      expect(find.text('Alex'), findsOneWidget);
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
      // context.go(AppRoute.overview.path) rebuilds step 9 without errors.
      expect(find.text('Step 9 of 9'), findsOneWidget);
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
      expect(find.text('Step 2 of 9'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Step 1 of 9'), findsOneWidget);
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

      expect(find.text('Step 1 of 9'), findsOneWidget);
      expect(find.text('Some fields contain invalid values.'), findsOneWidget);
      verifyNever(() => mockRepo.save(any()));
    });

    testWidgets('blocks Next on privacy step until acknowledged', (
      tester,
    ) async {
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

      Future<void> next() async {
        await tester.tap(find.text('Next'));
        await tester.pumpAndSettle();
      }

      await tester.enterText(find.byType(TextField), 'Alex');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      // Advance through steps 1-7 to reach the privacy step.
      for (var i = 0; i < 7; i++) {
        await next();
      }

      expect(find.text('Step 8 of 9'), findsOneWidget);
      await next();
      // Still on privacy: acknowledgement is required.
      expect(find.text('Step 8 of 9'), findsOneWidget);
      expect(
        find.text('Please acknowledge the privacy notice to continue'),
        findsOneWidget,
      );

      // Let the validation snackbar fade so it stops obscuring the buttons.
      await tester.pump(const Duration(seconds: 4));
      await tester.tap(find.text('I understand'));
      await tester.pumpAndSettle();
      await next();
      expect(find.text('Step 9 of 9'), findsOneWidget);
    });
  });
}
