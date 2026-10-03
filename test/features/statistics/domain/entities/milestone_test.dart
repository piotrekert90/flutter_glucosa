import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MilestoneCategory', () {
    test('contains expected semantic categories', () {
      expect(
        MilestoneCategory.values,
        containsAll([
          MilestoneCategory.goals,
          MilestoneCategory.streaks,
          MilestoneCategory.routines,
          MilestoneCategory.special,
        ]),
      );
    });
  });

  group('MilestoneType', () {
    test('maps each type to its correct category', () {
      expect(MilestoneType.firstReading.category, MilestoneCategory.goals);
      expect(MilestoneType.targetTirWeek.category, MilestoneCategory.goals);
      expect(MilestoneType.targetTirMonth.category, MilestoneCategory.goals);

      expect(MilestoneType.streak7.category, MilestoneCategory.streaks);
      expect(MilestoneType.streak30.category, MilestoneCategory.streaks);
      expect(MilestoneType.streak100.category, MilestoneCategory.streaks);
      expect(MilestoneType.streak365.category, MilestoneCategory.streaks);
      expect(MilestoneType.comeback.category, MilestoneCategory.streaks);

      expect(
        MilestoneType.fastingChampion.category,
        MilestoneCategory.routines,
      );
      expect(MilestoneType.postMealMaster.category, MilestoneCategory.routines);
      expect(MilestoneType.earlyBird.category, MilestoneCategory.routines);
      expect(MilestoneType.nightOwl.category, MilestoneCategory.routines);

      expect(MilestoneType.weekendWarrior.category, MilestoneCategory.special);
      expect(MilestoneType.newYear.category, MilestoneCategory.special);
      expect(MilestoneType.yearEnd.category, MilestoneCategory.special);
    });

    test('covers all enum values in category mapping', () {
      for (final type in MilestoneType.values) {
        expect(type.category, isA<MilestoneCategory>());
      }
    });
  });

  group('Milestone', () {
    final unlockedAt = DateTime(2026, 10, 3, 15, 30);

    test('creates valid instance with unlockedDate', () {
      final milestone = Milestone(
        type: MilestoneType.firstReading,
        isUnlocked: true,
        progress: 1.0,
        unlockedDate: unlockedAt,
      );

      expect(milestone.type, equals(MilestoneType.firstReading));
      expect(milestone.isUnlocked, isTrue);
      expect(milestone.progress, equals(1.0));
      expect(milestone.unlockedDate, equals(unlockedAt));
    });

    test('creates valid instance with null unlockedDate', () {
      const milestone = Milestone(
        type: MilestoneType.streak7,
        isUnlocked: false,
        progress: 0.43,
      );

      expect(milestone.type, equals(MilestoneType.streak7));
      expect(milestone.isUnlocked, isFalse);
      expect(milestone.progress, equals(0.43));
      expect(milestone.unlockedDate, isNull);
    });

    test(
      'copyWith updates specified fields and retains unspecified fields',
      () {
        const initial = Milestone(
          type: MilestoneType.streak7,
          isUnlocked: false,
          progress: 0.5,
        );

        final updatedType = initial.copyWith(type: MilestoneType.streak30);
        expect(updatedType.type, equals(MilestoneType.streak30));
        expect(updatedType.isUnlocked, isFalse);
        expect(updatedType.progress, equals(0.5));
        expect(updatedType.unlockedDate, isNull);

        final updatedUnlocked = initial.copyWith(
          isUnlocked: true,
          progress: 1.0,
          unlockedDate: unlockedAt,
        );
        expect(updatedUnlocked.type, equals(MilestoneType.streak7));
        expect(updatedUnlocked.isUnlocked, isTrue);
        expect(updatedUnlocked.progress, equals(1.0));
        expect(updatedUnlocked.unlockedDate, equals(unlockedAt));

        final unchanged = initial.copyWith();
        expect(unchanged.type, equals(initial.type));
        expect(unchanged.isUnlocked, equals(initial.isUnlocked));
        expect(unchanged.progress, equals(initial.progress));
        expect(unchanged.unlockedDate, equals(initial.unlockedDate));
      },
    );
  });
}
