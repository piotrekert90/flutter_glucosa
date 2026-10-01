import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/glucose/data/models/glucose_reading_model.dart';
import 'package:flutter_glucosa/features/glucose/data/repositories/glucose_reading_repository_impl.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
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

class MockQuery extends Mock
    implements
        Query<GlucoseReadingModel>,
        QueryBuilderInternal<GlucoseReadingModel> {
  @override
  MockQuery addSortBy(String property, Sort sort) => this;
  @override
  MockQuery addWhereClause(WhereClause clause) => this;
  @override
  Query<R> build<R>() => this as Query<R>;
  @override
  QueryBuilderInternal<GlucoseReadingModel> copyWith({
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

class MockIsarCollection extends Mock
    implements IsarCollection<GlucoseReadingModel> {
  final MockQuery mockQuery = MockQuery();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #where) {
      return QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QWhere>(
        mockQuery,
      );
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(GlucoseReadingModel());
  });

  late MockIsar mockIsar;
  late MockIsarCollection mockCollection;
  late GlucoseReadingRepositoryImpl repository;
  final testDate = DateTime(2026, 10, 2, 8, 30);

  setUp(() {
    mockIsar = MockIsar();
    mockCollection = MockIsarCollection();

    when(
      () => mockIsar.collection<GlucoseReadingModel>(),
    ).thenReturn(mockCollection);

    repository = GlucoseReadingRepositoryImpl(mockIsar);
  });

  group('GlucoseReadingRepositoryImpl - add()', () {
    test('successfully adds reading and returns (true, null)', () async {
      when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

      final reading = GlucoseReading(
        readingMgDl: 120,
        mealContext: MealContext.beforeBreakfast,
        createdAt: testDate,
      );

      final (success, failure) = await repository.add(reading);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.put(any())).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Storage error');

      final reading = GlucoseReading(
        readingMgDl: 120,
        mealContext: MealContext.beforeBreakfast,
        createdAt: testDate,
      );

      final (success, failure) = await repository.add(reading);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Storage error');
    });

    test('returns (false, DatabaseFailure) on unexpected exception', () async {
      mockIsar.writeTxnException = Exception('Unexpected failure');

      final reading = GlucoseReading(
        readingMgDl: 120,
        mealContext: MealContext.beforeBreakfast,
        createdAt: testDate,
      );

      final (success, failure) = await repository.add(reading);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('GlucoseReadingRepositoryImpl - update()', () {
    test('successfully updates reading and returns (true, null)', () async {
      when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

      final reading = GlucoseReading(
        id: 1,
        readingMgDl: 140,
        mealContext: MealContext.afterLunch,
        createdAt: testDate,
      );

      final (success, failure) = await repository.update(reading);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.put(any())).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Update error');

      final reading = GlucoseReading(
        id: 1,
        readingMgDl: 140,
        mealContext: MealContext.afterLunch,
        createdAt: testDate,
      );

      final (success, failure) = await repository.update(reading);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Update error');
    });
  });

  group('GlucoseReadingRepositoryImpl - delete()', () {
    test('successfully deletes item by id', () async {
      when(() => mockCollection.delete(1)).thenAnswer((_) async => true);

      final (success, failure) = await repository.delete(1);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.delete(1)).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Delete failed');

      final (success, failure) = await repository.delete(1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Delete failed');
    });
  });

  group('GlucoseReadingRepositoryImpl - getById()', () {
    test('returns mapped reading when found', () async {
      final model = GlucoseReadingModel()
        ..id = 1
        ..readingMgDl = 110
        ..mealContext = 'beforeBreakfast'
        ..createdAt = testDate;

      when(() => mockCollection.get(1)).thenAnswer((_) async => model);

      final result = await repository.getById(1);

      expect(result?.id, 1);
      expect(result?.readingMgDl, 110);
      expect(result?.mealContext, MealContext.beforeBreakfast);
    });

    test('returns null when reading not found', () async {
      when(() => mockCollection.get(2)).thenAnswer((_) async => null);

      final result = await repository.getById(2);

      expect(result, isNull);
    });

    test('throws DatabaseFailure on error', () async {
      when(() => mockCollection.get(1)).thenThrow(Exception('DB error'));

      expect(() => repository.getById(1), throwsA(isA<DatabaseFailure>()));
    });
  });

  group('GlucoseReadingRepositoryImpl - watchById()', () {
    test('emits mapped reading when object exists', () async {
      final controller = StreamController<GlucoseReadingModel?>();
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchById(1);

      final model = GlucoseReadingModel()
        ..id = 1
        ..readingMgDl = 125
        ..mealContext = 'snack'
        ..createdAt = testDate;

      expect(
        stream,
        emitsInOrder([
          isA<GlucoseReading>()
              .having((r) => r.id, 'id', 1)
              .having((r) => r.readingMgDl, 'readingMgDl', 125),
        ]),
      );

      controller.add(model);
      await controller.close();
    });

    test('emits null when object is deleted', () async {
      final controller = StreamController<GlucoseReadingModel?>();
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchById(1);

      expect(stream, emitsInOrder([isNull]));

      controller.add(null);
      await controller.close();
    });

    test('wraps stream errors into DatabaseFailure', () async {
      final controller = StreamController<GlucoseReadingModel?>();
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchById(1);

      expect(stream, emitsError(isA<DatabaseFailure>()));

      controller.addError(Exception('Stream error'));
      await controller.close();
    });
  });

  group('GlucoseReadingRepositoryImpl - watchAll() & getAll()', () {
    test('watchAll wraps stream errors into DatabaseFailure', () async {
      final controller = StreamController<List<GlucoseReadingModel>>();
      when(
        () => mockCollection.mockQuery.watch(
          fireImmediately: any(named: 'fireImmediately'),
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchAll();

      expect(stream, emitsError(isA<DatabaseFailure>()));

      controller.addError(Exception('Watch error'));
      await controller.close();
    });

    test('getAll returns mapped entities on success', () async {
      final model = GlucoseReadingModel()
        ..id = 1
        ..readingMgDl = 130
        ..mealContext = 'bedtime'
        ..createdAt = testDate;

      when(
        () => mockCollection.mockQuery.findAll(),
      ).thenAnswer((_) async => [model]);

      final result = await repository.getAll();

      expect(result, hasLength(1));
      expect(result.first.id, 1);
      expect(result.first.readingMgDl, 130);
    });

    test('getAll throws DatabaseFailure on query error', () async {
      when(
        () => mockCollection.mockQuery.findAll(),
      ).thenThrow(Exception('FindAll error'));

      expect(() => repository.getAll(), throwsA(isA<DatabaseFailure>()));
    });
  });

  group('GlucoseReadingRepositoryImpl - watchLatest() & getLatest()', () {
    test('getLatest returns null when collection is empty', () async {
      when(
        () => mockCollection.mockQuery.findFirst(),
      ).thenAnswer((_) async => null);

      final result = await repository.getLatest();

      expect(result, isNull);
    });

    test('getLatest returns mapped reading when found', () async {
      final model = GlucoseReadingModel()
        ..id = 2
        ..readingMgDl = 105
        ..mealContext = 'beforeBreakfast'
        ..createdAt = testDate;

      when(
        () => mockCollection.mockQuery.findFirst(),
      ).thenAnswer((_) async => model);

      final result = await repository.getLatest();

      expect(result?.id, 2);
      expect(result?.readingMgDl, 105);
    });

    test('watchLatest emits null when query returns empty', () async {
      final controller = StreamController<List<GlucoseReadingModel>>();
      when(
        () => mockCollection.mockQuery.watch(
          fireImmediately: any(named: 'fireImmediately'),
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchLatest();

      expect(stream, emitsInOrder([isNull]));

      controller.add([]);
      await controller.close();
    });

    test('watchLatest emits latest reading when available', () async {
      final controller = StreamController<List<GlucoseReadingModel>>();
      when(
        () => mockCollection.mockQuery.watch(
          fireImmediately: any(named: 'fireImmediately'),
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchLatest();

      final model = GlucoseReadingModel()
        ..id = 3
        ..readingMgDl = 99
        ..mealContext = 'fasting'
        ..createdAt = testDate;

      expect(
        stream,
        emitsInOrder([
          isA<GlucoseReading>()
              .having((r) => r.id, 'id', 3)
              .having((r) => r.readingMgDl, 'readingMgDl', 99),
        ]),
      );

      controller.add([model]);
      await controller.close();
    });
  });
}
