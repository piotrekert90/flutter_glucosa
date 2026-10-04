import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';

/// Modal dialog confirming irreversible erasure of all local health records and user settings.
class WipeDataDialog extends StatelessWidget {
  /// Creates a [WipeDataDialog].
  const WipeDataDialog({super.key});

  /// Displays the confirmation dialog and returns `true` if the wipe was confirmed.
  ///
  /// [context] The active build context.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => const WipeDataDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: Text(l10n.wipeDataConfirmTitle),
      content: SizedBox(width: 320, child: Text(l10n.wipeDataConfirmMessage)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: colorScheme.error),
          child: Text(l10n.wipeDataButton),
        ),
      ],
    );
  }
}
