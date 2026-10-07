import 'package:intl/intl.dart';

import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/utils/glucose_converter.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/statistics/domain/services/period_comparison_calculator.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/period_range_label.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

/// Formatter generating a structured, clinical summary text for doctor sharing and patient consultations.
class ProgressSummaryFormatter {
  const ProgressSummaryFormatter._();

  /// Formats a complete clinical progress summary.
  static String format({
    required List<GlucoseReading> readings,
    required UserProfile profile,
    required AppLocalizations l10n,
    int windowDays = 14,
    DateTime? now,
  }) {
    if (readings.isEmpty) return '';

    final referenceDate = now ?? DateTime.now();
    final unit = profile.preferredGlucoseUnit;
    final targetRange = profile.targetRange;

    final comparison = PeriodComparisonCalculator.compareRollingDays(
      readings: readings,
      days: windowDays,
      targetRange: targetRange,
      now: referenceDate,
    );

    final summary = comparison.currentPeriod;
    if (summary.readingCount == 0) return '';

    final buffer = StringBuffer();
    buffer.writeln('📋 ${l10n.doctorSummaryTitle}');
    buffer.writeln(
      '📅 ${DateFormat.yMMMMd(l10n.localeName).format(referenceDate)}',
    );

    if (profile.name.isNotEmpty) {
      buffer.writeln('👤 ${l10n.doctorSummaryPatientName}: ${profile.name}');
    }

    final targetMinStr = _formatValue(targetRange.minMgDl, unit);
    final targetMaxStr = _formatValue(targetRange.maxMgDl, unit);
    buffer.writeln(
      '🎯 ${l10n.doctorSummaryTargetRangeLabel}: $targetMinStr – $targetMaxStr ${unit.displayName} (${targetRange.preset.displayName})',
    );
    final periodLabel = PeriodRangeLabel.format(
      start: summary.start,
      end: summary.end,
      locale: l10n.localeName,
    );
    buffer.writeln('⏱️ ${l10n.doctorSummaryPeriod(periodLabel, windowDays)}');
    buffer.writeln('');

    // Glucose Metrics
    final meanMgDl = summary.meanGlucoseMgDl ?? 0.0;
    final meanStr = _formatValue(meanMgDl.round(), unit);
    buffer.writeln(
      '🩸 ${l10n.doctorSummaryMeanGlucose}: $meanStr ${unit.displayName}',
    );

    // Estimated HbA1c (Nathan formula)
    final estimatedA1c = (meanMgDl + 46.7) / 28.7;
    buffer.writeln(
      '🔬 ${l10n.doctorSummaryEstimatedHbA1c}: ${estimatedA1c.toStringAsFixed(1)}%',
    );

    if (summary.glucoseSd != null) {
      final sdStr = unit == GlucoseUnit.mmolL
          ? GlucoseConverter.mgDlToMmolL(
              summary.glucoseSd!.round(),
            ).toStringAsFixed(1)
          : summary.glucoseSd!.toStringAsFixed(0);
      buffer.writeln(
        '📈 ${l10n.doctorSummaryVariability}: ±$sdStr ${unit.displayName}',
      );
    }

    buffer.writeln('');

    // TIR Breakdown
    buffer.writeln('📊 ${l10n.doctorSummaryTirBreakdown}:');
    buffer.writeln(
      '  • ${l10n.doctorSummaryInTarget}: ${(summary.tirPercentage ?? 0).toStringAsFixed(1)}%',
    );
    buffer.writeln(
      '  • ${l10n.doctorSummaryAboveTarget}: ${(summary.tarPercentage ?? 0).toStringAsFixed(1)}%',
    );
    buffer.writeln(
      '  • ${l10n.doctorSummaryBelowTarget}: ${(summary.tbrPercentage ?? 0).toStringAsFixed(1)}%',
    );

    buffer.writeln('');
    buffer.writeln(
      '📝 ${l10n.doctorSummaryTotalReadings}: ${summary.readingCount}',
    );
    buffer.writeln(
      '⚠️ ${l10n.doctorSummaryHypoIncidents}: ${summary.hypoCount}',
    );

    return buffer.toString().trimRight();
  }

  static String _formatValue(int mgDl, GlucoseUnit unit) {
    if (unit == GlucoseUnit.mmolL) {
      return GlucoseConverter.mgDlToMmolL(mgDl).toStringAsFixed(1);
    }
    return mgDl.toString();
  }
}
