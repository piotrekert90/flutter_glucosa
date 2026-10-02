import 'package:flutter/material.dart';

import '../../../../../core/domain/enums/first_day_of_week.dart';
import '../../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../glucose/domain/entities/glucose_reading.dart';
import '../components/calendar_grid.dart';
import '../components/calendar_month_header.dart';
import '../components/calendar_weekday_header.dart';

/// Card container hosting the calendar month header, weekday labels, and monthly grid.
class CalendarMonthCard extends StatelessWidget {
  /// The month currently focused and displayed by the grid.
  final DateTime focusedMonth;

  /// The currently selected day.
  final DateTime selectedDate;

  /// All recorded glucose readings.
  final List<GlucoseReading> readings;

  /// Clinical target range used for color-coded status evaluation.
  final GlucoseTargetRange targetRange;

  /// Preferred first day of the week.
  final FirstDayOfWeek firstDayOfWeek;

  /// Callback when the previous month button is pressed.
  final VoidCallback onPreviousMonth;

  /// Callback when the next month button is pressed.
  final VoidCallback onNextMonth;

  /// Optional callback to jump back to today.
  final VoidCallback? onJumpToToday;

  /// Callback when a day in the grid is selected.
  final ValueChanged<DateTime> onDaySelected;

  /// Creates a [CalendarMonthCard].
  const CalendarMonthCard({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.readings,
    this.targetRange = const GlucoseTargetRange.ada(),
    required this.firstDayOfWeek,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.onJumpToToday,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CalendarMonthHeader(
                focusedMonth: focusedMonth,
                onPreviousMonth: onPreviousMonth,
                onNextMonth: onNextMonth,
                onJumpToToday: onJumpToToday,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CalendarWeekdayHeader(firstDayOfWeek: firstDayOfWeek),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! > 0) {
                    onPreviousMonth();
                  } else if (details.primaryVelocity! < 0) {
                    onNextMonth();
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: CalendarGrid(
                    key: ValueKey(focusedMonth),
                    focusedMonth: focusedMonth,
                    selectedDate: selectedDate,
                    readings: readings,
                    targetRange: targetRange,
                    firstDayOfWeek: firstDayOfWeek,
                    onDaySelected: (date, _) => onDaySelected(date),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
