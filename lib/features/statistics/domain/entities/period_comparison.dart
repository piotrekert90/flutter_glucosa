/// Summary metrics for glucose control in a discrete time period.
class GlucosePeriodSummary {
  /// Arithmetic mean of glucose readings in mg/dL, or null if empty.
  final double? meanGlucoseMgDl;

  /// Standard deviation of glucose readings in mg/dL, or null if fewer than 2 entries.
  final double? glucoseSd;

  /// Percentage of readings falling within the target range (0-100).
  final double? tirPercentage;

  /// Percentage of readings above the target range (Time Above Range / Hyper).
  final double? tarPercentage;

  /// Percentage of readings below the target range (Time Below Range / Hypo).
  final double? tbrPercentage;

  /// Total count of glucose readings recorded in this period.
  final int readingCount;

  /// Count of readings identified as hypoglycemic (< 70 mg/dL or range minimum).
  final int hypoCount;

  /// Count of readings identified as hyperglycemic (> 180 mg/dL or range maximum).
  final int hyperCount;

  /// Human-readable date range label (e.g. "Sep 24 – Oct 1").
  final String label;

  /// Creates a [GlucosePeriodSummary].
  const GlucosePeriodSummary({
    required this.meanGlucoseMgDl,
    required this.glucoseSd,
    required this.tirPercentage,
    required this.tarPercentage,
    required this.tbrPercentage,
    required this.readingCount,
    required this.hypoCount,
    required this.hyperCount,
    required this.label,
  });
}

/// Comparative result between two adjacent glucose tracking periods.
class GlucosePeriodComparisonResult {
  /// Metrics for the current active period.
  final GlucosePeriodSummary currentPeriod;

  /// Metrics for the baseline comparison period.
  final GlucosePeriodSummary previousPeriod;

  /// Difference in mean glucose in mg/dL (`current - previous`).
  final double? deltaMeanGlucose;

  /// Difference in glucose standard deviation (`current - previous`).
  final double? deltaGlucoseSd;

  /// Difference in Time in Range percentage points (`current - previous`).
  final double? deltaTirPercentage;

  /// Difference in number of logged readings (`current - previous`).
  final int deltaReadingCount;

  /// Difference in count of hypoglycemic readings (`current - previous`).
  final int deltaHypoCount;

  /// Whether both periods contain at least one reading for meaningful comparison.
  final bool hasComparisonData;

  /// Creates a [GlucosePeriodComparisonResult].
  const GlucosePeriodComparisonResult({
    required this.currentPeriod,
    required this.previousPeriod,
    required this.deltaMeanGlucose,
    required this.deltaGlucoseSd,
    required this.deltaTirPercentage,
    required this.deltaReadingCount,
    required this.deltaHypoCount,
    required this.hasComparisonData,
  });
}
