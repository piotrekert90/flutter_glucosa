import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/presentation/providers/glucose_reading_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGlucoseReadingRepository extends Mock
    implements GlucoseReadingRepository {}

final _testReading = GlucoseReading(
  id: 42,
  readingMgDl: 110,
  mealContext: MealContext.bedtime,
  createdAt: DateTime(2026, 10, 2, 22, 0),
);

ProviderContainer _makeContainer(MockGlucoseReadingRepository mock) {
  return ProviderContainer(
    overrides: [glucoseReadingRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  late MockGlucoseReadingRepository mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockGlucoseReadingRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('GlucoseReadingDetail - build()', () {
    test('watches reading by id and emits value', () async {
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => Stream.value(_testReading));

      container = _makeContainer(mockRepo);
      container.listen(glucoseReadingDetailProvider(42), (_, _) {});

      final result = await container.read(
        glucoseReadingDetailProvider(42).future,
      );

      expect(result, _testReading);
      verify(() => mockRepo.watchById(42)).called(1);
    });

    test('emits null when reading does not exist', () async {
      when(() => mockRepo.watchById(99)).thenAnswer((_) => Stream.value(null));

      container = _makeContainer(mockRepo);
      container.listen(glucoseReadingDetailProvider(99), (_, _) {});

      final result = await container.read(
        glucoseReadingDetailProvider(99).future,
      );

      expect(result, isNull);
      verify(() => mockRepo.watchById(99)).called(1);
    });

    test('cancels stream subscription when container is disposed', () async {
      final controller = StreamController<GlucoseReading?>();
      when(() => mockRepo.watchById(42)).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      container.listen(glucoseReadingDetailProvider(42), (_, _) {});
      controller.add(_testReading);
      await container.read(glucoseReadingDetailProvider(42).future);

      expect(controller.hasListener, isTrue);
      container.dispose();
      await Future.microtask(() {});

      expect(controller.hasListener, isFalse);
      await controller.close();
    });
  });
}
