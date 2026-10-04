import 'package:flutter_glucosa/features/hba1c/domain/enums/hba1c_status.dart';
import 'package:flutter_glucosa/features/hba1c/domain/utils/hba1c_status_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HbA1cStatusResolver', () {
    test('resolves normal when HbA1c < 5.7%', () {
      expect(HbA1cStatusResolver.resolve(4.8), HbA1cStatus.normal);
      expect(HbA1cStatusResolver.resolve(5.69), HbA1cStatus.normal);
    });

    test('resolves elevated when HbA1c 5.7% to 6.4%', () {
      expect(HbA1cStatusResolver.resolve(5.7), HbA1cStatus.elevated);
      expect(HbA1cStatusResolver.resolve(6.0), HbA1cStatus.elevated);
      expect(HbA1cStatusResolver.resolve(6.49), HbA1cStatus.elevated);
    });

    test('resolves high when HbA1c >= 6.5%', () {
      expect(HbA1cStatusResolver.resolve(6.5), HbA1cStatus.high);
      expect(HbA1cStatusResolver.resolve(8.0), HbA1cStatus.high);
    });
  });
}
