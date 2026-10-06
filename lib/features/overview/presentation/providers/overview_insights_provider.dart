import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../glucose/presentation/providers/glucose_reading_list_notifier.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../../statistics/domain/entities/milestone.dart';
import '../../../statistics/domain/services/habits_calculator.dart';
import '../../../statistics/domain/services/milestone_calculator.dart';

part 'overview_insights_provider.g.dart';

/// Aggregated habit and milestone insights rendered by the overview dashboard.
class OverviewInsights {
  /// Current consecutive-day logging streak.
  final int streak;

  /// Best historical consecutive-day logging streak.
  final int bestStreak;

  /// Monthly logging compliance percentage (0-100).
  final int compliancePct;

  /// Evaluated milestones for the current readings and target range.
  final List<Milestone> milestones;

  /// Creates an [OverviewInsights].
  const OverviewInsights({
    required this.streak,
    required this.bestStreak,
    required this.compliancePct,
    required this.milestones,
  });
}

/// Future provider computing overview habit/milestone insights.
///
/// Returns `null` when no readings exist so the dashboard can collapse
/// the insights section. Keeps aggregation logic out of the widget build.
@riverpod
Future<OverviewInsights?> overviewInsights(Ref ref) async {
  final readings = await ref.watch(glucoseReadingListProvider.future);
  if (readings.isEmpty) {
    return null;
  }
  final profile = await ref.watch(userProfileProvider.future);
  return OverviewInsights(
    streak: HabitsCalculator.calculateStreak(readings),
    bestStreak: HabitsCalculator.calculateBestStreak(readings),
    compliancePct: HabitsCalculator.calculateMonthlyCompliance(readings),
    milestones: MilestoneCalculator.evaluateAll(
      readings: readings,
      targetRange: profile.targetRange,
    ),
  );
}
