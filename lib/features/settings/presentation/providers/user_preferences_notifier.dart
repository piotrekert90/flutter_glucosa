import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../domain/entities/user_preferences.dart';
import '../../data/providers/user_preferences_repository_provider.dart';

part 'user_preferences_notifier.g.dart';

/// Riverpod state notifier managing the application's user preferences state.
///
/// Watches [UserPreferencesRepository.watch] for live settings changes and provides
/// methods to update theme modes and notification flags.
@riverpod
class UserPreferencesNotifier extends _$UserPreferencesNotifier {
  @override
  Stream<UserPreferences> build() {
    final repository = ref.watch(userPreferencesRepositoryProvider);
    return repository.watch();
  }

  /// Updates the application theme mode to [themeMode].
  Future<CommandResult> updateThemeMode(UserThemeMode themeMode) {
    return ref
        .read(userPreferencesRepositoryProvider)
        .updateThemeMode(themeMode);
  }

  /// Updates the user's notification preference flag to [isEnabled].
  Future<CommandResult> updateNotificationsEnabled(bool isEnabled) {
    return ref
        .read(userPreferencesRepositoryProvider)
        .updateNotificationsEnabled(isEnabled);
  }
}
