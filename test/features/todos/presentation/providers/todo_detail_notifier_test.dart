import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/core/errors/failure.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/domain/entities/todo.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/domain/repositories/todo_repository.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/presentation/providers/todo_detail_notifier.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/data/providers/todo_repository_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepo;
  late ProviderContainer container;

  final sampleTodo = Todo(
    id: 42,
    title: 'Detail Task',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockRepo = MockTodoRepository();
    container = ProviderContainer(
      overrides: [todoRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TodoDetail Notifier', () {
    test('build(id) subscribes to watchById and emits initial value', () async {
      final streamController = StreamController<Todo?>();
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => streamController.stream);

      final provider = todoDetailProvider(42);
      final listener = Listener<AsyncValue<Todo?>>();

      container.listen(provider, listener.call, fireImmediately: true);

      expect(container.read(provider), const AsyncLoading<Todo?>());

      streamController.add(sampleTodo);
      await pumpEventQueue();

      expect(container.read(provider), AsyncData<Todo?>(sampleTodo));

      await streamController.close();
    });

    test('emits null when watched item does not exist or is deleted', () async {
      final streamController = StreamController<Todo?>();
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => streamController.stream);

      final provider = todoDetailProvider(42);
      container.listen(provider, (_, _) {}, fireImmediately: true);

      streamController.add(null);
      await pumpEventQueue();

      expect(container.read(provider), const AsyncData<Todo?>(null));

      await streamController.close();
    });

    test(
      'enters retrying AsyncLoading state on stream error before initial data',
      () async {
        final streamController = StreamController<Todo?>();
        when(
          () => mockRepo.watchById(42),
        ).thenAnswer((_) => streamController.stream);

        final provider = todoDetailProvider(42);
        container.listen(provider, (_, _) {}, fireImmediately: true);

        const failure = DatabaseFailure('Read error');
        streamController.addError(failure);
        await pumpEventQueue();

        final state = container.read(provider);
        expect(state.isLoading, isTrue);

        await streamController.close();
      },
    );

    test(
      'retries preserving previous data when stream errors after initial event',
      () async {
        final streamController = StreamController<Todo?>();
        when(
          () => mockRepo.watchById(42),
        ).thenAnswer((_) => streamController.stream);

        final provider = todoDetailProvider(42);
        container.listen(provider, (_, _) {}, fireImmediately: true);

        streamController.add(sampleTodo);
        await pumpEventQueue();

        streamController.addError(const DatabaseFailure('Stream lost'));
        await pumpEventQueue();

        final state = container.read(provider);
        expect(state.isLoading, isTrue);
        expect(state.value, equals(sampleTodo));

        await streamController.close();
      },
    );
  });
}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}
