import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/domain/enums/glucose_range_preset.dart';
import '../../../../../core/domain/enums/glucose_unit.dart';
import '../../../../../core/domain/utils/glucose_converter.dart';
import '../../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../../l10n/app_localizations.dart';

/// Modal dialog for modifying the user's clinical blood glucose target range.
class TargetRangeDialog extends StatefulWidget {
  /// The current target range before editing.
  final GlucoseTargetRange currentRange;

  /// The active preferred blood glucose unit.
  final GlucoseUnit preferredUnit;

  /// Callback invoked with the validated new target range upon saving.
  final ValueChanged<GlucoseTargetRange> onSaved;

  /// Creates a [TargetRangeDialog].
  const TargetRangeDialog({
    super.key,
    required this.currentRange,
    required this.preferredUnit,
    required this.onSaved,
  });

  /// Displays the target range configuration dialog.
  static Future<void> show(
    BuildContext context, {
    required GlucoseTargetRange currentRange,
    required GlucoseUnit preferredUnit,
    required ValueChanged<GlucoseTargetRange> onSaved,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => TargetRangeDialog(
        currentRange: currentRange,
        preferredUnit: preferredUnit,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<TargetRangeDialog> createState() => _TargetRangeDialogState();
}

class _TargetRangeDialogState extends State<TargetRangeDialog> {
  late GlucoseRangePreset _selectedPreset;
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedPreset = widget.currentRange.preset;

    final initialMin = widget.preferredUnit == GlucoseUnit.mmolL
        ? GlucoseConverter.mgDlToMmolL(
            widget.currentRange.minMgDl,
          ).toStringAsFixed(1)
        : widget.currentRange.minMgDl.toString();

    final initialMax = widget.preferredUnit == GlucoseUnit.mmolL
        ? GlucoseConverter.mgDlToMmolL(
            widget.currentRange.maxMgDl,
          ).toStringAsFixed(1)
        : widget.currentRange.maxMgDl.toString();

    _minController = TextEditingController(text: initialMin);
    _maxController = TextEditingController(text: initialMax);
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  String _presetLabel(GlucoseRangePreset preset, AppLocalizations l10n) {
    final range = switch (preset) {
      GlucoseRangePreset.ada => const GlucoseTargetRange.ada(),
      GlucoseRangePreset.aace => const GlucoseTargetRange.aace(),
      GlucoseRangePreset.ukNice => const GlucoseTargetRange.ukNice(),
      GlucoseRangePreset.custom => null,
    };

    if (range == null) {
      return preset == GlucoseRangePreset.custom
          ? (l10n.targetRangeCustom)
          : preset.displayName;
    }

    if (widget.preferredUnit == GlucoseUnit.mmolL) {
      final minMmol = GlucoseConverter.mgDlToMmolL(
        range.minMgDl,
      ).toStringAsFixed(1);
      final maxMmol = GlucoseConverter.mgDlToMmolL(
        range.maxMgDl,
      ).toStringAsFixed(1);
      return '${preset.displayName} ($minMmol–$maxMmol mmol/L)';
    }

    return '${preset.displayName} (${range.minMgDl}–${range.maxMgDl} mg/dL)';
  }

  void _handleSave() {
    final l10n = AppLocalizations.of(context)!;

    if (_selectedPreset != GlucoseRangePreset.custom) {
      final range = switch (_selectedPreset) {
        GlucoseRangePreset.ada => const GlucoseTargetRange.ada(),
        GlucoseRangePreset.aace => const GlucoseTargetRange.aace(),
        GlucoseRangePreset.ukNice => const GlucoseTargetRange.ukNice(),
        GlucoseRangePreset.custom => const GlucoseTargetRange.ada(),
      };
      widget.onSaved(range);
      Navigator.of(context).pop();
      return;
    }

    final minParsed = double.tryParse(_minController.text.trim());
    final maxParsed = double.tryParse(_maxController.text.trim());

    if (minParsed == null ||
        maxParsed == null ||
        minParsed <= 0 ||
        minParsed >= maxParsed) {
      setState(() {
        _errorMessage = l10n.targetRangeInvalid;
      });
      return;
    }

    final int minMgDl;
    final int maxMgDl;
    if (widget.preferredUnit == GlucoseUnit.mmolL) {
      minMgDl = GlucoseConverter.mmolLToMgDl(minParsed);
      maxMgDl = GlucoseConverter.mmolLToMgDl(maxParsed);
    } else {
      minMgDl = minParsed.round();
      maxMgDl = maxParsed.round();
    }

    widget.onSaved(GlucoseTargetRange.custom(min: minMgDl, max: maxMgDl));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final unitSuffix = widget.preferredUnit.displayName;

    return AlertDialog(
      title: Text(l10n.editTargetRange),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RadioGroup<GlucoseRangePreset>(
              groupValue: _selectedPreset,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPreset = value;
                    _errorMessage = null;
                  });
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final preset in GlucoseRangePreset.values)
                    RadioListTile<GlucoseRangePreset>(
                      value: preset,
                      title: Text(_presetLabel(preset, l10n)),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
            if (_selectedPreset == GlucoseRangePreset.custom) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.targetRangeMin,
                        suffixText: unitSuffix,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _maxController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: l10n.targetRangeMax,
                        suffixText: unitSuffix,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _handleSave, child: Text(l10n.save)),
      ],
    );
  }
}
