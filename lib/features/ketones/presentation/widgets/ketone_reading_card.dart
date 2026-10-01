import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ketone_reading.dart';

/// Presentation card displaying an individual [KetoneReading] with clinical status badge.
class KetoneReadingCard extends StatelessWidget {
  /// The reading entity displayed by this card.
  final KetoneReading reading;

  /// Optional callback invoked when the user taps the card.
  final VoidCallback? onTap;

  /// Creates a [KetoneReadingCard].
  const KetoneReadingCard({super.key, required this.reading, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final displayValue = reading.readingMmolL.toStringAsFixed(1);
    const unitLabel = 'mmol/L';

    final formattedDate = DateFormat.yMMMd().format(reading.createdAt);

    // Clinical status badge per audit ketone levels:
    // Normal (<0.6), Elevated (0.6-1.5), High (>1.5, incl. DKA risk).
    final Color badgeColor;
    final String badgeLabel;
    if (reading.readingMmolL < 0.6) {
      badgeColor = isDark
          ? AppFeedbackTheme.successForegroundDark
          : AppFeedbackTheme.successForegroundLight;
      badgeLabel = l10n?.ketoneStatusNormal ?? 'Normal (<0.6)';
    } else if (reading.readingMmolL <= 1.5) {
      badgeColor = isDark
          ? AppFeedbackTheme.warningForegroundDark
          : AppFeedbackTheme.warningForegroundLight;
      badgeLabel = l10n?.ketoneStatusElevated ?? 'Elevated (0.6-1.5)';
    } else {
      badgeColor = isDark
          ? AppFeedbackTheme.errorForegroundDark
          : AppFeedbackTheme.errorForegroundLight;
      badgeLabel = l10n?.ketoneStatusHigh ?? 'High (>1.5)';
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    displayValue,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    unitLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badgeLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: badgeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formattedDate,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (reading.notes != null &&
                  reading.notes!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  reading.notes!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
