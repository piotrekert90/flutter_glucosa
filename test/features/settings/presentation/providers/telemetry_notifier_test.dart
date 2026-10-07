import 'package:flutter_glucosa/core/config/telemetry_settings.dart';
import 'package:flutter_glucosa/features/settings/presentation/providers/telemetry_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    TelemetrySettings.enabled = true;
    await TelemetrySettings.load();
  });

  test('build reflects cached consent flag', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(telemetryProvider), isTrue);
  });

  test('setEnabled persists consent and updates state', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(telemetryProvider, (_, _) {});
    bool? appliedValue;
    Future<void> applyCollection(bool value) async {
      appliedValue = value;
    }

    await container
        .read(telemetryProvider.notifier)
        .setEnabled(false, applyCollection: applyCollection);

    expect(container.read(telemetryProvider), isFalse);
    expect(TelemetrySettings.enabled, isFalse);
    expect(appliedValue, isFalse);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(TelemetrySettings.prefsKey), isFalse);
  });
}
