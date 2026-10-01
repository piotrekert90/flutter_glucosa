import 'dart:async';

import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';
import 'package:flutter_glucosa/features/blood_pressure/presentation/providers/latest_blood_pressure_reading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloodPressureReadingRepository extends Mock
    implements BloodPressureReadingRepository {}

void main() {
  late MockBloodPressureReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = BloodPressureReading(
    id: 1,
    systolicMmHg: 118,
    diastolicMmHg: 76,
    createdAt: DateTime(2026, 10, 2, 8, 0),
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

  group('latestBloodPressureReadingProvider', () {
    test('emits latest reading from repository watchLatest() stream', () async {
      when(
        () => mockRepo.watchLatest(),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(latestBloodPressureReadingProvider, (_, _) {});
      final state = await container.read(
        latestBloodPressureReadingProvider.future,
      );

      expect(state, equals(testReading));
      verify(() => mockRepo.watchLatest()).called(1);
    });

    test('emits null when no readings exist', () async {
      when(() => mockRepo.watchLatest()).thenAnswer((_) => Stream.value(null));

      container.listen(latestBloodPressureReadingProvider, (_, _) {});
      final state = await container.read(
        latestBloodPressureReadingProvider.future,
      );

      expect(state, isNull);
    });
  });
}
