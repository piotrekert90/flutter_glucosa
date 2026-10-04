import '../enums/ketone_status.dart';

/// Pure Dart utility resolving clinical ketone categories from blood beta-hydroxybutyrate readings.
abstract final class KetoneStatusResolver {
  /// Evaluates ketone status from [readingMmolL].
  ///
  /// - [KetoneStatus.normal]: < 0.6 mmol/L
  /// - [KetoneStatus.elevated]: 0.6–1.5 mmol/L
  /// - [KetoneStatus.high]: > 1.5 mmol/L
  static KetoneStatus resolve(double readingMmolL) {
    if (readingMmolL < 0.6) {
      return KetoneStatus.normal;
    }
    if (readingMmolL <= 1.5) {
      return KetoneStatus.elevated;
    }
    return KetoneStatus.high;
  }
}
