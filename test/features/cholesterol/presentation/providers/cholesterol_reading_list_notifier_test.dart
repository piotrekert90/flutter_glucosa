import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/repositories/cholesterol_reading_repository.dart';
import 'package:flutter_glucosa/features/cholesterol/presentation/providers/cholesterol_reading_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCholesterolReadingRepository extends Mock
    implements CholesterolReadingRepository {}

final _testReading1 = CholesterolReading(
  id: 1,
  totalMgDl: 190,
  ldlMgDl: 110,
  hdlMgDl: 55,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Annual panel',
);

final _testReading2 = CholesterolReading(
  id: 2,
  totalMgDl: 210,
  ldlMgDl: 130,
  hdlMgDl: 48,
  createdAt: DateTime(2026, 7, 2, 9, 30),
);

ProviderContainer _makeContainer(MockCholesterolReadingRepository mock) {
  return ProviderContainer(
    overrides: [cholesterolReadingRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  late MockCholesterolReadingRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_testReading1);
  });

  setUp(() {
    mockRepo = MockCholesterolReadingRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('CholesterolReadingList - build()', () {
    test('emits readings list from repository watchAll() stream', () async {
      when(
        () => mockRepo.watchAll(),
      ).thenAnswer((_) => Stream.value([_testReading1, _testReading2]));

      container = _makeContainer(mockRepo);
      container.listen(cholesterolReadingListProvider, (_, _) {});

      final state = await container.read(cholesterolReadingListProvider.future);
      expect(state, equals([_testReading1, _testReading2]));
    });

    test('updates state when new event is added to stream', () async {
      final controller = StreamController<List<CholesterolReading>>.broadcast();
      when(() => mockRepo.watchAll()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      final states = <AsyncValue<List<CholesterolReading>>>[];
      container.listen(
        cholesterolReadingListProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      controller.add([_testReading1]);
      await container.read(cholesterolReadingListProvider.future);

      controller.add([_testReading2, _testReading1]);
      await Future.microtask(() {});

      final state = container.read(cholesterolReadingListProvider);
      expect(state, isA<AsyncData<List<CholesterolReading>>>());
      expect(state.value, [_testReading2, _testReading1]);

      await controller.close();
    });
  });

  group('CholesterolReadingList - CRUD operations', () {
    test('addReading delegates to repository.add()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.add(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(cholesterolReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.add(_testReading1)).called(1);
    });

    test('updateReading delegates to repository.update()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.update(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(cholesterolReadingListProvider.notifier);

      final result = await notifier.updateReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.update(_testReading1)).called(1);
    });

    test('deleteReading delegates to repository.delete()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.delete(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(cholesterolReadingListProvider.notifier);

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
      final notifier = container.read(cholesterolReadingListProvider.notifier);

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isFalse);
      expect(result.$2, isA<DatabaseFailure>());
      expect(result.$2?.message, 'Disk full');
    });
  });
}
