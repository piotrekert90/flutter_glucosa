import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/crash_reporter.dart';
import 'health_metric.dart';
import 'health_sample.dart';
import 'platform_detector.dart';

/// Platform-neutral abstraction for querying and modifying health records.
///
/// Backed by Apple HealthKit (iOS) or Google Health Connect (Android),
/// hiding the underlying plugin details from the rest of the app.
abstract class HealthService {
  /// Checks if HealthKit (iOS) or Health Connect (Android) is available on the device.
  Future<bool> isHealthApiAvailable();

  /// Checks if read/write permissions for [metrics] are already granted.
  Future<bool> hasPermissions(Set<HealthMetric> metrics);

  /// Requests native OS permissions for [metrics] (read and write).
  Future<bool> requestPermissions(Set<HealthMetric> metrics);

  /// Opens the native app system settings so the user can manage permissions manually.
  Future<bool> openSystemSettings();

  /// Opens the Google Play Store listing for Health Connect on Android.
  ///
  /// Intended for devices where [isHealthApiAvailable] reports `false`;
  /// a no-op on other platforms.
  Future<void> installHealthConnect();

  /// Fetches numeric samples of [metric] within an inclusive date window.
  ///
  /// Only readings within the metric's plausible clinical range are returned;
  /// out-of-range or non-numeric points are discarded. Entries are sorted newest first.
  Future<List<HealthSample>> fetchSamples({
    required HealthMetric metric,
    required DateTime start,
    required DateTime end,
  });

  /// Writes [sample] to HealthKit / Health Connect.
  Future<bool> writeSample(HealthSample sample);

  /// Deletes the entry matching [sample] on a best-effort basis.
  ///
  /// The entry is located within a one-minute window around the sample
  /// timestamp, tolerating a small value difference. Returns `false` when
  /// no match is found or the plugin call fails.
  Future<bool> deleteSample(HealthSample sample);
}

/// Native implementation of [HealthService] backed by the `health` plugin.
///
/// All plugin calls are wrapped in try-catch blocks so missing Health Connect
/// installations, revoked permissions, or platform errors degrade to `false`
/// or an empty result instead of throwing unhandled exceptions. Permission
/// and settings calls are additionally bounded by a five-second timeout
/// ([_operationTimeout]) whose expiry is treated as a failure.
class NativeHealthService implements HealthService {
  /// Creates a [NativeHealthService] wrapping [health].
  ///
  /// [platformDetector] defaults to the native implementation.
  NativeHealthService({Health? health, PlatformDetector? platformDetector})
    : _health = health ?? Health(),
      _platformDetector = platformDetector ?? NativePlatformDetector();

  /// Maximum time allowed for permission and settings calls before fallback.
  static const Duration _operationTimeout = Duration(seconds: 5);

  /// Half-width of the lookup window around the deletion timestamp.
  static const Duration _deleteLookupWindow = Duration(minutes: 1);

  /// Relative match tolerance when locating an entry for deletion.
  static const double _deleteValueToleranceRatio = 0.001;

  /// Package name of the official Google Health Connect app.
  static const String _healthConnectPackageId =
      'com.google.android.apps.healthdata';

  /// Play Store deep link for the Health Connect app.
  static final Uri _healthConnectMarketUri = Uri.parse(
    'market://details?id=$_healthConnectPackageId',
  );

  /// Web fallback for devices without a `market://` handler.
  static final Uri _healthConnectPlayStoreUri = Uri.parse(
    'https://play.google.com/store/apps/details?id=$_healthConnectPackageId',
  );

  final Health _health;

  /// Platform detector for testing.
  final PlatformDetector _platformDetector;

  /// Whether [_health.configure] has completed successfully at least once.
  bool _isConfigured = false;

  /// Configures the health plugin exactly once before the first plugin call.
  Future<void> _ensureConfigured() async {
    if (!_isConfigured) {
      try {
        await _health.configure();
        _isConfigured = true;
      } catch (e, stack) {
        await AppCrashReporter.recordError(
          e,
          stack,
          reason: '[HealthService] Health plugin configuration failed',
        );
      }
    }
  }

  List<HealthDataType> _typesFor(Set<HealthMetric> metrics) {
    final types = <HealthDataType>[];
    for (final metric in HealthMetric.values) {
      if (metrics.contains(metric)) {
        // Each entry appears twice: once for READ, once for WRITE access.
        types.addAll([metric.dataType, metric.dataType]);
      }
    }
    return types;
  }

  static const List<HealthDataAccess> _readWriteAccess = [
    HealthDataAccess.READ,
    HealthDataAccess.WRITE,
  ];

  /// Builds the alternating READ/WRITE access list matching [_typesFor].
  List<HealthDataAccess> _accessFor(Set<HealthMetric> metrics) {
    final access = <HealthDataAccess>[];
    for (var i = 0; i < metrics.length; i++) {
      access.addAll(_readWriteAccess);
    }
    return access;
  }

  @override
  Future<bool> isHealthApiAvailable() async {
    try {
      if (!_platformDetector.isAndroid) {
        // HealthKit is available on every iOS device.
        return true;
      }
      await _ensureConfigured();
      final sdkStatus = await _health.getHealthConnectSdkStatus();
      return sdkStatus == HealthConnectSdkStatus.sdkAvailable;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] isHealthApiAvailable failed',
      );
      return false;
    }
  }

  @override
  Future<bool> hasPermissions(Set<HealthMetric> metrics) async {
    try {
      await _ensureConfigured();
      if (_platformDetector.isIOS) {
        // HealthKit does not disclose READ grants, so per-metric WRITE
        // grants are the only reliable authorization signal.
        final writeTypes = metrics.map((m) => m.dataType).toList();
        final writeAccess = List<HealthDataAccess>.filled(
          writeTypes.length,
          HealthDataAccess.WRITE,
        );
        final granted = await _health
            .hasPermissions(writeTypes, permissions: writeAccess)
            .timeout(_operationTimeout);
        return granted ?? false;
      }
      final granted = await _health
          .hasPermissions(_typesFor(metrics), permissions: _accessFor(metrics))
          .timeout(_operationTimeout);
      return granted ?? false;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] hasPermissions failed',
      );
      return false;
    }
  }

  @override
  Future<bool> requestPermissions(Set<HealthMetric> metrics) async {
    try {
      await _ensureConfigured();
      bool granted;
      try {
        granted = await _health
            .requestAuthorization(
              _typesFor(metrics),
              permissions: _accessFor(metrics),
            )
            .timeout(_operationTimeout);
      } catch (e, stack) {
        await AppCrashReporter.recordError(
          e,
          stack,
          reason:
              '[HealthService] Native Auth Exception in requestAuthorization',
        );
        return false;
      }
      if (!granted) return false;
      if (_platformDetector.isIOS) {
        // On iOS the plugin reports that the prompt was shown, not the
        // actual grant, so the result is verified through [hasPermissions].
        return await hasPermissions(metrics);
      }
      return granted;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] requestPermissions error',
      );
      return false;
    }
  }

  @override
  Future<bool> openSystemSettings() async {
    try {
      final opened = await openAppSettings().timeout(_operationTimeout);
      return opened;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] openSystemSettings error',
      );
      return false;
    }
  }

  @override
  Future<void> installHealthConnect() async {
    if (!_platformDetector.isAndroid) return;
    try {
      final marketLaunched = await launchUrl(_healthConnectMarketUri);
      if (!marketLaunched) {
        await launchUrl(
          _healthConnectPlayStoreUri,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] installHealthConnect error',
      );
    }
  }

  @override
  Future<List<HealthSample>> fetchSamples({
    required HealthMetric metric,
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      await _ensureConfigured();
      final points = await _health.getHealthDataFromTypes(
        types: [metric.dataType],
        startTime: start,
        endTime: end,
        preferredUnits: {metric.dataType: metric.unit},
      );
      final samples = <HealthSample>[];
      final seenKeys = <String>{};
      for (final point in points) {
        if (point.value is! NumericHealthValue) continue;
        final value = (point.value as NumericHealthValue).numericValue
            .toDouble();
        if (!metric.isPlausible(value)) continue;
        // Collapse data points sharing identical timestamps (to the minute) and values.
        final key =
            '${point.dateFrom.year}-${point.dateFrom.month}-${point.dateFrom.day}_'
            '${point.dateFrom.hour}:${point.dateFrom.minute}_'
            '${value.toStringAsFixed(1)}';
        if (seenKeys.add(key)) {
          samples.add(
            HealthSample(
              metric: metric,
              value: value,
              timestamp: point.dateFrom,
            ),
          );
        }
      }
      samples.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return samples;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] fetchSamples error',
      );
      return const [];
    }
  }

  @override
  Future<bool> writeSample(HealthSample sample) async {
    try {
      await _ensureConfigured();
      return await _health.writeHealthData(
        value: sample.value,
        unit: sample.metric.unit,
        type: sample.metric.dataType,
        startTime: sample.timestamp,
        endTime: sample.timestamp,
        // Required on iOS, where only manual or automatic recording methods
        // are accepted for health records.
        recordingMethod: RecordingMethod.manual,
      );
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] writeSample error',
      );
      return false;
    }
  }

  @override
  Future<bool> deleteSample(HealthSample sample) async {
    try {
      await _ensureConfigured();
      final tolerance = (sample.value.abs() * _deleteValueToleranceRatio).clamp(
        0.01,
        1.0,
      );
      final points = await _health.getHealthDataFromTypes(
        types: [sample.metric.dataType],
        startTime: sample.timestamp.subtract(_deleteLookupWindow),
        endTime: sample.timestamp.add(_deleteLookupWindow),
        preferredUnits: {sample.metric.dataType: sample.metric.unit},
      );
      HealthDataPoint? match;
      for (final point in points) {
        if (point.value is NumericHealthValue &&
            ((point.value as NumericHealthValue).numericValue - sample.value)
                    .abs() <=
                tolerance) {
          match = point;
          break;
        }
      }
      if (match == null) return false;
      return await _health.deleteByUUID(
        uuid: match.uuid,
        type: sample.metric.dataType,
      );
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[HealthService] deleteSample error',
      );
      return false;
    }
  }
}
