import 'dart:ui';

import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/milestone_localizer.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('MilestoneTypeLocalizationX', () {
    test('localizedTitle returns localized title for every milestone type', () {
      expect(
        MilestoneType.firstReading.localizedTitle(l10n),
        equals(l10n.milestoneFirstReadingTitle),
      );
      expect(
        MilestoneType.streak7.localizedTitle(l10n),
        equals(l10n.milestoneStreak7Title),
      );
      expect(
        MilestoneType.streak30.localizedTitle(l10n),
        equals(l10n.milestoneStreak30Title),
      );
      expect(
        MilestoneType.streak100.localizedTitle(l10n),
        equals(l10n.milestoneStreak100Title),
      );
      expect(
        MilestoneType.streak365.localizedTitle(l10n),
        equals(l10n.milestoneStreak365Title),
      );
      expect(
        MilestoneType.comeback.localizedTitle(l10n),
        equals(l10n.milestoneComebackTitle),
      );
      expect(
        MilestoneType.targetTirWeek.localizedTitle(l10n),
        equals(l10n.milestoneTargetTirWeekTitle),
      );
      expect(
        MilestoneType.targetTirMonth.localizedTitle(l10n),
        equals(l10n.milestoneTargetTirMonthTitle),
      );
      expect(
        MilestoneType.fastingChampion.localizedTitle(l10n),
        equals(l10n.milestoneFastingChampionTitle),
      );
      expect(
        MilestoneType.postMealMaster.localizedTitle(l10n),
        equals(l10n.milestonePostMealMasterTitle),
      );
      expect(
        MilestoneType.earlyBird.localizedTitle(l10n),
        equals(l10n.milestoneEarlyBirdTitle),
      );
      expect(
        MilestoneType.nightOwl.localizedTitle(l10n),
        equals(l10n.milestoneNightOwlTitle),
      );
      expect(
        MilestoneType.weekendWarrior.localizedTitle(l10n),
        equals(l10n.milestoneWeekendWarriorTitle),
      );
      expect(
        MilestoneType.newYear.localizedTitle(l10n),
        equals(l10n.milestoneNewYearTitle),
      );
      expect(
        MilestoneType.yearEnd.localizedTitle(l10n),
        equals(l10n.milestoneYearEndTitle),
      );
    });

    test(
      'localizedDescription returns localized description for every milestone type',
      () {
        expect(
          MilestoneType.firstReading.localizedDescription(l10n),
          equals(l10n.milestoneFirstReadingDesc),
        );
        expect(
          MilestoneType.streak7.localizedDescription(l10n),
          equals(l10n.milestoneStreak7Desc),
        );
        expect(
          MilestoneType.streak30.localizedDescription(l10n),
          equals(l10n.milestoneStreak30Desc),
        );
        expect(
          MilestoneType.streak100.localizedDescription(l10n),
          equals(l10n.milestoneStreak100Desc),
        );
        expect(
          MilestoneType.streak365.localizedDescription(l10n),
          equals(l10n.milestoneStreak365Desc),
        );
        expect(
          MilestoneType.comeback.localizedDescription(l10n),
          equals(l10n.milestoneComebackDesc),
        );
        expect(
          MilestoneType.targetTirWeek.localizedDescription(l10n),
          equals(l10n.milestoneTargetTirWeekDesc),
        );
        expect(
          MilestoneType.targetTirMonth.localizedDescription(l10n),
          equals(l10n.milestoneTargetTirMonthDesc),
        );
        expect(
          MilestoneType.fastingChampion.localizedDescription(l10n),
          equals(l10n.milestoneFastingChampionDesc),
        );
        expect(
          MilestoneType.postMealMaster.localizedDescription(l10n),
          equals(l10n.milestonePostMealMasterDesc),
        );
        expect(
          MilestoneType.earlyBird.localizedDescription(l10n),
          equals(l10n.milestoneEarlyBirdDesc),
        );
        expect(
          MilestoneType.nightOwl.localizedDescription(l10n),
          equals(l10n.milestoneNightOwlDesc),
        );
        expect(
          MilestoneType.weekendWarrior.localizedDescription(l10n),
          equals(l10n.milestoneWeekendWarriorDesc),
        );
        expect(
          MilestoneType.newYear.localizedDescription(l10n),
          equals(l10n.milestoneNewYearDesc),
        );
        expect(
          MilestoneType.yearEnd.localizedDescription(l10n),
          equals(l10n.milestoneYearEndDesc),
        );
      },
    );
  });

  group('MilestoneCategoryLocalizationX', () {
    test(
      'localizedName returns localized display name for every milestone category',
      () {
        expect(
          MilestoneCategory.goals.localizedName(l10n),
          equals(l10n.milestoneCategoryGoals),
        );
        expect(
          MilestoneCategory.streaks.localizedName(l10n),
          equals(l10n.milestoneCategoryStreaks),
        );
        expect(
          MilestoneCategory.routines.localizedName(l10n),
          equals(l10n.milestoneCategoryRoutines),
        );
        expect(
          MilestoneCategory.special.localizedName(l10n),
          equals(l10n.milestoneCategorySpecial),
        );
      },
    );
  });
}
