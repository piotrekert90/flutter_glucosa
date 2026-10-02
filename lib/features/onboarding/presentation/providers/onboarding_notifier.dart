import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/errors/result.dart';
import '../../../settings/data/providers/user_profile_repository_provider.dart';
import '../../../settings/domain/entities/user_profile.dart';

part 'onboarding_notifier.g.dart';

/// Draft profile values collected across the onboarding wizard steps.
class OnboardingDraft {
  /// Total number of wizard steps.
  static const int totalSteps = 4;

  /// Zero-based index of the currently displayed step.
  final int step;

  /// User-provided display name.
  final String name;

  /// Selected diabetes classification.
  final DiabetesType diabetesType;

  /// Selected preferred glucose unit.
  final GlucoseUnit glucoseUnit;

  /// Selected target range preset.
  final GlucoseRangePreset rangePreset;

  /// Creates an immutable [OnboardingDraft] with default selections.
  const OnboardingDraft({
    this.step = 0,
    this.name = '',
    this.diabetesType = DiabetesType.type2,
    this.glucoseUnit = GlucoseUnit.mgDl,
    this.rangePreset = GlucoseRangePreset.ada,
  });

  /// Returns a copy of this draft with the given fields replaced by new values.
  OnboardingDraft copyWith({
    int? step,
    String? name,
    DiabetesType? diabetesType,
    GlucoseUnit? glucoseUnit,
    GlucoseRangePreset? rangePreset,
  }) {
    return OnboardingDraft(
      step: step ?? this.step,
      name: name ?? this.name,
      diabetesType: diabetesType ?? this.diabetesType,
      glucoseUnit: glucoseUnit ?? this.glucoseUnit,
      rangePreset: rangePreset ?? this.rangePreset,
    );
  }
}

/// Riverpod notifier managing onboarding wizard step navigation and draft profile state.
@riverpod
class Onboarding extends _$Onboarding {
  @override
  OnboardingDraft build() => const OnboardingDraft();

  /// Advances to the next wizard step when not already on the last one.
  void next() {
    if (state.step < OnboardingDraft.totalSteps - 1) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  /// Returns to the previous wizard step when not already on the first one.
  void back() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1);
    }
  }

  /// Updates the draft display [name].
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  /// Selects the draft diabetes classification.
  void selectDiabetesType(DiabetesType type) {
    state = state.copyWith(diabetesType: type);
  }

  /// Selects the draft preferred glucose unit.
  void selectGlucoseUnit(GlucoseUnit unit) {
    state = state.copyWith(glucoseUnit: unit);
  }

  /// Selects the draft target range preset.
  void selectRangePreset(GlucoseRangePreset preset) {
    state = state.copyWith(rangePreset: preset);
  }

  /// Persists the draft as the user profile and marks onboarding completed.
  Future<CommandResult> complete() {
    final range = switch (state.rangePreset) {
      GlucoseRangePreset.ada => const GlucoseTargetRange.ada(),
      GlucoseRangePreset.aace => const GlucoseTargetRange.aace(),
      GlucoseRangePreset.ukNice => const GlucoseTargetRange.ukNice(),
      GlucoseRangePreset.custom => const GlucoseTargetRange.ada(),
    };
    final profile = UserProfile(
      name: state.name.trim(),
      diabetesType: state.diabetesType,
      preferredGlucoseUnit: state.glucoseUnit,
      targetRange: range.copyWith(preset: state.rangePreset),
      isOnboardingCompleted: true,
    );
    return ref.read(userProfileRepositoryProvider).save(profile);
  }
}
