import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/metric_type.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/utils/picker_helpers.dart';
import '../../../../core/presentation/widgets/app_empty_view.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reminder.dart';
import '../providers/reminder_list_notifier.dart';
import '../widgets/reminder_card.dart';

/// Screen allowing users to view, configure, toggle, and delete measurement reminders.
class RemindersScreen extends ConsumerWidget {
  /// Creates a [RemindersScreen].
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final remindersAsync = ref.watch(reminderListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.reminders ?? 'Reminders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditReminderDialog(context, ref),
        icon: const Icon(Icons.add_alarm_outlined),
        label: Text(l10n?.addReminder ?? 'Add Reminder'),
      ),
      body: ClampedLayout(
        child: remindersAsync.when(
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, _) => Center(
            child: AppErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(reminderListProvider),
            ),
          ),
          data: (reminders) {
            if (reminders.isEmpty) {
              return Center(
                child: AppEmptyView(
                  icon: Icons.notifications_none_outlined,
                  title: l10n?.noRemindersTitle ?? 'No reminders scheduled',
                  description:
                      l10n?.noRemindersSubtitle ??
                      'Add reminders to never forget logging your health measurements.',
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return Dismissible(
                  key: ValueKey(reminder.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    color: theme.colorScheme.error,
                    child: Icon(
                      Icons.delete_outline,
                      color: theme.colorScheme.onError,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (dialogCtx) => AlertDialog(
                            title: Text(
                              l10n?.deleteReminder ?? 'Delete Reminder',
                            ),
                            content: Text(
                              l10n?.deleteReminderConfirm ??
                                  'Are you sure you want to delete this reminder?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(dialogCtx).pop(false),
                                child: Text(
                                  MaterialLocalizations.of(
                                    context,
                                  ).cancelButtonLabel,
                                ),
                              ),
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.colorScheme.error,
                                  foregroundColor: theme.colorScheme.onError,
                                ),
                                onPressed: () =>
                                    Navigator.of(dialogCtx).pop(true),
                                child: Text(l10n?.deleteReminder ?? 'Delete'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (_) async {
                    await ref
                        .read(reminderListProvider.notifier)
                        .deleteReminder(reminder.id);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n?.reminderDeletedSuccess ?? 'Reminder deleted',
                          ),
                          action: SnackBarAction(
                            label: l10n?.undo ?? 'Undo',
                            onPressed: () {
                              ref
                                  .read(reminderListProvider.notifier)
                                  .addReminder(reminder);
                            },
                          ),
                        ),
                      );
                    }
                  },
                  child: ReminderCard(
                    reminder: reminder,
                    onToggle: (active) async {
                      final (success, failure) = await ref
                          .read(reminderListProvider.notifier)
                          .toggleReminder(reminder.id, active);
                      if (!success && context.mounted) {
                        AppSnackBar.show(
                          context,
                          message:
                              failure?.message ?? 'Failed to update reminder',
                          type: SnackBarType.error,
                        );
                      }
                    },
                    onTap: () => _showAddEditReminderDialog(
                      context,
                      ref,
                      existing: reminder,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddEditReminderDialog(
    BuildContext context,
    WidgetRef ref, {
    Reminder? existing,
  }) async {
    final l10n = AppLocalizations.of(context);
    final isEditing = existing != null;

    var label = existing?.label ?? '';
    var metricType = existing?.metricType ?? MetricType.glucose;
    var time = TimeOfDay(
      hour: existing?.hourOfDay ?? 8,
      minute: existing?.minute ?? 0,
    );
    var isOneTime = existing?.isOneTime ?? false;
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final theme = Theme.of(context);
            final timeFormatted =
                '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEditing
                            ? (l10n?.editReminder ?? 'Edit Reminder')
                            : (l10n?.addReminder ?? 'Add Reminder'),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: label,
                        decoration: InputDecoration(
                          labelText: l10n?.reminderLabel ?? 'Label',
                          hintText:
                              l10n?.reminderLabelHint ??
                              'e.g. Morning fasting glucose',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.label_outline),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n?.errorValidation ?? 'Label is required';
                          }
                          return null;
                        },
                        onSaved: (val) => label = val?.trim() ?? '',
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.access_time_outlined),
                              label: Text(
                                '${l10n?.reminderTime ?? 'Time'}: $timeFormatted',
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () async {
                                final selected =
                                    await PickerHelpers.showSafeTimePicker(
                                      context: context,
                                      initialTime: time,
                                    );
                                if (selected != null) {
                                  setSheetState(() => time = selected);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<MetricType>(
                        initialValue: metricType,
                        decoration: InputDecoration(
                          labelText: l10n?.reminderMetric ?? 'Health Metric',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.tune_outlined),
                        ),
                        items: MetricType.values.map((metric) {
                          return DropdownMenuItem(
                            value: metric,
                            child: Text(_metricTitle(metric)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setSheetState(() => metricType = val);
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          l10n?.reminderOneTime ?? 'One-time reminder',
                        ),
                        subtitle: Text(
                          l10n?.reminderOneTimeSubtitle ??
                              'Automatically deactivates after firing',
                        ),
                        value: isOneTime,
                        onChanged: (val) {
                          setSheetState(() => isOneTime = val);
                        },
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            formKey.currentState?.save();
                            Navigator.of(context).pop();

                            final reminder = Reminder(
                              id: existing?.id ?? 0,
                              label: label,
                              metricType: metricType,
                              hourOfDay: time.hour,
                              minute: time.minute,
                              isActive: existing?.isActive ?? true,
                              isOneTime: isOneTime,
                            );

                            final (success, failure) = isEditing
                                ? await ref
                                      .read(reminderListProvider.notifier)
                                      .updateReminder(reminder)
                                : await ref
                                      .read(reminderListProvider.notifier)
                                      .addReminder(reminder);

                            if (context.mounted) {
                              if (success) {
                                AppSnackBar.show(
                                  context,
                                  message:
                                      l10n?.reminderSavedSuccess ??
                                      'Reminder saved successfully',
                                  type: SnackBarType.success,
                                );
                              } else {
                                AppSnackBar.show(
                                  context,
                                  message:
                                      failure?.message ??
                                      'Failed to save reminder',
                                  type: SnackBarType.error,
                                );
                              }
                            }
                          }
                        },
                        child: Text(
                          MaterialLocalizations.of(context).saveButtonLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static String _metricTitle(MetricType type) {
    return switch (type) {
      MetricType.glucose => 'Glucose',
      MetricType.hba1c => 'HbA1c',
      MetricType.bloodPressure => 'Blood Pressure',
      MetricType.ketones => 'Ketones',
      MetricType.cholesterol => 'Cholesterol',
      MetricType.weight => 'Weight',
    };
  }
}
