import 'package:flutter/material.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/milestone_icon_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MilestoneIconResolver', () {
    test('iconForType returns correct IconData for all milestone types', () {
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.firstReading),
        equals(Icons.water_drop_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.streak7),
        equals(Icons.local_fire_department_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.streak30),
        equals(Icons.bolt_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.streak100),
        equals(Icons.workspace_premium_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.streak365),
        equals(Icons.emoji_events_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.comeback),
        equals(Icons.replay_rounded),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.targetTirWeek),
        equals(Icons.verified_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.targetTirMonth),
        equals(Icons.military_tech_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.fastingChampion),
        equals(Icons.brightness_5_rounded),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.postMealMaster),
        equals(Icons.restaurant_rounded),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.earlyBird),
        equals(Icons.wb_sunny_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.nightOwl),
        equals(Icons.bedtime_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.weekendWarrior),
        equals(Icons.weekend_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.newYear),
        equals(Icons.celebration_outlined),
      );
      expect(
        MilestoneIconResolver.iconForType(MilestoneType.yearEnd),
        equals(Icons.shield_outlined),
      );
    });

    test(
      'iconForCategory returns correct IconData for all milestone categories',
      () {
        expect(
          MilestoneIconResolver.iconForCategory(MilestoneCategory.goals),
          equals(Icons.track_changes_rounded),
        );
        expect(
          MilestoneIconResolver.iconForCategory(MilestoneCategory.streaks),
          equals(Icons.local_fire_department_rounded),
        );
        expect(
          MilestoneIconResolver.iconForCategory(MilestoneCategory.routines),
          equals(Icons.schedule_rounded),
        );
        expect(
          MilestoneIconResolver.iconForCategory(MilestoneCategory.special),
          equals(Icons.auto_awesome_rounded),
        );
      },
    );

    test('covers all enum types without error', () {
      for (final type in MilestoneType.values) {
        expect(MilestoneIconResolver.iconForType(type), isA<IconData>());
      }
      for (final cat in MilestoneCategory.values) {
        expect(MilestoneIconResolver.iconForCategory(cat), isA<IconData>());
      }
    });
  });
}
