/// Domain entity representing a single todo item in the application.
///
/// Encapsulates core business data and state for task management, remaining decoupled
/// from data storage implementations and UI frameworks.
class Todo {
  /// Creates a todo entity instance with the specified properties.
  const Todo({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
  });

  /// The unique identifier of the todo item.
  final int id;

  /// The title or descriptive text of the todo item.
  final String title;

  /// Indicates whether the task represented by this todo is completed.
  final bool isCompleted;

  /// The date and time when this todo item was originally created.
  final DateTime createdAt;

  /// Creates a copy of this [Todo] with the given fields replaced with new values.
  Todo copyWith({
    int? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Todo &&
            other.id == id &&
            other.title == title &&
            other.isCompleted == isCompleted &&
            other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, title, isCompleted, createdAt);
}
