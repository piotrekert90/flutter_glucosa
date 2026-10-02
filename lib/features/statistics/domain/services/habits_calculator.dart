import '../../../glucose/domain/entities/glucose_reading.dart';

/// Pure domain service calculating logging habit statistics such as current streak, best streak, and compliance rates.
class HabitsCalculator {
  const HabitsCalculator._();

  /// Calculates the current consecutive days logging streak relative to [now].
  ///
  /// A streak remains active if at least one reading was recorded today or yesterday.
  static int calculateStreak(List<GlucoseReading> readings, [DateTime? now]) {
    if (readings.isEmpty) return 0;

    final referenceDate = now ?? DateTime.now();
    final dates = readings
        .map(
          (r) => DateTime(r.createdAt.year, r.createdAt.month, r.createdAt.day),
        )
        .toSet();

    final todayDate = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    if (!dates.contains(todayDate) && !dates.contains(yesterdayDate)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = dates.contains(todayDate) ? todayDate : yesterdayDate;

    while (dates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return streak;
  }

  /// Calculates the best historical consecutive days logging streak.
  static int calculateBestStreak(List<GlucoseReading> readings) {
    if (readings.isEmpty) return 0;

    final dates =
        readings
            .map(
              (r) => DateTime(
                r.createdAt.year,
                r.createdAt.month,
                r.createdAt.day,
              ),
            )
            .toSet()
            .toList()
          ..sort((a, b) => a.compareTo(b));

    int best = 1;
    int current = 1;

    for (var i = 1; i < dates.length; i++) {
      final diff = dates[i].difference(dates[i - 1]).inDays;
      if (diff == 1) {
        current++;
        if (current > best) best = current;
      } else if (diff > 1) {
        current = 1;
      }
    }

    return best;
  }

  /// Calculates the overall compliance percentage (days logged vs total days since first reading).
  static int calculateTotalCompliance(
    List<GlucoseReading> readings, [
    DateTime? now,
  ]) {
    if (readings.isEmpty) return 0;

    final referenceDate = now ?? DateTime.now();
    final firstDate = readings
        .map((r) => r.createdAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);

    final today = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    final start = DateTime(firstDate.year, firstDate.month, firstDate.day);

    int totalDays = today.difference(start).inDays + 1;
    if (totalDays <= 0) totalDays = 1;

    final loggedDays = readings
        .map(
          (r) => DateTime(r.createdAt.year, r.createdAt.month, r.createdAt.day),
        )
        .toSet()
        .length;

    return ((loggedDays / totalDays) * 100).round().clamp(0, 100);
  }

  /// Calculates the compliance percentage for the current calendar month up to [now].
  static int calculateMonthlyCompliance(
    List<GlucoseReading> readings, [
    DateTime? now,
  ]) {
    if (readings.isEmpty) return 0;

    final referenceDate = now ?? DateTime.now();
    final daysInCurrentMonthElapsed = referenceDate.day;

    final loggedDaysThisMonth = readings
        .where(
          (r) =>
              r.createdAt.year == referenceDate.year &&
              r.createdAt.month == referenceDate.month &&
              r.createdAt.day <= referenceDate.day,
        )
        .map((r) => r.createdAt.day)
        .toSet()
        .length;

    if (daysInCurrentMonthElapsed <= 0) return 0;
    return ((loggedDaysThisMonth / daysInCurrentMonthElapsed) * 100)
        .round()
        .clamp(0, 100);
  }
}
