/// String helper extensions for presentation text formatting.
extension CapitalizeX on String {
  /// Returns a copy of this string with its first letter converted to uppercase.
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
