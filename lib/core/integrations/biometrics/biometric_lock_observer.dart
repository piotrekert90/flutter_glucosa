import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/app_logger.dart';
import 'biometric_service.dart';

/// Enforces the biometric app lock across application lifecycle state transitions.
///
/// Registers itself as a [WidgetsBindingObserver] and monitors background transitions.
/// When the app enters `paused`, `inactive`, or `hidden` state, it marks the time and locks
/// the application after [gracePeriod] has elapsed, causing the biometric shield screen to mount.
class BiometricLockObserver with WidgetsBindingObserver {
  /// Default grace period (30 seconds) before requiring biometric re-authentication.
  static const Duration defaultGracePeriod = Duration(seconds: 30);

  /// Callback returning whether the user has enabled the biometric lock feature.
  final bool Function() isBiometricLockEnabled;

  /// Optional callback returning whether the application is already locked.
  final bool Function()? isAppLocked;

  /// Callback invoked with `true` to lock the app or `false` to unlock.
  final ValueChanged<bool> onLockStateChanged;

  /// Stream of live biometric lock enabled settings changes.
  final Stream<bool>? lockEnabledStream;

  /// Duration the app may remain in the background before re-authentication is required.
  final Duration gracePeriod;

  /// Clock function providing current time for test isolation.
  final DateTime Function() clock;

  bool _isLockEnabled = false;
  bool _disposed = false;
  DateTime? _pausedAt;
  Timer? _graceTimer;
  StreamSubscription<bool>? _subscription;

  /// Creates a [BiometricLockObserver].
  BiometricLockObserver({
    required this.isBiometricLockEnabled,
    required this.onLockStateChanged,
    this.isAppLocked,
    this.lockEnabledStream,
    this.gracePeriod = defaultGracePeriod,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now {
    _isLockEnabled = isBiometricLockEnabled();
    WidgetsBinding.instance.addObserver(this);
    _subscription = lockEnabledStream?.listen((enabled) {
      _isLockEnabled = enabled;
      if (!enabled) {
        onLockStateChanged(false);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_disposed) return;
    if (state == AppLifecycleState.resumed) {
      _handleResumed();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.inactive) {
      _handleBackgrounded();
    }
  }

  void _handleBackgrounded() {
    if (!_isLockEnabled) return;
    if (BiometricService.instance.isAuthenticating) return;
    if (BiometricService.instance.wasAuthenticatingRecently) return;
    if (isAppLocked?.call() == true) return;

    if (gracePeriod == Duration.zero) {
      _checkBiometricLock();
      return;
    }

    _pausedAt ??= clock();
    _graceTimer?.cancel();
    _graceTimer = Timer(gracePeriod, () {
      if (!_disposed && _pausedAt != null) {
        _checkBiometricLock();
      }
    });
  }

  void _handleResumed() {
    _graceTimer?.cancel();
    _graceTimer = null;
    if (!_isLockEnabled) return;
    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (pausedAt == null) return;
    if (isAppLocked?.call() == true) return;

    final elapsed = clock().difference(pausedAt);
    if (elapsed >= gracePeriod) {
      _checkBiometricLock();
    }
  }

  void _checkBiometricLock() {
    if (!_isLockEnabled) return;
    if (BiometricService.instance.isAuthenticating) return;
    if (BiometricService.instance.wasAuthenticatingRecently) return;
    if (isAppLocked?.call() == true) return;

    AppLogger.info(
      'App backgrounded past grace period. Locking application.',
      tag: 'BiometricLockObserver',
    );
    onLockStateChanged(true);
  }

  /// Removes lifecycle observers and releases active subscriptions and timers.
  void dispose() {
    _disposed = true;
    _graceTimer?.cancel();
    _subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }
}
