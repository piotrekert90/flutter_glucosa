import 'package:flutter_glucosa/core/config/telemetry_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TelemetrySettings', () {
    test('defaults to enabled when nothing is persisted', () async {
      SharedPreferences.setMockInitialValues({});
      TelemetrySettings.enabled = true;

      await TelemetrySettings.load();

      expect(TelemetrySettings.enabled, isTrue);
    });

    test('loads persisted opt-out', () async {
      SharedPreferences.setMockInitialValues({
        TelemetrySettings.prefsKey: false,
      });

      await TelemetrySettings.load();

      expect(TelemetrySettings.enabled, isFalse);
    });

    test('setEnabled persists, caches, and applies collection', () async {
      SharedPreferences.setMockInitialValues({});
      TelemetrySettings.enabled = true;
      bool? appliedValue;
      await TelemetrySettings.load();

      await TelemetrySettings.setEnabled(
        false,
        applyCollection: (value) async {
          appliedValue = value;
        },
      );

      expect(TelemetrySettings.enabled, isFalse);
      expect(appliedValue, isFalse);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(TelemetrySettings.prefsKey), isFalse);

      await TelemetrySettings.setEnabled(
        true,
        applyCollection: (value) async {
          appliedValue = value;
        },
      );

      expect(TelemetrySettings.enabled, isTrue);
      expect(appliedValue, isTrue);
    });
  });
}
