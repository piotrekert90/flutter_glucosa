import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/todo.dart';
import '../../data/providers/todo_repository_provider.dart';

part 'todo_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of todo items.
///
/// Listens directly to [TodoRepository.watchAll] streams and exposes UI state actions
/// for creating, toggling, and deleting todo entities.
@riverpod
class TodoList extends _$TodoList {
  @override
  Stream<List<Todo>> build() {
    final repository = ref.watch(todoRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new todo item with the given [title].
  ///
  /// Trims whitespace from [title] before calling the repository. Returns a [Future] completing
  /// with a [CommandResult] containing `(false, DatabaseFailure)` if [title] is empty or whitespace-only.
  Future<CommandResult> addTodo(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return (false, const DatabaseFailure('Title cannot be empty'));
    }
    return ref.read(todoRepositoryProvider).add(title: trimmedTitle);
  }

  /// Toggles the completion status of a todo item identified by [id].
  Future<CommandResult> toggleTodo(int id) {
    return ref.read(todoRepositoryProvider).toggleCompleted(id: id);
  }

  /// Deletes a todo item identified by [id].
  Future<CommandResult> deleteTodo(int id) {
    return ref.read(todoRepositoryProvider).delete(id: id);
  }
}
