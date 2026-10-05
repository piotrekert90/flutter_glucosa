import 'dart:io';

import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/data/models/glucose_reading_model.dart';
import 'package:flutter_glucosa/features/glucose/data/repositories/glucose_reading_repository_impl.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

/// End-to-end persistence coverage using a real on-disk Isar instance.
///
/// Unlike the mock-based repository tests, this suite exercises the actual
/// Isar engine: write transactions, reactive watch streams, indexed range
/// queries, and deletion. Requires the platform Isar core binary
/// (bundled via `isar_community_flutter_libs` locally and fetched as
/// `libisar.so` with `LD_LIBRARY_PATH` set in CI).
void main() {
  late Directory tempDir;
  late Isar isar;
  late GlucoseReadingRepositoryImpl repository;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('isar_persistence_test');
    isar = await Isar.open([
      GlucoseReadingModelSchema,
    ], directory: tempDir.path);
    repository = GlucoseReadingRepositoryImpl(isar);
  });

  tearDown(() async {
    isar.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('persists, watches, range-queries, and deletes a reading', () async {
    final createdAt = DateTime(2026, 1, 10, 8);
    final (saved, saveFailure) = await repository.add(
      GlucoseReading(
        readingMgDl: 120,
        mealContext: MealContext.fasting,
        createdAt: createdAt,
      ),
    );
    expect(saved, isTrue, reason: saveFailure?.message);

    final watched = await repository.watchAll().first;
    expect(watched, hasLength(1));
    expect(watched.single.readingMgDl, 120);

    expect(await repository.getLatest(), isNotNull);

    final inRange = await repository.getByDateRange(
      DateTime(2026, 1, 1),
      DateTime(2026, 2, 1),
    );
    expect(inRange, hasLength(1));

    final outOfRange = await repository.getByDateRange(
      DateTime(2025, 1, 1),
      DateTime(2025, 2, 1),
    );
    expect(outOfRange, isEmpty);

    final (deleted, deleteFailure) = await repository.delete(watched.single.id);
    expect(deleted, isTrue, reason: deleteFailure?.message);
    expect(await repository.getAll(), isEmpty);
  });
}
