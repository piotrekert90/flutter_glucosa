import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_day_empty_card.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_day_entries_card.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/sections/calendar_selected_day_section.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarSelectedDaySection', () {
    Widget buildSection({
      required DateTime selectedDate,
      required List<GlucoseReading> dayReadings,
    }) {
      return ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: CalendarSelectedDaySection(
                selectedDate: selectedDate,
                dayReadings: dayReadings,
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders empty card when dayReadings is empty', (tester) async {
      await tester.pumpWidget(
        buildSection(
          selectedDate: DateTime(2026, 10, 15),
          dayReadings: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarDayEmptyCard), findsOneWidget);
      expect(find.byType(CalendarDayEntriesCard), findsNothing);
      expect(find.text('No readings on this day'), findsOneWidget);
    });

    testWidgets('renders entries card when dayReadings has entries', (
      tester,
    ) async {
      final readings = [
        GlucoseReading(
          id: 1,
          readingMgDl: 120,
          createdAt: DateTime(2026, 10, 15, 8, 30),
          mealContext: MealContext.fasting,
        ),
      ];

      await tester.pumpWidget(
        buildSection(
          selectedDate: DateTime(2026, 10, 15),
          dayReadings: readings,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarDayEntriesCard), findsOneWidget);
      expect(find.byType(CalendarDayEmptyCard), findsNothing);
      expect(find.text('1 reading'), findsOneWidget);
    });
  });
}
