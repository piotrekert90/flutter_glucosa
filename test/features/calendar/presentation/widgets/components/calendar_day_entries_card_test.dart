import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_day_entries_card.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/fake_glucose_reading_repository.dart';

void main() {
  group('CalendarDayEntriesCard', () {
    late FakeGlucoseReadingRepository fakeGlucoseRepo;

    setUp(() {
      fakeGlucoseRepo = FakeGlucoseReadingRepository();
    });

    tearDown(() {
      fakeGlucoseRepo.dispose();
    });

    Widget buildCard({
      required DateTime selectedDate,
      required List<GlucoseReading> readings,
      GlucoseUnit unit = GlucoseUnit.mgDl,
    }) {
      return ProviderScope(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: CalendarDayEntriesCard(
                selectedDate: selectedDate,
                readings: readings,
                preferredUnit: unit,
                targetRange: const GlucoseTargetRange.ada(),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders readings, in-range banner, and displays details', (
      tester,
    ) async {
      final reading = GlucoseReading(
        id: 1,
        readingMgDl: 110,
        createdAt: DateTime(2026, 10, 15, 8, 30),
        mealContext: MealContext.fasting,
        notes: 'Morning measurement',
      );

      await tester.pumpWidget(
        buildCard(selectedDate: DateTime(2026, 10, 15), readings: [reading]),
      );
      await tester.pumpAndSettle();

      expect(find.text('110'), findsOneWidget);
      expect(find.text('mg/dL'), findsOneWidget);
      expect(find.text('Morning measurement'), findsOneWidget);
      expect(find.text('All readings within target range'), findsOneWidget);
      expect(find.text('Add Another Reading'), findsOneWidget);
    });

    testWidgets('confirms and deletes reading via more options popup menu', (
      tester,
    ) async {
      final reading = GlucoseReading(
        id: 42,
        readingMgDl: 120,
        createdAt: DateTime(2026, 10, 15, 10, 0),
        mealContext: MealContext.afterBreakfast,
      );
      fakeGlucoseRepo.add(reading);

      await tester.pumpWidget(
        buildCard(selectedDate: DateTime(2026, 10, 15), readings: [reading]),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Reading'), findsOneWidget);

      // Confirm delete
      await tester.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      expect((await fakeGlucoseRepo.getAll()).any((r) => r.id == 42), isFalse);
    });
  });
}
