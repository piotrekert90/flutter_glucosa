import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/providers/onboarding_notifier.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_csv_import_step.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_diabetes_step.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_privacy_step.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/widgets/onboarding_target_range_step.dart';
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

    testWidgets('entering baseline updates the draft in mg/dL', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingDiabetesStep()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      expect(fields, findsOneWidget);
      await tester.enterText(fields, '120');
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(TextField)),
      );
      expect(container.read(onboardingProvider).baselineMgDl, equals(120));
    });

    testWidgets('invalid baseline shows error and clears draft value', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const OnboardingDiabetesStep()));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '9999');
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid glucose value'), findsOneWidget);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(TextField)),
      );
      expect(container.read(onboardingProvider).baselineMgDl, isNull);
    });
  });

  group('OnboardingUnitsStep', () {
    testWidgets('renders unit segmented control without range presets', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const OnboardingUnitsStep()));
      await tester.pumpAndSettle();

      expect(find.text('Preferred glucose unit'), findsOneWidget);
      expect(find.text('mg/dL'), findsOneWidget);
      expect(find.text('mmol/L'), findsOneWidget);
      expect(find.textContaining('ADA'), findsNothing);
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

  group('OnboardingTargetRangeStep', () {
    testWidgets('renders presets and updates the draft range', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingTargetRangeStep()));
      await tester.pumpAndSettle();

      expect(find.text('Choose your target range'), findsOneWidget);
      expect(find.textContaining('ADA'), findsOneWidget);

      await tester.tap(find.textContaining('AACE'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.textContaining('AACE')),
      );
      expect(
        container.read(onboardingProvider).rangePreset.name,
        equals('aace'),
      );
    });
  });

  group('OnboardingPrivacyStep', () {
    testWidgets('acknowledging updates the draft flag', (tester) async {
      await tester.pumpWidget(_wrap(const OnboardingPrivacyStep()));
      await tester.pumpAndSettle();

      expect(find.text('Your data stays yours'), findsOneWidget);
      await tester.tap(find.text('I understand'));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.text('I understand')),
      );
      expect(container.read(onboardingProvider).privacyAcknowledged, isTrue);
    });
  });

  group('OnboardingCsvImportStep', () {
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
              body: OnboardingCsvImportStep(
                onCompleted: () {
                  completed = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bring your history'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);

      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      verify(() => mockRepo.save(any())).called(1);
      expect(completed, isTrue);
    });
  });
}
