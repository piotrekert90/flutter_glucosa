import 'package:shared_preferences/shared_preferences.dart';

/// Prefs-backed store for the user's diagnostics collection consent.
///
/// Lives in core config (not the Isar profile) so the choice survives data
/// wipes and is readable before Firebase initializes in [main].
/// The in-memory [enabled] cache keeps synchronous error handlers cheap.
abstract final class TelemetrySettings {
  /// Prefs key persisting the diagnostics collection consent.
  static const String prefsKey = 'telemetry_enabled';

  /// Cached consent flag. Defaults to `true` until [load] completes.
  static bool enabled = true;

  /// Loads the persisted consent flag into [enabled].
  static Future<void> load({SharedPreferences? prefs}) async {
    final store = prefs ?? await SharedPreferences.getInstance();
    enabled = store.getBool(prefsKey) ?? true;
  }

  /// Persists [value], updates [enabled], and applies collection flags.
  ///
  /// [applyCollection] forwards the flag to Firebase collection switches.
  /// It is injected (instead of importing Firebase here) to keep core
  /// config free of third-party SDK dependencies and unit-testable.
  static Future<void> setEnabled(
    bool value, {
    SharedPreferences? prefs,
    Future<void> Function(bool value)? applyCollection,
  }) async {
    final store = prefs ?? await SharedPreferences.getInstance();
    await store.setBool(prefsKey, value);
    enabled = value;
    await applyCollection?.call(value);
  }
}
