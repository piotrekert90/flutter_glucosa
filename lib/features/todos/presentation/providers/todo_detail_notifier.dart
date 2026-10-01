import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/todo.dart';
import '../../data/providers/todo_repository_provider.dart';

part 'todo_detail_notifier.g.dart';

/// Riverpod family state notifier managing state for a single todo item identified by its ID.
///
/// Subscribes directly to [TodoRepository.watchById] for live single-item UI updates.
@riverpod
class TodoDetail extends _$TodoDetail {
  @override
  Stream<Todo?> build(int id) {
    final repository = ref.watch(todoRepositoryProvider);
    return repository.watchById(id);
  }
}
