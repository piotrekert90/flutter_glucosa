import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/statistics/domain/services/period_comparison_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PeriodComparisonCalculator', () {
    final now = DateTime(2026, 10, 14, 20);

    GlucoseReading makeReading({
      required int id,
      required int mgDl,
      required DateTime date,
    }) {
      return GlucoseReading(
        id: id,
        readingMgDl: mgDl,
        createdAt: date,
        mealContext: MealContext.fasting,
      );
    }

    test('returns empty summaries when readings list is empty', () {
      final result = PeriodComparisonCalculator.compareRollingDays(
        readings: [],
        days: 7,
        now: now,
      );

      expect(result.hasComparisonData, isFalse);
      expect(result.currentPeriod.readingCount, 0);
      expect(result.currentPeriod.meanGlucoseMgDl, isNull);
      expect(result.previousPeriod.readingCount, 0);
      expect(result.deltaMeanGlucose, isNull);
      expect(result.deltaReadingCount, 0);
    });

    test(
      'returns hasComparisonData false when only current window has readings',
      () {
        final readings = [
          makeReading(id: 1, mgDl: 120, date: DateTime(2026, 10, 10)),
        ];

        final result = PeriodComparisonCalculator.compareRollingDays(
          readings: readings,
          days: 7,
          now: now,
        );

        expect(result.hasComparisonData, isFalse);
        expect(result.currentPeriod.readingCount, 1);
        expect(result.previousPeriod.readingCount, 0);
        expect(result.deltaMeanGlucose, isNull);
      },
    );

    test(
      'calculates accurate means, SDs, and deltas when both windows have data',
      () {
        // Current 7-day window: Oct 8 to Oct 14
        // Previous 7-day window: Oct 1 to Oct 7
        final readings = [
          // Previous window (Oct 1 - 7):
          // Readings: 100, 120, 200 (high) -> sum = 420, mean = 140, hypo = 0, hyper = 1, tir = 2/3 = 66.7%
          makeReading(id: 1, mgDl: 100, date: DateTime(2026, 10, 2, 10)),
          makeReading(id: 2, mgDl: 120, date: DateTime(2026, 10, 4, 10)),
          makeReading(id: 3, mgDl: 200, date: DateTime(2026, 10, 6, 10)),

          // Current window (Oct 8 - 14):
          // Readings: 90, 110 -> sum = 200, mean = 100, hypo = 0, hyper = 0, tir = 2/2 = 100%
          makeReading(id: 4, mgDl: 90, date: DateTime(2026, 10, 10, 10)),
          makeReading(id: 5, mgDl: 110, date: DateTime(2026, 10, 12, 10)),
        ];

        final result = PeriodComparisonCalculator.compareRollingDays(
          readings: readings,
          days: 7,
          targetRange: const GlucoseTargetRange.ada(),
          now: now,
        );

        expect(result.hasComparisonData, isTrue);
        expect(result.currentPeriod.readingCount, 2);
        expect(result.previousPeriod.readingCount, 3);

        expect(result.currentPeriod.meanGlucoseMgDl, 100.0);
        expect(result.previousPeriod.meanGlucoseMgDl, 140.0);

        // deltaMeanGlucose = current - previous = 100 - 140 = -40
        expect(result.deltaMeanGlucose, -40.0);

        // Current SD of [90, 110]: mean=100, diffs=-10, +10. squared = 100 + 100 = 200. / 1 = 200. sqrt(200) = 14.14
        expect(result.currentPeriod.glucoseSd, closeTo(14.14, 0.01));

        // TIR: current = 100%, previous = 66.66%
        expect(result.currentPeriod.tirPercentage, 100.0);
        expect(result.previousPeriod.tirPercentage, closeTo(66.66, 0.1));
        expect(result.deltaTirPercentage, closeTo(33.33, 0.1));

        // Reading count delta: 2 - 3 = -1
        expect(result.deltaReadingCount, -1);
      },
    );

    test('tracks hypoglycemic event count deltas accurately', () {
      final readings = [
        // Previous: 1 hypo (60 mg/dL)
        makeReading(id: 1, mgDl: 60, date: DateTime(2026, 10, 3, 10)),
        // Current: 2 hypos (55, 65 mg/dL)
        makeReading(id: 2, mgDl: 55, date: DateTime(2026, 10, 9, 10)),
        makeReading(id: 3, mgDl: 65, date: DateTime(2026, 10, 11, 10)),
      ];

      final result = PeriodComparisonCalculator.compareRollingDays(
        readings: readings,
        days: 7,
        now: now,
      );

      expect(result.currentPeriod.hypoCount, 2);
      expect(result.previousPeriod.hypoCount, 1);
      expect(result.deltaHypoCount, 1);
    });
  });
}
