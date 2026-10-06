import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/presentation/widgets/pill_segmented_control.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// Third onboarding step selecting the preferred glucose unit.
class OnboardingUnitsStep extends ConsumerWidget {
  /// Creates an [OnboardingUnitsStep].
  const OnboardingUnitsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final draft = ref.watch(onboardingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            l10n.onboardingUnitsTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingGlucoseUnitLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          PillSegmentedControl<GlucoseUnit>(
            segments: [
              PillSegment(
                value: GlucoseUnit.mgDl,
                label: GlucoseUnit.mgDl.displayName,
              ),
              PillSegment(
                value: GlucoseUnit.mmolL,
                label: GlucoseUnit.mmolL.displayName,
              ),
            ],
            selected: draft.glucoseUnit,
            onChanged: (unit) =>
                ref.read(onboardingProvider.notifier).selectGlucoseUnit(unit),
          ),
        ],
      ),
    );
  }
}
