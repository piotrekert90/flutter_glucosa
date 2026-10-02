import 'package:isar_community/isar.dart';

part 'user_profile_model.g.dart';

/// The default fixed primary key ID used for persisting the single [UserProfileModel] record.
const userProfileSingletonId = 0;

/// Persistent Isar database collection model for user profile and application settings.
///
/// Functions as a single-row (singleton) collection storing clinical diabetes parameters,
/// preferred measurement units, target ranges, onboarding status, and UI preferences.
@collection
class UserProfileModel {
  /// The fixed singleton identifier for accessing user profile settings in Isar storage.
  Id id = userProfileSingletonId;

  /// User's name or display nickname.
  String name = '';

  /// Diagnosed diabetes classification stored by enum name.
  String diabetesType = 'type2';

  /// Preferred blood glucose unit stored by enum name ('mgDl' or 'mmolL').
  String preferredGlucoseUnit = 'mgDl';

  /// Preferred HbA1c unit stored by enum name ('percentage' or 'mmolMol').
  String preferredHbA1cUnit = 'percentage';

  /// Preferred body weight unit stored by enum name ('kilograms' or 'pounds').
  String preferredWeightUnit = 'kilograms';

  /// Target glucose range preset stored by enum name ('ada', 'aace', 'ukNice', 'custom').
  String targetRangePreset = 'ada';

  /// Target lower bound blood glucose in mg/dL.
  int targetRangeMinMgDl = 70;

  /// Target upper bound blood glucose in mg/dL.
  int targetRangeMaxMgDl = 180;

  /// Flag indicating if onboarding has been completed.
  bool isOnboardingCompleted = false;

  /// Flag indicating if notifications are enabled.
  bool isNotificationsEnabled = true;

  /// Active display theme preference stored by enum name ('system', 'light', 'dark').
  String themeMode = 'system';

  /// Flag indicating if biometric authentication lock is enabled.
  bool isBiometricLockEnabled = false;

  /// Preferred first day of the week stored by enum name ('system', 'monday', 'sunday').
  String firstDayOfWeek = 'system';

  /// Flag indicating if platform health store synchronization is enabled.
  bool isHealthSyncEnabled = false;

  /// Timestamp of the last successful platform health synchronization, if any.
  DateTime? lastHealthSyncAt;
}
