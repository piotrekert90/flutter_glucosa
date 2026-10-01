import 'package:flutter_riverpod_boilerplate/features/todos/domain/entities/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Todo entity', () {
    final now = DateTime(2024, 1, 15, 10, 30);

    test('constructor sets all properties correctly', () {
      final todo = Todo(
        id: 1,
        title: 'Learn Riverpod',
        isCompleted: false,
        createdAt: now,
      );

      expect(todo.id, 1);
      expect(todo.title, 'Learn Riverpod');
      expect(todo.isCompleted, isFalse);
      expect(todo.createdAt, now);
    });

    test(
      'copyWith replaces specified values and retains unspecified values',
      () {
        final initial = Todo(
          id: 1,
          title: 'Initial Title',
          isCompleted: false,
          createdAt: now,
        );

        final updated = initial.copyWith(
          title: 'Updated Title',
          isCompleted: true,
        );

        expect(updated.id, 1);
        expect(updated.title, 'Updated Title');
        expect(updated.isCompleted, isTrue);
        expect(updated.createdAt, now);
      },
    );

    test('supports value equality and hashCode consistency', () {
      final todo1 = Todo(
        id: 1,
        title: 'Test',
        isCompleted: true,
        createdAt: now,
      );
      final todo2 = Todo(
        id: 1,
        title: 'Test',
        isCompleted: true,
        createdAt: now,
      );
      final todo3 = Todo(
        id: 2,
        title: 'Test',
        isCompleted: true,
        createdAt: now,
      );

      expect(todo1, equals(todo2));
      expect(todo1.hashCode, equals(todo2.hashCode));

      expect(todo1, isNot(equals(todo3)));
      expect(todo1, isNot(equals(Object())));
    });
  });
}
