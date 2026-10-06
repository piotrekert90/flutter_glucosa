import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/utils/picker_helpers.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// Sixth onboarding step configuring an optional daily measurement reminder.
///
/// The chosen time is stored in the draft; the reminder itself is created
/// when the wizard completes. The step is skippable.
class OnboardingReminderStep extends ConsumerWidget {
  /// Creates an [OnboardingReminderStep].
  const OnboardingReminderStep({super.key});

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final draft = ref.read(onboardingProvider);
    final initial = TimeOfDay(
      hour: draft.reminderHour ?? 8,
      minute: draft.reminderMinute ?? 0,
    );
    final picked = await PickerHelpers.showSafeTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked == null) return;
    ref
        .read(onboardingProvider.notifier)
        .setReminderTime(picked.hour, picked.minute);
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool enable) async {
    if (!enable) {
      ref.read(onboardingProvider.notifier).setReminderTime(null, null);
      return;
    }
    // Enabling opens the time picker; cancelling it leaves the toggle
    // off, which already reflects the resulting draft state.
    await _pickTime(context, ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final draft = ref.watch(onboardingProvider);

    final timeLabel =
        draft.reminderEnabled &&
            draft.reminderHour != null &&
            draft.reminderMinute != null
        ? TimeOfDay(
            hour: draft.reminderHour!,
            minute: draft.reminderMinute!,
          ).format(context)
        : l10n.onboardingReminderOff;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.alarm_outlined,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingReminderTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingReminderSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SwitchListTile.adaptive(
            title: Text(l10n.onboardingReminderEnable),
            subtitle: Text(timeLabel),
            value: draft.reminderEnabled,
            onChanged: (value) => _toggle(context, ref, value),
          ),
          if (draft.reminderEnabled) ...[
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _pickTime(context, ref),
              icon: const Icon(Icons.schedule_outlined),
              label: Text(l10n.onboardingReminderChange),
            ),
          ],
        ],
      ),
    );
  }
}
