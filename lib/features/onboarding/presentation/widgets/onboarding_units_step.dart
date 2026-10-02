import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// Third onboarding step selecting the preferred glucose unit and target range preset.
class OnboardingUnitsStep extends ConsumerWidget {
  /// Creates an [OnboardingUnitsStep].
  const OnboardingUnitsStep({super.key});

  /// Resolves clinical bounds for selectable presets.
  GlucoseTargetRange _rangeFor(GlucoseRangePreset preset) {
    return switch (preset) {
      GlucoseRangePreset.ada => const GlucoseTargetRange.ada(),
      GlucoseRangePreset.aace => const GlucoseTargetRange.aace(),
      GlucoseRangePreset.ukNice => const GlucoseTargetRange.ukNice(),
      GlucoseRangePreset.custom => const GlucoseTargetRange.ada(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(onboardingProvider);
    final notifier = ref.read(onboardingProvider.notifier);

    const presets = [
      GlucoseRangePreset.ada,
      GlucoseRangePreset.aace,
      GlucoseRangePreset.ukNice,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            l10n?.onboardingUnitsTitle ?? 'Preferred units and target range',
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
          const SizedBox(height: 24),
          Text(
            l10n?.onboardingRangeLabel ?? 'Target range',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (final preset in presets)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ChoiceChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '${preset.displayName} '
                    '(${_rangeFor(preset).minMgDl}–${_rangeFor(preset).maxMgDl} mg/dL)',
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: draft.rangePreset == preset,
                onSelected: (_) => notifier.selectRangePreset(preset),
              ),
            ),
        ],
      ),
    );
  }
}
