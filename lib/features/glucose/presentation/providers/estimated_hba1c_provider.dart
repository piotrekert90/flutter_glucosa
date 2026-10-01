import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/utils/glucose_converter.dart';
import 'glucose_reading_list_notifier.dart';

part 'estimated_hba1c_provider.g.dart';

/// Future provider calculating estimated HbA1c percentage from the average of all glucose readings.
///
/// Returns `null` if no glucose readings exist in the database.
@riverpod
Future<double?> estimatedHbA1c(Ref ref) async {
  final readings = await ref.watch(glucoseReadingListProvider.future);
  if (readings.isEmpty) {
    return null;
  }

  final totalMgDl = readings.fold<int>(
    0,
    (acc, reading) => acc + reading.readingMgDl,
  );
  final averageMgDl = totalMgDl / readings.length;
  return GlucoseConverter.glucoseToEstimatedHbA1c(averageMgDl);
}
