import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/utils/glucose_converter.dart';
import 'glucose_reading_list_notifier.dart';

part 'estimated_hba1c_provider.g.dart';

/// Evaluation window in days corresponding to red blood cell turnover.
const int estimatedHbA1cWindowDays = 90;

/// Minimum number of glucose measurements within the 90-day window required to estimate HbA1c.
const int minReadingsForEstimatedHbA1c = 3;

/// Clock provider supplying the current timestamp, overridable in tests.
@riverpod
DateTime estimatedHbA1cClock(Ref ref) => DateTime.now();

/// Future provider calculating estimated HbA1c percentage from the 90-day average of glucose readings.
///
/// Returns `null` if fewer than [minReadingsForEstimatedHbA1c] readings exist within the last 90 days.
@riverpod
Future<double?> estimatedHbA1c(Ref ref) async {
  final readings = await ref.watch(glucoseReadingListProvider.future);
  if (readings.isEmpty) {
    return null;
  }

  final now = ref.watch(estimatedHbA1cClockProvider);
  final cutoff = now.subtract(const Duration(days: estimatedHbA1cWindowDays));
  final recentReadings = readings
      .where((reading) => reading.createdAt.isAfter(cutoff))
      .toList();

  if (recentReadings.length < minReadingsForEstimatedHbA1c) {
    return null;
  }

  final totalMgDl = recentReadings.fold<int>(
    0,
    (acc, reading) => acc + reading.readingMgDl,
  );
  final averageMgDl = totalMgDl / recentReadings.length;
  return GlucoseConverter.glucoseToEstimatedHbA1c(averageMgDl);
}
