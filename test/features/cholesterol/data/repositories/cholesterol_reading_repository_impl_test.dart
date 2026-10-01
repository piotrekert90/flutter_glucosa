import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/cholesterol/data/models/cholesterol_reading_model.dart';
import 'package:flutter_glucosa/features/cholesterol/data/repositories/cholesterol_reading_repository_impl.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
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
        Query<CholesterolReadingModel>,
        QueryBuilderInternal<CholesterolReadingModel> {
  @override
  MockQuery addSortBy(String property, Sort sort) => this;
  @override
  MockQuery addWhereClause(WhereClause clause) => this;
  @override
  Query<R> build<R>() => this as Query<R>;
  @override
  QueryBuilderInternal<CholesterolReadingModel> copyWith({
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
    implements IsarCollection<CholesterolReadingModel> {
  final MockQuery mockQuery = MockQuery();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #where) {
      return QueryBuilder<
        CholesterolReadingModel,
        CholesterolReadingModel,
        QWhere
      >(mockQuery);
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(CholesterolReadingModel());
  });

  late MockIsar mockIsar;
  late MockIsarCollection mockCollection;
  late CholesterolReadingRepositoryImpl repository;
  final testDate = DateTime(2026, 10, 2, 8, 30);

  CholesterolReading testReading() => CholesterolReading(
    totalMgDl: 190,
    ldlMgDl: 110,
    hdlMgDl: 55,
    createdAt: testDate,
  );

  setUp(() {
    mockIsar = MockIsar();
    mockCollection = MockIsarCollection();

    when(
      () => mockIsar.collection<CholesterolReadingModel>(),
    ).thenReturn(mockCollection);

    repository = CholesterolReadingRepositoryImpl(mockIsar);
  });

  group('CholesterolReadingRepositoryImpl - add()', () {
    test('successfully adds reading and returns (true, null)', () async {
      when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

      final (success, failure) = await repository.add(testReading());

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.put(any())).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Storage error');

      final (success, failure) = await repository.add(testReading());

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Storage error');
    });

    test('returns (false, DatabaseFailure) on unexpected exception', () async {
      mockIsar.writeTxnException = Exception('Unexpected failure');

      final (success, failure) = await repository.add(testReading());

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('CholesterolReadingRepositoryImpl - update()', () {
    test('successfully updates reading and returns (true, null)', () async {
      when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

      final reading = testReading().copyWith(id: 1, totalMgDl: 210);

      final (success, failure) = await repository.update(reading);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.put(any())).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Update error');

      final reading = testReading().copyWith(id: 1);

      final (success, failure) = await repository.update(reading);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Update error');
    });
  });

  group('CholesterolReadingRepositoryImpl - delete()', () {
    test('successfully deletes item by id', () async {
      when(() => mockCollection.delete(1)).thenAnswer((_) async => true);

      final (success, failure) = await repository.delete(1);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.delete(1)).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Delete error');

      final (success, failure) = await repository.delete(1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Delete error');
    });
  });

  group('CholesterolReadingRepositoryImpl - getById()', () {
    test('returns mapped reading when found', () async {
      final model = CholesterolReadingModel()
        ..id = 1
        ..totalMgDl = 190
        ..ldlMgDl = 110
        ..hdlMgDl = 55
        ..createdAt = testDate;

      when(() => mockCollection.get(1)).thenAnswer((_) async => model);

      final result = await repository.getById(1);

      expect(result, isNotNull);
      expect(result?.id, 1);
      expect(result?.totalMgDl, 190);
      expect(result?.ldlMgDl, 110);
      expect(result?.hdlMgDl, 55);
    });

    test('returns null when reading not found', () async {
      when(() => mockCollection.get(99)).thenAnswer((_) async => null);

      final result = await repository.getById(99);

      expect(result, isNull);
    });

    test('throws DatabaseFailure on error', () async {
      when(() => mockCollection.get(any())).thenThrow(Exception('DB error'));

      expect(() => repository.getById(1), throwsA(isA<DatabaseFailure>()));
    });
  });

  group('CholesterolReadingRepositoryImpl - watchById()', () {
    test('emits mapped reading when object exists', () async {
      final model = CholesterolReadingModel()
        ..id = 1
        ..totalMgDl = 190
        ..ldlMgDl = 110
        ..hdlMgDl = 55
        ..createdAt = testDate;

      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => Stream.value(model));

      final stream = repository.watchById(1);

      expect(
        stream,
        emits(
          predicate<CholesterolReading?>(
            (r) =>
                r?.id == 1 &&
                r?.totalMgDl == 190 &&
                r?.ldlMgDl == 110 &&
                r?.hdlMgDl == 55,
          ),
        ),
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

  group('CholesterolReadingRepositoryImpl - watchAll() & getAll()', () {
    test('watchAll wraps stream errors into DatabaseFailure', () async {
      when(
        () => mockCollection.mockQuery.watch(fireImmediately: true),
      ).thenAnswer((_) => Stream.error(Exception('Query stream error')));

      final stream = repository.watchAll();

      expect(stream, emitsError(isA<DatabaseFailure>()));
    });

    test('getAll returns mapped entities on success', () async {
      final model1 = CholesterolReadingModel()
        ..id = 1
        ..totalMgDl = 190
        ..ldlMgDl = 110
        ..hdlMgDl = 55
        ..createdAt = testDate;

      when(
        () => mockCollection.mockQuery.findAll(),
      ).thenAnswer((_) async => [model1]);

      final results = await repository.getAll();

      expect(results, hasLength(1));
      expect(results.first.id, 1);
      expect(results.first.totalMgDl, 190);
    });

    test('getAll throws DatabaseFailure on query error', () async {
      when(
        () => mockCollection.mockQuery.findAll(),
      ).thenThrow(Exception('Query error'));

      expect(() => repository.getAll(), throwsA(isA<DatabaseFailure>()));
    });
  });

  group('CholesterolReadingRepositoryImpl - watchLatest() & getLatest()', () {
    test('getLatest returns null when collection is empty', () async {
      when(
        () => mockCollection.mockQuery.findFirst(),
      ).thenAnswer((_) async => null);

      final result = await repository.getLatest();

      expect(result, isNull);
    });

    test('getLatest returns mapped reading when found', () async {
      final model = CholesterolReadingModel()
        ..id = 3
        ..totalMgDl = 200
        ..ldlMgDl = 120
        ..hdlMgDl = 50
        ..createdAt = testDate;

      when(
        () => mockCollection.mockQuery.findFirst(),
      ).thenAnswer((_) async => model);

      final result = await repository.getLatest();

      expect(result?.id, 3);
      expect(result?.totalMgDl, 200);
    });

    test('watchLatest emits null when query returns empty', () async {
      when(
        () => mockCollection.mockQuery.watch(fireImmediately: true),
      ).thenAnswer((_) => Stream.value(<CholesterolReadingModel>[]));

      final stream = repository.watchLatest();

      expect(stream, emits(isNull));
    });

    test('watchLatest emits latest reading when available', () async {
      final model = CholesterolReadingModel()
        ..id = 4
        ..totalMgDl = 185
        ..ldlMgDl = 105
        ..hdlMgDl = 60
        ..createdAt = testDate;

      when(
        () => mockCollection.mockQuery.watch(fireImmediately: true),
      ).thenAnswer((_) => Stream.value([model]));

      final stream = repository.watchLatest();

      expect(
        stream,
        emits(
          predicate<CholesterolReading?>(
            (r) => r?.id == 4 && r?.totalMgDl == 185,
          ),
        ),
      );
    });
  });
}
