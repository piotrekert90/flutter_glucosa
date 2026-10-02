// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_lock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State notifier managing whether the application is currently locked behind the biometric shield.

@ProviderFor(BiometricLock)
final biometricLockProvider = BiometricLockProvider._();

/// State notifier managing whether the application is currently locked behind the biometric shield.
final class BiometricLockProvider
    extends $NotifierProvider<BiometricLock, bool> {
  /// State notifier managing whether the application is currently locked behind the biometric shield.
  BiometricLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'biometricLockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$biometricLockHash();

  @$internal
  @override
  BiometricLock create() => BiometricLock();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$biometricLockHash() => r'8070f0d7f766442e37067697b7c7a3bfafee9952';

/// State notifier managing whether the application is currently locked behind the biometric shield.

abstract class _$BiometricLock extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
