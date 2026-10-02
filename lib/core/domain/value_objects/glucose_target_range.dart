import 'package:flutter_glucosa/core/domain/enums/glucose_range_preset.dart';

/// Immutable value object defining lower and upper blood glucose target limits in mg/dL.
class GlucoseTargetRange {
  /// Clinical preset classification associated with this range.
  final GlucoseRangePreset preset;

  /// Lower bound concentration in mg/dL.
  final int minMgDl;

  /// Upper bound concentration in mg/dL.
  final int maxMgDl;

  /// Creates a target range with explicit thresholds.
  const GlucoseTargetRange({
    required this.preset,
    required this.minMgDl,
    required this.maxMgDl,
  });

  /// American Diabetes Association default target range (70–180 mg/dL).
  const GlucoseTargetRange.ada()
    : preset = GlucoseRangePreset.ada,
      minMgDl = 70,
      maxMgDl = 180;

  /// American Association of Clinical Endocrinologists target range (110–140 mg/dL).
  const GlucoseTargetRange.aace()
    : preset = GlucoseRangePreset.aace,
      minMgDl = 110,
      maxMgDl = 140;

  /// UK NICE guidelines target range (72–153 mg/dL).
  const GlucoseTargetRange.ukNice()
    : preset = GlucoseRangePreset.ukNice,
      minMgDl = 72,
      maxMgDl = 153;

  /// User-defined customized target thresholds.
  const GlucoseTargetRange.custom({required int min, required int max})
    : preset = GlucoseRangePreset.custom,
      minMgDl = min,
      maxMgDl = max;

  /// Returns a copy of this range with optional updated values.
  GlucoseTargetRange copyWith({
    GlucoseRangePreset? preset,
    int? minMgDl,
    int? maxMgDl,
  }) {
    return GlucoseTargetRange(
      preset: preset ?? this.preset,
      minMgDl: minMgDl ?? this.minMgDl,
      maxMgDl: maxMgDl ?? this.maxMgDl,
    );
  }

  /// Checks whether a given blood glucose concentration in mg/dL falls within this target range.
  bool isInRange(int mgDl) => mgDl >= minMgDl && mgDl <= maxMgDl;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GlucoseTargetRange &&
        other.preset == preset &&
        other.minMgDl == minMgDl &&
        other.maxMgDl == maxMgDl;
  }

  @override
  int get hashCode => Object.hash(preset, minMgDl, maxMgDl);

  @override
  String toString() =>
      'GlucoseTargetRange(preset: ${preset.name}, min: $minMgDl, max: $maxMgDl)';
}
