import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';
import '../widgets/onboarding_biometric_step.dart';
import '../widgets/onboarding_csv_import_step.dart';
import '../widgets/onboarding_diabetes_step.dart';
import '../widgets/onboarding_health_sync_step.dart';
import '../widgets/onboarding_privacy_step.dart';
import '../widgets/onboarding_reminder_step.dart';
import '../widgets/onboarding_target_range_step.dart';
import '../widgets/onboarding_units_step.dart';
import '../widgets/onboarding_welcome_step.dart';

/// First-run wizard collecting the user's profile across nine steps.
///
/// Steps: welcome, units, diabetes type with optional baseline, target range,
/// health sync, daily reminder, biometric lock, privacy notice, and CSV import
/// with completion. Steps without mandatory input are skippable via Next.
class OnboardingScreen extends ConsumerWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({super.key});

  void _next(BuildContext context, WidgetRef ref) {
    final draft = ref.read(onboardingProvider);
    final l10n = AppLocalizations.of(context);
    if (draft.step == 0 && draft.name.trim().isEmpty) {
      AppSnackBar.show(
        context,
        message: l10n?.errorValidation ?? 'Invalid value',
        type: SnackBarType.error,
      );
      return;
    }
    if (draft.step == 7 && !draft.privacyAcknowledged) {
      AppSnackBar.show(
        context,
        message:
            l10n?.onboardingPrivacyRequired ??
            'Please acknowledge the privacy notice to continue',
        type: SnackBarType.error,
      );
      return;
    }
    ref.read(onboardingProvider.notifier).next();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: draft.step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: l10n?.onboardingBack ?? 'Back',
                onPressed: () => ref.read(onboardingProvider.notifier).back(),
              )
            : null,
        title: Text(
          l10n?.onboardingStepOf(draft.step + 1, OnboardingDraft.totalSteps) ??
              'Step ${draft.step + 1} of ${OnboardingDraft.totalSteps}',
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (draft.step + 1) / OnboardingDraft.totalSteps,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: switch (draft.step) {
                0 => const OnboardingWelcomeStep(),
                1 => const OnboardingUnitsStep(),
                2 => const OnboardingDiabetesStep(),
                3 => const OnboardingTargetRangeStep(),
                4 => const OnboardingHealthSyncStep(),
                5 => const OnboardingReminderStep(),
                6 => const OnboardingBiometricStep(),
                7 => const OnboardingPrivacyStep(),
                _ => OnboardingCsvImportStep(
                  onCompleted: () => context.go(AppRoute.overview.path),
                ),
              },
            ),
            if (draft.step < OnboardingDraft.totalSteps - 1)
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => _next(context, ref),
                  child: Text(l10n?.onboardingNext ?? 'Next'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
