import 'dart:async';

import 'package:flutter_riverpod_boilerplate/core/errors/failure.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/data/models/todo_model.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/data/repositories/todo_repository_impl.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/domain/entities/todo.dart';
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
    implements Query<TodoModel>, QueryBuilderInternal<TodoModel> {
  @override
  MockQuery addSortBy(String property, Sort sort) => this;
  @override
  MockQuery addWhereClause(WhereClause clause) => this;
  @override
  Query<R> build<R>() => this as Query<R>;
}

class MockIsarCollection extends Mock implements IsarCollection<TodoModel> {
  final MockQuery mockQuery = MockQuery();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #where) {
      return QueryBuilder<TodoModel, TodoModel, QWhere>(mockQuery);
    }
    return super.noSuchMethod(invocation);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(TodoModel());
  });

  late MockIsar mockIsar;
  late MockIsarCollection mockCollection;
  late TodoRepositoryImpl repository;

  setUp(() {
    mockIsar = MockIsar();
    mockCollection = MockIsarCollection();

    when(() => mockIsar.collection<TodoModel>()).thenReturn(mockCollection);

    repository = TodoRepositoryImpl(mockIsar);
  });

  group('TodoRepositoryImpl - add()', () {
    test('successfully adds todo and returns (true, null)', () async {
      when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

      final (success, failure) = await repository.add(title: ' Buy milk ');

      expect(success, isTrue);
      expect(failure, isNull);
      verify(
        () => mockCollection.put(
          any(
            that: isA<TodoModel>()
                .having((m) => m.title, 'title', 'Buy milk')
                .having((m) => m.isCompleted, 'isCompleted', false),
          ),
        ),
      ).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Write error');

      final (success, failure) = await repository.add(title: 'Test');

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Write error');
    });

    test('returns (false, DatabaseFailure) on unexpected exception', () async {
      mockIsar.writeTxnException = StateError('Unexpected');

      final (success, failure) = await repository.add(title: 'Test');

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('TodoRepositoryImpl - toggleCompleted()', () {
    test('returns (false, DatabaseFailure) when item does not exist', () async {
      when(() => mockCollection.get(1)).thenAnswer((_) async => null);

      final (success, failure) = await repository.toggleCompleted(id: 1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Todo not found');
    });

    test(
      'toggles completed status and returns (true, null) when found',
      () async {
        final existing = TodoModel()
          ..id = 1
          ..title = 'Task 1'
          ..isCompleted = false
          ..createdAt = DateTime(2024, 1, 1);

        when(() => mockCollection.get(1)).thenAnswer((_) async => existing);
        when(() => mockCollection.put(any())).thenAnswer((_) async => 1);

        final (success, failure) = await repository.toggleCompleted(id: 1);

        expect(success, isTrue);
        expect(failure, isNull);
        expect(existing.isCompleted, isTrue);
        verify(() => mockCollection.put(existing)).called(1);
      },
    );

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Isar exception');

      final (success, failure) = await repository.toggleCompleted(id: 1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Isar exception');
    });

    test('returns (false, DatabaseFailure) on unexpected exception', () async {
      mockIsar.writeTxnException = Exception('Generic error');

      final (success, failure) = await repository.toggleCompleted(id: 1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('TodoRepositoryImpl - delete()', () {
    test('successfully deletes item by id', () async {
      when(() => mockCollection.delete(1)).thenAnswer((_) async => true);

      final (success, failure) = await repository.delete(id: 1);

      expect(success, isTrue);
      expect(failure, isNull);
      verify(() => mockCollection.delete(1)).called(1);
    });

    test('returns (false, DatabaseFailure) on IsarError', () async {
      mockIsar.writeTxnException = IsarError('Delete failed');

      final (success, failure) = await repository.delete(id: 1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, 'Delete failed');
    });

    test('returns (false, DatabaseFailure) on unexpected error', () async {
      mockIsar.writeTxnException = Exception('Fail');

      final (success, failure) = await repository.delete(id: 1);

      expect(success, isFalse);
      expect(failure, isA<DatabaseFailure>());
      expect(failure?.message, contains('Unexpected error'));
    });
  });

  group('TodoRepositoryImpl - watchById()', () {
    test('emits mapped Todo when object exists', () async {
      final controller = StreamController<TodoModel?>();
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchById(1);

      final model = TodoModel()
        ..id = 1
        ..title = 'Watched Item'
        ..isCompleted = false
        ..createdAt = DateTime(2024, 1, 1);

      expect(
        stream,
        emitsInOrder([
          isA<Todo>()
              .having((t) => t.id, 'id', 1)
              .having((t) => t.title, 'title', 'Watched Item'),
        ]),
      );

      controller.add(model);
      await controller.close();
    });

    test('emits null when object is deleted or does not exist', () async {
      final controller = StreamController<TodoModel?>();
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchById(1);

      expect(stream, emitsInOrder([isNull]));

      controller.add(null);
      await controller.close();
    });

    test('wraps stream errors into DatabaseFailure', () async {
      final controller = StreamController<TodoModel?>();
      when(
        () => mockCollection.watchObject(1, fireImmediately: true),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchById(1);

      expect(
        stream,
        emitsError(
          isA<DatabaseFailure>().having(
            (f) => f.message,
            'message',
            contains('Failed to watch todo 1'),
          ),
        ),
      );

      controller.addError(Exception('Stream failure'));
      await controller.close();
    });
  });

  group('TodoRepositoryImpl - watchAll() & getAll()', () {
    test('watchAll wraps stream errors into DatabaseFailure', () async {
      final controller = StreamController<List<TodoModel>>();
      when(
        () => mockCollection.mockQuery.watch(
          fireImmediately: any(named: 'fireImmediately'),
        ),
      ).thenAnswer((_) => controller.stream);

      final stream = repository.watchAll();

      expect(
        stream,
        emitsError(
          isA<DatabaseFailure>().having(
            (f) => f.message,
            'message',
            contains('Failed to watch todos'),
          ),
        ),
      );

      controller.addError(Exception('Query stream error'));
      await controller.close();
    });

    test('getAll wraps query errors into DatabaseFailure', () async {
      when(
        () => mockCollection.mockQuery.findAll(),
      ).thenThrow(Exception('Find all error'));

      expect(
        () => repository.getAll(),
        throwsA(
          isA<DatabaseFailure>().having(
            (f) => f.message,
            'message',
            contains('Failed to load todos'),
          ),
        ),
      );
    });

    test('getAll returns mapped entities on success', () async {
      final model1 = TodoModel()
        ..id = 1
        ..title = 'Item 1'
        ..isCompleted = false
        ..createdAt = DateTime(2024, 1, 1);

      when(
        () => mockCollection.mockQuery.findAll(),
      ).thenAnswer((_) async => [model1]);

      final result = await repository.getAll();

      expect(result, hasLength(1));
      expect(result.first.id, 1);
      expect(result.first.title, 'Item 1');
    });
  });
}
