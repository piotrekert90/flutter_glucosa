import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/daily_tip_provider.dart';

/// Card displaying the rotating daily diabetes self-care tip.
class DailyTipCard extends StatelessWidget {
  /// Creates a [DailyTipCard].
  const DailyTipCard({super.key});

  /// Resolves the localized tip text for a zero-based [index].
  String tipFor(int index, AppLocalizations? l10n) {
    final tips = [
      l10n?.dailyTip1 ?? 'Check glucose before driving.',
      l10n?.dailyTip2 ?? 'Log every reading right away.',
      l10n?.dailyTip3 ?? 'Carry fast-acting glucose with you.',
      l10n?.dailyTip4 ?? 'Walk 10 minutes after meals.',
      l10n?.dailyTip5 ?? 'Review your weekly Time in Range.',
      l10n?.dailyTip6 ?? 'Keep test strips away from heat.',
      l10n?.dailyTip7 ?? 'Stay hydrated throughout the day.',
      l10n?.dailyTip8 ?? 'Pair carbs with protein or fat.',
      l10n?.dailyTip9 ?? 'Set a consistent bedtime.',
      l10n?.dailyTip10 ?? 'Inspect injection sites regularly.',
      l10n?.dailyTip11 ?? 'Learn your personal hypo signs.',
      l10n?.dailyTip12 ?? 'Share summaries with your doctor.',
      l10n?.dailyTip13 ?? 'Recheck after treating a low.',
      l10n?.dailyTip14 ?? 'Celebrate streaks, forgive gaps.',
    ];
    return tips[index % tips.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final tip = tipFor(DailyTipProvider.indexFor(DateTime.now()), l10n);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 28,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.dailyTipTitle ?? 'Daily tip',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
