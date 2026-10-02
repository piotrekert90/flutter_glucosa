import 'package:flutter/material.dart';

import '../../../../../core/domain/enums/first_day_of_week.dart';
import '../../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../glucose/domain/entities/glucose_reading.dart';
import 'calendar_day_cell.dart';

/// A fixed 7-column grid of [CalendarDayCell] instances representing a focused month.
class CalendarGrid extends StatelessWidget {
  /// The month and year currently displayed by the grid.
  final DateTime focusedMonth;

  /// The currently active selected date.
  final DateTime selectedDate;

  /// All available [GlucoseReading] entities to map into calendar dates.
  final List<GlucoseReading> readings;

  /// The active clinical target range for evaluating status colors.
  final GlucoseTargetRange targetRange;

  /// The preferred first day of the week.
  final FirstDayOfWeek firstDayOfWeek;

  /// Callback triggered when an interactive day cell is tapped.
  final void Function(DateTime date, List<GlucoseReading> readings)
  onDaySelected;

  /// Optional override for the current reference date (defaults to [DateTime.now]).
  final DateTime? today;

  /// Creates a [CalendarGrid].
  const CalendarGrid({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.readings,
    this.targetRange = const GlucoseTargetRange.ada(),
    this.firstDayOfWeek = FirstDayOfWeek.system,
    required this.onDaySelected,
    this.today,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      focusedMonth.year,
      focusedMonth.month,
    );
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);

    final int startingOffset;
    switch (firstDayOfWeek) {
      case FirstDayOfWeek.monday:
        startingOffset = (firstDayOfMonth.weekday - 1) % 7;
      case FirstDayOfWeek.sunday:
        startingOffset = firstDayOfMonth.weekday % 7;
      case FirstDayOfWeek.system:
        final systemFirstDayIndex = MaterialLocalizations.of(
          context,
        ).firstDayOfWeekIndex;
        startingOffset =
            (firstDayOfMonth.weekday % 7 - systemFirstDayIndex + 7) % 7;
    }

    final totalCells = startingOffset + daysInMonth;

    final Map<int, List<GlucoseReading>> readingsByDay = {};
    for (final reading in readings) {
      if (reading.createdAt.year == focusedMonth.year &&
          reading.createdAt.month == focusedMonth.month) {
        readingsByDay.putIfAbsent(reading.createdAt.day, () => []).add(reading);
      }
    }

    final now = today ?? DateTime.now();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      clipBehavior: Clip.none,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 0,
        mainAxisExtent: 44,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        if (index < startingOffset) {
          return const SizedBox.shrink();
        }

        final dayNumber = index - startingOffset + 1;
        final date = DateTime(focusedMonth.year, focusedMonth.month, dayNumber);
        final dayReadings = readingsByDay[dayNumber] ?? const [];
        final isToday = DateUtils.isSameDay(date, now);
        final isSelected = DateUtils.isSameDay(date, selectedDate);
        final isFuture = date.isAfter(todayEnd);

        return CalendarDayCell(
          date: date,
          dayNumber: dayNumber,
          readings: dayReadings,
          targetRange: targetRange,
          isToday: isToday,
          isSelected: isSelected,
          isFuture: isFuture,
          onTap: isFuture ? null : () => onDaySelected(date, dayReadings),
        );
      },
    );
  }
}
