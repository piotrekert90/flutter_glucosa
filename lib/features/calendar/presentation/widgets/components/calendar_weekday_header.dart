import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/domain/enums/first_day_of_week.dart';

/// Renders seven abbreviated weekday column headers matching the configured [firstDayOfWeek].
class CalendarWeekdayHeader extends StatelessWidget {
  /// The preferred first day of the week.
  final FirstDayOfWeek firstDayOfWeek;

  /// Creates a [CalendarWeekdayHeader].
  const CalendarWeekdayHeader({super.key, required this.firstDayOfWeek});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final format = DateFormat.EEEE(locale);

    // 2026-01-05 is a Monday; 2026-01-04 is a Sunday.
    final DateTime baseDay;
    switch (firstDayOfWeek) {
      case FirstDayOfWeek.monday:
        baseDay = DateTime(2026, 1, 5);
      case FirstDayOfWeek.sunday:
        baseDay = DateTime(2026, 1, 4);
      case FirstDayOfWeek.system:
        final systemFirstDayIndex = MaterialLocalizations.of(
          context,
        ).firstDayOfWeekIndex;
        // In Flutter's MaterialLocalizations, 0 = Sunday, 1 = Monday.
        if (systemFirstDayIndex == 1) {
          baseDay = DateTime(2026, 1, 5);
        } else {
          baseDay = DateTime(2026, 1, 4);
        }
    }

    final weekDays = List.generate(7, (i) => baseDay.add(Duration(days: i)));

    String abbreviate(String dayName) {
      if (dayName.length < 3) return dayName.toUpperCase();
      final sub = dayName.substring(0, 3);
      return sub[0].toUpperCase() + sub.substring(1);
    }

    return SizedBox(
      height: 24,
      child: Row(
        children: weekDays.map((date) {
          final fullDayName = format.format(date);
          return Expanded(
            child: Center(
              child: Semantics(
                label: fullDayName,
                excludeSemantics: true,
                child: Text(
                  abbreviate(fullDayName),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
