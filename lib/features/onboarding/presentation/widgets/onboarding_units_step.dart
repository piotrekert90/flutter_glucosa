import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// Third onboarding step selecting the preferred glucose unit.
class OnboardingUnitsStep extends ConsumerWidget {
  /// Creates an [OnboardingUnitsStep].
  const OnboardingUnitsStep({super.key});

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
            l10n?.onboardingUnitsTitle ?? 'Preferred glucose unit',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n?.onboardingGlucoseUnitLabel ?? 'Glucose unit',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<GlucoseUnit>(
            segments: const [
              ButtonSegment(value: GlucoseUnit.mgDl, label: Text('mg/dL')),
              ButtonSegment(value: GlucoseUnit.mmolL, label: Text('mmol/L')),
            ],
            selected: {draft.glucoseUnit},
            onSelectionChanged: (selection) =>
                notifier.selectGlucoseUnit(selection.first),
          ),
        ],
      ),
    );
  }
}
