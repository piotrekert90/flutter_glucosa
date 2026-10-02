import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Reminder', () {
    test('creates valid instance with default values', () {
      const reminder = Reminder(
        label: 'Morning Glucose',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 30,
      );

      expect(reminder.id, equals(0));
      expect(reminder.label, equals('Morning Glucose'));
      expect(reminder.metricType, equals(MetricType.glucose));
      expect(reminder.hourOfDay, equals(8));
      expect(reminder.minute, equals(30));
      expect(reminder.isActive, isTrue);
      expect(reminder.isOneTime, isFalse);
    });

    test('copyWith updates specified fields and keeps unspecified', () {
      const reminder = Reminder(
        id: 1,
        label: 'Morning Glucose',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 30,
        isActive: true,
        isOneTime: false,
      );

      final updated = reminder.copyWith(
        label: 'Evening Glucose',
        hourOfDay: 20,
        minute: 0,
        isActive: false,
        isOneTime: true,
      );

      expect(updated.id, equals(1));
      expect(updated.label, equals('Evening Glucose'));
      expect(updated.metricType, equals(MetricType.glucose));
      expect(updated.hourOfDay, equals(20));
      expect(updated.minute, equals(0));
      expect(updated.isActive, isFalse);
      expect(updated.isOneTime, isTrue);
    });

    test('equality and hashCode verify identical instances', () {
      const r1 = Reminder(
        id: 1,
        label: 'Check BP',
        metricType: MetricType.bloodPressure,
        hourOfDay: 9,
        minute: 15,
        isActive: true,
        isOneTime: false,
      );
      const r2 = Reminder(
        id: 1,
        label: 'Check BP',
        metricType: MetricType.bloodPressure,
        hourOfDay: 9,
        minute: 15,
        isActive: true,
        isOneTime: false,
      );
      const r3 = Reminder(
        id: 2,
        label: 'Check BP',
        metricType: MetricType.bloodPressure,
        hourOfDay: 9,
        minute: 15,
        isActive: true,
        isOneTime: false,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1, isNot(equals(r3)));
    });

    test('toString includes formatted fields and time HH:mm', () {
      const reminder = Reminder(
        id: 10,
        label: 'Weight check',
        metricType: MetricType.weight,
        hourOfDay: 7,
        minute: 5,
        isActive: true,
        isOneTime: false,
      );

      expect(
        reminder.toString(),
        equals(
          'Reminder(id: 10, label: Weight check, metricType: weight, time: 07:05, isActive: true, isOneTime: false)',
        ),
      );
    });
  });
}
