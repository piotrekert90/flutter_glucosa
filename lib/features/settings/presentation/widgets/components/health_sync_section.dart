import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/user_profile.dart';
import '../../providers/health_sync_notifier.dart';
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
  String get _platformLabel {
    final l10n = AppLocalizations.of(context)!;
    return Platform.isIOS
        ? l10n.healthSyncAppleHealth
        : l10n.healthSyncHealthConnect;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = widget.profile;
    final isSyncing = ref.watch(healthSyncProvider).isSyncing;

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
            showChevron: !isSyncing,
            onTap: isSyncing ? null : () => _syncNow(),
          ),
          if (isSyncing) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(minHeight: 2),
          ],
        ],
      ],
    );
  }

  Future<void> _toggleHealthSync(bool enable) async {
    final readiness = await ref
        .read(healthSyncProvider.notifier)
        .setEnabled(enable);
    if (!mounted) return;
    if (readiness == HealthSyncReadiness.ready) return;
    final l10n = AppLocalizations.of(context)!;
    switch (readiness) {
      case HealthSyncReadiness.needsInstall:
        await HealthConnectInstallDialog.show(context);
      case HealthSyncReadiness.unavailable:
        AppSnackBar.show(
          context,
          message: l10n.healthSyncUnavailable,
          type: SnackBarType.error,
        );
      case HealthSyncReadiness.noPermissions:
        AppSnackBar.show(
          context,
          message: l10n.healthSyncNoPermissions,
          type: SnackBarType.error,
        );
      case HealthSyncReadiness.ready:
        break;
    }
  }

  Future<void> _syncNow() async {
    final result = await ref
        .read(healthSyncProvider.notifier)
        .syncNow(lastSyncAt: widget.profile.lastHealthSyncAt);
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
    AppSnackBar.show(
      context,
      message: l10n.healthSyncSuccess(
        result.importedCount,
        result.exportedCount,
      ),
      type: SnackBarType.success,
    );
  }
}
