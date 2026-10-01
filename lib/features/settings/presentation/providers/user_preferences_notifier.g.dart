// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the application's user preferences state.
///
/// Watches [UserPreferencesRepository.watch] for live settings changes and provides
/// methods to update theme modes and notification flags.

@ProviderFor(UserPreferencesNotifier)
final userPreferencesProvider = UserPreferencesNotifierProvider._();

/// Riverpod state notifier managing the application's user preferences state.
///
/// Watches [UserPreferencesRepository.watch] for live settings changes and provides
/// methods to update theme modes and notification flags.
final class UserPreferencesNotifierProvider
    extends $StreamNotifierProvider<UserPreferencesNotifier, UserPreferences> {
  /// Riverpod state notifier managing the application's user preferences state.
  ///
  /// Watches [UserPreferencesRepository.watch] for live settings changes and provides
  /// methods to update theme modes and notification flags.
  UserPreferencesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPreferencesNotifierHash();

  @$internal
  @override
  UserPreferencesNotifier create() => UserPreferencesNotifier();
}

String _$userPreferencesNotifierHash() =>
    r'dbde4b27cab4be51f7106c09f92506e4a1fe8901';

/// Riverpod state notifier managing the application's user preferences state.
///
/// Watches [UserPreferencesRepository.watch] for live settings changes and provides
/// methods to update theme modes and notification flags.

abstract class _$UserPreferencesNotifier
    extends $StreamNotifier<UserPreferences> {
  Stream<UserPreferences> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserPreferences>, UserPreferences>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserPreferences>, UserPreferences>,
              AsyncValue<UserPreferences>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
