import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../l10n/app_localizations.dart';

/// Screen presenting chronological history of logged health readings and measurements.
class HistoryScreen extends StatelessWidget {
  /// Creates the history overview screen.
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.navHistory ?? 'History')),
      body: ClampedLayout(
        child: Center(
          child: Text(l10n?.historyComingSoon ?? 'History log coming soon'),
        ),
      ),
    );
  }
}
