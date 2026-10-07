import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/models/blood_pressure_reading_model.dart';
import 'package:flutter_glucosa/features/cholesterol/data/models/cholesterol_reading_model.dart';
import 'package:flutter_glucosa/features/glucose/data/models/glucose_reading_model.dart';
import 'package:flutter_glucosa/features/hba1c/data/models/hba1c_reading_model.dart';
import 'package:flutter_glucosa/features/ketones/data/models/ketone_reading_model.dart';
import 'package:flutter_glucosa/features/reminders/data/models/reminder_model.dart';
import 'package:flutter_glucosa/features/settings/data/models/user_profile_model.dart';
import 'package:flutter_glucosa/features/settings/data/repositories/user_profile_repository_impl.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/weight/data/models/weight_reading_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';

class MockGlucoseCollection extends Mock
    implements IsarCollection<GlucoseReadingModel> {}

class MockHbA1cCollection extends Mock
    implements IsarCollection<HbA1cReadingModel> {}

class MockBloodPressureCollection extends Mock
    implements IsarCollection<BloodPressureReadingModel> {}

class MockKetoneCollection extends Mock
    implements IsarCollection<KetoneReadingModel> {}

class MockCholesterolCollection extends Mock
    implements IsarCollection<CholesterolReadingModel> {}

class MockWeightCollection extends Mock
    implements IsarCollection<WeightReadingModel> {}

class MockReminderCollection extends Mock
    implements IsarCollection<ReminderModel> {}

class MockIsar extends Mock implements Isar {
  Object? writeTxnException;

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) {
    if (writeTxnException != null) {
      throw writeTxnException!;
    }
    return callback();
  }
}

class MockIsarCollection extends Mock
    implements IsarCollection<UserProfileModel> {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserProfileModel());
  });

  late MockIsar mockIsar;
  late MockIsarCollection mockCollection;
  late UserProfileRepositoryImpl repository;

  setUp(() {
    mockIsar = MockIsar();
    mockCollection = MockIsarCollection();

    when(
      () => mockIsar.collection<UserProfileModel>(),
    ).thenReturn(mockCollection);

    repository = UserProfileRepositoryImpl(mockIsar);
  });

  group('UserProfileRepositoryImpl - get()', () {
    test('returns UserProfile.defaults() when model is null', () async {
      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenAnswer((_) async => null);

      final result = await repository.get();

      expect(result, equals(UserProfile.defaults()));
    });

    test('returns mapped UserProfile entity when model exists', () async {
      final model = UserProfileModel()
        ..id = userProfileSingletonId
        ..name = 'Alice'
        ..themeMode = 'dark'
        ..isNotificationsEnabled = false;

      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenAnswer((_) async => model);

      final result = await repository.get();

      expect(result.name, 'Alice');
      expect(result.themeMode, UserThemeMode.dark);
      expect(result.isNotificationsEnabled, isFalse);
    });

    test('throws DatabaseFailure on database error', () async {
      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenThrow(Exception('Read failure'));

      expect(
        () => repository.get(),
        throwsA(
          isA<DatabaseFailure>().having(
            (f) => f.message,
            'message',
            contains('Failed to load user profile'),
          ),
        ),
      );
    });
  });

  group('UserProfileRepositoryImpl - watch()', () {
    test('emits default profile when watched object is null', () async {
      final controller = StreamController<UserProfileModel?>();
      when(
        () => mockCollection.watchObject(
          userProfileSingletonId,
          fireImmediately: true,
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watch();

      expect(stream, emitsInOrder([equals(UserProfile.defaults())]));

      controller.add(null);
      await controller.close();
    });

    test('emits mapped UserProfile when watched object changes', () async {
      final controller = StreamController<UserProfileModel?>();
      when(
        () => mockCollection.watchObject(
          userProfileSingletonId,
          fireImmediately: true,
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watch();

      final model = UserProfileModel()
        ..id = userProfileSingletonId
        ..name = 'Bob'
        ..themeMode = 'light'
        ..isNotificationsEnabled = true;

      expect(
        stream,
        emitsInOrder([
          isA<UserProfile>()
              .having((p) => p.name, 'name', 'Bob')
              .having((p) => p.themeMode, 'themeMode', UserThemeMode.light)
              .having(
                (p) => p.isNotificationsEnabled,
                'isNotificationsEnabled',
                isTrue,
              ),
        ]),
      );

      controller.add(model);
      await controller.close();
    });

    test('wraps stream error into DatabaseFailure', () async {
      final controller = StreamController<UserProfileModel?>();
      when(
        () => mockCollection.watchObject(
          userProfileSingletonId,
          fireImmediately: true,
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watch();

      expect(
        stream,
        emitsError(
          isA<DatabaseFailure>().having(
            (f) => f.message,
            'message',
            contains('Failed to watch user profile'),
          ),
        ),
      );

      controller.addError(Exception('Watch failed'));
      await controller.close();
    });
  });

  group('UserProfileRepositoryImpl - save()', () {
    test('saves profile model to collection', () async {
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      const profile = UserProfile(
        name: 'Charlie',
        diabetesType: DiabetesType.type1,
        themeMode: UserThemeMode.dark,
      );

      final (success, failure) = await repository.save(profile);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.put(any())).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Isar write lock error');

      final (success, failure) = await repository.save(UserProfile.defaults());

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Isar write lock error');
    });
  });

  group('UserProfileRepositoryImpl - update methods', () {
    test('updateThemeMode updates existing model themeMode', () async {
      final existing = UserProfileModel()
        ..id = userProfileSingletonId
        ..themeMode = 'dark';

      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenAnswer((_) async => existing);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.updateThemeMode(
        UserThemeMode.light,
      );

      expect(success, isTrue);
      expect(failure, isNull);
      expect(existing.themeMode, 'light');
      verify(() => mockCollection.put(existing)).called(1);
    });

    test('updateNotificationsEnabled updates isNotificationsEnabled', () async {
      final existing = UserProfileModel()
        ..id = userProfileSingletonId
        ..isNotificationsEnabled = true;

      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenAnswer((_) async => existing);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.updateNotificationsEnabled(
        false,
      );

      expect(success, isTrue);
      expect(failure, isNull);
      expect(existing.isNotificationsEnabled, isFalse);
    });

    test('updateGlucoseUnit updates preferredGlucoseUnit', () async {
      final existing = UserProfileModel()
        ..id = userProfileSingletonId
        ..preferredGlucoseUnit = 'mgDl';

      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenAnswer((_) async => existing);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.updateGlucoseUnit(
        GlucoseUnit.mmolL,
      );

      expect(success, isTrue);
      expect(failure, isNull);
      expect(existing.preferredGlucoseUnit, 'mmolL');
    });

    test('updateTargetRange updates range preset and boundaries', () async {
      final existing = UserProfileModel()..id = userProfileSingletonId;

      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenAnswer((_) async => existing);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.updateTargetRange(
        const GlucoseTargetRange.aace(),
      );

      expect(success, isTrue);
      expect(failure, isNull);
      expect(existing.targetRangePreset, 'aace');
      expect(existing.targetRangeMinMgDl, 110);
      expect(existing.targetRangeMaxMgDl, 140);
    });

    test('completeOnboarding sets isOnboardingCompleted to true', () async {
      final existing = UserProfileModel()
        ..id = userProfileSingletonId
        ..isOnboardingCompleted = false;

      when(
        () => mockCollection.get(userProfileSingletonId),
      ).thenAnswer((_) async => existing);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.completeOnboarding();

      expect(success, isTrue);
      expect(failure, isNull);
      expect(existing.isOnboardingCompleted, isTrue);
    });

    test('returns (false, DatabaseFailure) on unexpected error', () async {
      mockIsar.writeTxnException = Exception('DB error');

      final (success, failure) = await repository.updateThemeMode(
        UserThemeMode.dark,
      );

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('UserProfileRepositoryImpl - wipeAllData()', () {
    test('clears all collections and restores defaults', () async {
      final glucose = MockGlucoseCollection();
      final hba1c = MockHbA1cCollection();
      final bloodPressure = MockBloodPressureCollection();
      final ketone = MockKetoneCollection();
      final cholesterol = MockCholesterolCollection();
      final weight = MockWeightCollection();
      final reminder = MockReminderCollection();
      final List<IsarCollection> wipedCollections = [
        glucose,
        hba1c,
        bloodPressure,
        ketone,
        cholesterol,
        weight,
        reminder,
      ];
      for (final collection in wipedCollections) {
        when(() => collection.clear()).thenAnswer((_) async => 0);
      }
      when(
        () => mockIsar.collection<GlucoseReadingModel>(),
      ).thenReturn(glucose);
      when(() => mockIsar.collection<HbA1cReadingModel>()).thenReturn(hba1c);
      when(
        () => mockIsar.collection<BloodPressureReadingModel>(),
      ).thenReturn(bloodPressure);
      when(() => mockIsar.collection<KetoneReadingModel>()).thenReturn(ketone);
      when(
        () => mockIsar.collection<CholesterolReadingModel>(),
      ).thenReturn(cholesterol);
      when(() => mockIsar.collection<WeightReadingModel>()).thenReturn(weight);
      when(() => mockIsar.collection<ReminderModel>()).thenReturn(reminder);
      when(() => mockCollection.clear()).thenAnswer((_) async => 0);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.wipeAllData();

      expect(success, isTrue);
      expect(failure, isNull);
      for (final collection in wipedCollections) {
        verify(() => collection.clear()).called(1);
      }
      verify(() => mockCollection.clear()).called(1);
      verify(() => mockCollection.put(any())).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('wipe failed');

      final (success, failure) = await repository.wipeAllData();

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
    });
  });
}
