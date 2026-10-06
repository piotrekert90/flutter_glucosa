import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/weight_unit.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../domain/entities/weight_reading.dart';

/// Presentation card displaying an individual [WeightReading] in the user's preferred unit.
class WeightReadingCard extends ConsumerWidget {
  /// The reading entity displayed by this card.
  final WeightReading reading;

  /// Optional callback invoked when the user taps the card.
  final VoidCallback? onTap;

  /// Creates a [WeightReadingCard].
  const WeightReadingCard({super.key, required this.reading, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(userProfileProvider);

    final preferredWeightUnit =
        profileAsync.value?.preferredWeightUnit ?? WeightUnit.kilograms;

    final String displayValue;
    final String unitLabel;
    if (preferredWeightUnit == WeightUnit.pounds) {
      displayValue = GlucoseConverter.kgToLbs(
        reading.readingKg,
      ).toStringAsFixed(1);
      unitLabel = WeightUnit.pounds.displayName;
    } else {
      displayValue = reading.readingKg.toStringAsFixed(1);
      unitLabel = WeightUnit.kilograms.displayName;
    }

    final formattedDate = DateFormat.yMMMd().format(reading.createdAt);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
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
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.monitor_weight_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
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
