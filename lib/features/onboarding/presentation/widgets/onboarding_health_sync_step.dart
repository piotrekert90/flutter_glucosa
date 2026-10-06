import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/integrations/health/health_metric.dart';
import '../../../../core/integrations/health/health_service_provider.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/widgets/components/health_connect_install_dialog.dart';
import '../providers/onboarding_notifier.dart';

/// Fifth onboarding step requesting platform health store synchronization.
///
/// Requests native permissions live and records the choice in the draft.
/// The step is skippable — advancing works regardless of the toggle state.
class OnboardingHealthSyncStep extends ConsumerWidget {
  /// Creates an [OnboardingHealthSyncStep].
  const OnboardingHealthSyncStep({super.key});

  String _platformLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Platform.isIOS
        ? l10n.healthSyncAppleHealth
        : l10n.healthSyncHealthConnect;
  }

  Future<void> _toggle(BuildContext context, WidgetRef ref, bool enable) async {
    final l10n = AppLocalizations.of(context)!;
    final notifier = ref.read(onboardingProvider.notifier);
    if (!enable) {
      notifier.setHealthSyncEnabled(false);
      return;
    }

    final service = ref.read(healthServiceProvider);
    if (!await service.isHealthApiAvailable()) {
      if (!context.mounted) return;
      if (Platform.isAndroid) {
        await HealthConnectInstallDialog.show(context);
      } else {
        AppSnackBar.show(
          context,
          message: l10n.healthSyncUnavailable,
          type: SnackBarType.error,
        );
      }
      return;
    }

    if (!await service.requestPermissions({HealthMetric.bloodGlucose})) {
      if (!context.mounted) return;
      AppSnackBar.show(
        context,
        message: l10n.healthSyncNoPermissions,
        type: SnackBarType.error,
      );
      return;
    }
    notifier.setHealthSyncEnabled(true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final enabled = ref.watch(
      onboardingProvider.select((draft) => draft.healthSyncEnabled),
    );
    final platform = _platformLabel(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.favorite_outline,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingHealthTitle(platform),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingHealthSubtitle(platform),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SwitchListTile.adaptive(
            title: Text(l10n.onboardingHealthEnable),
            value: enabled,
            onChanged: (value) => _toggle(context, ref, value),
          ),
        ],
      ),
    );
  }
}
