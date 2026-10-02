import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../domain/entities/user_profile.dart';
import '../models/user_profile_model.dart';

/// Synchronous data mapping extensions for converting [UserProfileModel] database instances to domain entities.
extension UserProfileModelMapper on UserProfileModel {
  /// Converts this persistent [UserProfileModel] instance into a domain [UserProfile] entity.
  UserProfile toEntity() {
    return UserProfile(
      name: name,
      diabetesType: _enumFromName(
        DiabetesType.values,
        diabetesType,
        DiabetesType.type2,
      ),
      preferredGlucoseUnit: _enumFromName(
        GlucoseUnit.values,
        preferredGlucoseUnit,
        GlucoseUnit.mgDl,
      ),
      preferredHbA1cUnit: _enumFromName(
        HbA1cUnit.values,
        preferredHbA1cUnit,
        HbA1cUnit.percentage,
      ),
      preferredWeightUnit: _enumFromName(
        WeightUnit.values,
        preferredWeightUnit,
        WeightUnit.kilograms,
      ),
      targetRange: GlucoseTargetRange(
        preset: _enumFromName(
          GlucoseRangePreset.values,
          targetRangePreset,
          GlucoseRangePreset.ada,
        ),
        minMgDl: targetRangeMinMgDl,
        maxMgDl: targetRangeMaxMgDl,
      ),
      isOnboardingCompleted: isOnboardingCompleted,
      isNotificationsEnabled: isNotificationsEnabled,
      themeMode: _enumFromName(
        UserThemeMode.values,
        themeMode,
        UserThemeMode.system,
      ),
      isBiometricLockEnabled: isBiometricLockEnabled,
    );
  }
}

/// Synchronous data mapping extensions for converting domain [UserProfile] entities to persistent models.
extension UserProfileMapper on UserProfile {
  /// Converts this domain [UserProfile] entity into an Isar [UserProfileModel] with the singleton key.
  UserProfileModel toModel() {
    return UserProfileModel()
      ..id = userProfileSingletonId
      ..name = name
      ..diabetesType = diabetesType.name
      ..preferredGlucoseUnit = preferredGlucoseUnit.name
      ..preferredHbA1cUnit = preferredHbA1cUnit.name
      ..preferredWeightUnit = preferredWeightUnit.name
      ..targetRangePreset = targetRange.preset.name
      ..targetRangeMinMgDl = targetRange.minMgDl
      ..targetRangeMaxMgDl = targetRange.maxMgDl
      ..isOnboardingCompleted = isOnboardingCompleted
      ..isNotificationsEnabled = isNotificationsEnabled
      ..themeMode = themeMode.name
      ..isBiometricLockEnabled = isBiometricLockEnabled;
  }
}

T _enumFromName<T extends Enum>(List<T> values, String name, T fallback) {
  return values.firstWhere((e) => e.name == name, orElse: () => fallback);
}
