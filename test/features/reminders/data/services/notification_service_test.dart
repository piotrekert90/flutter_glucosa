import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/features/reminders/data/services/notification_service_impl.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_notification_service.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  group('FakeNotificationService', () {
    late FakeNotificationService service;

    setUp(() {
      service = FakeNotificationService();
    });

    test(
      'scheduleReminder tracks active reminders and replaces existing',
      () async {
        const r1 = Reminder(
          id: 1,
          label: 'Morning Glucose',
          metricType: MetricType.glucose,
          hourOfDay: 8,
          minute: 0,
          isActive: true,
        );

        await service.scheduleReminder(r1);
        expect(service.scheduledReminders, contains(r1));

        final updatedR1 = r1.copyWith(label: 'Updated Label');
        await service.scheduleReminder(updatedR1);
        expect(service.scheduledReminders.length, equals(1));
        expect(service.scheduledReminders.first.label, equals('Updated Label'));
      },
    );

    test('scheduleReminder removes reminder when inactive', () async {
      const r1 = Reminder(
        id: 1,
        label: 'Morning Glucose',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
        isActive: true,
      );

      await service.scheduleReminder(r1);
      expect(service.scheduledReminders.length, equals(1));

      final inactive = r1.copyWith(isActive: false);
      await service.scheduleReminder(inactive);
      expect(service.scheduledReminders, isEmpty);
    });

    test('cancelReminder removes reminder and records id', () async {
      const r1 = Reminder(
        id: 2,
        label: 'BP Check',
        metricType: MetricType.bloodPressure,
        hourOfDay: 14,
        minute: 30,
        isActive: true,
      );

      await service.scheduleReminder(r1);
      await service.cancelReminder(2);

      expect(service.scheduledReminders, isEmpty);
      expect(service.cancelledReminderIds, contains(2));
    });

    test('cancelAll clears all reminders and sets flag', () async {
      const r1 = Reminder(
        id: 1,
        label: 'Test 1',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
      );
      const r2 = Reminder(
        id: 2,
        label: 'Test 2',
        metricType: MetricType.weight,
        hourOfDay: 9,
        minute: 0,
      );

      await service.scheduleReminder(r1);
      await service.scheduleReminder(r2);
      expect(service.scheduledReminders.length, equals(2));

      await service.cancelAll();
      expect(service.scheduledReminders, isEmpty);
      expect(service.allCancelled, isTrue);
    });

    test('requestPermissions returns configured value', () async {
      service.permissionResult = false;
      expect(await service.requestPermissions(), isFalse);

      service.permissionResult = true;
      expect(await service.requestPermissions(), isTrue);
    });
  });

  group('NotificationServiceImpl', () {
    late MockFlutterLocalNotificationsPlugin mockPlugin;
    late NotificationServiceImpl service;

    setUp(() {
      mockPlugin = MockFlutterLocalNotificationsPlugin();
      service = NotificationServiceImpl(plugin: mockPlugin);
    });

    test('cancelReminder delegates to plugin.cancel', () async {
      when(
        () => mockPlugin.cancel(id: any(named: 'id')),
      ).thenAnswer((_) async {});

      await service.cancelReminder(42);

      verify(() => mockPlugin.cancel(id: 42)).called(1);
    });

    test('cancelAll delegates to plugin.cancelAll', () async {
      when(() => mockPlugin.cancelAll()).thenAnswer((_) async {});

      await service.cancelAll();

      verify(() => mockPlugin.cancelAll()).called(1);
    });
  });
}
