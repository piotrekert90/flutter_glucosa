import 'package:flutter/material.dart';
import '../../domain/entities/milestone.dart';

/// Utility class resolving icons for milestones and achievement categories.
class MilestoneIconResolver {
  const MilestoneIconResolver._();

  /// Resolves the primary [IconData] representing a specific [MilestoneType].
  static IconData iconForType(MilestoneType type) {
    return switch (type) {
      MilestoneType.firstReading => Icons.water_drop_outlined,
      MilestoneType.streak7 => Icons.local_fire_department_outlined,
      MilestoneType.streak30 => Icons.bolt_outlined,
      MilestoneType.streak100 => Icons.workspace_premium_outlined,
      MilestoneType.streak365 => Icons.emoji_events_outlined,
      MilestoneType.comeback => Icons.replay_rounded,
      MilestoneType.targetTirWeek => Icons.verified_outlined,
      MilestoneType.targetTirMonth => Icons.military_tech_outlined,
      MilestoneType.fastingChampion => Icons.brightness_5_rounded,
      MilestoneType.postMealMaster => Icons.restaurant_rounded,
      MilestoneType.earlyBird => Icons.wb_sunny_outlined,
      MilestoneType.nightOwl => Icons.bedtime_outlined,
      MilestoneType.weekendWarrior => Icons.weekend_outlined,
      MilestoneType.newYear => Icons.celebration_outlined,
      MilestoneType.yearEnd => Icons.shield_outlined,
    };
  }

  /// Resolves the header [IconData] for a [MilestoneCategory].
  static IconData iconForCategory(MilestoneCategory category) {
    return switch (category) {
      MilestoneCategory.goals => Icons.track_changes_rounded,
      MilestoneCategory.streaks => Icons.local_fire_department_rounded,
      MilestoneCategory.routines => Icons.schedule_rounded,
      MilestoneCategory.special => Icons.auto_awesome_rounded,
    };
  }
}
