import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/add_reading_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../glucose/presentation/providers/estimated_hba1c_provider.dart';
import '../../../glucose/presentation/providers/glucose_reading_list_notifier.dart';
import '../../../glucose/presentation/providers/latest_glucose_reading_provider.dart';
import '../../../glucose/presentation/widgets/glucose_reading_card.dart';
import '../../../settings/domain/entities/user_profile.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../../statistics/presentation/utils/summary_share_coordinator.dart';
import '../../../statistics/presentation/widgets/sections/habits_activity_card.dart';
import '../../../statistics/presentation/widgets/sections/milestones_card.dart';
import '../../../statistics/presentation/widgets/sections/period_comparison_card.dart';
import '../providers/overview_insights_provider.dart';
import '../widgets/metric_trend_card.dart';
import '../widgets/daily_tip_card.dart';
import '../widgets/today_shimmer_skeleton.dart';
import '../widgets/widget_promo_card.dart';

/// Main dashboard overview screen displaying latest readings, health summaries, and quick actions.
class OverviewScreen extends ConsumerWidget {
  /// Creates the overview dashboard screen.
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final latestReadingAsync = ref.watch(latestGlucoseReadingProvider);
    final readingsAsync = ref.watch(glucoseReadingListProvider);
    final estimatedHbA1cAsync = ref.watch(estimatedHbA1cProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: l10n.navOverview,
        actions: [
          if (readingsAsync.value?.isNotEmpty ?? false)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: l10n.shareDoctorSummaryTooltip,
              onPressed: () {
                final readings = readingsAsync.value;
                if (readings == null || readings.isEmpty) return;
                final profile = profileAsync.value ?? const UserProfile();
                SummaryShareCoordinator.shareDoctorSummary(
                  context,
                  readings: readings,
                  profile: profile,
                );
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addReading,
        onPressed: () => showAddReadingBottomSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: ClampedLayout(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(latestGlucoseReadingProvider);
            ref.invalidate(glucoseReadingListProvider);
            ref.invalidate(estimatedHbA1cProvider);
            ref.invalidate(userProfileProvider);
            ref.invalidate(overviewInsightsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                      onTap: () => context.pushNamed(
                        AppRoute.editGlucose.name,
                        pathParameters: {'id': '${reading.id}'},
                      ),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: TodayShimmerSkeleton(),
                  ),
                  error: (_, _) => AppErrorView(
                    message: l10n.genericError,
                    onRetry: () {
                      ref.invalidate(latestGlucoseReadingProvider);
                      ref.invalidate(glucoseReadingListProvider);
                    },
                  ),
                ),
                const SizedBox(height: 20),

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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

                Text(
                  l10n.chartTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const MetricTrendCard(),
                const SizedBox(height: 20),

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

                readingsAsync.when(
                  data: (readings) {
                    if (readings.isEmpty) return const SizedBox.shrink();
                    final profile = profileAsync.value ?? const UserProfile();
                    final insightsAsync = ref.watch(overviewInsightsProvider);

                    return insightsAsync.when(
                      data: (insights) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          PeriodComparisonCard(
                            readings: readings,
                            unit: profile.preferredGlucoseUnit,
                            targetRange: profile.targetRange,
                          ),
                          if (insights != null) ...[
                            const SizedBox(height: 20),
                            HabitsActivityCard(
                              streak: insights.streak,
                              bestStreak: insights.bestStreak,
                              compliancePct: insights.compliancePct,
                            ),
                            const SizedBox(height: 20),
                            MilestonesCard(milestones: insights.milestones),
                          ],
                          const SizedBox(height: 20),
                          const WidgetPromoCard(),
                        ],
                      ),
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
                const DailyTipCard(),
                // Clearance for the end-float FAB so trailing content
                // (e.g. Period Comparison) is never obscured.
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
