import 'package:flutter_glucosa/features/settings/domain/services/package_license_loader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PackageLicenseLoader', () {
    test('aggregates entries per package sorted case-insensitively', () async {
      final licenses = await PackageLicenseLoader.loadLicenses(
        licenses: Stream.fromIterable([
          const LicenseEntryData(
            packages: ['b_pkg'],
            paragraphTexts: ['text one', 'text two'],
          ),
          const LicenseEntryData(
            packages: ['A_pkg', 'b_pkg'],
            paragraphTexts: ['shared'],
          ),
        ]),
      );

      expect(licenses.map((l) => l.packageName), ['A_pkg', 'b_pkg']);
      expect(licenses.firstWhere((l) => l.packageName == 'b_pkg').paragraphs, [
        'text one\n\ntext two',
        'shared',
      ]);
    });

    test('returns empty list when stream is empty', () async {
      final licenses = await PackageLicenseLoader.loadLicenses(
        licenses: const Stream.empty(),
      );

      expect(licenses, isEmpty);
    });
  });
}
