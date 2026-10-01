import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../mappers/todo_mapper.dart';
import '../models/todo_model.dart';

/// Concrete implementation of [TodoRepository] using Isar database for local persistence.
///
/// Encapsulates all Isar database transactions, query subscriptions, and data mapping logic
/// for todo item storage operations.
class TodoRepositoryImpl implements TodoRepository {
  /// Creates a todo repository instance backed by the given [_isar] database.
  TodoRepositoryImpl(this._isar);

  final Isar _isar;

  /// Watches all todo items stored in the Isar database.
  ///
  /// Emits a continuous [Stream] emitting the complete list of [Todo] entities ordered
  /// by creation date descending whenever the todo collection changes.
  ///
  /// Throws [DatabaseFailure] if a database query error occurs while watching.
  @override
  Stream<List<Todo>> watchAll() {
    return _isar.todoModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch todos: $error');
        });
  }

  /// Watches a specific todo item identified by [id].
  ///
  /// Emits a continuous [Stream] emitting the matching [Todo] entity (or `null` if deleted)
  /// whenever the record matching [id] changes.
  ///
  /// Throws [DatabaseFailure] if a database query error occurs while watching.
  @override
  Stream<Todo?> watchById(int id) {
    return _isar.todoModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toEntity())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch todo $id: $error');
        });
  }

  /// Retrieves a snapshot of all todo items stored in the database.
  ///
  /// Throws [DatabaseFailure] if a database reading error occurs.
  @override
  Future<List<Todo>> getAll() async {
    try {
      final models = await _isar.todoModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load todos: $e');
    }
  }

  /// Adds a new todo item with the given [title].
  @override
  Future<CommandResult> add({required String title}) async {
    try {
      final model = TodoModel()
        ..title = title.trim()
        ..createdAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.todoModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  /// Toggles the completion status of a todo item identified by [id].
  @override
  Future<CommandResult> toggleCompleted({required int id}) async {
    try {
      var found = false;
      await _isar.writeTxn(() async {
        final model = await _isar.todoModels.get(id);
        if (model == null) {
          return;
        }

        found = true;
        model.isCompleted = !model.isCompleted;
        await _isar.todoModels.put(model);
      });
      if (!found) {
        return (false, const DatabaseFailure('Todo not found'));
      }
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  /// Deletes a todo item identified by [id] from Isar storage.
  @override
  Future<CommandResult> delete({required int id}) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.todoModels.delete(id);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }
}
