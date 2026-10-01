import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/hba1c/domain/repositories/hba1c_reading_repository.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/providers/hba1c_reading_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHbA1cReadingRepository extends Mock
    implements HbA1cReadingRepository {}

final _testReading1 = HbA1cReading(
  id: 1,
  readingPercentage: 6.2,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Lab test',
);

final _testReading2 = HbA1cReading(
  id: 2,
  readingPercentage: 6.8,
  createdAt: DateTime(2026, 7, 2, 9, 30),
);

ProviderContainer _makeContainer(MockHbA1cReadingRepository mock) {
  return ProviderContainer(
    overrides: [hbA1cReadingRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  late MockHbA1cReadingRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_testReading1);
  });

  setUp(() {
    mockRepo = MockHbA1cReadingRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('HbA1cReadingList - build()', () {
    test('emits readings list from repository watchAll() stream', () async {
      when(
        () => mockRepo.watchAll(),
      ).thenAnswer((_) => Stream.value([_testReading1, _testReading2]));

      container = _makeContainer(mockRepo);
      container.listen(hbA1cReadingListProvider, (_, _) {});

      final state = await container.read(hbA1cReadingListProvider.future);
      expect(state, equals([_testReading1, _testReading2]));
    });

    test('updates state when new event is added to stream', () async {
      final controller = StreamController<List<HbA1cReading>>.broadcast();
      when(() => mockRepo.watchAll()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      final states = <AsyncValue<List<HbA1cReading>>>[];
      container.listen(
        hbA1cReadingListProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      controller.add([_testReading1]);
      await container.read(hbA1cReadingListProvider.future);

      controller.add([_testReading2, _testReading1]);
      await Future.microtask(() {});

      final state = container.read(hbA1cReadingListProvider);
      expect(state, isA<AsyncData<List<HbA1cReading>>>());
      expect(state.value, [_testReading2, _testReading1]);

      await controller.close();
    });
  });

  group('HbA1cReadingList - CRUD operations', () {
    test('addReading delegates to repository.add()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.add(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(hbA1cReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.add(_testReading1)).called(1);
    });

    test('updateReading delegates to repository.update()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.update(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(hbA1cReadingListProvider.notifier);

      final result = await notifier.updateReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.update(_testReading1)).called(1);
    });

    test('deleteReading delegates to repository.delete()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.delete(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(hbA1cReadingListProvider.notifier);

      final result = await notifier.deleteReading(1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.delete(1)).called(1);
    });

    test('returns failure record when repository operation fails', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(
        () => mockRepo.add(any()),
      ).thenAnswer((_) async => (false, const DatabaseFailure('Disk full')));

      container = _makeContainer(mockRepo);
      final notifier = container.read(hbA1cReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isFalse);
      expect(result.$2, isA<DatabaseFailure>());
      expect(result.$2?.message, 'Disk full');
    });
  });
}
