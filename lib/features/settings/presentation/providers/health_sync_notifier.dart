import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/integrations/health/health_metric.dart';
import '../../../../core/integrations/health/health_service_provider.dart';
import '../../../../core/integrations/health/platform_detector.dart';
import '../../../glucose/data/providers/glucose_health_sync_coordinator_provider.dart';
import '../../../glucose/data/services/glucose_health_sync_coordinator.dart';
import 'user_profile_notifier.dart';

part 'health_sync_notifier.g.dart';

/// Outcome of preparing the platform health store for synchronization.
enum HealthSyncReadiness {
  /// Health API is available and permissions were granted.
  ready,

  /// Android device without Health Connect installed; prompt installation.
  needsInstall,

  /// Health API is unavailable on this platform.
  unavailable,

  /// The user denied health permission requests.
  noPermissions,
}

/// Presentation-layer state for the health synchronization settings section.
class HealthSyncUiState {
  /// Whether a synchronization pass is currently running.
  final bool isSyncing;

  /// Creates a [HealthSyncUiState].
  const HealthSyncUiState({this.isSyncing = false});
}

/// Riverpod notifier encapsulating platform health-store sync orchestration.
///
/// Keeps data-layer coordination (permission checks, sync passes, profile
/// timestamp updates) out of widgets so [HealthSyncSection] only renders
/// state and forwards user events.
@riverpod
class HealthSync extends _$HealthSync {
  @override
  HealthSyncUiState build() => const HealthSyncUiState();

  /// Enables or disables platform health synchronization.
  ///
  /// When enabling, verifies API availability and requests permissions first;
  /// the profile flag is only set once preparation succeeds.
  /// [enable] Whether synchronization should be turned on.
  /// [platformDetector] Platform probe override for testability; defaults
  /// to the native platform implementation.
  Future<HealthSyncReadiness> setEnabled(
    bool enable, {
    PlatformDetector? platformDetector,
  }) async {
    if (!enable) {
      await ref
          .read(userProfileProvider.notifier)
          .updateHealthSyncEnabled(false);
      return HealthSyncReadiness.ready;
    }
    final service = ref.read(healthServiceProvider);
    if (!await service.isHealthApiAvailable()) {
      return (platformDetector ?? NativePlatformDetector()).isAndroid
          ? HealthSyncReadiness.needsInstall
          : HealthSyncReadiness.unavailable;
    }
    if (!await service.requestPermissions({HealthMetric.bloodGlucose})) {
      return HealthSyncReadiness.noPermissions;
    }
    await ref.read(userProfileProvider.notifier).updateHealthSyncEnabled(true);
    return HealthSyncReadiness.ready;
  }

  /// Runs a bidirectional synchronization pass and records its timestamp.
  ///
  /// [lastSyncAt] Timestamp of the previous successful sync, used as the
  /// incremental baseline. Returns `null` when health permissions are missing.
  Future<GlucoseHealthSyncResult?> syncNow({DateTime? lastSyncAt}) async {
    state = const HealthSyncUiState(isSyncing: true);
    try {
      final result = await ref
          .read(glucoseHealthSyncCoordinatorProvider)
          .sync(lastSyncTime: lastSyncAt);
      if (result != null) {
        await ref
            .read(userProfileProvider.notifier)
            .updateLastHealthSyncAt(DateTime.now());
      }
      return result;
    } finally {
      state = const HealthSyncUiState();
    }
  }
}
