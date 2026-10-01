import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/blood_pressure/data/models/blood_pressure_reading_model.dart';
import '../../features/cholesterol/data/models/cholesterol_reading_model.dart';
import '../../features/glucose/data/models/glucose_reading_model.dart';
import '../../features/hba1c/data/models/hba1c_reading_model.dart';
import '../../features/ketones/data/models/ketone_reading_model.dart';
import '../../features/settings/data/models/user_profile_model.dart';

part 'isar_provider.g.dart';

/// Asynchronously initializes and provides the singleton [Isar] database instance.
@Riverpod(keepAlive: true)
Future<Isar> isarDb(Ref ref) async {
  final directory = await getApplicationDocumentsDirectory();
  final isar =
      Isar.getInstance() ??
      await Isar.open([
        UserProfileModelSchema,
        GlucoseReadingModelSchema,
        HbA1cReadingModelSchema,
        BloodPressureReadingModelSchema,
        KetoneReadingModelSchema,
        CholesterolReadingModelSchema,
      ], directory: directory.path);
  ref.onDispose(() {
    if (isar.isOpen) {
      isar.close();
    }
  });
  return isar;
}

/// Provides the synchronous [Isar] database instance for repositories.
///
/// Pre-warmed during application startup by `appStartupProvider`.
@Riverpod(keepAlive: true)
Isar isar(Ref ref) {
  return ref.watch(isarDbProvider).requireValue;
}
