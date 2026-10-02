import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/reminders/data/models/reminder_model.dart';
import 'package:flutter_glucosa/features/reminders/data/repositories/reminder_repository_impl.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_notification_service.dart';
import '../../../../helpers/fake_reminder_repository.dart';

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

class MockQuery extends Mock
    implements Query<ReminderModel>, QueryBuilderInternal<ReminderModel> {
  @override
  MockQuery addSortBy(String property, Sort sort) => this;
  @override
  MockQuery addWhereClause(WhereClause clause) => this;
  @override
  Query<R> build<R>() => this as Query<R>;
  @override
  QueryBuilderInternal<ReminderModel> copyWith({
    List<WhereClause>? whereClauses,
    FilterGroup? filter,
    bool? filterIsGrouped,
    FilterGroupType? filterGroupType,
    bool? filterNot,
    List<FilterGroup>? parentFilters,
    List<DistinctProperty>? distinctByProperties,
    List<SortProperty>? sortByProperties,
    int? offset,
    int? limit,
    String? propertyName,
  }) => this;
}

class MockIsarCollection extends Mock implements IsarCollection<ReminderModel> {
  final MockQuery mockQuery = MockQuery();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #where) {
      return QueryBuilder<ReminderModel, ReminderModel, QWhere>(mockQuery);
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(ReminderModel());
    registerFallbackValue(
      const Reminder(
        label: 'fallback',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
      ),
    );
  });

  late MockIsar mockIsar;
  late MockIsarCollection mockCollection;
  late FakeNotificationService fakeNotifications;
  late ReminderRepositoryImpl repository;

  setUp(() {
    mockIsar = MockIsar();
    mockCollection = MockIsarCollection();
    fakeNotifications = FakeNotificationService();

    when(() => mockIsar.collection<ReminderModel>()).thenReturn(mockCollection);

    repository = ReminderRepositoryImpl(
      mockIsar,
      notificationService: fakeNotifications,
    );
  });

  group('ReminderRepositoryImpl - add()', () {
    test(
      'successfully adds reminder, schedules notification, and returns (true, null)',
      () async {
        when(() => mockCollection.put(any())).thenAnswer((_) async => 5);

        const reminder = Reminder(
          label: 'Morning Glucose',
          metricType: MetricType.glucose,
          hourOfDay: 8,
          minute: 0,
          isActive: true,
        );

        final (success, failure) = await repository.add(reminder);

        expect(success, isTrue);
        expect(failure, isNull);
        verify(() => mockCollection.put(any())).called(1);
        expect(fakeNotifications.scheduledReminders.length, equals(1));
        expect(fakeNotifications.scheduledReminders.first.id, equals(5));
      },
    );

    test('does not schedule notification when reminder is inactive', () async {
      when(() => mockCollection.put(any())).thenAnswer((_) async => 6);

      const reminder = Reminder(
        label: 'Inactive Reminder',
        metricType: MetricType.weight,
        hourOfDay: 9,
        minute: 0,
        isActive: false,
      );

      final (success, failure) = await repository.add(reminder);

      expect(success, isTrue);
      expect(failure, isNull);
      expect(fakeNotifications.scheduledReminders, isEmpty);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Storage failure');

      const reminder = Reminder(
        label: 'Fail',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
      );

      final (success, failure) = await repository.add(reminder);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, equals('Storage failure'));
    });

    test('returns (false, DatabaseFailure) on unexpected exception', () async {
      mockIsar.writeTxnException = Exception('Crash');

      const reminder = Reminder(
        label: 'Fail',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
      );

      final (success, failure) = await repository.add(reminder);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('ReminderRepositoryImpl - update()', () {
    test(
      'successfully updates reminder and schedules notification when active',
      () async {
        when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

        const reminder = Reminder(
          id: 1,
          label: 'Updated',
          metricType: MetricType.glucose,
          hourOfDay: 12,
          minute: 0,
          isActive: true,
        );

        final (success, failure) = await repository.update(reminder);

        expect(success, isTrue);
        expect(failure, isNull);
        expect(fakeNotifications.scheduledReminders.length, equals(1));
      },
    );

    test(
      'cancels scheduled notification when updated reminder is inactive',
      () async {
        when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

        const reminder = Reminder(
          id: 1,
          label: 'Updated Deactivated',
          metricType: MetricType.glucose,
          hourOfDay: 12,
          minute: 0,
          isActive: false,
        );

        final (success, failure) = await repository.update(reminder);

        expect(success, isTrue);
        expect(failure, isNull);
        expect(fakeNotifications.cancelledReminderIds, contains(1));
      },
    );

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Update fail');

      const reminder = Reminder(
        id: 2,
        label: 'Fail',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
      );

      final (success, failure) = await repository.update(reminder);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, equals('Update fail'));
    });
  });

  group('ReminderRepositoryImpl - delete()', () {
    test('successfully deletes item and cancels notification', () async {
      when(() => mockCollection.delete(1)).thenAnswer((_) async => true);

      final (success, failure) = await repository.delete(1);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.delete(1)).called(1);
      expect(fakeNotifications.cancelledReminderIds, contains(1));
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Delete fail');

      final (success, failure) = await repository.delete(1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, equals('Delete fail'));
    });
  });

  group('ReminderRepositoryImpl - getById()', () {
    test('returns mapped reminder when found', () async {
      final model = ReminderModel()
        ..id = 1
        ..label = 'Found'
        ..metricType = 'glucose'
        ..hourOfDay = 8
        ..minute = 30
        ..isActive = true
        ..isOneTime = false;

      when(() => mockCollection.get(1)).thenAnswer((_) async => model);

      final result = await repository.getById(1);

      expect(result, isNotNull);
      expect(result?.id, equals(1));
      expect(result?.label, equals('Found'));
    });

    test('returns null when reminder not found', () async {
      when(() => mockCollection.get(99)).thenAnswer((_) async => null);

      final result = await repository.getById(99);

      expect(result, isNull);
    });

    test('throws DatabaseFailure on error', () async {
      when(() => mockCollection.get(any())).thenThrow(Exception('DB error'));

      expect(() => repository.getById(1), throwsA(isA<DatabaseFailure>()));
    });
  });

  group('ReminderRepositoryImpl - watchById()', () {
    test('emits mapped reminder when object exists', () async {
      final model = ReminderModel()
        ..id = 1
        ..label = 'Watched'
        ..metricType = 'glucose'
        ..hourOfDay = 8
        ..minute = 30
        ..isActive = true
        ..isOneTime = false;

      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => Stream.value(model));

      final stream = repository.watchById(1);

      expect(
        stream,
        emits(predicate<Reminder?>((r) => r?.id == 1 && r?.label == 'Watched')),
      );
    });

    test('emits null when object is deleted', () async {
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => Stream.value(null));

      final stream = repository.watchById(1);

      expect(stream, emits(isNull));
    });

    test('wraps stream errors into DatabaseFailure', () async {
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => Stream.error(Exception('Stream error')));

      final stream = repository.watchById(1);

      expect(stream, emitsError(isA<DatabaseFailure>()));
    });
  });

  group('FakeReminderRepository', () {
    late FakeReminderRepository fakeRepo;

    setUp(() {
      fakeRepo = FakeReminderRepository();
    });

    tearDown(() {
      fakeRepo.dispose();
    });

    test('performs in-memory CRUD operations and sorting correctly', () async {
      const r1 = Reminder(
        label: 'Evening',
        metricType: MetricType.glucose,
        hourOfDay: 20,
        minute: 0,
        isActive: true,
      );
      const r2 = Reminder(
        label: 'Morning',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
        isActive: false,
      );

      await fakeRepo.add(r1);
      await fakeRepo.add(r2);

      final all = await fakeRepo.getAll();
      expect(all.length, equals(2));
      expect(all.first.label, equals('Morning')); // Sorted by hour ascending

      final active = await fakeRepo.getActive();
      expect(active.length, equals(1));
      expect(active.first.label, equals('Evening'));

      final updated = all.first.copyWith(isActive: true);
      await fakeRepo.update(updated);
      expect((await fakeRepo.getActive()).length, equals(2));

      await fakeRepo.delete(all.first.id);
      expect((await fakeRepo.getAll()).length, equals(1));
    });

    test('handles shouldFail correctly', () async {
      fakeRepo.shouldFail = true;

      const r = Reminder(
        label: 'Test',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
      );

      expect(
        await fakeRepo.add(r),
        equals((false, const DatabaseFailure('Fake failure'))),
      );
      expect(
        await fakeRepo.update(r),
        equals((false, const DatabaseFailure('Fake failure'))),
      );
      expect(
        await fakeRepo.delete(1),
        equals((false, const DatabaseFailure('Fake failure'))),
      );
      expect(() => fakeRepo.getAll(), throwsA(isA<DatabaseFailure>()));
      expect(() => fakeRepo.getActive(), throwsA(isA<DatabaseFailure>()));
      expect(() => fakeRepo.getById(1), throwsA(isA<DatabaseFailure>()));
    });
  });
}
