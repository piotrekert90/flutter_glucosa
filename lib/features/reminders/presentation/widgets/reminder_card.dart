import 'package:flutter/material.dart';

import '../../../../core/domain/enums/metric_type.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reminder.dart';

/// Presentation card displaying a scheduled [Reminder] with a status toggle and metric badge.
class ReminderCard extends StatelessWidget {
  /// The reminder configuration displayed by this card.
  final Reminder reminder;

  /// Callback triggered when the active state switch is toggled.
  final ValueChanged<bool>? onToggle;

  /// Optional callback invoked when the card is tapped.
  final VoidCallback? onTap;

  /// Creates a [ReminderCard].
  const ReminderCard({
    super.key,
    required this.reminder,
    this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final formattedTime = TimeOfDay(
      hour: reminder.hourOfDay,
      minute: reminder.minute,
    ).format(context);

    final (metricIcon, metricLabel) = _metricInfo(reminder.metricType, l10n);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: MergeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formattedTime,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: reminder.isActive
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.38,
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reminder.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: reminder.isActive
                              ? theme.colorScheme.onSurfaceVariant
                              : theme.colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.38,
                                ),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _BadgeChip(
                            icon: metricIcon,
                            label: metricLabel,
                            isActive: reminder.isActive,
                          ),
                          _BadgeChip(
                            icon: reminder.isOneTime
                                ? Icons.looks_one_outlined
                                : Icons.repeat_outlined,
                            label: reminder.isOneTime
                                ? l10n.reminderOnce
                                : l10n.reminderDaily,
                            isActive: reminder.isActive,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Semantics(
              label: l10n.reminderActiveToggle,
              child: Switch.adaptive(
                value: reminder.isActive,
                onChanged: onToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, String) _metricInfo(MetricType type, AppLocalizations l10n) {
    return switch (type) {
      MetricType.glucose => (Icons.water_drop_outlined, l10n.glucose),
      MetricType.hba1c => (Icons.biotech_outlined, l10n.hba1c),
      MetricType.bloodPressure => (Icons.favorite_outline, l10n.bloodPressure),
      MetricType.ketones => (Icons.science_outlined, l10n.ketones),
      MetricType.cholesterol => (Icons.bubble_chart_outlined, l10n.cholesterol),
      MetricType.weight => (Icons.monitor_weight_outlined, l10n.weight),
    };
  }
}

class _BadgeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _BadgeChip({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
