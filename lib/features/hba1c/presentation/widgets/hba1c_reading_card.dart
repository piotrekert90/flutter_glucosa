import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/glucose_unit.dart';
import '../../../../core/domain/enums/hba1c_unit.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../domain/entities/hba1c_reading.dart';

/// Presentation card displaying an individual [HbA1cReading] with clinical status badge and estimated average glucose.
class HbA1cReadingCard extends ConsumerWidget {
  /// The reading entity displayed by this card.
  final HbA1cReading reading;

  /// Optional callback invoked when the user taps the card.
  final VoidCallback? onTap;

  /// Creates an [HbA1cReadingCard].
  const HbA1cReadingCard({super.key, required this.reading, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    final preferredHbA1cUnit =
        profileAsync.value?.preferredHbA1cUnit ?? HbA1cUnit.percentage;
    final preferredGlucoseUnit =
        profileAsync.value?.preferredGlucoseUnit ?? GlucoseUnit.mgDl;

    final String displayValue;
    final String unitLabel;
    if (preferredHbA1cUnit == HbA1cUnit.mmolMol) {
      displayValue = GlucoseConverter.percentageToMmolMol(
        reading.readingPercentage,
      ).round().toString();
      unitLabel = HbA1cUnit.mmolMol.displayName;
    } else {
      displayValue = reading.readingPercentage.toStringAsFixed(1);
      unitLabel = HbA1cUnit.percentage.displayName;
    }

    final avgMgDl = GlucoseConverter.hba1cToEstimatedGlucose(
      reading.readingPercentage,
    ).round();
    final String avgGlucoseStr;
    if (preferredGlucoseUnit == GlucoseUnit.mmolL) {
      avgGlucoseStr =
          '~${GlucoseConverter.mgDlToMmolL(avgMgDl).toStringAsFixed(1)} ${GlucoseUnit.mmolL.displayName}';
    } else {
      avgGlucoseStr = '~$avgMgDl ${GlucoseUnit.mgDl.displayName}';
    }

    final formattedDate = DateFormat.yMMMd().format(reading.createdAt);

    // Clinical status badge: <5.7 normal, 5.7-6.4 elevated, >=6.5 high
    final Color badgeColor;
    final String badgeLabel;
    if (reading.readingPercentage < 5.7) {
      badgeColor = isDark
          ? AppFeedbackTheme.successForegroundDark
          : AppFeedbackTheme.successForegroundLight;
      badgeLabel = l10n?.hba1cStatusNormal ?? 'Normal';
    } else if (reading.readingPercentage < 6.5) {
      badgeColor = isDark
          ? AppFeedbackTheme.warningForegroundDark
          : AppFeedbackTheme.warningForegroundLight;
      badgeLabel = l10n?.hba1cStatusElevated ?? 'Elevated';
    } else {
      badgeColor = isDark
          ? AppFeedbackTheme.errorForegroundDark
          : AppFeedbackTheme.errorForegroundLight;
      badgeLabel = l10n?.hba1cStatusHigh ?? 'High';
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
                    Icons.speed_outlined,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    avgGlucoseStr,
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
