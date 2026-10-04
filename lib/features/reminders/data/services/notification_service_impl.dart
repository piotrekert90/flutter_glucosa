import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/config/app_environment.dart';
import '../../../../core/utils/app_logger.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/services/notification_service.dart';

/// Implementation of [NotificationService] using `flutter_local_notifications`.
class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  /// Optional timezone resolver for testing and platform override.
  final Future<String> Function()? timezoneProvider;
  bool _initialized = false;

  /// Creates a [NotificationServiceImpl] with optional [_plugin] and [timezoneProvider] for testing.
  NotificationServiceImpl({
    FlutterLocalNotificationsPlugin? plugin,
    this.timezoneProvider,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final identifier = timezoneProvider != null
          ? await timezoneProvider!()
          : (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(identifier));
    } catch (e, st) {
      AppLogger.warning(
        'Failed to configure local timezone, default to UTC: $e',
        error: e,
        stackTrace: st,
      );
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(settings: initSettings);
    _initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    if (!reminder.isActive) {
      await cancelReminder(reminder.id);
      return;
    }

    await initialize();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      reminder.hourOfDay,
      reminder.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        AppConfig.notificationChannelId,
        'Measurement Reminders',
        channelDescription:
            'Scheduled notifications reminding you to log health measurements',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.zonedSchedule(
      id: reminder.id,
      title: reminder.label,
      body: 'Time to log your ${reminder.metricType.name} measurement.',
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: reminder.isOneTime
          ? null
          : DateTimeComponents.time,
    );
  }

  @override
  Future<void> cancelReminder(int id) async {
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
