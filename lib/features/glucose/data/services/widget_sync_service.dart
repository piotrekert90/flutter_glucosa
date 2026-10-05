import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/glucose_unit.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/domain/utils/glucose_status_resolver.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/utils/crash_reporter.dart';
import '../../domain/entities/glucose_reading.dart';

/// Builds the shared-preferences payload consumed by native home screen widgets.
///
/// Extracted as a pure function so payload formatting is unit-testable
/// without platform channels. Keys mirror the UserDefaults / SharedPreferences
/// entries read by the WidgetKit extension and AppWidget providers.
Map<String, Object> buildWidgetPayload({
  required List<GlucoseReading> readings,
  required GlucoseUnit unit,
  required GlucoseTargetRange targetRange,
  required String headerTitle,
  required String noDataLabel,
  required String tapToAddLabel,
  required String todayLabel,
  String? localeName,
  bool hideSensitiveData = false,
}) {
  if (readings.isEmpty) {
    return {
      'has_data': false,
      'header_title': headerTitle,
      'no_data_text': noDataLabel,
      'tap_to_add_text': tapToAddLabel,
    };
  }

  if (hideSensitiveData) {
    return {
      'has_data': true,
      'header_title': headerTitle,
      'glucose_value': '•••',
      'glucose_unit': unit.displayName,
      'status': 'hidden',
      'trend': 'flat',
      'trend_text': '',
      'last_entry_text': '',
    };
  }

  final sorted = readings.toList()
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  final latest = sorted.last;

  final displayValue = unit == GlucoseUnit.mmolL
      ? GlucoseConverter.mgDlToMmolL(latest.readingMgDl).toStringAsFixed(1)
      : latest.readingMgDl.toString();

  final status = GlucoseStatusResolver.resolve(
    readingMgDl: latest.readingMgDl,
    targetRange: targetRange,
  );

  var trend = 'flat';
  var trendText = '';
  if (sorted.length > 1) {
    final previous = sorted[sorted.length - 2];
    final deltaMgDl = latest.readingMgDl - previous.readingMgDl;
    if (deltaMgDl > 0) {
      trend = 'up';
    } else if (deltaMgDl < 0) {
      trend = 'down';
    }
    if (deltaMgDl != 0) {
      final deltaDisplay = unit == GlucoseUnit.mmolL
          ? GlucoseConverter.mgDlToMmolL(deltaMgDl.abs()).toStringAsFixed(1)
          : deltaMgDl.abs().toString();
      final sign = deltaMgDl > 0 ? '+' : '-';
      trendText = '$sign$deltaDisplay ${unit.displayName}';
    }
  }

  final now = DateTime.now();
  final isToday =
      latest.createdAt.year == now.year &&
      latest.createdAt.month == now.month &&
      latest.createdAt.day == now.day;
  final timeStr = DateFormat('HH:mm').format(latest.createdAt);
  String dateStr;
  try {
    dateStr = DateFormat('d MMM', localeName).format(latest.createdAt);
  } catch (_) {
    dateStr = DateFormat('d MMM').format(latest.createdAt);
  }
  final lastEntryText = isToday
      ? '$todayLabel, $timeStr'
      : '$dateStr • $timeStr';

  return {
    'has_data': true,
    'header_title': headerTitle,
    'glucose_value': displayValue,
    'glucose_unit': unit.displayName,
    'status': status.name,
    'trend': trend,
    'trend_text': trendText,
    'last_entry_text': lastEntryText,
  };
}

/// Service synchronizing the latest glucose reading with native home screen
/// widgets (Android AppWidgetProvider).
///
/// iOS currently ships no widget extension, so every operation is a no-op
/// there and no glucose data is written to the shared App Group container.
class WidgetSyncService {
  /// Shared App Group identifier reserved for a future iOS widget extension.
  static const String appGroupId = 'group.com.ekerstudio.glucosa';

  /// Android compact widget provider class name.
  static const String androidWidgetName = 'GlucosaAppWidgetProvider';

  /// Android full-size widget provider class name.
  static const String androidFullWidgetName = 'GlucosaFullAppWidgetProvider';

  /// iOS WidgetKit extension kind (reserved, no extension is shipped yet).
  static const String iOSWidgetName = 'GlucosaWidget';

  /// Creates a [WidgetSyncService].
  const WidgetSyncService();

  bool get _isSupportedPlatform => defaultTargetPlatform != TargetPlatform.iOS;

  /// Configures the App Group identifier used by the iOS widget extension.
  Future<void> initialize() async {
    if (!_isSupportedPlatform) return;
    try {
      await HomeWidget.setAppGroupId(appGroupId);
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[WidgetSyncService] initialize failed',
      );
    }
  }

  /// Pushes the latest glucose payload built by [buildWidgetPayload] to native widget storage.
  Future<void> updateWidgetData({
    required List<GlucoseReading> readings,
    required GlucoseUnit unit,
    required GlucoseTargetRange targetRange,
    required String headerTitle,
    required String noDataLabel,
    required String tapToAddLabel,
    required String todayLabel,
    String? localeName,
    bool hideSensitiveData = false,
  }) async {
    if (!_isSupportedPlatform) return;
    try {
      final payload = buildWidgetPayload(
        readings: readings,
        unit: unit,
        targetRange: targetRange,
        headerTitle: headerTitle,
        noDataLabel: noDataLabel,
        tapToAddLabel: tapToAddLabel,
        todayLabel: todayLabel,
        localeName: localeName,
        hideSensitiveData: hideSensitiveData,
      );
      await Future.wait([
        for (final entry in payload.entries) _saveEntry(entry.key, entry.value),
      ]);
      await Future.wait([
        HomeWidget.updateWidget(
          androidName: androidWidgetName,
          iOSName: iOSWidgetName,
        ),
        HomeWidget.updateWidget(
          androidName: androidFullWidgetName,
          iOSName: iOSWidgetName,
        ),
      ]);
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[WidgetSyncService] updateWidgetData failed',
      );
    }
  }

  /// Clears widget storage on database wipe.
  Future<void> clearWidgetData() async {
    if (!_isSupportedPlatform) return;
    try {
      await Future.wait([
        HomeWidget.saveWidgetData<bool>('has_data', false),
        HomeWidget.saveWidgetData<String>('glucose_value', '--'),
        HomeWidget.saveWidgetData<String>('trend_text', ''),
        HomeWidget.saveWidgetData<String>('last_entry_text', ''),
      ]);
      await Future.wait([
        HomeWidget.updateWidget(
          androidName: androidWidgetName,
          iOSName: iOSWidgetName,
        ),
        HomeWidget.updateWidget(
          androidName: androidFullWidgetName,
          iOSName: iOSWidgetName,
        ),
      ]);
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[WidgetSyncService] clearWidgetData failed',
      );
    }
  }

  Future<void> _saveEntry(String key, Object value) {
    return switch (value) {
      final bool v => HomeWidget.saveWidgetData<bool>(key, v),
      final int v => HomeWidget.saveWidgetData<int>(key, v),
      final double v => HomeWidget.saveWidgetData<double>(key, v),
      _ => HomeWidget.saveWidgetData<String>(key, value.toString()),
    };
  }
}
