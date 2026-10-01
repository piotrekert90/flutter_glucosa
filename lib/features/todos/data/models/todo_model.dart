import 'package:isar_community/isar.dart';

part 'todo_model.g.dart';

/// Persistent Isar database collection model for storing todo items.
///
/// Serves strictly as a data-layer DTO directly mapped to local storage tables,
/// transformed to and from the domain entity `Todo` using mapper extensions.
@collection
class TodoModel {
  /// The unique auto-incrementing primary key identifier for the todo record.
  Id id = Isar.autoIncrement;

  /// The title or descriptive text of the todo item.
  late String title;

  /// Indicates whether the todo item has been completed.
  bool isCompleted = false;

  /// The timestamp when the todo item was created, indexed for sorted query retrieval.
  @Index()
  late DateTime createdAt;
}
