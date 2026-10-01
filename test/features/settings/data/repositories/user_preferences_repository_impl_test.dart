import 'dart:async';

import 'package:flutter_riverpod_boilerplate/core/errors/failure.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/data/models/user_preferences_model.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/data/repositories/user_preferences_repository_impl.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';

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
    implements IsarCollection<UserPreferencesModel> {}

void main() {
  setUpAll(() {
    registerFallbackValue(UserPreferencesModel());
  });

  late MockIsar mockIsar;
  late MockIsarCollection mockCollection;
  late UserPreferencesRepositoryImpl repository;

  setUp(() {
    mockIsar = MockIsar();
    mockCollection = MockIsarCollection();

    when(
      () => mockIsar.collection<UserPreferencesModel>(),
    ).thenReturn(mockCollection);

    repository = UserPreferencesRepositoryImpl(mockIsar);
  });

  group('UserPreferencesRepositoryImpl - get()', () {
    test('returns UserPreferences.defaults() when model is null', () async {
      when(
        () => mockCollection.get(userPreferencesSingletonId),
      ).thenAnswer((_) async => null);

      final result = await repository.get();

      expect(result, equals(UserPreferences.defaults()));
    });

    test('returns mapped UserPreferences entity when model exists', () async {
      final model = UserPreferencesModel()
        ..id = userPreferencesSingletonId
        ..themeMode = 'dark'
        ..isNotificationsEnabled = false;

      when(
        () => mockCollection.get(userPreferencesSingletonId),
      ).thenAnswer((_) async => model);

      final result = await repository.get();

      expect(result.themeMode, UserThemeMode.dark);
      expect(result.isNotificationsEnabled, isFalse);
    });

    test('throws DatabaseFailure on database error', () async {
      when(
        () => mockCollection.get(userPreferencesSingletonId),
      ).thenThrow(Exception('Read failure'));

      expect(
        () => repository.get(),
        throwsA(
          isA<DatabaseFailure>().having(
            (f) => f.message,
            'message',
            contains('Failed to load preferences'),
          ),
        ),
      );
    });
  });

  group('UserPreferencesRepositoryImpl - watch()', () {
    test('emits default preferences when watched object is null', () async {
      final controller = StreamController<UserPreferencesModel?>();
      when(
        () => mockCollection.watchObject(
          userPreferencesSingletonId,
          fireImmediately: true,
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watch();

      expect(stream, emitsInOrder([equals(UserPreferences.defaults())]));

      controller.add(null);
      await controller.close();
    });

    test('emits mapped UserPreferences when watched object changes', () async {
      final controller = StreamController<UserPreferencesModel?>();
      when(
        () => mockCollection.watchObject(
          userPreferencesSingletonId,
          fireImmediately: true,
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watch();

      final model = UserPreferencesModel()
        ..id = userPreferencesSingletonId
        ..themeMode = 'light'
        ..isNotificationsEnabled = true;

      expect(
        stream,
        emitsInOrder([
          isA<UserPreferences>()
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
      final controller = StreamController<UserPreferencesModel?>();
      when(
        () => mockCollection.watchObject(
          userPreferencesSingletonId,
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
            contains('Failed to watch preferences'),
          ),
        ),
      );

      controller.addError(Exception('Watch failed'));
      await controller.close();
    });
  });

  group('UserPreferencesRepositoryImpl - updateThemeMode()', () {
    test('creates new model if absent and updates themeMode to dark', () async {
      when(
        () => mockCollection.get(userPreferencesSingletonId),
      ).thenAnswer((_) async => null);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.updateThemeMode(
        UserThemeMode.dark,
      );

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.put(any())).called(2);
    });

    test('updates existing model themeMode to light', () async {
      final existing = UserPreferencesModel()
        ..id = userPreferencesSingletonId
        ..themeMode = 'dark'
        ..isNotificationsEnabled = true;

      when(
        () => mockCollection.get(userPreferencesSingletonId),
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

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Isar write lock error');

      final (success, failure) = await repository.updateThemeMode(
        UserThemeMode.system,
      );

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Isar write lock error');
    });

    test('returns (false, DatabaseFailure) on unexpected exception', () async {
      mockIsar.writeTxnException = Exception('Storage unavailable');

      final (success, failure) = await repository.updateThemeMode(
        UserThemeMode.dark,
      );

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('UserPreferencesRepositoryImpl - updateNotificationsEnabled()', () {
    test(
      'creates new model if absent and updates isNotificationsEnabled',
      () async {
        when(
          () => mockCollection.get(userPreferencesSingletonId),
        ).thenAnswer((_) async => null);
        when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

        final (success, failure) = await repository.updateNotificationsEnabled(
          false,
        );

        expect(success, isTrue);
        expect(failure, isNull);
        verify(() => mockCollection.put(any())).called(2);
      },
    );

    test('updates existing model isNotificationsEnabled to true', () async {
      final existing = UserPreferencesModel()
        ..id = userPreferencesSingletonId
        ..themeMode = 'system'
        ..isNotificationsEnabled = false;

      when(
        () => mockCollection.get(userPreferencesSingletonId),
      ).thenAnswer((_) async => existing);
      when(() => mockCollection.put(any())).thenAnswer((_) async => 0);

      final (success, failure) = await repository.updateNotificationsEnabled(
        true,
      );

      expect(success, isTrue);
      expect(failure, isNull);
      expect(existing.isNotificationsEnabled, isTrue);
      verify(() => mockCollection.put(existing)).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('DB write error');

      final (success, failure) = await repository.updateNotificationsEnabled(
        true,
      );

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'DB write error');
    });

    test('returns (false, DatabaseFailure) on unexpected exception', () async {
      mockIsar.writeTxnException = Exception('Unknown failure');

      final (success, failure) = await repository.updateNotificationsEnabled(
        false,
      );

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });
}
