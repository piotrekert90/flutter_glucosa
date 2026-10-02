import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/domain/enums/glucose_unit.dart';
import '../../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../glucose/domain/entities/glucose_reading.dart';
import '../components/calendar_day_empty_card.dart';
import '../components/calendar_day_entries_card.dart';

/// Section displaying the selected day's readings summary header and entries or empty placeholder.
class CalendarSelectedDaySection extends StatelessWidget {
  /// The selected day.
  final DateTime selectedDate;

  /// The list of glucose readings recorded on [selectedDate].
  final List<GlucoseReading> dayReadings;

  /// The active clinical target range.
  final GlucoseTargetRange targetRange;

  /// Preferred glucose unit.
  final GlucoseUnit preferredUnit;

  /// Creates a [CalendarSelectedDaySection].
  const CalendarSelectedDaySection({
    super.key,
    required this.selectedDate,
    required this.dayReadings,
    this.targetRange = const GlucoseTargetRange.ada(),
    this.preferredUnit = GlucoseUnit.mgDl,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final formattedSelectedDate = DateFormat.MMMMd(locale).format(selectedDate);

    final selectedDayHeader = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              l10n?.entriesFromDate(formattedSelectedDate) ??
                  'Readings for $formattedSelectedDate',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          if (dayReadings.isNotEmpty) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                l10n?.readingsCountPill(dayReadings.length) ??
                    '${dayReadings.length} readings',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        selectedDayHeader,
        if (dayReadings.isEmpty)
          CalendarDayEmptyCard(selectedDate: selectedDate)
        else
          CalendarDayEntriesCard(
            selectedDate: selectedDate,
            readings: dayReadings,
            targetRange: targetRange,
            preferredUnit: preferredUnit,
          ),
      ],
    );
  }
}
