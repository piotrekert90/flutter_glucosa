import 'package:flutter/foundation.dart';

import '../../domain/services/package_license_loader.dart';

/// Data-layer bridge exposing Flutter's [LicenseRegistry] as pure domain data.
///
/// Keeps `flutter/foundation.dart` out of the domain layer: widgets consume
/// this stream via [watchLicenses] and pass it to [PackageLicenseLoader].
abstract final class LicenseRegistrySource {
  /// Streams raw license entries from the platform license registry.
  static Stream<LicenseEntryData> watchLicenses() async* {
    await for (final entry in LicenseRegistry.licenses) {
      yield LicenseEntryData(
        packages: entry.packages.toList(),
        paragraphTexts: entry.paragraphs.map((p) => p.text).toList(),
      );
    }
  }
}
