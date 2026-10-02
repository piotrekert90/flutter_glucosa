/// Rotating evidence-based diabetes self-care tips.
///
/// Selects one tip per calendar day by cycling through [tipCount] entries,
/// so every user sees the same tip on a given date. Localized tip texts
/// live in the ARB catalog as `dailyTip1` … `dailyTip{tipCount}`.
abstract final class DailyTipProvider {
  /// Total number of rotating tips available.
  static const int tipCount = 14;

  /// Returns the zero-based tip index for [date].
  static int indexFor(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return dayOfYear % tipCount;
  }
}
