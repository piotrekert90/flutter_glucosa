import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/providers/onboarding_notifier.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

void main() {
  late MockUserProfileRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(UserProfile.defaults());
  });

  setUp(() {
    mockRepo = MockUserProfileRepository();
    container = ProviderContainer(
      overrides: [userProfileRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Onboarding readNotifier() => container.read(onboardingProvider.notifier);

  group('Onboarding - navigation', () {
    test('starts at step 0 with default selections', () {
      final state = container.read(onboardingProvider);

      expect(state.step, equals(0));
      expect(state.name, isEmpty);
      expect(state.diabetesType, equals(DiabetesType.type2));
      expect(state.glucoseUnit, equals(GlucoseUnit.mgDl));
      expect(state.rangePreset, equals(GlucoseRangePreset.ada));
    });

    test('next() advances and back() returns within bounds', () {
      final notifier = readNotifier();

      notifier.next();
      expect(container.read(onboardingProvider).step, equals(1));

      notifier.back();
      expect(container.read(onboardingProvider).step, equals(0));

      notifier.back();
      expect(container.read(onboardingProvider).step, equals(0));
    });

    test('next() clamps at the last step', () {
      final notifier = readNotifier();

      for (var i = 0; i < 10; i++) {
        notifier.next();
      }

      expect(
        container.read(onboardingProvider).step,
        equals(OnboardingDraft.totalSteps - 1),
      );
    });
  });

  group('Onboarding - draft selections', () {
    test('updateName and selectors modify draft state', () {
      final notifier = readNotifier();

      notifier.updateName('Alex');
      notifier.selectDiabetesType(DiabetesType.type1);
      notifier.selectGlucoseUnit(GlucoseUnit.mmolL);
      notifier.selectRangePreset(GlucoseRangePreset.aace);

      final state = container.read(onboardingProvider);
      expect(state.name, equals('Alex'));
      expect(state.diabetesType, equals(DiabetesType.type1));
      expect(state.glucoseUnit, equals(GlucoseUnit.mmolL));
      expect(state.rangePreset, equals(GlucoseRangePreset.aace));
    });
  });

  group('Onboarding - complete()', () {
    test('saves profile with completed flag and draft values', () async {
      when(() => mockRepo.save(any())).thenAnswer((_) async => (true, null));

      final notifier = readNotifier();
      notifier.updateName('  Alex  ');
      notifier.selectDiabetesType(DiabetesType.gestational);
      notifier.selectGlucoseUnit(GlucoseUnit.mmolL);
      notifier.selectRangePreset(GlucoseRangePreset.ukNice);

      final (success, failure) = await notifier.complete();

      expect(success, isTrue);
      expect(failure, isNull);

      final captured =
          verify(() => mockRepo.save(captureAny())).captured.single
              as UserProfile;
      expect(captured.name, equals('Alex'));
      expect(captured.diabetesType, equals(DiabetesType.gestational));
      expect(captured.preferredGlucoseUnit, equals(GlucoseUnit.mmolL));
      expect(captured.targetRange.minMgDl, equals(72));
      expect(captured.targetRange.maxMgDl, equals(153));
      expect(captured.isOnboardingCompleted, isTrue);
    });
  });
}
