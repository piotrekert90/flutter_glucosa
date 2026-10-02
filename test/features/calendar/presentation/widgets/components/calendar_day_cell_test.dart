import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_day_cell.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarDayCell', () {
    Widget buildCell({
      required DateTime date,
      required int dayNumber,
      List<GlucoseReading> readings = const [],
      GlucoseTargetRange targetRange = const GlucoseTargetRange.ada(),
      bool isToday = false,
      bool isSelected = false,
      bool isFuture = false,
      VoidCallback? onTap,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: CalendarDayCell(
              date: date,
              dayNumber: dayNumber,
              readings: readings,
              targetRange: targetRange,
              isToday: isToday,
              isSelected: isSelected,
              isFuture: isFuture,
              onTap: onTap,
            ),
          ),
        ),
      );
    }

    testWidgets('renders day number and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        buildCell(
          date: DateTime(2026, 10, 15),
          dayNumber: 15,
          onTap: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);

      await tester.tap(find.text('15'));
      expect(tapped, isTrue);
    });

    testWidgets('does not respond to tap when isFuture is true', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        buildCell(
          date: DateTime(2026, 10, 30),
          dayNumber: 30,
          isFuture: true,
          onTap: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('30'));
      expect(tapped, isFalse);
    });

    testWidgets('renders dots when readings are present (1 to 3)', (
      tester,
    ) async {
      final readings = [
        GlucoseReading(
          id: 1,
          readingMgDl: 100,
          createdAt: DateTime(2026, 10, 15, 8),
          mealContext: MealContext.fasting,
        ),
        GlucoseReading(
          id: 2,
          readingMgDl: 130,
          createdAt: DateTime(2026, 10, 15, 12),
          mealContext: MealContext.afterLunch,
        ),
      ];

      await tester.pumpWidget(
        buildCell(
          date: DateTime(2026, 10, 15),
          dayNumber: 15,
          readings: readings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });

    testWidgets('renders bar indicator when 4 or more readings exist', (
      tester,
    ) async {
      final readings = List.generate(
        4,
        (i) => GlucoseReading(
          id: i + 1,
          readingMgDl: 110,
          createdAt: DateTime(2026, 10, 15, 8 + i),
          mealContext: MealContext.fasting,
        ),
      );

      await tester.pumpWidget(
        buildCell(
          date: DateTime(2026, 10, 15),
          dayNumber: 15,
          readings: readings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('15'), findsOneWidget);
    });
  });
}
