/// Pure helpers for parsing user-entered decimal numbers.
///
/// Accepts both `.` and `,` decimal separators so input behaves identically
/// across locales and dialogs.
abstract final class DecimalParser {
  /// Parses [raw] into a double, or returns `null` when invalid.
  ///
  /// Trims surrounding whitespace and normalizes comma separators to dots
  /// before delegating to [double.tryParse].
  static double? parse(String raw) {
    final normalized = raw.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }
}
