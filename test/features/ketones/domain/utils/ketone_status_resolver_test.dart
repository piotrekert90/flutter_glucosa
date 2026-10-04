import 'package:flutter_glucosa/features/ketones/domain/enums/ketone_status.dart';
import 'package:flutter_glucosa/features/ketones/domain/utils/ketone_status_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KetoneStatusResolver', () {
    test('resolves normal when ketones < 0.6 mmol/L', () {
      expect(KetoneStatusResolver.resolve(0.2), KetoneStatus.normal);
      expect(KetoneStatusResolver.resolve(0.59), KetoneStatus.normal);
    });

    test('resolves elevated when ketones 0.6 to 1.5 mmol/L', () {
      expect(KetoneStatusResolver.resolve(0.6), KetoneStatus.elevated);
      expect(KetoneStatusResolver.resolve(1.0), KetoneStatus.elevated);
      expect(KetoneStatusResolver.resolve(1.5), KetoneStatus.elevated);
    });

    test('resolves high when ketones > 1.5 mmol/L', () {
      expect(KetoneStatusResolver.resolve(1.51), KetoneStatus.high);
      expect(KetoneStatusResolver.resolve(3.0), KetoneStatus.high);
    });
  });
}
