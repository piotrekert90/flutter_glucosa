import 'package:flutter/foundation.dart';

import '../entities/package_license.dart';

/// Pure domain service aggregating [LicenseRegistry] entries per package.
///
/// Kept out of widgets so license loading stays independently testable.
abstract final class PackageLicenseLoader {
  /// Loads all package licenses sorted case-insensitively by package name.
  static Future<List<PackageLicense>> loadLicenses() async {
    final packageMap = <String, List<String>>{};

    await for (final entry in LicenseRegistry.licenses) {
      final text = entry.paragraphs.map((p) => p.text).join('\n\n');
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
