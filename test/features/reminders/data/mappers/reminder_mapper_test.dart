import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/features/reminders/data/mappers/reminder_mapper.dart';
import 'package:flutter_glucosa/features/reminders/data/models/reminder_model.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  group('ReminderMapper', () {
    test('toModel converts entity with existing id', () {
      const entity = Reminder(
        id: 7,
        label: 'Evening Insulin',
        metricType: MetricType.glucose,
        hourOfDay: 20,
        minute: 15,
        isActive: true,
        isOneTime: false,
      );

      final model = entity.toModel();

      expect(model.id, equals(7));
      expect(model.label, equals('Evening Insulin'));
      expect(model.metricType, equals('glucose'));
      expect(model.hourOfDay, equals(20));
      expect(model.minute, equals(15));
      expect(model.isActive, isTrue);
      expect(model.isOneTime, isFalse);
    });

    test('toModel converts entity with id 0 to Isar.autoIncrement', () {
      const entity = Reminder(
        id: 0,
        label: 'BP Check',
        metricType: MetricType.bloodPressure,
        hourOfDay: 8,
        minute: 0,
        isActive: false,
        isOneTime: true,
      );

      final model = entity.toModel();

      expect(model.id, equals(Isar.autoIncrement));
      expect(model.label, equals('BP Check'));
      expect(model.metricType, equals('bloodPressure'));
      expect(model.hourOfDay, equals(8));
      expect(model.minute, equals(0));
      expect(model.isActive, isFalse);
      expect(model.isOneTime, isTrue);
    });

    test('toDomain converts model to entity correctly', () {
      final model = ReminderModel()
        ..id = 15
        ..label = 'Weight check'
        ..metricType = 'weight'
        ..hourOfDay = 7
        ..minute = 45
        ..isActive = true
        ..isOneTime = false;

      final entity = model.toDomain();

      expect(entity.id, equals(15));
      expect(entity.label, equals('Weight check'));
      expect(entity.metricType, equals(MetricType.weight));
      expect(entity.hourOfDay, equals(7));
      expect(entity.minute, equals(45));
      expect(entity.isActive, isTrue);
      expect(entity.isOneTime, isFalse);
    });

    test(
      'toDomain falls back to MetricType.glucose for unknown metricType',
      () {
        final model = ReminderModel()
          ..id = 3
          ..label = 'Unknown'
          ..metricType = 'nonExistentMetric'
          ..hourOfDay = 12
          ..minute = 0
          ..isActive = true
          ..isOneTime = false;

        final entity = model.toDomain();

        expect(entity.metricType, equals(MetricType.glucose));
      },
    );
  });
}
