import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/integrations/health/health_service_provider.dart';
import '../../../../../l10n/app_localizations.dart';

/// Dialog prompting the user to install Google Health Connect from Google Play.
///
/// Shown on Android devices where the Health Connect SDK is unavailable.
class HealthConnectInstallDialog extends ConsumerWidget {
  /// Creates a [HealthConnectInstallDialog].
  const HealthConnectInstallDialog({super.key});

  /// Displays the dialog.
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const HealthConnectInstallDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: Text(l10n.healthConnectRequiredTitle),
      content: SizedBox(
        width: 320,
        child: Text(l10n.healthConnectRequiredSubtitle),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ref.read(healthServiceProvider).installHealthConnect();
          },
          child: Text(l10n.installFromPlayStore),
        ),
      ],
    );
  }
}
