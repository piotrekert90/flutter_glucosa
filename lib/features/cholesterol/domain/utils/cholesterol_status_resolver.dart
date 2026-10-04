import '../enums/cholesterol_status.dart';

/// Pure Dart utility resolving clinical cholesterol categories according to NCEP ATP III guidelines.
abstract final class CholesterolStatusResolver {
  /// Evaluates total cholesterol status from [totalMgDl].
  ///
  /// - [CholesterolStatus.normal]: < 200 mg/dL
  /// - [CholesterolStatus.borderline]: 200–239 mg/dL
  /// - [CholesterolStatus.high]: >= 240 mg/dL
  static CholesterolStatus resolve(int totalMgDl) {
    if (totalMgDl < 200) {
      return CholesterolStatus.normal;
    }
    if (totalMgDl < 240) {
      return CholesterolStatus.borderline;
    }
    return CholesterolStatus.high;
  }
}
