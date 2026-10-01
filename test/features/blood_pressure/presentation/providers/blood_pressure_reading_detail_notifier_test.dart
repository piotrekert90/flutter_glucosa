import 'dart:async';

import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';
import 'package:flutter_glucosa/features/blood_pressure/presentation/providers/blood_pressure_reading_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloodPressureReadingRepository extends Mock
    implements BloodPressureReadingRepository {}

void main() {
  late MockBloodPressureReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = BloodPressureReading(
    id: 42,
    systolicMmHg: 120,
    diastolicMmHg: 80,
    createdAt: DateTime(2026, 10, 2, 10, 0),
  );

  setUp(() {
    mockRepo = MockBloodPressureReadingRepository();
    container = ProviderContainer(
      overrides: [
        bloodPressureReadingRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('BloodPressureReadingDetail', () {
    test('build() watches reading by id and emits value', () async {
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(bloodPressureReadingDetailProvider(42), (_, _) {});
      final state = await container.read(
        bloodPressureReadingDetailProvider(42).future,
      );

      expect(state, equals(testReading));
      verify(() => mockRepo.watchById(42)).called(1);
    });

    test('build() emits null when reading does not exist', () async {
      when(() => mockRepo.watchById(99)).thenAnswer((_) => Stream.value(null));

      container.listen(bloodPressureReadingDetailProvider(99), (_, _) {});
      final state = await container.read(
        bloodPressureReadingDetailProvider(99).future,
      );

      expect(state, isNull);
    });
  });
}
