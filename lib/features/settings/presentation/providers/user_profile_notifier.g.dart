// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the user's clinical profile and settings state.
///
/// Watches [UserProfileRepository.watch] for live updates and provides methods to update
/// preferences, target ranges, measurement units, and onboarding status.

@ProviderFor(UserProfileNotifier)
final userProfileProvider = UserProfileNotifierProvider._();

/// Riverpod state notifier managing the user's clinical profile and settings state.
///
/// Watches [UserProfileRepository.watch] for live updates and provides methods to update
/// preferences, target ranges, measurement units, and onboarding status.
final class UserProfileNotifierProvider
    extends $StreamNotifierProvider<UserProfileNotifier, UserProfile> {
  /// Riverpod state notifier managing the user's clinical profile and settings state.
  ///
  /// Watches [UserProfileRepository.watch] for live updates and provides methods to update
  /// preferences, target ranges, measurement units, and onboarding status.
  UserProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileNotifierHash();

  @$internal
  @override
  UserProfileNotifier create() => UserProfileNotifier();
}

String _$userProfileNotifierHash() =>
    r'f8487088cff288bbe0f1aec59148166621a71075';

/// Riverpod state notifier managing the user's clinical profile and settings state.
///
/// Watches [UserProfileRepository.watch] for live updates and provides methods to update
/// preferences, target ranges, measurement units, and onboarding status.

abstract class _$UserProfileNotifier extends $StreamNotifier<UserProfile> {
  Stream<UserProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<UserProfile>, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<UserProfile>, UserProfile>,
              AsyncValue<UserProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
