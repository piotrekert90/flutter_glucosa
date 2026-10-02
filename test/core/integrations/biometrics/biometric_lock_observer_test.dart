import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_glucosa/core/integrations/biometrics/biometric_lock_observer.dart';
import 'package:flutter_glucosa/core/integrations/biometrics/biometric_service.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BiometricLockObserver', () {
    late bool isLockEnabled;
    late bool lockStateEmitted;
    late StreamController<bool> lockStreamController;

    setUp(() {
      isLockEnabled = false;
      lockStateEmitted = false;
      lockStreamController = StreamController<bool>.broadcast();
    });

    tearDown(() {
      lockStreamController.close();
    });

    test('initializes lock state and listens to stream updates', () async {
      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => isLockEnabled,
        onLockStateChanged: (locked) {
          lockStateEmitted = locked;
        },
        lockEnabledStream: lockStreamController.stream,
      );

      expect(observer, isNotNull);

      lockStreamController.add(true);
      await pumpEventQueue();
      expect(lockStateEmitted, isFalse);

      observer.dispose();
    });

    test('didChangeAppLifecycleState ignores non-resumed states', () {
      bool called = false;
      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => false,
        onLockStateChanged: (_) {
          called = true;
        },
      );

      observer.didChangeAppLifecycleState(AppLifecycleState.paused);
      observer.didChangeAppLifecycleState(AppLifecycleState.inactive);
      observer.didChangeAppLifecycleState(AppLifecycleState.detached);

      expect(called, isFalse);
      observer.dispose();
    });

    test(
      'didChangeAppLifecycleState triggers check on resumed state',
      () async {
        final observer = BiometricLockObserver(
          isBiometricLockEnabled: () => false,
          onLockStateChanged: (_) {},
        );

        observer.didChangeAppLifecycleState(AppLifecycleState.resumed);
        await pumpEventQueue();

        observer.dispose();
      },
    );

    test('backgrounding locks the app when lock is enabled', () {
      var locked = false;
      BiometricService.resetForTesting();
      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => true,
        onLockStateChanged: (isLocked) {
          locked = isLocked;
        },
        isAppLocked: () => false,
        gracePeriod: Duration.zero,
      );

      observer.didChangeAppLifecycleState(AppLifecycleState.paused);
      observer.dispose();

      expect(locked, isTrue);
    });

    test('hidden lifecycle state locks the app when lock is enabled', () {
      var locked = false;
      BiometricService.resetForTesting();
      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => true,
        onLockStateChanged: (isLocked) {
          locked = isLocked;
        },
        isAppLocked: () => false,
        gracePeriod: Duration.zero,
      );

      observer.didChangeAppLifecycleState(AppLifecycleState.hidden);
      observer.dispose();

      expect(locked, isTrue);
    });

    test(
      'backgrounding skips the lock when authentication is in progress',
      () async {
        final completer = Completer<bool>();
        var locked = false;
        LocalAuthPlatform.instance = _PendingLocalAuthPlatform(
          completer.future,
        );
        BiometricService.resetForTesting();

        final observer = BiometricLockObserver(
          isBiometricLockEnabled: () => true,
          onLockStateChanged: (isLocked) {
            locked = isLocked;
          },
          isAppLocked: () => false,
          gracePeriod: Duration.zero,
        );

        final authFuture = BiometricService.instance.authenticate(
          localizedReason: 'unlock',
        );
        await pumpEventQueue();
        observer.didChangeAppLifecycleState(AppLifecycleState.paused);
        expect(locked, isFalse);

        completer.complete(true);
        await authFuture;
        observer.dispose();
      },
    );

    test('backgrounding skips the lock shortly after authentication', () async {
      var locked = false;
      LocalAuthPlatform.instance = _PendingLocalAuthPlatform(
        Future.value(true),
      );
      BiometricService.resetForTesting();

      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => true,
        onLockStateChanged: (isLocked) {
          locked = isLocked;
        },
        isAppLocked: () => false,
        gracePeriod: Duration.zero,
      );

      await BiometricService.instance.authenticate(localizedReason: 'unlock');
      observer.didChangeAppLifecycleState(AppLifecycleState.paused);
      observer.dispose();

      expect(locked, isFalse);
    });

    test('backgrounding skips the lock when the app is already locked', () {
      var locked = false;
      BiometricService.resetForTesting();
      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => true,
        onLockStateChanged: (isLocked) {
          locked = isLocked;
        },
        isAppLocked: () => true,
        gracePeriod: Duration.zero,
      );

      observer.didChangeAppLifecycleState(AppLifecycleState.paused);
      observer.dispose();

      expect(locked, isFalse);
    });

    test('dispose is idempotent and removes the binding observer', () {
      var locked = false;
      BiometricService.resetForTesting();
      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => true,
        onLockStateChanged: (_) {
          locked = true;
        },
        isAppLocked: () => false,
      );

      observer.dispose();
      observer.dispose();

      observer.didChangeAppLifecycleState(AppLifecycleState.paused);

      expect(locked, isFalse);
    });

    test('resuming within grace period does not lock the app', () {
      var locked = false;
      var currentTime = DateTime(2026, 10, 1, 12, 0, 0);
      BiometricService.resetForTesting();

      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => true,
        onLockStateChanged: (isLocked) {
          locked = isLocked;
        },
        isAppLocked: () => false,
        gracePeriod: const Duration(seconds: 30),
        clock: () => currentTime,
      );

      // App is paused / inactive (e.g. notification shade or app switcher)
      observer.didChangeAppLifecycleState(AppLifecycleState.inactive);
      expect(locked, isFalse);

      // Return 10 seconds later (< 30s grace period)
      currentTime = currentTime.add(const Duration(seconds: 10));
      observer.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(locked, isFalse);
      observer.dispose();
    });

    test('resuming after grace period locks the app', () {
      var locked = false;
      var currentTime = DateTime(2026, 10, 1, 12, 0, 0);
      BiometricService.resetForTesting();

      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => true,
        onLockStateChanged: (isLocked) {
          locked = isLocked;
        },
        isAppLocked: () => false,
        gracePeriod: const Duration(seconds: 30),
        clock: () => currentTime,
      );

      // App is backgrounded
      observer.didChangeAppLifecycleState(AppLifecycleState.paused);
      expect(locked, isFalse);

      // Return 35 seconds later (>= 30s grace period)
      currentTime = currentTime.add(const Duration(seconds: 35));
      observer.didChangeAppLifecycleState(AppLifecycleState.resumed);

      expect(locked, isTrue);
      observer.dispose();
    });

    test('dispose cancels the lock-enabled stream subscription', () async {
      final observer = BiometricLockObserver(
        isBiometricLockEnabled: () => false,
        onLockStateChanged: (_) {},
        lockEnabledStream: lockStreamController.stream,
      );

      expect(lockStreamController.hasListener, isTrue);
      observer.dispose();
      expect(lockStreamController.hasListener, isFalse);
    });
  });
}

/// Test double for [LocalAuthPlatform] whose authentication never completes
/// until the provided future resolves.
class _PendingLocalAuthPlatform extends LocalAuthPlatform {
  _PendingLocalAuthPlatform(this.authenticationResult);

  final Future<bool> authenticationResult;

  @override
  Future<bool> isDeviceSupported() async => true;

  @override
  Future<bool> deviceSupportsBiometrics() async => true;

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async => const [
    BiometricType.fingerprint,
  ];

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) {
    return authenticationResult;
  }
}
