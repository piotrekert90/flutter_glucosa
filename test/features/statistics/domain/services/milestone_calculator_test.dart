import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/features/statistics/domain/services/milestone_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MilestoneCalculator', () {
    GlucoseReading makeReading({
      required int id,
      required int mgDl,
      required DateTime date,
      MealContext context = MealContext.fasting,
    }) {
      return GlucoseReading(
        id: id,
        readingMgDl: mgDl,
        createdAt: date,
        mealContext: context,
      );
    }

    test('returns all locked milestones when readings list is empty', () {
      final milestones = MilestoneCalculator.evaluate(readings: []);
      expect(milestones.length, MilestoneType.values.length);
      expect(milestones.every((m) => !m.isUnlocked), isTrue);
      expect(milestones.every((m) => m.progress == 0.0), isTrue);
    });

    test('unlocks firstReading on single reading', () {
      final date = DateTime(2026, 10, 1, 10);
      final readings = [makeReading(id: 1, mgDl: 110, date: date)];

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final firstM = milestones.firstWhere(
        (m) => m.type == MilestoneType.firstReading,
      );

      expect(firstM.isUnlocked, isTrue);
      expect(firstM.progress, 1.0);
      expect(firstM.unlockedDate, date);
    });

    test('unlocks streak7 and advances streak30 progress', () {
      final readings = List.generate(
        8,
        (i) =>
            makeReading(id: i, mgDl: 105, date: DateTime(2026, 10, 1 + i, 9)),
      );

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final s7 = milestones.firstWhere((m) => m.type == MilestoneType.streak7);
      final s30 = milestones.firstWhere(
        (m) => m.type == MilestoneType.streak30,
      );

      expect(s7.isUnlocked, isTrue);
      expect(s7.progress, 1.0);
      expect(s30.isUnlocked, isFalse);
      expect(s30.progress, closeTo(8 / 30.0, 0.001));
    });

    test('unlocks comeback milestone after 15 days gap', () {
      final readings = [
        makeReading(id: 1, mgDl: 100, date: DateTime(2026, 9, 1, 9)),
        // 16 days later
        makeReading(id: 2, mgDl: 110, date: DateTime(2026, 9, 17, 9)),
      ];

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final comeback = milestones.firstWhere(
        (m) => m.type == MilestoneType.comeback,
      );

      expect(comeback.isUnlocked, isTrue);
      expect(comeback.progress, 1.0);
      expect(comeback.unlockedDate, DateTime(2026, 9, 17));
    });

    test('unlocks fastingChampion after 10 fasting readings', () {
      final readings = List.generate(
        10,
        (i) => makeReading(
          id: i,
          mgDl: 95,
          date: DateTime(2026, 10, 1, 8, i),
          context: MealContext.fasting,
        ),
      );

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final fasting = milestones.firstWhere(
        (m) => m.type == MilestoneType.fastingChampion,
      );

      expect(fasting.isUnlocked, isTrue);
      expect(fasting.progress, 1.0);
    });

    test('unlocks postMealMaster after 10 post-meal readings', () {
      final readings = List.generate(
        10,
        (i) => makeReading(
          id: i,
          mgDl: 135,
          date: DateTime(2026, 10, 1, 14, i),
          context: MealContext.afterBreakfast,
        ),
      );

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final postMeal = milestones.firstWhere(
        (m) => m.type == MilestoneType.postMealMaster,
      );

      expect(postMeal.isUnlocked, isTrue);
      expect(postMeal.progress, 1.0);
    });

    test('unlocks earlyBird and nightOwl based on reading timestamps', () {
      final readings = [
        makeReading(id: 1, mgDl: 90, date: DateTime(2026, 10, 1, 6, 30)),
        makeReading(id: 2, mgDl: 110, date: DateTime(2026, 10, 1, 23, 15)),
      ];

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final earlyBird = milestones.firstWhere(
        (m) => m.type == MilestoneType.earlyBird,
      );
      final nightOwl = milestones.firstWhere(
        (m) => m.type == MilestoneType.nightOwl,
      );

      expect(earlyBird.isUnlocked, isTrue);
      expect(nightOwl.isUnlocked, isTrue);
    });

    test('unlocks weekendWarrior when Saturday and Sunday are logged', () {
      // 2026-10-10 is Saturday, 2026-10-11 is Sunday
      final readings = [
        makeReading(id: 1, mgDl: 100, date: DateTime(2026, 10, 10, 10)),
        makeReading(id: 2, mgDl: 105, date: DateTime(2026, 10, 11, 11)),
      ];

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final ww = milestones.firstWhere(
        (m) => m.type == MilestoneType.weekendWarrior,
      );

      expect(ww.isUnlocked, isTrue);
      expect(ww.progress, 1.0);
    });

    test('unlocks newYear and yearEnd milestones', () {
      final readings = [
        makeReading(id: 1, mgDl: 100, date: DateTime(2026, 1, 1, 10)),
        makeReading(id: 2, mgDl: 105, date: DateTime(2026, 12, 31, 20)),
      ];

      final milestones = MilestoneCalculator.evaluate(readings: readings);
      final ny = milestones.firstWhere((m) => m.type == MilestoneType.newYear);
      final ye = milestones.firstWhere((m) => m.type == MilestoneType.yearEnd);

      expect(ny.isUnlocked, isTrue);
      expect(ye.isUnlocked, isTrue);
    });

    test(
      'unlocks targetTirWeek when 70%+ in range with at least 14 readings',
      () {
        // 14 readings over 7 days, 12 in-range (100-120), 2 high (220) -> 12/14 = 85.7% > 70%
        final readings = List.generate(
          14,
          (i) => makeReading(
            id: i,
            mgDl: i < 12 ? 110 : 220,
            date: DateTime(2026, 10, 1).add(Duration(hours: i * 10)),
          ),
        );

        final milestones = MilestoneCalculator.evaluate(
          readings: readings,
          targetRange: const GlucoseTargetRange.ada(),
        );
        final tirWeek = milestones.firstWhere(
          (m) => m.type == MilestoneType.targetTirWeek,
        );

        expect(tirWeek.isUnlocked, isTrue);
        expect(tirWeek.progress, 1.0);
      },
    );
  });
}
