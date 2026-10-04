import '../enums/hba1c_status.dart';

/// Pure Dart utility resolving clinical HbA1c categories per ADA diagnostic criteria.
abstract final class HbA1cStatusResolver {
  /// Evaluates clinical HbA1c status from [percentage].
  ///
  /// - [HbA1cStatus.normal]: < 5.7%
  /// - [HbA1cStatus.elevated]: 5.7%–6.4%
  /// - [HbA1cStatus.high]: >= 6.5%
  static HbA1cStatus resolve(double percentage) {
    if (percentage < 5.7) {
      return HbA1cStatus.normal;
    }
    if (percentage < 6.5) {
      return HbA1cStatus.elevated;
    }
    return HbA1cStatus.high;
  }
}
