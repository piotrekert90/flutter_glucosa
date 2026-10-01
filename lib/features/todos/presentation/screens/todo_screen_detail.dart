import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/format.dart';

import '../../../../core/errors/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/todo_detail_notifier.dart';

/// Presentation widget rendering detailed information for a single todo item.
///
/// Watches [todoDetailProvider] for the target [todoId] and displays completion status
/// and formatted creation timestamps.
class TodoDetailScreen extends ConsumerWidget {
  /// Creates a detail screen displaying the todo corresponding to [todoId].
  const TodoDetailScreen({super.key, required this.todoId});

  /// The unique identifier of the target todo item to display.
  final int todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoAsync = ref.watch(todoDetailProvider(todoId));
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.taskDetailsTitle ?? 'Task Details')),
      body: todoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n?.genericError ?? 'An error occurred',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  error is Failure ? error.userMessage : error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => ref.invalidate(todoDetailProvider(todoId)),
                  child: Text(l10n?.tryAgain ?? 'Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (todo) {
          if (todo == null) {
            return Center(
              child: Text(
                l10n?.taskNotFound ?? 'Task not found.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                todo.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow(
                context,
                icon: todo.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                iconColor: todo.isCompleted
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                label: l10n?.statusLabel ?? 'Status',
                value: todo.isCompleted
                    ? (l10n?.statusCompleted ?? 'Completed')
                    : (l10n?.statusInProgress ?? 'In progress'),
              ),
              const Divider(height: 32),
              _buildDetailRow(
                context,
                icon: Icons.calendar_today,
                label: l10n?.createdAtLabel ?? 'Created at',
                value: formatTodoDate(todo.createdAt),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
