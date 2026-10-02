import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/domain/enums/glucose_status.dart';
import '../../../../../core/domain/utils/glucose_status_resolver.dart';
import '../../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../glucose/domain/entities/glucose_reading.dart';
import '../../../../glucose/presentation/extensions/glucose_status_ui_extension.dart';

/// A single day cell within the calendar grid displaying day number, selection state, and glucose status dots.
class CalendarDayCell extends StatelessWidget {
  /// The full calendar date represented by this cell.
  final DateTime date;

  /// The day-of-month integer to display.
  final int dayNumber;

  /// All glucose readings recorded on this day.
  final List<GlucoseReading> readings;

  /// The active clinical target range for status evaluation.
  final GlucoseTargetRange targetRange;

  /// Whether this cell represents the current calendar day.
  final bool isToday;

  /// Whether this cell is currently selected.
  final bool isSelected;

  /// Whether this cell falls after today and is non-interactive.
  final bool isFuture;

  /// Callback invoked when the user taps on this day cell.
  final VoidCallback? onTap;

  /// Creates a [CalendarDayCell].
  const CalendarDayCell({
    super.key,
    required this.date,
    required this.dayNumber,
    this.readings = const [],
    this.targetRange = const GlucoseTargetRange.ada(),
    this.isToday = false,
    this.isSelected = false,
    this.isFuture = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    Color textColor;
    if (isFuture) {
      textColor = colorScheme.onSurface.withValues(alpha: 0.3);
    } else if (isSelected) {
      textColor = colorScheme.onSurface;
    } else if (isToday) {
      textColor = colorScheme.primary;
    } else {
      textColor = colorScheme.onSurface;
    }

    final cellDecoration = isSelected
        ? BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.primary, width: 1.5),
          )
        : null;

    final dateFormatted = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).format(date);

    final statuses = readings
        .map(
          (r) => GlucoseStatusResolver.resolve(
            readingMgDl: r.readingMgDl,
            targetRange: targetRange,
          ),
        )
        .toList();

    final allInRange =
        readings.isNotEmpty &&
        statuses.every((s) => s == GlucoseStatus.inRange);

    final semanticLabel = allInRange
        ? l10n?.calendarDaySemanticsGoalAchieved(
                dateFormatted,
                readings.length,
              ) ??
              '$dateFormatted, ${readings.length} readings, all in target'
        : l10n?.calendarDaySemantics(dateFormatted, readings.length) ??
              '$dateFormatted, ${readings.length} readings';

    Widget buildIndicator() {
      if (readings.isEmpty) return const SizedBox.shrink();

      if (readings.length >= 4) {
        final hasSevere = statuses.any(
          (s) =>
              s == GlucoseStatus.hypoglycemia ||
              s == GlucoseStatus.hyperglycemia,
        );
        final hasWarning = statuses.any(
          (s) => s == GlucoseStatus.low || s == GlucoseStatus.high,
        );

        final Color barColor;
        if (hasSevere) {
          barColor = GlucoseStatus.hypoglycemia.foregroundColor(context);
        } else if (hasWarning) {
          barColor = GlucoseStatus.high.foregroundColor(context);
        } else {
          barColor = GlucoseStatus.inRange.foregroundColor(context);
        }

        return ExcludeSemantics(
          child: Container(
            width: 14,
            height: 3.5,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }

      // 1 to 3 readings: individual dots with status color.
      final dots = statuses.take(3).map((status) {
        final color = status.foregroundColor(context);
        return Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        );
      }).toList();

      if (dots.length == 1) {
        return ExcludeSemantics(child: dots.first);
      }

      return ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < dots.length; i++) ...[
              dots[i],
              if (i != dots.length - 1) const SizedBox(width: 2.5),
            ],
          ],
        ),
      );
    }

    return Semantics(
      button: !isFuture,
      selected: isSelected,
      label: semanticLabel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isFuture ? null : onTap,
          customBorder: const CircleBorder(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: cellDecoration,
                alignment: Alignment.center,
                child: ExcludeSemantics(
                  child: Text(
                    '$dayNumber',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: textColor,
                      fontWeight: (isSelected || isToday)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              SizedBox(
                height: 5,
                child: readings.isNotEmpty
                    ? Center(child: buildIndicator())
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
