import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/presentation/providers/glucose_reading_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGlucoseReadingRepository extends Mock
    implements GlucoseReadingRepository {}

final _testReading1 = GlucoseReading(
  id: 1,
  readingMgDl: 120,
  mealContext: MealContext.beforeBreakfast,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Fasting test',
);

final _testReading2 = GlucoseReading(
  id: 2,
  readingMgDl: 145,
  mealContext: MealContext.afterBreakfast,
  createdAt: DateTime(2026, 10, 2, 9, 30),
);

ProviderContainer _makeContainer(MockGlucoseReadingRepository mock) {
  return ProviderContainer(
    overrides: [glucoseReadingRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  late MockGlucoseReadingRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_testReading1);
  });

  setUp(() {
    mockRepo = MockGlucoseReadingRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('GlucoseReadingList - build()', () {
    test('emits readings list from repository watchAll() stream', () async {
      when(
        () => mockRepo.watchAll(),
      ).thenAnswer((_) => Stream.value([_testReading1, _testReading2]));

      container = _makeContainer(mockRepo);
      container.listen(glucoseReadingListProvider, (_, _) {});

      final result = await container.read(glucoseReadingListProvider.future);

      expect(result, [_testReading1, _testReading2]);
      verify(() => mockRepo.watchAll()).called(1);
    });

    test('updates state when new event is added to stream', () async {
      final controller = StreamController<List<GlucoseReading>>();
      when(() => mockRepo.watchAll()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      container.listen(glucoseReadingListProvider, (_, _) {});

      controller.add([_testReading1]);
      await container.read(glucoseReadingListProvider.future);

      controller.add([_testReading2, _testReading1]);
      await Future.microtask(() {});

      final state = container.read(glucoseReadingListProvider);
      expect(state, isA<AsyncData<List<GlucoseReading>>>());
      expect(state.value, [_testReading2, _testReading1]);

      await controller.close();
    });
  });

  group('GlucoseReadingList - CRUD operations', () {
    setUp(() {
      when(
        () => mockRepo.watchAll(),
      ).thenAnswer((_) => Stream.value([_testReading1]));
    });

    test('addReading delegates to repository.add()', () async {
      when(() => mockRepo.add(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(glucoseReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.add(_testReading1)).called(1);
    });

    test('updateReading delegates to repository.update()', () async {
      when(() => mockRepo.update(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(glucoseReadingListProvider.notifier);

      final result = await notifier.updateReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.update(_testReading1)).called(1);
    });

    test('deleteReading delegates to repository.delete()', () async {
      when(() => mockRepo.delete(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(glucoseReadingListProvider.notifier);

      final result = await notifier.deleteReading(1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.delete(1)).called(1);
    });

    test('returns failure record when repository operation fails', () async {
      const failure = DatabaseFailure('Failed to write');
      when(() => mockRepo.add(any())).thenAnswer((_) async => (false, failure));

      container = _makeContainer(mockRepo);
      final notifier = container.read(glucoseReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isFalse);
      expect(result.$2, failure);
    });
  });

  group('GlucoseReadingList - Resource disposal', () {
    test('closes stream subscription when container is disposed', () async {
      final controller = StreamController<List<GlucoseReading>>();
      when(() => mockRepo.watchAll()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      container.listen(glucoseReadingListProvider, (_, _) {});
      controller.add([_testReading1]);
      await container.read(glucoseReadingListProvider.future);

      expect(controller.hasListener, isTrue);
      container.dispose();
      await Future.microtask(() {});

      expect(controller.hasListener, isFalse);
      await controller.close();
    });
  });
}
