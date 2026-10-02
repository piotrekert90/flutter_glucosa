import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/features/settings/presentation/providers/user_profile_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

const _testProfile = UserProfile(
  name: 'Test User',
  diabetesType: DiabetesType.type2,
  themeMode: UserThemeMode.system,
  isNotificationsEnabled: true,
);

ProviderContainer _makeContainer(MockUserProfileRepository mock) {
  return ProviderContainer(
    overrides: [userProfileRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(_testProfile);
  });

  late MockUserProfileRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockUserProfileRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('UserProfileNotifier - build()', () {
    test('returns profile from the first stream event', () async {
      when(
        () => mockRepo.watch(),
      ).thenAnswer((_) => Stream.value(_testProfile));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});

      final result = await container.read(userProfileProvider.future);

      expect(result, _testProfile);
      verify(() => mockRepo.watch()).called(1);
      verifyNever(() => mockRepo.get());
    });

    test('state becomes AsyncData on every new stream event', () async {
      final controller = StreamController<UserProfile>();
      when(() => mockRepo.watch()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});

      controller.add(_testProfile);
      await container.read(userProfileProvider.future);

      final updated = _testProfile.copyWith(themeMode: UserThemeMode.dark);
      controller.add(updated);
      await Future.microtask(() {});

      final state = container.read(userProfileProvider);
      expect(state, isA<AsyncData<UserProfile>>());
      expect(state.value, updated);

      await controller.close();
    });

    test(
      'enters retrying AsyncLoading state when stream consistently errors before first event',
      () async {
        when(
          () => mockRepo.watch(),
        ).thenAnswer((_) => Stream.error(Exception('Isar Error')));

        container = _makeContainer(mockRepo);
        container.listen(userProfileProvider, (_, _) {});

        await Future.microtask(() {});

        final state = container.read(userProfileProvider);
        expect(state.isLoading, isTrue);
      },
    );
  });

  group('UserProfileNotifier - updates', () {
    setUp(() {
      when(
        () => mockRepo.watch(),
      ).thenAnswer((_) => Stream.value(_testProfile));
    });

    test('calls repository.updateThemeMode with selected mode', () async {
      when(
        () => mockRepo.updateThemeMode(UserThemeMode.dark),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateThemeMode(UserThemeMode.dark);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.updateThemeMode(UserThemeMode.dark)).called(1);
    });

    test('calls repository.updateNotificationsEnabled with value', () async {
      when(
        () => mockRepo.updateNotificationsEnabled(false),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateNotificationsEnabled(false);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.updateNotificationsEnabled(false)).called(1);
    });

    test('calls repository.updateBiometricLockEnabled with value', () async {
      when(
        () => mockRepo.updateBiometricLockEnabled(true),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateBiometricLockEnabled(true);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.updateBiometricLockEnabled(true)).called(1);
    });

    test('calls repository.updateHealthSyncEnabled with value', () async {
      when(
        () => mockRepo.updateHealthSyncEnabled(true),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateHealthSyncEnabled(true);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.updateHealthSyncEnabled(true)).called(1);
    });

    test('calls repository.updateLastHealthSyncAt with timestamp', () async {
      final stamp = DateTime(2026, 10, 3, 14, 30);
      when(
        () => mockRepo.updateLastHealthSyncAt(stamp),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateLastHealthSyncAt(stamp);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.updateLastHealthSyncAt(stamp)).called(1);
    });

    test('calls repository.wipeAllData', () async {
      when(() => mockRepo.wipeAllData()).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .wipeAllData();

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.wipeAllData()).called(1);
    });

    test('calls repository.updateGlucoseUnit with unit', () async {
      when(
        () => mockRepo.updateGlucoseUnit(GlucoseUnit.mmolL),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateGlucoseUnit(GlucoseUnit.mmolL);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.updateGlucoseUnit(GlucoseUnit.mmolL)).called(1);
    });

    test('calls repository.updateTargetRange with range', () async {
      when(
        () => mockRepo.updateTargetRange(const GlucoseTargetRange.aace()),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateTargetRange(const GlucoseTargetRange.aace());

      expect(success, isTrue);
      expect(failure, isNull);
      verify(
        () => mockRepo.updateTargetRange(const GlucoseTargetRange.aace()),
      ).called(1);
    });

    test('calls repository.completeOnboarding', () async {
      when(
        () => mockRepo.completeOnboarding(),
      ).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .completeOnboarding();

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockRepo.completeOnboarding()).called(1);
    });

    test('calls repository.save with updated name', () async {
      when(() => mockRepo.get()).thenAnswer((_) async => _testProfile);
      when(() => mockRepo.save(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateName('Jane Doe');

      expect(success, isTrue);
      expect(failure, isNull);
      verify(
        () => mockRepo.save(
          any(
            that: isA<UserProfile>().having((p) => p.name, 'name', 'Jane Doe'),
          ),
        ),
      ).called(1);
    });

    test('calls repository.save with updated diabetes type', () async {
      when(() => mockRepo.get()).thenAnswer((_) async => _testProfile);
      when(() => mockRepo.save(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateDiabetesType(DiabetesType.type1);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(
        () => mockRepo.save(
          any(
            that: isA<UserProfile>().having(
              (p) => p.diabetesType,
              'diabetesType',
              DiabetesType.type1,
            ),
          ),
        ),
      ).called(1);
    });

    test('calls repository.save with updated HbA1c unit', () async {
      when(() => mockRepo.get()).thenAnswer((_) async => _testProfile);
      when(() => mockRepo.save(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateHbA1cUnit(HbA1cUnit.mmolMol);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(
        () => mockRepo.save(
          any(
            that: isA<UserProfile>().having(
              (p) => p.preferredHbA1cUnit,
              'preferredHbA1cUnit',
              HbA1cUnit.mmolMol,
            ),
          ),
        ),
      ).called(1);
    });

    test('calls repository.save with updated weight unit', () async {
      when(() => mockRepo.get()).thenAnswer((_) async => _testProfile);
      when(() => mockRepo.save(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      await container.read(userProfileProvider.future);

      final (success, failure) = await container
          .read(userProfileProvider.notifier)
          .updateWeightUnit(WeightUnit.pounds);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(
        () => mockRepo.save(
          any(
            that: isA<UserProfile>().having(
              (p) => p.preferredWeightUnit,
              'preferredWeightUnit',
              WeightUnit.pounds,
            ),
          ),
        ),
      ).called(1);
    });

    test(
      'returns failure record when update fails and preserves state',
      () async {
        when(() => mockRepo.updateThemeMode(UserThemeMode.light)).thenAnswer(
          (_) async => (false, const DatabaseFailure('Database error')),
        );

        container = _makeContainer(mockRepo);
        container.listen(userProfileProvider, (_, _) {});
        await container.read(userProfileProvider.future);

        final (success, failure) = await container
            .read(userProfileProvider.notifier)
            .updateThemeMode(UserThemeMode.light);

        expect(success, isFalse);
        expect(failure, isA<DatabaseFailure>());
        expect(failure?.message, 'Database error');
        expect(
          container.read(userProfileProvider),
          isA<AsyncData<UserProfile>>(),
        );
      },
    );
  });

  group('UserProfileNotifier - Memory management', () {
    test('cancels stream subscription when container is disposed', () async {
      final controller = StreamController<UserProfile>();
      when(() => mockRepo.watch()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      container.listen(userProfileProvider, (_, _) {});
      controller.add(_testProfile);
      await container.read(userProfileProvider.future);

      container.dispose();

      expect(() => controller.add(_testProfile), returnsNormally);
      await controller.close();
    });
  });
}
