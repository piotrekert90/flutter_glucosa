import 'dart:math' as math;

import '../enums/glucose_status.dart';
import '../value_objects/glucose_target_range.dart';

/// Pure Dart utility resolving clinical glucose status from a reading and target thresholds.
abstract final class GlucoseStatusResolver {
  /// ADA/EASD consensus threshold for Level 2 (clinically significant) hypoglycemia (< 54 mg/dL).
  static const int severeHypoglycemiaThresholdMgDl = 54;

  /// ADA/EASD consensus threshold for Level 2 (severe) hyperglycemia (> 250 mg/dL).
  static const int severeHyperglycemiaThresholdMgDl = 250;

  /// Evaluates a blood glucose [readingMgDl] against clinical boundaries.
  ///
  /// Uses absolute clinical thresholds per ADA/EASD consensus:
  /// - [GlucoseStatus.hypoglycemia]: < 54 mg/dL (Level 2 clinically significant)
  /// - [GlucoseStatus.low]: >= 54 mg/dL and < [rangeMin] (Level 1 / below target)
  /// - [GlucoseStatus.inRange]: >= [rangeMin] and <= [rangeMax]
  /// - [GlucoseStatus.high]: > [rangeMax] and <= 250 mg/dL (Level 1 / above target)
  /// - [GlucoseStatus.hyperglycemia]: > 250 mg/dL (Level 2 / severe hyperglycemia)
  ///
  /// [readingMgDl] Blood glucose concentration in mg/dL.
  /// [rangeMin] Lower bound of the target range in mg/dL.
  /// [rangeMax] Upper bound of the target range in mg/dL.
  static GlucoseStatus resolveFromBounds({
    required int readingMgDl,
    required int rangeMin,
    required int rangeMax,
  }) {
    if (readingMgDl < math.min(severeHypoglycemiaThresholdMgDl, rangeMin)) {
      return GlucoseStatus.hypoglycemia;
    }
    if (readingMgDl < rangeMin) {
      return GlucoseStatus.low;
    }
    if (readingMgDl <= rangeMax) {
      return GlucoseStatus.inRange;
    }
    if (readingMgDl <= math.max(severeHyperglycemiaThresholdMgDl, rangeMax)) {
      return GlucoseStatus.high;
    }
    return GlucoseStatus.hyperglycemia;
  }

  /// Evaluates a blood glucose [readingMgDl] against a [targetRange].
  ///
  /// [readingMgDl] Blood glucose concentration in mg/dL.
  /// [targetRange] The clinical target range containing lower and upper limits.
  static GlucoseStatus resolve({
    required int readingMgDl,
    required GlucoseTargetRange targetRange,
  }) {
    return resolveFromBounds(
      readingMgDl: readingMgDl,
      rangeMin: targetRange.minMgDl,
      rangeMax: targetRange.maxMgDl,
    );
  }
}
