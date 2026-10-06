import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/utils/decimal_parser.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/domain/utils/reading_validator.dart';
import '../../../../l10n/app_localizations.dart';
import '../extensions/diabetes_type_l10n.dart';
import '../providers/onboarding_notifier.dart';

/// Second onboarding step selecting the diagnosed diabetes type with an
/// optional baseline glucose measurement.
class OnboardingDiabetesStep extends ConsumerStatefulWidget {
  /// Creates an [OnboardingDiabetesStep].
  const OnboardingDiabetesStep({super.key});

  @override
  ConsumerState<OnboardingDiabetesStep> createState() =>
      _OnboardingDiabetesStepState();
}

class _OnboardingDiabetesStepState
    extends ConsumerState<OnboardingDiabetesStep> {
  final _baselineController = TextEditingController();
  String? _baselineError;

  @override
  void dispose() {
    _baselineController.dispose();
    super.dispose();
  }

  /// Parses the baseline input in the draft unit and stores mg/dL.
  void _onBaselineChanged(String raw) {
    final notifier = ref.read(onboardingProvider.notifier);
    final draft = ref.read(onboardingProvider);
    final value = DecimalParser.parse(raw);
    final isMmolL = draft.glucoseUnit == GlucoseUnit.mmolL;
    final valid =
        value != null &&
        (isMmolL
            ? ReadingValidator.isValidGlucoseMmolL(value)
            : ReadingValidator.isValidGlucoseMgDl(value));
    if (!valid) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _baselineError = value == null && raw.trim().isEmpty
            ? null
            : l10n.onboardingBaselineInvalid;
      });
      notifier.updateBaselineMgDl(null);
      return;
    }
    setState(() => _baselineError = null);
    notifier.updateBaselineMgDl(
      isMmolL ? GlucoseConverter.mmolLToMgDl(value) : value.round(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            l10n.onboardingDiabetesTypeTitle,
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
                onSelected: (_) => ref
                    .read(onboardingProvider.notifier)
                    .selectDiabetesType(type),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            l10n.onboardingBaselineLabel,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _baselineController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
            ],
            decoration: InputDecoration(
              hintText: draft.glucoseUnit == GlucoseUnit.mmolL
                  ? l10n.onboardingBaselineHintMmolL
                  : l10n.onboardingBaselineHintMgDl,
              errorText: _baselineError,
              border: const OutlineInputBorder(),
            ),
            onChanged: _onBaselineChanged,
          ),
        ],
      ),
    );
  }
}
