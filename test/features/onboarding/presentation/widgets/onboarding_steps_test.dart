import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/providers/onboarding_notifier.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_confirm_step.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_diabetes_step.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_units_step.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_welcome_step.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(UserProfile.defaults());
  });

  group('OnboardingWelcomeStep', () {
    testWidgets('renders title, subtitle and name field', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingWelcomeStep()));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Glucosa'), findsOneWidget);
      expect(
        find.text("Let's set up your profile in a few quick steps."),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('typing updates the draft name', (tester) async {
      late ProviderContainer container;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: OnboardingWelcomeStep()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      container = ProviderScope.containerOf(
        tester.element(find.byType(TextField)),
      );

      await tester.enterText(find.byType(TextField), 'Alex');
      await tester.pumpAndSettle();

      expect(container.read(onboardingProvider).name, equals('Alex'));
    });
  });

  group('OnboardingDiabetesStep', () {
    testWidgets('renders all four diabetes type options', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingDiabetesStep()));
      await tester.pumpAndSettle();

      expect(find.text('Which type of diabetes do you have?'), findsOneWidget);
      expect(find.text('Type 1'), findsOneWidget);
      expect(find.text('Type 2'), findsOneWidget);
      expect(find.text('Gestational'), findsOneWidget);
      expect(find.text('LADA'), findsOneWidget);
    });

    testWidgets('selecting a chip updates the draft type', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingDiabetesStep()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Type 1'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.text('Type 1')),
      );
      expect(
        container.read(onboardingProvider).diabetesType.name,
        equals('type1'),
      );
    });
  });

  group('OnboardingUnitsStep', () {
    testWidgets('renders unit segmented control and range presets', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const OnboardingUnitsStep()));
      await tester.pumpAndSettle();

      expect(find.text('Preferred units and target range'), findsOneWidget);
      expect(find.text('mg/dL'), findsOneWidget);
      expect(find.text('mmol/L'), findsOneWidget);
      expect(find.textContaining('ADA'), findsOneWidget);
      expect(find.textContaining('AACE'), findsOneWidget);
      expect(find.textContaining('UK NICE'), findsOneWidget);
    });

    testWidgets('selecting mmol/L updates the draft unit', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingUnitsStep()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('mmol/L'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.text('mmol/L')),
      );
      expect(
        container.read(onboardingProvider).glucoseUnit.name,
        equals('mmolL'),
      );
    });
  });

  group('OnboardingConfirmStep', () {
    testWidgets('renders summary and saves on Get Started', (tester) async {
      final mockRepo = MockUserProfileRepository();
      when(() => mockRepo.save(any())).thenAnswer((_) async => (true, null));

      var completed = false;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: OnboardingConfirmStep(
                onCompleted: () {
                  completed = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("You're all set!"), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.save(any())).called(1);
      expect(completed, isTrue);
    });
  });
}
