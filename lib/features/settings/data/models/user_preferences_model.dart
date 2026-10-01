import 'package:isar_community/isar.dart';

part 'user_preferences_model.g.dart';

/// The default fixed primary key ID used for persisting the single [UserPreferencesModel] record.
const userPreferencesSingletonId = 0;

/// Persistent Isar database collection model for application user preferences.
///
/// Functions as a single-row (singleton) collection storing theme and notification preferences,
/// mapped synchronously to and from domain `UserPreferences` entities.
@collection
class UserPreferencesModel {
  /// The fixed singleton identifier for accessing user preference settings in Isar storage.
  Id id = userPreferencesSingletonId;

  /// The persisted theme mode preference serialized as a raw String name.
  late String themeMode;

  /// Indicates whether push or local notifications are enabled by the user.
  bool isNotificationsEnabled = true;
}
