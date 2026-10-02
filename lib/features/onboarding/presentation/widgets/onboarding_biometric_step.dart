import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/integrations/biometrics/biometric_service.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// Seventh onboarding step offering biometric app lock.
///
/// Enabling authenticates the user first and records the choice in the draft
/// only on success. The step is skippable — advancing works regardless.
class OnboardingBiometricStep extends ConsumerStatefulWidget {
  /// Creates an [OnboardingBiometricStep].
  const OnboardingBiometricStep({super.key});

  @override
  ConsumerState<OnboardingBiometricStep> createState() =>
      _OnboardingBiometricStepState();
}

class _OnboardingBiometricStepState
    extends ConsumerState<OnboardingBiometricStep> {
  /// Whether the device exposes authentication; true until the async check completes.
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final available = await BiometricService.instance.canAuthenticate();
    if (mounted) setState(() => _isAvailable = available);
  }

  Future<void> _toggle(bool enable) async {
    final notifier = ref.read(onboardingProvider.notifier);
    if (!enable) {
      notifier.setBiometricEnabled(false);
      return;
    }

    final l10n = AppLocalizations.of(context);
    if (!await BiometricService.instance.canAuthenticate()) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message:
            l10n?.biometricNotAvailable ??
            'Biometric authentication is not available on this device',
        type: SnackBarType.error,
      );
      return;
    }

    final result = await BiometricService.instance.authenticate(
      localizedReason:
          l10n?.biometricReason ??
          'Unlock Glucosa to access your blood glucose records',
      authMessages: l10n != null
          ? BiometricService.createAuthMessages(l10n)
          : const [],
    );
    if (!mounted) return;
    if (result == BiometricAuthResult.success) {
      notifier.setBiometricEnabled(true);
    } else if (result != BiometricAuthResult.canceled) {
      AppSnackBar.show(
        context,
        message:
            l10n?.biometricNotAvailable ?? 'Biometric authentication failed',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final enabled = ref.watch(
      onboardingProvider.select((draft) => draft.biometricEnabled),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(Icons.fingerprint, size: 72, color: theme.colorScheme.primary),
          const SizedBox(height: 24),
          Text(
            l10n?.onboardingBiometricTitle ?? 'Protect with biometrics',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.onboardingBiometricSubtitle ??
                'Require Face ID, Touch ID, or fingerprint to open Glucosa.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SwitchListTile.adaptive(
            title: Text(l10n?.onboardingBiometricEnable ?? 'Enable app lock'),
            value: enabled && _isAvailable,
            onChanged: _isAvailable ? _toggle : null,
          ),
          if (!_isAvailable) ...[
            const SizedBox(height: 8),
            Text(
              l10n?.biometricNotAvailable ??
                  'Biometric authentication is not available on this device',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
