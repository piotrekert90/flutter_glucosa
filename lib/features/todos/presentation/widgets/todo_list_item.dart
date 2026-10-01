import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../shared/format.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/todo.dart';

/// Reusable list tile component rendering a single todo item within a dismissible list.
///
/// Features interactive checkbox toggling, swipe-to-delete dismissal, and tap navigation
/// to the detail screen for the given [todo].
class TodoListItem extends StatelessWidget {
  /// Creates a list tile displaying [todo] with action callbacks.
  const TodoListItem({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
    this.onTap,
  });

  /// The domain [Todo] entity represented by this list item.
  final Todo todo;

  /// Callback executed when the checkbox state is toggled by the user.
  final VoidCallback onToggle;

  /// Callback executed when the item is swiped away to be deleted.
  final VoidCallback onDelete;

  /// Optional custom callback executed on tap, overriding default GoRouter navigation.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.error,
        child: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap:
            onTap ??
            () {
              context.pushNamed(
                AppRoute.todoDetail.name,
                pathParameters: {'id': todo.id.toString()},
              );
            },
        leading: Semantics(
          label: todo.isCompleted
              ? (l10n?.markAsNotDone(todo.title) ??
                    'Mark "${todo.title}" as not done')
              : (l10n?.markAsDone(todo.title) ??
                    'Mark "${todo.title}" as done'),
          child: Checkbox(
            value: todo.isCompleted,
            onChanged: (_) => onToggle(),
          ),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : null,
          ),
        ),
        subtitle: Text(
          formatTodoDate(todo.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
