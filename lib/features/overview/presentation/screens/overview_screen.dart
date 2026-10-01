import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../l10n/app_localizations.dart';

/// Main dashboard overview screen displaying latest readings, charts, and health summaries.
class OverviewScreen extends StatelessWidget {
  /// Creates the overview dashboard screen.
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.navOverview ?? 'Overview')),
      body: ClampedLayout(
        child: Center(
          child: Text(
            l10n?.overviewComingSoon ?? 'Overview dashboard coming soon',
          ),
        ),
      ),
    );
  }
}
