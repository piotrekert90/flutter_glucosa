import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/settings/data/mappers/user_profile_mapper.dart';
import 'package:flutter_glucosa/features/settings/data/models/user_profile_model.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfileMapper', () {
    test(
      'toEntity() converts UserProfileModel to UserProfile entity correctly',
      () {
        final model = UserProfileModel()
          ..name = 'Alice'
          ..diabetesType = 'type1'
          ..preferredGlucoseUnit = 'mmolL'
          ..preferredHbA1cUnit = 'mmolMol'
          ..preferredWeightUnit = 'pounds'
          ..targetRangePreset = 'ukNice'
          ..targetRangeMinMgDl = 72
          ..targetRangeMaxMgDl = 140
          ..isOnboardingCompleted = true
          ..isNotificationsEnabled = false
          ..themeMode = 'dark';

        final entity = model.toEntity();

        expect(entity.name, 'Alice');
        expect(entity.diabetesType, DiabetesType.type1);
        expect(entity.preferredGlucoseUnit, GlucoseUnit.mmolL);
        expect(entity.preferredHbA1cUnit, HbA1cUnit.mmolMol);
        expect(entity.preferredWeightUnit, WeightUnit.pounds);
        expect(entity.targetRange.preset, GlucoseRangePreset.ukNice);
        expect(entity.targetRange.minMgDl, 72);
        expect(entity.targetRange.maxMgDl, 140);
        expect(entity.isOnboardingCompleted, isTrue);
        expect(entity.isNotificationsEnabled, isFalse);
        expect(entity.themeMode, UserThemeMode.dark);
      },
    );

    test('toEntity() defaults when enum values are unknown', () {
      final model = UserProfileModel()
        ..name = ''
        ..diabetesType = 'unknown'
        ..preferredGlucoseUnit = 'unknown'
        ..preferredHbA1cUnit = 'unknown'
        ..preferredWeightUnit = 'unknown'
        ..targetRangePreset = 'unknown'
        ..targetRangeMinMgDl = 70
        ..targetRangeMaxMgDl = 180
        ..isOnboardingCompleted = false
        ..isNotificationsEnabled = true
        ..themeMode = 'unknown';

      final entity = model.toEntity();

      expect(entity.diabetesType, DiabetesType.type2);
      expect(entity.preferredGlucoseUnit, GlucoseUnit.mgDl);
      expect(entity.preferredHbA1cUnit, HbA1cUnit.percentage);
      expect(entity.preferredWeightUnit, WeightUnit.kilograms);
      expect(entity.targetRange.preset, GlucoseRangePreset.ada);
      expect(entity.themeMode, UserThemeMode.system);
    });

    test(
      'toModel() converts UserProfile entity to UserProfileModel correctly',
      () {
        const entity = UserProfile(
          name: 'Bob',
          diabetesType: DiabetesType.gestational,
          preferredGlucoseUnit: GlucoseUnit.mgDl,
          preferredHbA1cUnit: HbA1cUnit.percentage,
          preferredWeightUnit: WeightUnit.kilograms,
          targetRange: GlucoseTargetRange.aace(),
          isOnboardingCompleted: true,
          isNotificationsEnabled: true,
          themeMode: UserThemeMode.light,
        );

        final model = entity.toModel();

        expect(model.id, userProfileSingletonId);
        expect(model.name, 'Bob');
        expect(model.diabetesType, 'gestational');
        expect(model.preferredGlucoseUnit, 'mgDl');
        expect(model.preferredHbA1cUnit, 'percentage');
        expect(model.preferredWeightUnit, 'kilograms');
        expect(model.targetRangePreset, 'aace');
        expect(model.targetRangeMinMgDl, 110);
        expect(model.targetRangeMaxMgDl, 140);
        expect(model.isOnboardingCompleted, isTrue);
        expect(model.isNotificationsEnabled, isTrue);
        expect(model.themeMode, 'light');
      },
    );
  });
}
