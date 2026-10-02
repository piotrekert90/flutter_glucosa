import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/milestone.dart';

/// Extension providing localized titles and descriptions for milestones.
extension MilestoneTypeLocalizationX on MilestoneType {
  /// Returns the localized title of the milestone.
  String localizedTitle(AppLocalizations l10n) {
    return switch (this) {
      MilestoneType.firstReading => l10n.milestoneFirstReadingTitle,
      MilestoneType.streak7 => l10n.milestoneStreak7Title,
      MilestoneType.streak30 => l10n.milestoneStreak30Title,
      MilestoneType.streak100 => l10n.milestoneStreak100Title,
      MilestoneType.streak365 => l10n.milestoneStreak365Title,
      MilestoneType.comeback => l10n.milestoneComebackTitle,
      MilestoneType.targetTirWeek => l10n.milestoneTargetTirWeekTitle,
      MilestoneType.targetTirMonth => l10n.milestoneTargetTirMonthTitle,
      MilestoneType.fastingChampion => l10n.milestoneFastingChampionTitle,
      MilestoneType.postMealMaster => l10n.milestonePostMealMasterTitle,
      MilestoneType.earlyBird => l10n.milestoneEarlyBirdTitle,
      MilestoneType.nightOwl => l10n.milestoneNightOwlTitle,
      MilestoneType.weekendWarrior => l10n.milestoneWeekendWarriorTitle,
      MilestoneType.newYear => l10n.milestoneNewYearTitle,
      MilestoneType.yearEnd => l10n.milestoneYearEndTitle,
    };
  }

  /// Returns the localized description of the milestone condition.
  String localizedDescription(AppLocalizations l10n) {
    return switch (this) {
      MilestoneType.firstReading => l10n.milestoneFirstReadingDesc,
      MilestoneType.streak7 => l10n.milestoneStreak7Desc,
      MilestoneType.streak30 => l10n.milestoneStreak30Desc,
      MilestoneType.streak100 => l10n.milestoneStreak100Desc,
      MilestoneType.streak365 => l10n.milestoneStreak365Desc,
      MilestoneType.comeback => l10n.milestoneComebackDesc,
      MilestoneType.targetTirWeek => l10n.milestoneTargetTirWeekDesc,
      MilestoneType.targetTirMonth => l10n.milestoneTargetTirMonthDesc,
      MilestoneType.fastingChampion => l10n.milestoneFastingChampionDesc,
      MilestoneType.postMealMaster => l10n.milestonePostMealMasterDesc,
      MilestoneType.earlyBird => l10n.milestoneEarlyBirdDesc,
      MilestoneType.nightOwl => l10n.milestoneNightOwlDesc,
      MilestoneType.weekendWarrior => l10n.milestoneWeekendWarriorDesc,
      MilestoneType.newYear => l10n.milestoneNewYearDesc,
      MilestoneType.yearEnd => l10n.milestoneYearEndDesc,
    };
  }
}

/// Extension providing localized category headings.
extension MilestoneCategoryLocalizationX on MilestoneCategory {
  /// Returns the localized category display name.
  String localizedName(AppLocalizations l10n) {
    return switch (this) {
      MilestoneCategory.goals => l10n.milestoneCategoryGoals,
      MilestoneCategory.streaks => l10n.milestoneCategoryStreaks,
      MilestoneCategory.routines => l10n.milestoneCategoryRoutines,
      MilestoneCategory.special => l10n.milestoneCategorySpecial,
    };
  }
}
