import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/daily_tip_provider.dart';

/// Card displaying the rotating daily diabetes self-care tip.
class DailyTipCard extends StatelessWidget {
  /// Creates a [DailyTipCard].
  const DailyTipCard({super.key});

  /// Resolves the localized tip text for a zero-based [index].
  String tipFor(int index, AppLocalizations l10n) {
    final tips = [
      l10n.dailyTip1,
      l10n.dailyTip2,
      l10n.dailyTip3,
      l10n.dailyTip4,
      l10n.dailyTip5,
      l10n.dailyTip6,
      l10n.dailyTip7,
      l10n.dailyTip8,
      l10n.dailyTip9,
      l10n.dailyTip10,
      l10n.dailyTip11,
      l10n.dailyTip12,
      l10n.dailyTip13,
      l10n.dailyTip14,
    ];
    return tips[index % tips.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
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
                    l10n.dailyTipTitle,
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
