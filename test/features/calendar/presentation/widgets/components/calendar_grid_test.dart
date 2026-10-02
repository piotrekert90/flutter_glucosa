import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/first_day_of_week.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_day_cell.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_grid.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarGrid', () {
    Widget buildGrid({
      required DateTime focusedMonth,
      required DateTime selectedDate,
      List<GlucoseReading> readings = const [],
      FirstDayOfWeek firstDayOfWeek = FirstDayOfWeek.monday,
      DateTime? today,
      required void Function(DateTime, List<GlucoseReading>) onDaySelected,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CalendarGrid(
              focusedMonth: focusedMonth,
              selectedDate: selectedDate,
              readings: readings,
              firstDayOfWeek: firstDayOfWeek,
              today: today ?? DateTime(2026, 10, 20),
              onDaySelected: onDaySelected,
            ),
          ),
        ),
      );
    }

    testWidgets('renders days and triggers onDaySelected when tapping a day', (
      tester,
    ) async {
      DateTime? tappedDate;
      List<GlucoseReading>? tappedReadings;

      final reading = GlucoseReading(
        id: 1,
        readingMgDl: 115,
        createdAt: DateTime(2026, 10, 10, 9),
        mealContext: MealContext.fasting,
      );

      await tester.pumpWidget(
        buildGrid(
          focusedMonth: DateTime(2026, 10, 1),
          selectedDate: DateTime(2026, 10, 10),
          readings: [reading],
          onDaySelected: (date, readings) {
            tappedDate = date;
            tappedReadings = readings;
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarDayCell), findsWidgets);
      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.text('10'));
      expect(tappedDate, DateTime(2026, 10, 10));
      expect(tappedReadings?.length, 1);
      expect(tappedReadings?.first.id, 1);
    });

    testWidgets('respects Sunday as first day of week', (tester) async {
      await tester.pumpWidget(
        buildGrid(
          focusedMonth: DateTime(2026, 10, 1),
          selectedDate: DateTime(2026, 10, 1),
          firstDayOfWeek: FirstDayOfWeek.sunday,
          onDaySelected: (_, _) {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarDayCell), findsWidgets);
    });
  });
}
