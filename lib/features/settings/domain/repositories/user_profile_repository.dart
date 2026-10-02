import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/errors/result.dart';
import '../entities/user_profile.dart';

/// Repository interface defining domain operations for user profile and application settings.
///
/// Provides abstract data access methods for watching and modifying patient settings,
/// isolating domain logic from the underlying storage mechanism.
abstract class UserProfileRepository {
  /// Watches user profile for live updates.
  ///
  /// Emits a continuous [Stream] containing updated [UserProfile] whenever settings
  /// in the underlying persistence store are modified.
  Stream<UserProfile> watch();

  /// Gets the current snapshot of the user profile.
  Future<UserProfile> get();

  /// Saves the complete [UserProfile].
  Future<CommandResult> save(UserProfile profile);

  /// Updates the theme mode setting to [themeMode].
  Future<CommandResult> updateThemeMode(UserThemeMode themeMode);

  /// Updates whether notifications are enabled to [isEnabled].
  Future<CommandResult> updateNotificationsEnabled(bool isEnabled);

  /// Updates whether biometric lock is enabled to [isEnabled].
  Future<CommandResult> updateBiometricLockEnabled(bool isEnabled);

  /// Updates the user's preferred glucose unit to [unit].
  Future<CommandResult> updateGlucoseUnit(GlucoseUnit unit);

  /// Updates the target glucose range to [range].
  Future<CommandResult> updateTargetRange(GlucoseTargetRange range);

  /// Marks the onboarding wizard as completed.
  Future<CommandResult> completeOnboarding();

  /// Updates the preferred first day of the week to [firstDayOfWeek].
  Future<CommandResult> updateFirstDayOfWeek(FirstDayOfWeek firstDayOfWeek);

  /// Irreversibly erases all health records, reminders, and resets user profile to defaults.
  Future<CommandResult> wipeAllData();
}
