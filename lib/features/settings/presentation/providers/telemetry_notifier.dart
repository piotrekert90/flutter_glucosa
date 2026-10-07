import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/config/telemetry_settings.dart';

part 'telemetry_notifier.g.dart';

/// Riverpod notifier exposing the diagnostics collection consent flag.
///
/// Backed by [TelemetrySettings] (SharedPreferences) so the toggle works
/// before Firebase initializes and survives Isar data wipes.
@riverpod
class Telemetry extends _$Telemetry {
  @override
  bool build() => TelemetrySettings.enabled;

  /// Persists the consent flag and applies Firebase collection switches.
  ///
  /// [enable] Whether crash/analytics collection should be active.
  /// [applyCollection] Collection-switch override for testability; defaults
  /// to the real Firebase Crashlytics/Analytics switches.
  Future<void> setEnabled(
    bool enable, {
    Future<void> Function(bool value)? applyCollection,
  }) async {
    await TelemetrySettings.setEnabled(
      enable,
      applyCollection:
          applyCollection ??
          (value) async {
            await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
              value,
            );
            await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
              value,
            );
          },
    );
    state = enable;
  }
}
