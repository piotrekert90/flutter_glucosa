import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../glucose/presentation/providers/estimated_hba1c_provider.dart';
import '../../../glucose/presentation/providers/latest_glucose_reading_provider.dart';
import '../../../glucose/presentation/widgets/glucose_reading_card.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';

/// Main dashboard overview screen displaying latest readings, health summaries, and quick actions.
class OverviewScreen extends ConsumerWidget {
  /// Creates the overview dashboard screen.
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final latestReadingAsync = ref.watch(latestGlucoseReadingProvider);
    final estimatedHbA1cAsync = ref.watch(estimatedHbA1cProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navOverview)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addGlucoseReading,
        onPressed: () => context.push(AppRoute.addGlucose.path),
        child: const Icon(Icons.add_rounded),
      ),
      body: ClampedLayout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Latest Reading Section
              Text(
                l10n.latestReading,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              latestReadingAsync.when(
                data: (reading) {
                  if (reading == null) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(
                              Icons.water_drop_outlined,
                              size: 40,
                              color: theme.colorScheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              l10n.noReadingsYet,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              icon: const Icon(Icons.add_rounded, size: 18),
                              label: Text(l10n.addGlucoseReading),
                              onPressed: () =>
                                  context.push(AppRoute.addGlucose.path),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return GlucoseReadingCard(
                    reading: reading,
                    onTap: () => context.push('/glucose/edit/${reading.id}'),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: AppLoadingIndicator(),
                  ),
                ),
                error: (_, _) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.genericError,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Estimated HbA1c Card
              estimatedHbA1cAsync.when(
                data: (a1c) {
                  if (a1c == null) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.estimatedHbA1c,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.science_outlined,
                                  color: theme.colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${a1c.toStringAsFixed(1)}%',
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                    ),
                                    Text(
                                      'Estimated average glycated hemoglobin',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),

              // Target Range Summary
              Text(
                l10n.targetRange,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.track_changes_rounded,
                          color: theme.colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profileAsync
                                      .value
                                      ?.targetRange
                                      .preset
                                      .displayName ??
                                  'ADA',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profileAsync.value?.targetRange.minMgDl ?? 70} - ${profileAsync.value?.targetRange.maxMgDl ?? 180} ${profileAsync.value?.preferredGlucoseUnit.displayName ?? 'mg/dL'}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
