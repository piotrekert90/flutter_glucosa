import '../entities/package_license.dart';

/// Raw license entry expressed in pure Dart.
///
/// The data layer maps platform license entries (e.g. Flutter's
/// `LicenseRegistry`) to this type so domain aggregation stays
/// testable without Flutter bindings.
class LicenseEntryData {
  /// Names of packages the entry applies to.
  final List<String> packages;

  /// License paragraph texts of the entry.
  final List<String> paragraphTexts;

  /// Creates a [LicenseEntryData].
  const LicenseEntryData({
    required this.packages,
    required this.paragraphTexts,
  });
}

/// Pure domain service aggregating raw license entries per package.
///
/// Kept out of widgets so license loading stays independently testable.
abstract final class PackageLicenseLoader {
  /// Aggregates [licenses] per package, sorted case-insensitively by name.
  static Future<List<PackageLicense>> loadLicenses({
    required Stream<LicenseEntryData> licenses,
  }) async {
    final packageMap = <String, List<String>>{};

    await for (final entry in licenses) {
      final text = entry.paragraphTexts.join('\n\n');
      for (final package in entry.packages) {
        packageMap.putIfAbsent(package, () => <String>[]).add(text);
      }
    }

    final sortedKeys = packageMap.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    return sortedKeys
        .map(
          (pkg) =>
              PackageLicense(packageName: pkg, paragraphs: packageMap[pkg]!),
        )
        .toList();
  }
}
