import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/errors/result.dart';
import '../../../glucose/data/providers/glucose_reading_repository_provider.dart';
import '../../../glucose/domain/entities/glucose_reading.dart';
import '../../../reminders/data/providers/reminder_repository_provider.dart';
import '../../../reminders/domain/entities/reminder.dart';
import '../../../settings/data/providers/user_profile_repository_provider.dart';
import '../../../settings/domain/entities/user_profile.dart';

part 'onboarding_notifier.g.dart';

/// Draft profile values collected across the onboarding wizard steps.
class OnboardingDraft {
  /// Total number of wizard steps.
  static const int totalSteps = 9;

  /// Zero-based index of the currently displayed step.
  final int step;

  /// User-provided display name.
  final String name;

  /// Selected diabetes classification.
  final DiabetesType diabetesType;

  /// Optional baseline glucose reading in mg/dL collected at signup.
  final int? baselineMgDl;

  /// Selected preferred glucose unit.
  final GlucoseUnit glucoseUnit;

  /// Selected target range preset.
  final GlucoseRangePreset rangePreset;

  /// Whether platform health store synchronization was enabled.
  final bool healthSyncEnabled;

  /// Whether a daily measurement reminder was configured.
  final bool reminderEnabled;

  /// Reminder hour of day (0–23), when [reminderEnabled] is true.
  final int? reminderHour;

  /// Reminder minute of hour (0–59), when [reminderEnabled] is true.
  final int? reminderMinute;

  /// Whether biometric app lock was enabled.
  final bool biometricEnabled;

  /// Whether the privacy notice was acknowledged.
  final bool privacyAcknowledged;

  /// Creates an immutable [OnboardingDraft] with default selections.
  const OnboardingDraft({
    this.step = 0,
    this.name = '',
    this.diabetesType = DiabetesType.type2,
    this.baselineMgDl,
    this.glucoseUnit = GlucoseUnit.mgDl,
    this.rangePreset = GlucoseRangePreset.ada,
    this.healthSyncEnabled = false,
    this.reminderEnabled = false,
    this.reminderHour,
    this.reminderMinute,
    this.biometricEnabled = false,
    this.privacyAcknowledged = false,
  });

  /// Returns a copy of this draft with the given fields replaced by new values.
  OnboardingDraft copyWith({
    int? step,
    String? name,
    DiabetesType? diabetesType,
    int? baselineMgDl,
    bool clearBaseline = false,
    GlucoseUnit? glucoseUnit,
    GlucoseRangePreset? rangePreset,
    bool? healthSyncEnabled,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? biometricEnabled,
    bool? privacyAcknowledged,
  }) {
    return OnboardingDraft(
      step: step ?? this.step,
      name: name ?? this.name,
      diabetesType: diabetesType ?? this.diabetesType,
      baselineMgDl: clearBaseline ? null : (baselineMgDl ?? this.baselineMgDl),
      glucoseUnit: glucoseUnit ?? this.glucoseUnit,
      rangePreset: rangePreset ?? this.rangePreset,
      healthSyncEnabled: healthSyncEnabled ?? this.healthSyncEnabled,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      privacyAcknowledged: privacyAcknowledged ?? this.privacyAcknowledged,
    );
  }
}

/// Riverpod notifier managing onboarding wizard step navigation and draft profile state.
///
/// Kept alive for the container lifetime so text input callbacks always
/// reach a live notifier, even when no widget is currently watching.
@Riverpod(keepAlive: true)
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

  /// Sets the optional baseline glucose reading in mg/dL, or clears it.
  void updateBaselineMgDl(int? value) {
    state = state.copyWith(baselineMgDl: value, clearBaseline: value == null);
  }

  /// Toggles platform health store synchronization.
  void setHealthSyncEnabled(bool enabled) {
    state = state.copyWith(healthSyncEnabled: enabled);
  }

  /// Configures the daily reminder time, or disables the reminder when [hour] is null.
  void setReminderTime(int? hour, int? minute) {
    state = state.copyWith(
      reminderEnabled: hour != null && minute != null,
      reminderHour: hour,
      reminderMinute: minute,
    );
  }

  /// Toggles biometric app lock.
  void setBiometricEnabled(bool enabled) {
    state = state.copyWith(biometricEnabled: enabled);
  }

  /// Marks the privacy notice as acknowledged.
  void acknowledgePrivacy() {
    state = state.copyWith(privacyAcknowledged: true);
  }

  /// Persists the draft as the user profile and marks onboarding completed.
  ///
  /// Also stores the optional baseline glucose reading and creates the
  /// configured daily reminder labeled [reminderLabel]. Returns the first
  /// failure encountered, if any.
  Future<CommandResult> complete({required String reminderLabel}) async {
    final range = GlucoseTargetRange.fromPreset(state.rangePreset);
    final profile = UserProfile(
      name: state.name.trim(),
      diabetesType: state.diabetesType,
      preferredGlucoseUnit: state.glucoseUnit,
      targetRange: range.copyWith(preset: state.rangePreset),
      isBiometricLockEnabled: state.biometricEnabled,
      isHealthSyncEnabled: state.healthSyncEnabled,
      isOnboardingCompleted: true,
    );
    final (saved, saveFailure) = await ref
        .read(userProfileRepositoryProvider)
        .save(profile);
    if (!saved) return (false, saveFailure);

    if (state.baselineMgDl != null) {
      final (added, addFailure) = await ref
          .read(glucoseReadingRepositoryProvider)
          .add(
            GlucoseReading(
              readingMgDl: state.baselineMgDl!,
              mealContext: MealContext.fasting,
              createdAt: DateTime.now(),
            ),
          );
      if (!added) return (false, addFailure);
    }

    if (state.reminderEnabled &&
        state.reminderHour != null &&
        state.reminderMinute != null) {
      final (created, createFailure) = await ref
          .read(reminderRepositoryProvider)
          .add(
            Reminder(
              label: reminderLabel,
              metricType: MetricType.glucose,
              hourOfDay: state.reminderHour!,
              minute: state.reminderMinute!,
            ),
          );
      if (!created) return (false, createFailure);
    }
    return (true, null);
  }
}
