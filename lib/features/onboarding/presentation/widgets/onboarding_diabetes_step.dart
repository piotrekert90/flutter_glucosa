import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../l10n/app_localizations.dart';
import '../extensions/diabetes_type_l10n.dart';
import '../providers/onboarding_notifier.dart';

/// Second onboarding step selecting the diagnosed diabetes type.
class OnboardingDiabetesStep extends ConsumerWidget {
  /// Creates an [OnboardingDiabetesStep].
  const OnboardingDiabetesStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            l10n?.onboardingDiabetesTypeTitle ??
                'Which type of diabetes do you have?',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          for (final type in DiabetesType.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ChoiceChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(type.label(l10n), textAlign: TextAlign.center),
                ),
                selected: draft.diabetesType == type,
                onSelected: (_) => notifier.selectDiabetesType(type),
              ),
            ),
        ],
      ),
    );
  }
}
