// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier managing onboarding wizard step navigation and draft profile state.

@ProviderFor(Onboarding)
final onboardingProvider = OnboardingProvider._();

/// Riverpod notifier managing onboarding wizard step navigation and draft profile state.
final class OnboardingProvider
    extends $NotifierProvider<Onboarding, OnboardingDraft> {
  /// Riverpod notifier managing onboarding wizard step navigation and draft profile state.
  OnboardingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingHash();

  @$internal
  @override
  Onboarding create() => Onboarding();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingDraft value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingDraft>(value),
    );
  }
}

String _$onboardingHash() => r'ed28b2d49d2c892e31947362b1bf75e92de4aa0f';

/// Riverpod notifier managing onboarding wizard step navigation and draft profile state.

abstract class _$Onboarding extends $Notifier<OnboardingDraft> {
  OnboardingDraft build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OnboardingDraft, OnboardingDraft>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingDraft, OnboardingDraft>,
              OnboardingDraft,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
