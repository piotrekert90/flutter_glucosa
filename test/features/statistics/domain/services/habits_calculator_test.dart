import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/statistics/domain/services/habits_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HabitsCalculator', () {
    final now = DateTime(2026, 10, 15, 12, 0);

    GlucoseReading makeReading(int id, int mgDl, DateTime date) {
      return GlucoseReading(
        id: id,
        readingMgDl: mgDl,
        createdAt: date,
        mealContext: MealContext.fasting,
      );
    }

    test('returns 0 when readings list is empty', () {
      expect(HabitsCalculator.calculateStreak([], now), 0);
      expect(HabitsCalculator.calculateBestStreak([]), 0);
      expect(HabitsCalculator.calculateTotalCompliance([], now), 0);
      expect(HabitsCalculator.calculateMonthlyCompliance([], now), 0);
    });

    test('calculates streak 1 when logged today', () {
      final readings = [makeReading(1, 120, DateTime(2026, 10, 15, 8))];
      expect(HabitsCalculator.calculateStreak(readings, now), 1);
      expect(HabitsCalculator.calculateBestStreak(readings), 1);
    });

    test('calculates streak 1 when logged yesterday but not yet today', () {
      final readings = [makeReading(1, 120, DateTime(2026, 10, 14, 20))];
      expect(HabitsCalculator.calculateStreak(readings, now), 1);
      expect(HabitsCalculator.calculateBestStreak(readings), 1);
    });

    test('returns streak 0 when last reading was 2 days ago', () {
      final readings = [makeReading(1, 120, DateTime(2026, 10, 13, 20))];
      expect(HabitsCalculator.calculateStreak(readings, now), 0);
      expect(HabitsCalculator.calculateBestStreak(readings), 1);
    });

    test('calculates multi-day streak accurately', () {
      final readings = [
        makeReading(1, 100, DateTime(2026, 10, 11, 8)),
        makeReading(2, 110, DateTime(2026, 10, 12, 8)),
        makeReading(3, 115, DateTime(2026, 10, 13, 8)),
        makeReading(4, 105, DateTime(2026, 10, 14, 8)),
        makeReading(5, 120, DateTime(2026, 10, 15, 8)),
      ];
      expect(HabitsCalculator.calculateStreak(readings, now), 5);
      expect(HabitsCalculator.calculateBestStreak(readings), 5);
    });

    test('calculates historical best streak when current streak is broken', () {
      final readings = [
        // Historical 4-day streak
        makeReading(1, 100, DateTime(2026, 10, 1, 8)),
        makeReading(2, 110, DateTime(2026, 10, 2, 8)),
        makeReading(3, 115, DateTime(2026, 10, 3, 8)),
        makeReading(4, 105, DateTime(2026, 10, 4, 8)),
        // Gap, then 2-day current streak
        makeReading(5, 120, DateTime(2026, 10, 14, 8)),
        makeReading(6, 125, DateTime(2026, 10, 15, 8)),
      ];
      expect(HabitsCalculator.calculateStreak(readings, now), 2);
      expect(HabitsCalculator.calculateBestStreak(readings), 4);
    });

    test('calculates total and monthly compliance correctly', () {
      final readings = [
        makeReading(1, 100, DateTime(2026, 10, 6, 8)),
        makeReading(2, 110, DateTime(2026, 10, 7, 8)),
        makeReading(3, 120, DateTime(2026, 10, 15, 8)),
      ];
      // Start is Oct 6, now is Oct 15 -> total days elapsed = 10. 3 days logged = 30%.
      expect(HabitsCalculator.calculateTotalCompliance(readings, now), 30);

      // Current month: 15 days elapsed, 3 logged days = (3 / 15) * 100 = 20%.
      expect(HabitsCalculator.calculateMonthlyCompliance(readings, now), 20);
    });
  });
}
