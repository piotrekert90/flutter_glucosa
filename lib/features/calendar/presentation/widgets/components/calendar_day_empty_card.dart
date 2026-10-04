import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_routes.dart';
import '../../../../../l10n/app_localizations.dart';

/// Empty state card for a selected calendar day with zero recorded readings.
class CalendarDayEmptyCard extends StatelessWidget {
  /// The selected calendar date with zero readings.
  final DateTime selectedDate;

  /// Creates a [CalendarDayEmptyCard].
  const CalendarDayEmptyCard({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            ExcludeSemantics(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: colorScheme.secondaryContainer,
                child: Icon(
                  Icons.event_busy_outlined,
                  size: 36,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noEntriesForDate,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noEntriesForDateSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => context.push(AppRoute.addGlucose.path),
                icon: const Icon(Icons.add),
                label: Text(l10n.addReading),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
