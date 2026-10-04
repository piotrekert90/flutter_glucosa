import 'package:flutter_glucosa/features/blood_pressure/domain/enums/blood_pressure_status.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/utils/blood_pressure_status_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BloodPressureStatusResolver', () {
    test('resolves normal when systolic < 120 and diastolic < 80', () {
      expect(
        BloodPressureStatusResolver.resolve(
          systolicMmHg: 118,
          diastolicMmHg: 76,
        ),
        BloodPressureStatus.normal,
      );
      expect(
        BloodPressureStatusResolver.resolve(
          systolicMmHg: 90,
          diastolicMmHg: 60,
        ),
        BloodPressureStatus.normal,
      );
    });

    test('resolves elevated when systolic 120-129 and diastolic < 80', () {
      expect(
        BloodPressureStatusResolver.resolve(
          systolicMmHg: 120,
          diastolicMmHg: 79,
        ),
        BloodPressureStatus.elevated,
      );
      expect(
        BloodPressureStatusResolver.resolve(
          systolicMmHg: 129,
          diastolicMmHg: 75,
        ),
        BloodPressureStatus.elevated,
      );
    });

    test('resolves high when systolic >= 130 or diastolic >= 80', () {
      // Systolic high, diastolic normal
      expect(
        BloodPressureStatusResolver.resolve(
          systolicMmHg: 130,
          diastolicMmHg: 75,
        ),
        BloodPressureStatus.high,
      );
      // Systolic normal, diastolic high
      expect(
        BloodPressureStatusResolver.resolve(
          systolicMmHg: 115,
          diastolicMmHg: 80,
        ),
        BloodPressureStatus.high,
      );
      // Both high
      expect(
        BloodPressureStatusResolver.resolve(
          systolicMmHg: 145,
          diastolicMmHg: 95,
        ),
        BloodPressureStatus.high,
      );
    });
  });
}
