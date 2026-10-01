import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile', () {
    test('defaults() creates clinical defaults', () {
      final profile = UserProfile.defaults();

      expect(profile.name, isEmpty);
      expect(profile.diabetesType, DiabetesType.type2);
      expect(profile.preferredGlucoseUnit, GlucoseUnit.mgDl);
      expect(profile.preferredHbA1cUnit, HbA1cUnit.percentage);
      expect(profile.preferredWeightUnit, WeightUnit.kilograms);
      expect(profile.targetRange, const GlucoseTargetRange.ada());
      expect(profile.isOnboardingCompleted, isFalse);
      expect(profile.isNotificationsEnabled, isTrue);
      expect(profile.themeMode, UserThemeMode.system);
    });

    test(
      'copyWith updates specified fields and preserves unprovided fields',
      () {
        final initial = UserProfile.defaults();

        final updated = initial.copyWith(
          name: 'John Doe',
          diabetesType: DiabetesType.type1,
          preferredGlucoseUnit: GlucoseUnit.mmolL,
          preferredHbA1cUnit: HbA1cUnit.mmolMol,
          preferredWeightUnit: WeightUnit.pounds,
          targetRange: const GlucoseTargetRange.ukNice(),
          isOnboardingCompleted: true,
          isNotificationsEnabled: false,
          themeMode: UserThemeMode.dark,
        );

        expect(updated.name, 'John Doe');
        expect(updated.diabetesType, DiabetesType.type1);
        expect(updated.preferredGlucoseUnit, GlucoseUnit.mmolL);
        expect(updated.preferredHbA1cUnit, HbA1cUnit.mmolMol);
        expect(updated.preferredWeightUnit, WeightUnit.pounds);
        expect(updated.targetRange, const GlucoseTargetRange.ukNice());
        expect(updated.isOnboardingCompleted, isTrue);
        expect(updated.isNotificationsEnabled, isFalse);
        expect(updated.themeMode, UserThemeMode.dark);
      },
    );

    test('supports value equality and hashCode consistency', () {
      const p1 = UserProfile(
        name: 'Alice',
        diabetesType: DiabetesType.type1,
        themeMode: UserThemeMode.dark,
      );
      const p2 = UserProfile(
        name: 'Alice',
        diabetesType: DiabetesType.type1,
        themeMode: UserThemeMode.dark,
      );
      const p3 = UserProfile(
        name: 'Bob',
        diabetesType: DiabetesType.type1,
        themeMode: UserThemeMode.dark,
      );

      expect(p1, equals(p2));
      expect(p1.hashCode, equals(p2.hashCode));
      expect(p1, isNot(equals(p3)));
      expect(p1, isNot(equals('different_type')));
    });
  });
}
