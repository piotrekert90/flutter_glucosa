import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/errors/result.dart';
import '../../data/providers/user_profile_repository_provider.dart';
import '../../domain/entities/user_profile.dart';

part 'user_profile_notifier.g.dart';

/// Riverpod state notifier managing the user's clinical profile and settings state.
///
/// Watches [UserProfileRepository.watch] for live updates and provides methods to update
/// preferences, target ranges, measurement units, and onboarding status.
@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Stream<UserProfile> build() {
    final repository = ref.watch(userProfileRepositoryProvider);
    return repository.watch();
  }

  /// Updates the application theme mode to [themeMode].
  Future<CommandResult> updateThemeMode(UserThemeMode themeMode) {
    return ref.read(userProfileRepositoryProvider).updateThemeMode(themeMode);
  }

  /// Updates the user's notification preference flag to [isEnabled].
  Future<CommandResult> updateNotificationsEnabled(bool isEnabled) {
    return ref
        .read(userProfileRepositoryProvider)
        .updateNotificationsEnabled(isEnabled);
  }

  /// Updates the user's complete [profile].
  Future<CommandResult> updateProfile(UserProfile profile) {
    return ref.read(userProfileRepositoryProvider).save(profile);
  }

  /// Updates the preferred blood glucose unit to [unit].
  Future<CommandResult> updateGlucoseUnit(GlucoseUnit unit) {
    return ref.read(userProfileRepositoryProvider).updateGlucoseUnit(unit);
  }

  /// Updates the target clinical blood glucose range to [range].
  Future<CommandResult> updateTargetRange(GlucoseTargetRange range) {
    return ref.read(userProfileRepositoryProvider).updateTargetRange(range);
  }

  /// Marks onboarding as completed.
  Future<CommandResult> completeOnboarding() {
    return ref.read(userProfileRepositoryProvider).completeOnboarding();
  }
}
