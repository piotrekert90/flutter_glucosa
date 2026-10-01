import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/cholesterol_reading.dart';

/// Presentation card displaying an individual [CholesterolReading] with clinical status badge.
class CholesterolReadingCard extends StatelessWidget {
  /// The reading entity displayed by this card.
  final CholesterolReading reading;

  /// Optional callback invoked when the user taps the card.
  final VoidCallback? onTap;

  /// Creates a [CholesterolReadingCard].
  const CholesterolReadingCard({super.key, required this.reading, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    final displayValue = reading.totalMgDl.toString();
    const unitLabel = 'mg/dL';

    final formattedDate = DateFormat.yMMMd().format(reading.createdAt);

    // Clinical status badge based on total cholesterol:
    // Normal (<200), Borderline (200-239), High (≥240).
    final Color badgeColor;
    final String badgeLabel;
    if (reading.totalMgDl < 200) {
      badgeColor = isDark
          ? AppFeedbackTheme.successForegroundDark
          : AppFeedbackTheme.successForegroundLight;
      badgeLabel = l10n?.cholesterolStatusNormal ?? 'Normal (<200)';
    } else if (reading.totalMgDl < 240) {
      badgeColor = isDark
          ? AppFeedbackTheme.warningForegroundDark
          : AppFeedbackTheme.warningForegroundLight;
      badgeLabel = l10n?.cholesterolStatusElevated ?? 'Borderline (200-239)';
    } else {
      badgeColor = isDark
          ? AppFeedbackTheme.errorForegroundDark
          : AppFeedbackTheme.errorForegroundLight;
      badgeLabel = l10n?.cholesterolStatusHigh ?? 'High (≥240)';
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
                  const SizedBox(width: 16),
                  Icon(
                    Icons.bloodtype_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'LDL ${reading.ldlMgDl} · HDL ${reading.hdlMgDl}',
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
