import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/config/app_environment.dart';
import '../../../../core/domain/enums/metric_type.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/services/notification_service.dart';

/// Implementation of [NotificationService] using `flutter_local_notifications`.
class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  /// Optional timezone resolver for testing and platform override.
  final Future<String> Function()? timezoneProvider;

  /// Optional localizations provider for testing and platform override.
  final AppLocalizations Function()? localizationsProvider;
  bool _initialized = false;

  /// Creates a [NotificationServiceImpl] with optional [_plugin], [timezoneProvider], and [localizationsProvider].
  NotificationServiceImpl({
    FlutterLocalNotificationsPlugin? plugin,
    this.timezoneProvider,
    this.localizationsProvider,
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

    final l10n = localizationsProvider != null
        ? localizationsProvider!()
        : lookupAppLocalizations(PlatformDispatcher.instance.locale);

    final notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        AppConfig.notificationChannelId,
        l10n.notificationChannelName,
        channelDescription: l10n.notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    bool canExact = false;
    try {
      canExact =
          (await androidPlugin?.canScheduleExactNotifications()) ?? false;
    } catch (_) {
      canExact = false;
    }

    final scheduleMode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    try {
      await _scheduleZonedNotification(
        reminder: reminder,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        scheduleMode: scheduleMode,
        l10n: l10n,
      );
    } catch (e, st) {
      if (scheduleMode == AndroidScheduleMode.exactAllowWhileIdle) {
        AppLogger.warning(
          'Exact alarm scheduling failed, falling back to inexact: $e',
          error: e,
          stackTrace: st,
        );
        await _scheduleZonedNotification(
          reminder: reminder,
          scheduledDate: scheduledDate,
          notificationDetails: notificationDetails,
          scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          l10n: l10n,
        );
      } else {
        rethrow;
      }
    }
  }

  Future<void> _scheduleZonedNotification({
    required Reminder reminder,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    required AndroidScheduleMode scheduleMode,
    required AppLocalizations l10n,
  }) {
    final metricName = _metricLabel(reminder.metricType, l10n);
    return _plugin.zonedSchedule(
      id: reminder.id,
      title: reminder.label,
      body: l10n.notificationReminderBody(metricName),
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: reminder.isOneTime
          ? null
          : DateTimeComponents.time,
    );
  }

  String _metricLabel(MetricType type, AppLocalizations l10n) {
    return switch (type) {
      MetricType.glucose => l10n.glucose,
      MetricType.hba1c => l10n.hba1c,
      MetricType.bloodPressure => l10n.bloodPressure,
      MetricType.ketones => l10n.ketones,
      MetricType.cholesterol => l10n.cholesterol,
      MetricType.weight => l10n.weight,
    };
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
