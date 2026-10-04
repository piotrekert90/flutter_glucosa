import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/integrations/health/health_metric.dart';
import '../../../../../core/integrations/health/health_service_provider.dart';
import '../../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../glucose/data/providers/glucose_health_sync_coordinator_provider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/user_profile.dart';
import '../../providers/user_profile_notifier.dart';
import 'custom_settings_tile.dart';
import 'custom_settings_toggle.dart';
import 'health_connect_install_dialog.dart';

/// Health synchronization section of the settings screen.
///
/// Renders the platform health store toggle (Apple Health on iOS,
/// Health Connect on Android) and a manual "Sync Now" action with the
/// last successful synchronization timestamp.
class HealthSyncSection extends ConsumerStatefulWidget {
  /// Current user profile snapshot.
  final UserProfile profile;

  /// Creates a [HealthSyncSection] for [profile].
  const HealthSyncSection({super.key, required this.profile});

  @override
  ConsumerState<HealthSyncSection> createState() => _HealthSyncSectionState();
}

class _HealthSyncSectionState extends ConsumerState<HealthSyncSection> {
  bool _isSyncing = false;

  String get _platformLabel =>
      Platform.isIOS ? 'Apple Health' : 'Health Connect';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = widget.profile;

    final lastSyncText = profile.lastHealthSyncAt != null
        ? (l10n.healthSyncLast(
            DateFormat.yMMMd(
              Localizations.localeOf(context).toString(),
            ).add_Hm().format(profile.lastHealthSyncAt!),
          ))
        : l10n.healthSyncNever;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomSettingsToggle(
          icon: Icons.favorite_outline,
          title: l10n.healthSyncTitle(_platformLabel),
          subtitle: l10n.healthSyncSubtitle(_platformLabel),
          value: profile.isHealthSyncEnabled,
          onChanged: (value) => _toggleHealthSync(value),
        ),
        if (profile.isHealthSyncEnabled) ...[
          CustomSettingsTile(
            icon: Icons.sync_rounded,
            title: l10n.healthSyncNow,
            valueText: lastSyncText,
            showChevron: !_isSyncing,
            onTap: _isSyncing ? null : () => _syncNow(),
          ),
          if (_isSyncing) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(minHeight: 2),
          ],
        ],
      ],
    );
  }

  Future<void> _toggleHealthSync(bool enable) async {
    if (!enable) {
      await ref
          .read(userProfileProvider.notifier)
          .updateHealthSyncEnabled(false);
      return;
    }

    if (!context.mounted) return;
    final l10n = AppLocalizations.of(context)!;

    final service = ref.read(healthServiceProvider);
    if (!await service.isHealthApiAvailable()) {
      if (!mounted) return;
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
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: l10n.healthSyncNoPermissions,
        type: SnackBarType.error,
      );
      return;
    }

    await ref.read(userProfileProvider.notifier).updateHealthSyncEnabled(true);
  }

  Future<void> _syncNow() async {
    setState(() => _isSyncing = true);
    try {
      final result = await ref
          .read(glucoseHealthSyncCoordinatorProvider)
          .sync(lastSyncTime: widget.profile.lastHealthSyncAt);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      if (result == null) {
        AppSnackBar.show(
          context,
          message: l10n.healthSyncNoPermissions,
          type: SnackBarType.error,
        );
        return;
      }
      await ref
          .read(userProfileProvider.notifier)
          .updateLastHealthSyncAt(DateTime.now());
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: l10n.healthSyncSuccess(
          result.importedCount,
          result.exportedCount,
        ),
        type: SnackBarType.success,
      );
    } finally {
      if (mounted) setState(() => _isSyncing = false);
    }
  }
}
