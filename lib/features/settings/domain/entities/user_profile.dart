import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';

/// Domain entity representing complete user settings and clinical diabetes profile.
class UserProfile {
  /// User's display name or nickname.
  final String name;

  /// Diagnosed diabetes classification.
  final DiabetesType diabetesType;

  /// Preferred blood glucose unit of measurement.
  final GlucoseUnit preferredGlucoseUnit;

  /// Preferred glycated hemoglobin (HbA1c) unit of measurement.
  final HbA1cUnit preferredHbA1cUnit;

  /// Preferred body weight unit of measurement.
  final WeightUnit preferredWeightUnit;

  /// Clinical blood glucose target range thresholds.
  final GlucoseTargetRange targetRange;

  /// Flag indicating whether the initial onboarding wizard has been completed.
  final bool isOnboardingCompleted;

  /// Flag indicating whether local measurement notifications/reminders are enabled.
  final bool isNotificationsEnabled;

  /// Active display theme preference (system, light, dark).
  final UserThemeMode themeMode;

  /// Flag indicating whether biometric authentication is required to unlock the app.
  final bool isBiometricLockEnabled;

  /// Preferred first day of the week for calendar displays.
  final FirstDayOfWeek firstDayOfWeek;

  /// Flag indicating whether synchronization with the platform health store is enabled.
  final bool isHealthSyncEnabled;

  /// Timestamp of the last successful platform health synchronization, if any.
  final DateTime? lastHealthSyncAt;

  /// Creates a [UserProfile] instance with default clinical parameters.
  const UserProfile({
    this.name = '',
    this.diabetesType = DiabetesType.type2,
    this.preferredGlucoseUnit = GlucoseUnit.mgDl,
    this.preferredHbA1cUnit = HbA1cUnit.percentage,
    this.preferredWeightUnit = WeightUnit.kilograms,
    this.targetRange = const GlucoseTargetRange.ada(),
    this.isOnboardingCompleted = false,
    this.isNotificationsEnabled = true,
    this.themeMode = UserThemeMode.system,
    this.isBiometricLockEnabled = false,
    this.firstDayOfWeek = FirstDayOfWeek.system,
    this.isHealthSyncEnabled = false,
    this.lastHealthSyncAt,
  });

  /// Factory constructor producing default baseline profile parameters.
  factory UserProfile.defaults() => const UserProfile();

  /// Creates a copy of this [UserProfile] instance with specified properties modified.
  UserProfile copyWith({
    String? name,
    DiabetesType? diabetesType,
    GlucoseUnit? preferredGlucoseUnit,
    HbA1cUnit? preferredHbA1cUnit,
    WeightUnit? preferredWeightUnit,
    GlucoseTargetRange? targetRange,
    bool? isOnboardingCompleted,
    bool? isNotificationsEnabled,
    UserThemeMode? themeMode,
    bool? isBiometricLockEnabled,
    FirstDayOfWeek? firstDayOfWeek,
    bool? isHealthSyncEnabled,
    DateTime? lastHealthSyncAt,
  }) {
    return UserProfile(
      name: name ?? this.name,
      diabetesType: diabetesType ?? this.diabetesType,
      preferredGlucoseUnit: preferredGlucoseUnit ?? this.preferredGlucoseUnit,
      preferredHbA1cUnit: preferredHbA1cUnit ?? this.preferredHbA1cUnit,
      preferredWeightUnit: preferredWeightUnit ?? this.preferredWeightUnit,
      targetRange: targetRange ?? this.targetRange,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      themeMode: themeMode ?? this.themeMode,
      isBiometricLockEnabled:
          isBiometricLockEnabled ?? this.isBiometricLockEnabled,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
      isHealthSyncEnabled: isHealthSyncEnabled ?? this.isHealthSyncEnabled,
      lastHealthSyncAt: lastHealthSyncAt ?? this.lastHealthSyncAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.name == name &&
        other.diabetesType == diabetesType &&
        other.preferredGlucoseUnit == preferredGlucoseUnit &&
        other.preferredHbA1cUnit == preferredHbA1cUnit &&
        other.preferredWeightUnit == preferredWeightUnit &&
        other.targetRange == targetRange &&
        other.isOnboardingCompleted == isOnboardingCompleted &&
        other.isNotificationsEnabled == isNotificationsEnabled &&
        other.themeMode == themeMode &&
        other.isBiometricLockEnabled == isBiometricLockEnabled &&
        other.firstDayOfWeek == firstDayOfWeek &&
        other.isHealthSyncEnabled == isHealthSyncEnabled &&
        other.lastHealthSyncAt == lastHealthSyncAt;
  }

  @override
  int get hashCode => Object.hash(
    name,
    diabetesType,
    preferredGlucoseUnit,
    preferredHbA1cUnit,
    preferredWeightUnit,
    targetRange,
    isOnboardingCompleted,
    isNotificationsEnabled,
    themeMode,
    isBiometricLockEnabled,
    firstDayOfWeek,
    isHealthSyncEnabled,
    lastHealthSyncAt,
  );
}
