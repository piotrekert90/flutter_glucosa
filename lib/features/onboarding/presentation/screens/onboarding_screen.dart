import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';
import '../widgets/onboarding_confirm_step.dart';
import '../widgets/onboarding_diabetes_step.dart';
import '../widgets/onboarding_units_step.dart';
import '../widgets/onboarding_welcome_step.dart';

/// First-run wizard collecting the user's profile across four steps.
class OnboardingScreen extends ConsumerWidget {
  /// Creates an [OnboardingScreen].
  const OnboardingScreen({super.key});

  void _next(BuildContext context, WidgetRef ref) {
    final draft = ref.read(onboardingProvider);
    if (draft.step == 0 && draft.name.trim().isEmpty) {
      final l10n = AppLocalizations.of(context);
      AppSnackBar.show(
        context,
        message: l10n?.errorValidation ?? 'Invalid value',
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
    final notifier = ref.read(onboardingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: draft.step > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                tooltip: l10n?.onboardingBack ?? 'Back',
                onPressed: notifier.back,
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
                1 => const OnboardingDiabetesStep(),
                2 => const OnboardingUnitsStep(),
                _ => OnboardingConfirmStep(
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
