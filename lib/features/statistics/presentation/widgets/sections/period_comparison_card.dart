import 'package:flutter/material.dart';

import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/utils/glucose_converter.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_feedback_theme.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/period_comparison.dart';
import 'package:flutter_glucosa/features/statistics/domain/services/period_comparison_calculator.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

/// Card widget presenting comparative clinical analysis between rolling time windows.
class PeriodComparisonCard extends StatefulWidget {
  /// The full list of glucose readings.
  final List<GlucoseReading> readings;

  /// Preferred glucose measurement unit.
  final GlucoseUnit unit;

  /// Active clinical target range.
  final GlucoseTargetRange targetRange;

  /// Optional override for testing purposes.
  final GlucosePeriodComparisonResult? comparisonOverride;

  /// Creates a [PeriodComparisonCard].
  const PeriodComparisonCard({
    super.key,
    required this.readings,
    this.unit = GlucoseUnit.mgDl,
    this.targetRange = const GlucoseTargetRange.ada(),
    this.comparisonOverride,
  });

  @override
  State<PeriodComparisonCard> createState() => _PeriodComparisonCardState();
}

class _PeriodComparisonCardState extends State<PeriodComparisonCard> {
  int _selectedDays = 7;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inRangeColor = isDark
        ? AppFeedbackTheme.successForegroundDark
        : AppFeedbackTheme.successForegroundLight;
    final l10n = AppLocalizations.of(context);

    final comparison =
        widget.comparisonOverride ??
        PeriodComparisonCalculator.compareRollingDays(
          readings: widget.readings,
          days: _selectedDays,
          targetRange: widget.targetRange,
          locale: Localizations.localeOf(context).languageCode,
        );

    return Semantics(
      container: true,
      label:
          '${l10n?.periodComparison ?? "Period Comparison"}: $_selectedDays days',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.compare_arrows_rounded,
                    size: 24,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n?.periodComparison ?? 'Period Comparison',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  _buildPeriodSegmentedButton(cs, l10n),
                ],
              ),
              const SizedBox(height: 12),
              if (!comparison.hasComparisonData)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: cs.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n?.insufficientComparisonData ??
                              'More data needed in both periods to compare',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comparison.currentPeriod.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    Text(
                      'vs ${comparison.previousPeriod.label}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildComparisonRow(
                  context,
                  title: l10n?.meanGlucose ?? 'Mean Glucose',
                  currentVal: _formatGlucose(
                    comparison.currentPeriod.meanGlucoseMgDl,
                  ),
                  previousVal: _formatGlucose(
                    comparison.previousPeriod.meanGlucoseMgDl,
                  ),
                  delta: comparison.deltaMeanGlucose != null
                      ? _formatGlucoseDelta(comparison.deltaMeanGlucose!)
                      : null,
                  // Glucose reduction or staying closer to target is typically positive
                  isPositiveTrend: (comparison.deltaMeanGlucose ?? 0) <= 0,
                  inRangeColor: inRangeColor,
                  needsAttentionColor: cs.error,
                ),
                const Divider(height: 16),
                _buildComparisonRow(
                  context,
                  title: l10n?.timeInRangeShort ?? 'Time in Range',
                  currentVal:
                      '${(comparison.currentPeriod.tirPercentage ?? 0).toStringAsFixed(0)}%',
                  previousVal:
                      '${(comparison.previousPeriod.tirPercentage ?? 0).toStringAsFixed(0)}%',
                  delta: comparison.deltaTirPercentage != null
                      ? '${comparison.deltaTirPercentage! >= 0 ? "+" : ""}${comparison.deltaTirPercentage!.toStringAsFixed(1)}%'
                      : null,
                  isPositiveTrend: (comparison.deltaTirPercentage ?? 0) >= 0,
                  inRangeColor: inRangeColor,
                  needsAttentionColor: cs.error,
                ),
                const Divider(height: 16),
                _buildComparisonRow(
                  context,
                  title: l10n?.hypoIncidentsLabel ?? 'Hypo Events',
                  currentVal: '${comparison.currentPeriod.hypoCount}',
                  previousVal: '${comparison.previousPeriod.hypoCount}',
                  delta:
                      '${comparison.deltaHypoCount >= 0 ? "+" : ""}${comparison.deltaHypoCount}',
                  // Fewer hypos is positive
                  isPositiveTrend: comparison.deltaHypoCount <= 0,
                  inRangeColor: inRangeColor,
                  needsAttentionColor: cs.error,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSegmentedButton(ColorScheme cs, AppLocalizations? l10n) {
    return SegmentedButton<int>(
      segments: [
        ButtonSegment(value: 7, label: Text(l10n?.rollingDays7 ?? '7d')),
        ButtonSegment(value: 14, label: Text(l10n?.rollingDays14 ?? '14d')),
        ButtonSegment(value: 30, label: Text(l10n?.rollingDays30 ?? '30d')),
      ],
      selected: {_selectedDays},
      onSelectionChanged: (set) {
        setState(() => _selectedDays = set.first);
      },
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildComparisonRow(
    BuildContext context, {
    required String title,
    required String currentVal,
    required String previousVal,
    required String? delta,
    required bool isPositiveTrend,
    required Color inRangeColor,
    required Color needsAttentionColor,
  }) {
    final cs = Theme.of(context).colorScheme;
    final trendColor = isPositiveTrend ? inRangeColor : needsAttentionColor;

    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            currentVal,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            previousVal,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
          ),
        ),
        if (delta != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: trendColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              delta,
              style: TextStyle(
                color: trendColor,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
      ],
    );
  }

  String _formatGlucose(double? mgDl) {
    if (mgDl == null) return '—';
    if (widget.unit == GlucoseUnit.mmolL) {
      return '${GlucoseConverter.mgDlToMmolL(mgDl.round()).toStringAsFixed(1)} ${widget.unit.displayName}';
    }
    return '${mgDl.round()} ${widget.unit.displayName}';
  }

  String _formatGlucoseDelta(double deltaMgDl) {
    final prefix = deltaMgDl > 0 ? '+' : '';
    if (widget.unit == GlucoseUnit.mmolL) {
      final deltaMmolL = (deltaMgDl / 18.0182).toStringAsFixed(1);
      return '$prefix$deltaMmolL';
    }
    return '$prefix${deltaMgDl.round()}';
  }
}
