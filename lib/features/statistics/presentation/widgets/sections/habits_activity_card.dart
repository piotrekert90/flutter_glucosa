import 'package:flutter/material.dart';

import 'package:flutter_glucosa/l10n/app_localizations.dart';

/// Card widget displaying patient logging habits, current streak, best streak, and compliance.
class HabitsActivityCard extends StatelessWidget {
  /// Current consecutive days streak.
  final int streak;

  /// Longest historical consecutive days streak.
  final int bestStreak;

  /// Monthly logging compliance percentage (0-100).
  final int compliancePct;

  /// Creates a [HabitsActivityCard].
  const HabitsActivityCard({
    super.key,
    required this.streak,
    required this.bestStreak,
    required this.compliancePct,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final streakLabel = l10n.streakDays(streak);
    final bestStreakLabel = l10n.streakDays(bestStreak);

    return Semantics(
      container: true,
      label:
          '${l10n.habitsAndStreaks}: ${l10n.currentStreak}: $streakLabel, ${l10n.bestStreak}: $bestStreakLabel, ${l10n.monthlyCompliance}: $compliancePct%',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.event_repeat_rounded, size: 24, color: cs.primary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.habitsAndStreaks,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      context,
                      icon: Icons.local_fire_department_rounded,
                      iconColor: cs.primary,
                      title: l10n.currentStreak,
                      value: streakLabel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      context,
                      icon: Icons.emoji_events_rounded,
                      iconColor: cs.tertiary,
                      title: l10n.bestStreak,
                      value: bestStreakLabel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      context,
                      icon: Icons.pie_chart_rounded,
                      iconColor: cs.secondary,
                      title: l10n.monthlyCompliance,
                      value: '$compliancePct%',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
