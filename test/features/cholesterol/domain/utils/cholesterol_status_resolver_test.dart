import 'package:flutter_glucosa/features/cholesterol/domain/enums/cholesterol_status.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/utils/cholesterol_status_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CholesterolStatusResolver', () {
    test('resolves normal when total cholesterol < 200 mg/dL', () {
      expect(CholesterolStatusResolver.resolve(150), CholesterolStatus.normal);
      expect(CholesterolStatusResolver.resolve(199), CholesterolStatus.normal);
    });

    test('resolves borderline when total cholesterol 200 to 239 mg/dL', () {
      expect(
        CholesterolStatusResolver.resolve(200),
        CholesterolStatus.borderline,
      );
      expect(
        CholesterolStatusResolver.resolve(220),
        CholesterolStatus.borderline,
      );
      expect(
        CholesterolStatusResolver.resolve(239),
        CholesterolStatus.borderline,
      );
    });

    test('resolves high when total cholesterol >= 240 mg/dL', () {
      expect(CholesterolStatusResolver.resolve(240), CholesterolStatus.high);
      expect(CholesterolStatusResolver.resolve(280), CholesterolStatus.high);
    });
  });
}
