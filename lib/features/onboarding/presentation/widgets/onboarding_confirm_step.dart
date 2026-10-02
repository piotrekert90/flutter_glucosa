import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../extensions/diabetes_type_l10n.dart';
import '../providers/onboarding_notifier.dart';

/// Final onboarding step summarizing the draft profile before saving.
class OnboardingConfirmStep extends ConsumerStatefulWidget {
  /// Callback invoked after the profile is saved successfully.
  final VoidCallback onCompleted;

  /// Creates an [OnboardingConfirmStep].
  const OnboardingConfirmStep({super.key, required this.onCompleted});

  @override
  ConsumerState<OnboardingConfirmStep> createState() =>
      _OnboardingConfirmStepState();
}

class _OnboardingConfirmStepState extends ConsumerState<OnboardingConfirmStep> {
  bool _isSaving = false;

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final (success, failure) = await ref
        .read(onboardingProvider.notifier)
        .complete();
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      widget.onCompleted();
    } else {
      AppSnackBar.show(
        context,
        message: failure?.message ?? 'Failed to save profile',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.check_circle_outlined,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n?.onboardingConfirmTitle ?? "You're all set!",
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: Text(draft.name.isEmpty ? '—' : draft.name),
                ),
                ListTile(
                  leading: const Icon(Icons.medical_information_outlined),
                  title: Text(draft.diabetesType.label(l10n)),
                ),
                ListTile(
                  leading: const Icon(Icons.water_drop_outlined),
                  title: Text(draft.glucoseUnit.displayName),
                ),
                ListTile(
                  leading: const Icon(Icons.track_changes_outlined),
                  title: Text(draft.rangePreset.displayName),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(l10n?.onboardingGetStarted ?? 'Get Started'),
          ),
        ],
      ),
    );
  }
}
