import '../../../../core/errors/result.dart';
import '../entities/user_preferences.dart';

/// Repository interface defining domain operations for user preferences.
///
/// Provides abstract data access methods for watching and modifying application settings,
/// isolating domain logic from the underlying storage mechanism.
abstract class UserPreferencesRepository {
  /// Watches user preferences for changes.
  ///
  /// Emits a continuous [Stream] containing updated [UserPreferences] whenever settings
  /// in the underlying persistence store are modified.
  Stream<UserPreferences> watch();

  /// Gets the current snapshot of user preferences.
  Future<UserPreferences> get();

  /// Updates the theme mode setting to [themeMode].
  Future<CommandResult> updateThemeMode(UserThemeMode themeMode);

  /// Updates whether notifications are enabled to [isEnabled].
  Future<CommandResult> updateNotificationsEnabled(bool isEnabled);
}
