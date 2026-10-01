import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';
import 'package:flutter_glucosa/features/blood_pressure/presentation/providers/blood_pressure_reading_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloodPressureReadingRepository extends Mock
    implements BloodPressureReadingRepository {}

final _testReading1 = BloodPressureReading(
  id: 1,
  systolicMmHg: 120,
  diastolicMmHg: 80,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Home test',
);

final _testReading2 = BloodPressureReading(
  id: 2,
  systolicMmHg: 130,
  diastolicMmHg: 85,
  createdAt: DateTime(2026, 7, 2, 9, 30),
);

ProviderContainer _makeContainer(MockBloodPressureReadingRepository mock) {
  return ProviderContainer(
    overrides: [bloodPressureReadingRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  late MockBloodPressureReadingRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_testReading1);
  });

  setUp(() {
    mockRepo = MockBloodPressureReadingRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('BloodPressureReadingList - build()', () {
    test('emits readings list from repository watchAll() stream', () async {
      when(
        () => mockRepo.watchAll(),
      ).thenAnswer((_) => Stream.value([_testReading1, _testReading2]));

      container = _makeContainer(mockRepo);
      container.listen(bloodPressureReadingListProvider, (_, _) {});

      final state = await container.read(
        bloodPressureReadingListProvider.future,
      );
      expect(state, equals([_testReading1, _testReading2]));
    });

    test('updates state when new event is added to stream', () async {
      final controller =
          StreamController<List<BloodPressureReading>>.broadcast();
      when(() => mockRepo.watchAll()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      final states = <AsyncValue<List<BloodPressureReading>>>[];
      container.listen(
        bloodPressureReadingListProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      controller.add([_testReading1]);
      await container.read(bloodPressureReadingListProvider.future);

      controller.add([_testReading2, _testReading1]);
      await Future.microtask(() {});

      final state = container.read(bloodPressureReadingListProvider);
      expect(state, isA<AsyncData<List<BloodPressureReading>>>());
      expect(state.value, [_testReading2, _testReading1]);

      await controller.close();
    });
  });

  group('BloodPressureReadingList - CRUD operations', () {
    test('addReading delegates to repository.add()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.add(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(
        bloodPressureReadingListProvider.notifier,
      );

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.add(_testReading1)).called(1);
    });

    test('updateReading delegates to repository.update()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.update(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(
        bloodPressureReadingListProvider.notifier,
      );

      final result = await notifier.updateReading(_testReading1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.update(_testReading1)).called(1);
    });

    test('deleteReading delegates to repository.delete()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.delete(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(
        bloodPressureReadingListProvider.notifier,
      );

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
      final notifier = container.read(
        bloodPressureReadingListProvider.notifier,
      );

      final result = await notifier.addReading(_testReading1);

      expect(result.$1, isFalse);
      expect(result.$2, isA<DatabaseFailure>());
      expect(result.$2?.message, 'Disk full');
    });
  });
}
