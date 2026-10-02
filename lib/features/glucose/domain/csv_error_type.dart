/// Categorized failure modes when parsing or analyzing CSV glucose files.
enum CsvErrorType {
  /// File exceeds maximum allowed size.
  fileTooLarge,

  /// File contains unparseable or corrupted CSV structure.
  invalidFormat,

  /// File contains no valid glucose records.
  noEntries,
}
