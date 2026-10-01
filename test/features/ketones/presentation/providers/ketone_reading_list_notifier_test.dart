import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/ketones/domain/repositories/ketone_reading_repository.dart';
import 'package:flutter_glucosa/features/ketones/presentation/providers/ketone_reading_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockKetoneReadingRepository extends Mock
    implements KetoneReadingRepository {}

final _testReading1 = KetoneReading(
  id: 1,
  readingMmolL: 0.4,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Fasting test',
);

final _testReading2 = KetoneReading(
  id: 2,
  readingMmolL: 1.2,
  createdAt: DateTime(2026, 7, 2, 9, 30),
);

ProviderContainer _makeContainer(MockKetoneReadingRepository mock) {
  return ProviderContainer(
    overrides: [ketoneReadingRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  late MockKetoneReadingRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_testReading1);
  });

  setUp(() {
    mockRepo = MockKetoneReadingRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('KetoneReadingList - build()', () {
    test('emits readings list from repository watchAll() stream', () async {
      when(
        () => mockRepo.watchAll(),
      ).thenAnswer((_) => Stream.value([_testReading1, _testReading2]));

      container = _makeContainer(mockRepo);
      container.listen(ketoneReadingListProvider, (_, _) {});

      final state = await container.read(ketoneReadingListProvider.future);
      expect(state, equals([_testReading1, _testReading2]));
    });

    test('updates state when new event is added to stream', () async {
      final controller = StreamController<List<KetoneReading>>.broadcast();
      when(() => mockRepo.watchAll()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      final states = <AsyncValue<List<KetoneReading>>>[];
      container.listen(
        ketoneReadingListProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      controller.add([_testReading1]);
      await container.read(ketoneReadingListProvider.future);

      controller.add([_testReading2, _testReading1]);
      await Future.microtask(() {});

      final state = container.read(ketoneReadingListProvider);
      expect(state, isA<AsyncData<List<KetoneReading>>>());
      expect(state.value, [_testReading2, _testReading1]);

      await controller.close();
    });
  });

  group('KetoneReadingList - CRUD operations', () {
    test('addReading delegates to repository.add()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.add(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(ketoneReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.add(_testReading1)).called(1);
    });

    test('updateReading delegates to repository.update()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.update(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(ketoneReadingListProvider.notifier);

      final result = await notifier.updateReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.update(_testReading1)).called(1);
    });

    test('deleteReading delegates to repository.delete()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.delete(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(ketoneReadingListProvider.notifier);

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
      final notifier = container.read(ketoneReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isFalse);
      expect(result.$2, isA<DatabaseFailure>());
      expect(result.$2?.message, 'Disk full');
    });
  });
}
