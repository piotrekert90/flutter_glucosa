/// Grouping categories for diabetes habit and clinical milestones.
enum MilestoneCategory {
  /// Clinical targets and glucose control achievements.
  goals,

  /// Consistent daily logging streaks.
  streaks,

  /// Daily routine and meal context tracking.
  routines,

  /// Seasonal and special calendar milestones.
  special,
}

/// Specific milestone achievement identifiers for glucose tracking.
enum MilestoneType {
  /// First glucose measurement logged.
  firstReading,

  /// 7 consecutive days of logging readings.
  streak7,

  /// 30 consecutive days of logging readings.
  streak30,

  /// 100 consecutive days of logging readings.
  streak100,

  /// 365 consecutive days of logging readings.
  streak365,

  /// Resumed logging after a gap of more than 14 days.
  comeback,

  /// Achieved 70%+ Time in Range across 7 days (minimum 14 readings).
  targetTirWeek,

  /// Achieved 70%+ Time in Range across 30 days (minimum 50 readings).
  targetTirMonth,

  /// Logged at least 10 fasting glucose readings.
  fastingChampion,

  /// Logged at least 10 post-meal glucose readings.
  postMealMaster,

  /// Logged a morning reading before 7:00 AM.
  earlyBird,

  /// Logged an evening reading after 11:00 PM.
  nightOwl,

  /// Logged readings on both Saturday and Sunday in a single weekend.
  weekendWarrior,

  /// Logged a reading on New Year's Day (January 1).
  newYear,

  /// Logged a reading on New Year's Eve (December 31).
  yearEnd;

  /// Returns the semantic [MilestoneCategory] this milestone belongs to.
  MilestoneCategory get category => switch (this) {
    MilestoneType.firstReading ||
    MilestoneType.targetTirWeek ||
    MilestoneType.targetTirMonth => MilestoneCategory.goals,
    MilestoneType.streak7 ||
    MilestoneType.streak30 ||
    MilestoneType.streak100 ||
    MilestoneType.streak365 ||
    MilestoneType.comeback => MilestoneCategory.streaks,
    MilestoneType.fastingChampion ||
    MilestoneType.postMealMaster ||
    MilestoneType.earlyBird ||
    MilestoneType.nightOwl => MilestoneCategory.routines,
    MilestoneType.weekendWarrior ||
    MilestoneType.newYear ||
    MilestoneType.yearEnd => MilestoneCategory.special,
  };
}

/// Domain entity representing a milestone achievement with progress and unlock state.
class Milestone {
  /// The specific type of this milestone.
  final MilestoneType type;

  /// Whether the milestone conditions are completely met.
  final bool isUnlocked;

  /// Progress towards unlocking, clamped between 0.0 and 1.0.
  final double progress;

  /// Timestamp when the milestone was first unlocked, if applicable.
  final DateTime? unlockedDate;

  /// Creates a [Milestone].
  const Milestone({
    required this.type,
    required this.isUnlocked,
    required this.progress,
    this.unlockedDate,
  });

  /// Returns a copy of this milestone with updated fields.
  Milestone copyWith({
    MilestoneType? type,
    bool? isUnlocked,
    double? progress,
    DateTime? unlockedDate,
  }) {
    return Milestone(
      type: type ?? this.type,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      progress: progress ?? this.progress,
      unlockedDate: unlockedDate ?? this.unlockedDate,
    );
  }
}
