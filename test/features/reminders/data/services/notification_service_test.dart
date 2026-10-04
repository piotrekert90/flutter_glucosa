import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/features/reminders/data/services/notification_service_impl.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../helpers/fake_notification_service.dart';

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

class MockAndroidFlutterLocalNotificationsPlugin extends Mock
    implements AndroidFlutterLocalNotificationsPlugin {}

class MockIOSFlutterLocalNotificationsPlugin extends Mock
    implements IOSFlutterLocalNotificationsPlugin {}

class FakeInitializationSettings extends Fake
    implements InitializationSettings {}

class FakeNotificationDetails extends Fake implements NotificationDetails {}

class FakeTZDateTime extends Fake implements tz.TZDateTime {}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    registerFallbackValue(FakeInitializationSettings());
    registerFallbackValue(FakeNotificationDetails());
    registerFallbackValue(FakeTZDateTime());
    registerFallbackValue(AndroidScheduleMode.exactAllowWhileIdle);
  });

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

    test('initialize configures plugin and is idempotent', () async {
      when(
        () => mockPlugin.initialize(settings: any(named: 'settings')),
      ).thenAnswer((_) async => true);

      await service.initialize();
      verify(
        () => mockPlugin.initialize(settings: any(named: 'settings')),
      ).called(1);

      // Subsequent call is a no-op
      await service.initialize();
      verifyNoMoreInteractions(mockPlugin);
    });

    test(
      'scheduleReminder calculates scheduledDate in local timezone',
      () async {
        service = NotificationServiceImpl(
          plugin: mockPlugin,
          timezoneProvider: () async => 'Europe/Warsaw',
        );

        when(
          () => mockPlugin.initialize(settings: any(named: 'settings')),
        ).thenAnswer((_) async => true);
        when(
          () => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        const reminder = Reminder(
          id: 7,
          label: 'Evening Glucose',
          metricType: MetricType.glucose,
          hourOfDay: 20,
          minute: 15,
          isActive: true,
        );

        await service.scheduleReminder(reminder);

        final captured = verify(
          () => mockPlugin.zonedSchedule(
            id: 7,
            title: 'Evening Glucose',
            body: any(named: 'body'),
            scheduledDate: captureAny(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: DateTimeComponents.time,
          ),
        ).captured;

        final scheduledDate = captured.first as tz.TZDateTime;
        expect(scheduledDate.location.name, equals('Europe/Warsaw'));
        expect(scheduledDate.hour, equals(20));
        expect(scheduledDate.minute, equals(15));
      },
    );

    test('scheduleReminder cancels when reminder is inactive', () async {
      when(
        () => mockPlugin.cancel(id: any(named: 'id')),
      ).thenAnswer((_) async {});

      const reminder = Reminder(
        id: 8,
        label: 'Inactive Reminder',
        metricType: MetricType.bloodPressure,
        hourOfDay: 9,
        minute: 0,
        isActive: false,
      );

      await service.scheduleReminder(reminder);

      verify(() => mockPlugin.cancel(id: 8)).called(1);
      verifyNever(
        () => mockPlugin.zonedSchedule(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
          notificationDetails: any(named: 'notificationDetails'),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        ),
      );
    });

    test(
      'initialize resolves timezone identifier from FlutterTimezone method channel',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter_timezone'), (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'getLocalTimezone') {
                return 'America/New_York';
              }
              return null;
            });

        final defaultService = NotificationServiceImpl(plugin: mockPlugin);
        when(
          () => mockPlugin.initialize(settings: any(named: 'settings')),
        ).thenAnswer((_) async => true);

        await defaultService.initialize();

        expect(tz.local.name, equals('America/New_York'));
      },
    );

    test(
      'scheduleReminder uses inexactAllowWhileIdle when canScheduleExactNotifications is false or null',
      () async {
        when(
          () => mockPlugin.initialize(settings: any(named: 'settings')),
        ).thenAnswer((_) async => true);
        when(
          () => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        const reminder = Reminder(
          id: 11,
          label: 'Inexact Reminder',
          metricType: MetricType.glucose,
          hourOfDay: 10,
          minute: 0,
          isActive: true,
        );

        await service.scheduleReminder(reminder);

        verify(
          () => mockPlugin.zonedSchedule(
            id: 11,
            title: 'Inexact Reminder',
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          ),
        ).called(1);
      },
    );

    test(
      'scheduleReminder uses exactAllowWhileIdle when canScheduleExactNotifications is true',
      () async {
        final mockAndroid = MockAndroidFlutterLocalNotificationsPlugin();
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(mockAndroid);
        when(
          () => mockAndroid.canScheduleExactNotifications(),
        ).thenAnswer((_) async => true);

        when(
          () => mockPlugin.initialize(settings: any(named: 'settings')),
        ).thenAnswer((_) async => true);
        when(
          () => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).thenAnswer((_) async {});

        const reminder = Reminder(
          id: 12,
          label: 'Exact Reminder',
          metricType: MetricType.glucose,
          hourOfDay: 10,
          minute: 0,
          isActive: true,
        );

        await service.scheduleReminder(reminder);

        verify(
          () => mockPlugin.zonedSchedule(
            id: 12,
            title: 'Exact Reminder',
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          ),
        ).called(1);
      },
    );

    test(
      'scheduleReminder falls back to inexact when exact scheduling throws',
      () async {
        final mockAndroid = MockAndroidFlutterLocalNotificationsPlugin();
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(mockAndroid);
        when(
          () => mockAndroid.canScheduleExactNotifications(),
        ).thenAnswer((_) async => true);

        when(
          () => mockPlugin.initialize(settings: any(named: 'settings')),
        ).thenAnswer((_) async => true);

        var firstCall = true;
        when(
          () => mockPlugin.zonedSchedule(
            id: any(named: 'id'),
            title: any(named: 'title'),
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: any(named: 'androidScheduleMode'),
            matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
          ),
        ).thenAnswer((invocation) async {
          final mode =
              invocation.namedArguments[#androidScheduleMode]
                  as AndroidScheduleMode;
          if (mode == AndroidScheduleMode.exactAllowWhileIdle && firstCall) {
            firstCall = false;
            throw PlatformException(
              code: 'exact_alarms_not_permitted',
              message: 'Exact alarms not permitted',
            );
          }
        });

        const reminder = Reminder(
          id: 13,
          label: 'Fallback Reminder',
          metricType: MetricType.glucose,
          hourOfDay: 10,
          minute: 0,
          isActive: true,
        );

        await service.scheduleReminder(reminder);

        verifyInOrder([
          () => mockPlugin.zonedSchedule(
            id: 13,
            title: 'Fallback Reminder',
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          ),
          () => mockPlugin.zonedSchedule(
            id: 13,
            title: 'Fallback Reminder',
            body: any(named: 'body'),
            scheduledDate: any(named: 'scheduledDate'),
            notificationDetails: any(named: 'notificationDetails'),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.time,
          ),
        ]);
      },
    );

    test('scheduleReminder rethrows if inexact scheduling fails', () async {
      when(
        () => mockPlugin.initialize(settings: any(named: 'settings')),
      ).thenAnswer((_) async => true);
      when(
        () => mockPlugin.zonedSchedule(
          id: any(named: 'id'),
          title: any(named: 'title'),
          body: any(named: 'body'),
          scheduledDate: any(named: 'scheduledDate'),
          notificationDetails: any(named: 'notificationDetails'),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        ),
      ).thenThrow(Exception('Inexact failed'));

      const reminder = Reminder(
        id: 14,
        label: 'Failing Reminder',
        metricType: MetricType.glucose,
        hourOfDay: 10,
        minute: 0,
        isActive: true,
      );

      expect(
        () => service.scheduleReminder(reminder),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'requestPermissions delegates to AndroidFlutterLocalNotificationsPlugin.requestNotificationsPermission',
      () async {
        final mockAndroid = MockAndroidFlutterLocalNotificationsPlugin();
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(mockAndroid);
        when(
          () => mockAndroid.requestNotificationsPermission(),
        ).thenAnswer((_) async => true);

        final granted = await service.requestPermissions();
        expect(granted, isTrue);
        verify(() => mockAndroid.requestNotificationsPermission()).called(1);
      },
    );

    test(
      'requestPermissions delegates to IOSFlutterLocalNotificationsPlugin on iOS',
      () async {
        final mockIos = MockIOSFlutterLocalNotificationsPlugin();
        when(
          () => mockPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >(),
        ).thenReturn(mockIos);
        when(
          () => mockIos.requestPermissions(
            alert: any(named: 'alert'),
            badge: any(named: 'badge'),
            sound: any(named: 'sound'),
          ),
        ).thenAnswer((_) async => true);

        final granted = await service.requestPermissions();
        expect(granted, isTrue);
        verify(
          () =>
              mockIos.requestPermissions(alert: true, badge: true, sound: true),
        ).called(1);
      },
    );
  });
}
