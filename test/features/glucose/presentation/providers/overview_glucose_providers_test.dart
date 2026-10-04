import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/presentation/providers/estimated_hba1c_provider.dart';
import 'package:flutter_glucosa/features/glucose/presentation/providers/latest_glucose_reading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGlucoseReadingRepository extends Mock
    implements GlucoseReadingRepository {}

final _fixedNow = DateTime(2026, 10, 4, 12, 0);

final _reading1 = GlucoseReading(
  id: 1,
  readingMgDl: 100,
  mealContext: MealContext.fasting,
  createdAt: _fixedNow.subtract(const Duration(days: 10)),
);

final _reading2 = GlucoseReading(
  id: 2,
  readingMgDl: 154,
  mealContext: MealContext.afterBreakfast,
  createdAt: _fixedNow.subtract(const Duration(days: 5)),
);

final _reading3 = GlucoseReading(
  id: 3,
  readingMgDl: 127,
  mealContext: MealContext.beforeDinner,
  createdAt: _fixedNow.subtract(const Duration(days: 1)),
);

final _oldReading = GlucoseReading(
  id: 4,
  readingMgDl: 250,
  mealContext: MealContext.bedtime,
  createdAt: _fixedNow.subtract(const Duration(days: 95)),
);

void main() {
  late MockGlucoseReadingRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockGlucoseReadingRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('latestGlucoseReadingProvider', () {
    test('emits latest reading from repository watchLatest() stream', () async {
      when(
        () => mockRepo.watchLatest(),
      ).thenAnswer((_) => Stream.value(_reading2));

      container = ProviderContainer(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      container.listen(latestGlucoseReadingProvider, (_, _) {});

      final result = await container.read(latestGlucoseReadingProvider.future);

      expect(result, _reading2);
      verify(() => mockRepo.watchLatest()).called(1);
    });

    test('emits null when no readings exist', () async {
      when(() => mockRepo.watchLatest()).thenAnswer((_) => Stream.value(null));

      container = ProviderContainer(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      container.listen(latestGlucoseReadingProvider, (_, _) {});

      final result = await container.read(latestGlucoseReadingProvider.future);

      expect(result, isNull);
    });

    test('cancels stream subscription when disposed', () async {
      final controller = StreamController<GlucoseReading?>();
      when(() => mockRepo.watchLatest()).thenAnswer((_) => controller.stream);

      container = ProviderContainer(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      container.listen(latestGlucoseReadingProvider, (_, _) {});
      controller.add(_reading1);
      await container.read(latestGlucoseReadingProvider.future);

      expect(controller.hasListener, isTrue);
      container.dispose();
      await Future.microtask(() {});

      expect(controller.hasListener, isFalse);
      await controller.close();
    });
  });

  group('estimatedHbA1cProvider', () {
    test('returns null when readings list is empty', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => Stream.value([]));

      container = ProviderContainer(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(mockRepo),
          estimatedHbA1cClockProvider.overrideWithValue(_fixedNow),
        ],
      );
      container.listen(estimatedHbA1cProvider, (_, _) {});

      final result = await container.read(estimatedHbA1cProvider.future);

      expect(result, isNull);
    });

    test(
      'returns null when fewer than 3 readings exist in the 90-day window',
      () async {
        when(
          () => mockRepo.watchAll(),
        ).thenAnswer((_) => Stream.value([_reading1, _reading2]));

        container = ProviderContainer(
          overrides: [
            glucoseReadingRepositoryProvider.overrideWithValue(mockRepo),
            estimatedHbA1cClockProvider.overrideWithValue(_fixedNow),
          ],
        );
        container.listen(estimatedHbA1cProvider, (_, _) {});

        final result = await container.read(estimatedHbA1cProvider.future);

        expect(result, isNull);
      },
    );

    test(
      'calculates correct estimated HbA1c excluding readings older than 90 days',
      () async {
        // Readings: 100, 154, 127 within 90 days. _oldReading (250, 95 days old) is excluded.
        // Average of 100, 154, and 127 = 381 / 3 = 127 mg/dL
        // ADAG formula: (127 + 46.7) / 28.7 = 173.7 / 28.7 ≈ 6.05%
        when(() => mockRepo.watchAll()).thenAnswer(
          (_) => Stream.value([_reading1, _reading2, _reading3, _oldReading]),
        );

        container = ProviderContainer(
          overrides: [
            glucoseReadingRepositoryProvider.overrideWithValue(mockRepo),
            estimatedHbA1cClockProvider.overrideWithValue(_fixedNow),
          ],
        );
        container.listen(estimatedHbA1cProvider, (_, _) {});

        final result = await container.read(estimatedHbA1cProvider.future);

        expect(result, isNotNull);
        expect(result!, closeTo(6.05, 0.05));
      },
    );
  });
}
