import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/settings/presentation/providers/user_profile_notifier.dart';
import '../../../l10n/app_localizations.dart';
import '../../integrations/biometrics/biometric_lock_provider.dart';
import '../../integrations/biometrics/biometric_service.dart';
import '../../utils/app_logger.dart';
import '../../utils/crash_reporter.dart';

/// Full-screen privacy overlay mounted whenever the app is locked by biometric security.
///
/// Obscures sensitive medical and glucose data in the OS App Switcher and prompts
/// for biometric or passcode authentication upon resumption.
class BiometricShieldScreen extends ConsumerStatefulWidget {
  /// Creates a [BiometricShieldScreen].
  const BiometricShieldScreen({super.key});

  @override
  ConsumerState<BiometricShieldScreen> createState() =>
      _BiometricShieldScreenState();
}

class _BiometricShieldScreenState extends ConsumerState<BiometricShieldScreen> {
  bool _isUnlocking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _handleUnlock(context);
      }
    });
  }

  Future<void> _handleUnlock(BuildContext context) async {
    if (_isUnlocking) return;
    setState(() {
      _isUnlocking = true;
    });

    final l10n = AppLocalizations.of(context);

    try {
      final result = await BiometricService.instance.authenticate(
        localizedReason:
            l10n?.biometricReason ??
            'Unlock Glucosa to access your blood glucose records',
        authMessages: l10n != null
            ? BiometricService.createAuthMessages(l10n)
            : const [],
      );

      if (result == BiometricAuthResult.success) {
        AppLogger.info('Biometric unlock succeeded.', tag: 'BiometricShield');
        ref.read(biometricLockProvider.notifier).setLocked(false);
      } else if (result == BiometricAuthResult.canceled) {
        AppLogger.debug(
          'User canceled biometric prompt.',
          tag: 'BiometricShield',
        );
      } else if (BiometricService.isTerminalFailure(result) ||
          result == BiometricAuthResult.notAvailable) {
        AppLogger.warning(
          'Terminal biometric failure: ${result.name}. Offering recovery.',
          tag: 'BiometricShield',
        );
        if (!context.mounted) return;
        await _offerLockRecovery(context, l10n);
      } else {
        AppLogger.warning(
          'Biometric unlock failed: ${result.name}.',
          tag: 'BiometricShield',
        );
        if (context.mounted) {
          final message = result == BiometricAuthResult.lockedOut
              ? (l10n?.biometricLockedOut ?? 'Biometrics temporarily locked.')
              : (l10n?.biometricNotAvailable ??
                    'Biometric authentication is not available.');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: 'Unhandled exception in BiometricShieldScreen._handleUnlock',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUnlocking = false;
        });
      }
    }
  }

  Future<void> _offerLockRecovery(
    BuildContext context,
    AppLocalizations? l10n,
  ) async {
    final disable = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        scrollable: true,
        title: Text(
          l10n?.biometricLockRecoveryTitle ?? 'Biometrics Unavailable',
        ),
        content: SizedBox(
          width: 320,
          child: Text(
            l10n?.biometricLockRecoveryMessage ??
                'Biometric authentication cannot be completed because credentials are not set up or have been disabled. Would you like to disable the biometric lock to regain access?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n?.biometricLockRecoveryDisable ?? 'Disable Lock'),
          ),
        ],
      ),
    );

    if (disable == true && mounted) {
      AppLogger.info(
        'User confirmed disabling biometric lock via recovery.',
        tag: 'BiometricShield',
      );
      await ref
          .read(userProfileProvider.notifier)
          .updateBiometricLockEnabled(false);
      ref.read(biometricLockProvider.notifier).setLocked(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: l10n?.biometricUnlockTitle ?? 'Unlock Glucosa',
                  child: Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Semantics(
                  header: true,
                  child: Text(
                    l10n?.biometricUnlockTitle ?? 'Unlock Glucosa',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n?.biometricUnlockDescription ??
                      'Authentication required to protect your medical information.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(200, 48),
                  ),
                  onPressed: _isUnlocking ? null : () => _handleUnlock(context),
                  icon: const Icon(Icons.fingerprint),
                  label: Text(l10n?.biometricUnlockButton ?? 'Unlock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
