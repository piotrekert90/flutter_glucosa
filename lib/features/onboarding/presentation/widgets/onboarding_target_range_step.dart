import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// Fourth onboarding step selecting the clinical blood glucose target range.
class OnboardingTargetRangeStep extends ConsumerWidget {
  /// Creates an [OnboardingTargetRangeStep].
  const OnboardingTargetRangeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final draft = ref.watch(onboardingProvider);

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
            l10n.onboardingRangeTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingRangeSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          for (final preset in presets)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ChoiceChip(
                label: SizedBox(
                  width: double.infinity,
                  child: Text(
                    _presetLabel(
                      preset,
                      GlucoseTargetRange.fromPreset(preset),
                      draft.glucoseUnit,
                      l10n,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                selected: draft.rangePreset == preset,
                onSelected: (_) => ref
                    .read(onboardingProvider.notifier)
                    .selectRangePreset(preset),
              ),
            ),
        ],
      ),
    );
  }
}

/// Formats a preset chip label with unit-aware bounds.
String _presetLabel(
  GlucoseRangePreset preset,
  GlucoseTargetRange range,
  GlucoseUnit unit,
  AppLocalizations l10n,
) {
  if (unit == GlucoseUnit.mmolL) {
    final min = GlucoseConverter.mgDlToMmolL(range.minMgDl).toStringAsFixed(1);
    final max = GlucoseConverter.mgDlToMmolL(range.maxMgDl).toStringAsFixed(1);
    return l10n.targetRangePresetOption(
      preset.displayName,
      min,
      max,
      unit.displayName,
    );
  }
  return l10n.targetRangePresetOption(
    preset.displayName,
    range.minMgDl.toString(),
    range.maxMgDl.toString(),
    unit.displayName,
  );
}
