import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/glucose_unit.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/domain/utils/glucose_status_resolver.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../domain/entities/glucose_reading.dart';
import '../extensions/glucose_status_ui_extension.dart';

/// Presentation card displaying an individual [GlucoseReading] with clinical status badge and meal context.
class GlucoseReadingCard extends ConsumerWidget {
  /// The reading entity displayed by this card.
  final GlucoseReading reading;

  /// Optional callback invoked when the user taps the card.
  final VoidCallback? onTap;

  /// Optional target range override, falling back to profile setting if omitted.
  final GlucoseTargetRange? targetRange;

  /// Creates a [GlucoseReadingCard].
  const GlucoseReadingCard({
    super.key,
    required this.reading,
    this.onTap,
    this.targetRange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final profileAsync = ref.watch(userProfileProvider);

    final preferredUnit =
        profileAsync.value?.preferredGlucoseUnit ?? GlucoseUnit.mgDl;
    final effectiveTargetRange =
        targetRange ??
        profileAsync.value?.targetRange ??
        const GlucoseTargetRange.ada();

    final status = GlucoseStatusResolver.resolve(
      readingMgDl: reading.readingMgDl,
      targetRange: effectiveTargetRange,
    );

    final String displayValue;
    if (preferredUnit == GlucoseUnit.mmolL) {
      displayValue = GlucoseConverter.mgDlToMmolL(
        reading.readingMgDl,
      ).toStringAsFixed(1);
    } else {
      displayValue = reading.readingMgDl.toString();
    }

    final formattedTime = DateFormat.jm().format(reading.createdAt);
    final formattedDate = DateFormat.MMMd().format(reading.createdAt);

    final statusBgColor = status.backgroundColor(context);
    final statusFgColor = status.foregroundColor(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: MergeSemantics(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          preferredUnit.displayName,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.localizedName(l10n),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: statusFgColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.restaurant_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      reading.mealContext.localizedName(l10n),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '$formattedDate, $formattedTime',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (reading.notes != null &&
                    reading.notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          reading.notes!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
