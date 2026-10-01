import '../enums/glucose_status.dart';
import '../value_objects/glucose_target_range.dart';

/// Pure Dart utility resolving clinical glucose status from a reading and target thresholds.
abstract final class GlucoseStatusResolver {
  /// Evaluates a blood glucose [readingMgDl] against clinical boundaries.
  ///
  /// [readingMgDl] Blood glucose concentration in mg/dL.
  /// [rangeMin] Lower bound of the target range in mg/dL.
  /// [rangeMax] Upper bound of the target range in mg/dL.
  static GlucoseStatus resolveFromBounds({
    required int readingMgDl,
    required int rangeMin,
    required int rangeMax,
  }) {
    if (readingMgDl < rangeMin - 15) {
      return GlucoseStatus.hypoglycemia;
    }
    if (readingMgDl < rangeMin) {
      return GlucoseStatus.low;
    }
    if (readingMgDl <= rangeMax) {
      return GlucoseStatus.inRange;
    }
    if (readingMgDl <= rangeMax + 40) {
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
