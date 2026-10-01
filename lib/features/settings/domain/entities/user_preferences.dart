/// Domain-level enum representing supported application display theme modes.
enum UserThemeMode {
  /// Always force light theme mode regardless of system settings.
  light,

  /// Always force dark theme mode regardless of system settings.
  dark,

  /// Automatically follow the host operating system's active theme setting.
  system,
}

/// Domain entity representing user-configurable application preferences.
///
/// Encapsulates preferences such as theme selection and notification toggles,
/// keeping domain business rules completely independent of persistence layers.
class UserPreferences {
  /// Creates user preferences with explicit [themeMode] and [isNotificationsEnabled] values.
  const UserPreferences({
    required this.themeMode,
    required this.isNotificationsEnabled,
  });

  /// Creates default [UserPreferences] configured with [UserThemeMode.system] and notifications enabled.
  factory UserPreferences.defaults() {
    return const UserPreferences(
      themeMode: UserThemeMode.system,
      isNotificationsEnabled: true,
    );
  }

  /// The active theme mode preference.
  final UserThemeMode themeMode;

  /// Indicates whether push or local notifications are enabled by the user.
  final bool isNotificationsEnabled;

  /// Creates a copy of this [UserPreferences] instance with specified fields replaced.
  UserPreferences copyWith({
    UserThemeMode? themeMode,
    bool? isNotificationsEnabled,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UserPreferences &&
            other.themeMode == themeMode &&
            other.isNotificationsEnabled == isNotificationsEnabled;
  }

  @override
  int get hashCode => Object.hash(themeMode, isNotificationsEnabled);
}
