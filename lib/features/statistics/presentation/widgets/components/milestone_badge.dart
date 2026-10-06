import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_glucosa/core/presentation/theme/app_feedback_theme.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/milestone_icon_resolver.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/milestone_localizer.dart';

/// An interactive badge displaying an individual milestone achievement with progress and unlock state.
class MilestoneBadge extends StatelessWidget {
  /// The milestone represented by this badge.
  final Milestone milestone;

  /// Creates a [MilestoneBadge].
  const MilestoneBadge({super.key, required this.milestone});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inRangeColor = isDark
        ? AppFeedbackTheme.successForegroundDark
        : AppFeedbackTheme.successForegroundLight;
    final l10n = AppLocalizations.of(context)!;
    final title = milestone.type.localizedTitle(l10n);
    final description = milestone.type.localizedDescription(l10n);
    final isUnlocked = milestone.isUnlocked;

    return Semantics(
      button: true,
      label:
          '$title: ${isUnlocked ? (l10n.milestoneUnlockedDate('')) : l10n.milestoneLocked}',
      child: InkWell(
        onTap: () => _showDetailDialog(
          context,
          l10n,
          cs,
          inRangeColor,
          title,
          description,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 96,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: isUnlocked
                ? inRangeColor.withValues(alpha: 0.12)
                : cs.surfaceContainerHighest.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnlocked
                  ? inRangeColor.withValues(alpha: 0.35)
                  : cs.outlineVariant.withValues(alpha: 0.4),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: CircularProgressIndicator(
                      value: milestone.progress,
                      strokeWidth: 3,
                      backgroundColor: cs.outlineVariant.withValues(
                        alpha: 0.25,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isUnlocked ? inRangeColor : cs.primary,
                      ),
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isUnlocked
                          ? inRangeColor.withValues(alpha: 0.2)
                          : cs.surfaceContainerHighest.withValues(alpha: 0.4),
                    ),
                    child: Icon(
                      MilestoneIconResolver.iconForType(milestone.type),
                      size: 20,
                      color: isUnlocked ? inRangeColor : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: isUnlocked ? FontWeight.bold : FontWeight.w500,
                  color: isUnlocked ? cs.onSurface : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailDialog(
    BuildContext context,
    AppLocalizations l10n,
    ColorScheme cs,
    Color inRangeColor,
    String title,
    String description,
  ) {
    final progressPct = (milestone.progress * 100).round();
    final unlockedDateStr = milestone.unlockedDate != null
        ? DateFormat.yMMMd(l10n.localeName).format(milestone.unlockedDate!)
        : null;

    showAdaptiveDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog.adaptive(
        icon: Icon(
          MilestoneIconResolver.iconForType(milestone.type),
          size: 40,
          color: milestone.isUnlocked ? inRangeColor : cs.primary,
        ),
        title: Text(title, textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (milestone.isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: inRangeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unlockedDateStr != null
                      ? l10n.milestoneUnlockedDate(unlockedDateStr)
                      : l10n.milestoneLocked,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: inRangeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else ...[
              LinearProgressIndicator(
                value: milestone.progress,
                backgroundColor: cs.outlineVariant.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.milestoneProgress(progressPct),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
