import '../../domain/entities/user_preferences.dart';
import '../models/user_preferences_model.dart';

/// Synchronous data mapping extensions for converting [UserPreferencesModel] database instances to domain entities.
extension UserPreferencesModelMapper on UserPreferencesModel {
  /// Converts this persistent [UserPreferencesModel] instance into a domain [UserPreferences] entity.
  UserPreferences toEntity() {
    return UserPreferences(
      themeMode: _themeModeFromStorage(themeMode),
      isNotificationsEnabled: isNotificationsEnabled,
    );
  }
}

/// Synchronous data mapping extensions for converting domain [UserPreferences] entities to persistent models.
extension UserPreferencesMapper on UserPreferences {
  /// Converts this domain [UserPreferences] entity into an Isar [UserPreferencesModel] with the singleton key.
  UserPreferencesModel toModel() {
    return UserPreferencesModel()
      ..id = userPreferencesSingletonId
      ..themeMode = themeMode.name
      ..isNotificationsEnabled = isNotificationsEnabled;
  }
}

UserThemeMode _themeModeFromStorage(String value) {
  return UserThemeMode.values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => UserThemeMode.system,
  );
}
