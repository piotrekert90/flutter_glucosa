import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';

import '../../../l10n/app_localizations.dart';
import '../../utils/app_logger.dart';
import '../../utils/crash_reporter.dart';

/// Represents the clinical outcome of a device credential authentication attempt.
enum BiometricAuthResult {
  /// Authentication succeeded.
  success,

  /// The user dismissed or canceled the prompt.
  canceled,

  /// Biometrics are temporarily locked out due to too many attempts.
  lockedOut,

  /// Biometrics are permanently locked out until the user re-enrolls in system settings.
  permanentlyLockedOut,

  /// No biometric credentials are enrolled on this device.
  notEnrolled,

  /// No device passcode or lock screen security is set.
  passcodeNotSet,

  /// Biometrics are not supported or available on this hardware.
  notAvailable,

  /// An unhandled platform error occurred.
  error,
}

/// Singleton integration service managing biometric and device credential authentication.
///
/// Encapsulates platform authentication calls, concurrency deduplication, and error mapping.
class BiometricService {
  BiometricService._();

  /// Shared singleton instance of [BiometricService].
  static final BiometricService instance = BiometricService._();

  final LocalAuthentication _authentication = LocalAuthentication();

  StreamController<void> _authenticationSuccessController =
      StreamController<void>.broadcast();

  /// Broadcast stream emitting after every successful authentication.
  Stream<void> get authenticationSuccesses =>
      _authenticationSuccessController.stream;

  Future<BiometricAuthResult>? _activeAuthFuture;
  DateTime? _lastAuthCompletionTime;

  /// Resets internal stream controller and timers for test isolation.
  @visibleForTesting
  static void resetForTesting() {
    if (!instance._authenticationSuccessController.isClosed) {
      instance._authenticationSuccessController.close();
    }
    instance._authenticationSuccessController =
        StreamController<void>.broadcast();
    instance._lastAuthCompletionTime = null;
    instance._activeAuthFuture = null;
  }

  /// Disposes active stream controllers.
  Future<void> dispose() async {
    if (!_authenticationSuccessController.isClosed) {
      await _authenticationSuccessController.close();
    }
  }

  void _notifyAuthenticationSuccess() {
    if (!_authenticationSuccessController.isClosed) {
      _authenticationSuccessController.add(null);
    }
  }

  /// Whether biometric authentication is currently actively being presented.
  bool get isAuthenticating => _activeAuthFuture != null;

  /// Whether biometric authentication finished very recently (within 1 second).
  bool get wasAuthenticatingRecently =>
      _lastAuthCompletionTime != null &&
      DateTime.now().difference(_lastAuthCompletionTime!) <
          const Duration(seconds: 1);

  /// Checks whether the device hardware supports biometrics and has enrolled credentials.
  Future<bool> isAvailable() async {
    try {
      final canCheck = await _authentication.canCheckBiometrics;
      if (!canCheck) return false;
      final biometrics = await _authentication.getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[BiometricService] isAvailable check failed',
      );
      return false;
    }
  }

  /// Checks whether biometric authentication is supported by the OS and device hardware.
  Future<bool> isSupported() async {
    try {
      final deviceSupported = await _authentication.isDeviceSupported();
      if (!deviceSupported) return false;
      return await _authentication.canCheckBiometrics;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[BiometricService] isSupported check failed',
      );
      return false;
    }
  }

  /// Checks whether the device can present any authentication challenge (biometric or passcode).
  Future<bool> canAuthenticate() async {
    try {
      final deviceSupported = await _authentication.isDeviceSupported();
      final canCheck = await _authentication.canCheckBiometrics;
      return deviceSupported || canCheck;
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[BiometricService] canAuthenticate check failed',
      );
      return false;
    }
  }

  /// Prompts the user for biometric or device credential authentication.
  ///
  /// [localizedReason] Explanation message displayed to the user in the system prompt.
  /// [authMessages] Optional platform-specific message overrides.
  Future<BiometricAuthResult> authenticate({
    required String localizedReason,
    Iterable<AuthMessages>? authMessages,
  }) async {
    if (_activeAuthFuture != null) {
      AppLogger.debug(
        'Authentication already in progress. Re-using active Future.',
        tag: 'BiometricService',
      );
      return _activeAuthFuture!;
    }

    _activeAuthFuture = _performAuthentication(
      localizedReason: localizedReason,
      authMessages: authMessages,
    );

    try {
      return await _activeAuthFuture!;
    } finally {
      _activeAuthFuture = null;
      _lastAuthCompletionTime = DateTime.now();
    }
  }

  Future<BiometricAuthResult> _performAuthentication({
    required String localizedReason,
    Iterable<AuthMessages>? authMessages,
  }) async {
    try {
      final canAuth = await canAuthenticate();
      if (!canAuth) return BiometricAuthResult.notAvailable;

      final ok = await _authentication.authenticate(
        localizedReason: localizedReason,
        authMessages: authMessages ?? const <AuthMessages>[],
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      if (ok) {
        _notifyAuthenticationSuccess();
        return BiometricAuthResult.success;
      }
      return BiometricAuthResult.canceled;
    } on LocalAuthException catch (e, stack) {
      if (e.code == LocalAuthExceptionCode.deviceError ||
          e.code == LocalAuthExceptionCode.unknownError) {
        await AppCrashReporter.recordError(
          e,
          stack,
          reason:
              '[BiometricService] LocalAuthException ${e.code.name}: ${e.description}',
        );
      }
      return switch (e.code) {
        LocalAuthExceptionCode.userCanceled ||
        LocalAuthExceptionCode.systemCanceled ||
        LocalAuthExceptionCode.userRequestedFallback ||
        LocalAuthExceptionCode.timeout => BiometricAuthResult.canceled,
        LocalAuthExceptionCode.temporaryLockout =>
          BiometricAuthResult.lockedOut,
        LocalAuthExceptionCode.biometricLockout =>
          BiometricAuthResult.permanentlyLockedOut,
        LocalAuthExceptionCode.noBiometricsEnrolled =>
          BiometricAuthResult.notEnrolled,
        LocalAuthExceptionCode.noCredentialsSet =>
          BiometricAuthResult.passcodeNotSet,
        LocalAuthExceptionCode.noBiometricHardware ||
        LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable =>
          BiometricAuthResult.notAvailable,
        LocalAuthExceptionCode.authInProgress ||
        LocalAuthExceptionCode.uiUnavailable ||
        LocalAuthExceptionCode.deviceError ||
        LocalAuthExceptionCode.unknownError => BiometricAuthResult.error,
      };
    } on MissingPluginException catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[BiometricService] MissingPluginException: $e',
      );
      return BiometricAuthResult.notAvailable;
    } on PlatformException catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[BiometricService] PlatformException: ${e.code} ${e.message}',
      );
      return switch (e.code) {
        'LockedOut' => BiometricAuthResult.lockedOut,
        'PermanentlyLockedOut' => BiometricAuthResult.permanentlyLockedOut,
        'NotEnrolled' => BiometricAuthResult.notEnrolled,
        'PasscodeNotSet' => BiometricAuthResult.passcodeNotSet,
        'NotAvailable' => BiometricAuthResult.notAvailable,
        'NotAuthenticated' ||
        'UserCanceled' ||
        'SystemCanceled' ||
        'AuthenticationCanceled' ||
        'user_canceled' ||
        'canceled' => BiometricAuthResult.canceled,
        'auth_in_progress' => BiometricAuthResult.error,
        _ => BiometricAuthResult.error,
      };
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[BiometricService] unexpected authentication exception',
      );
      return BiometricAuthResult.error;
    }
  }

  /// Determines whether [result] indicates an irrecoverable credential failure.
  static bool isTerminalFailure(BiometricAuthResult result) {
    return switch (result) {
      BiometricAuthResult.notEnrolled ||
      BiometricAuthResult.notAvailable ||
      BiometricAuthResult.permanentlyLockedOut ||
      BiometricAuthResult.passcodeNotSet => true,
      _ => false,
    };
  }

  /// Creates localized platform-specific authentication prompt messages.
  ///
  /// [l10n] Active [AppLocalizations] instance.
  static List<AuthMessages> createAuthMessages(AppLocalizations l10n) {
    return [
      AndroidAuthMessages(
        signInTitle: l10n.biometricUnlockTitle,
        cancelButton: l10n.cancel,
        signInHint: '',
      ),
      IOSAuthMessages(cancelButton: l10n.cancel),
    ];
  }
}
