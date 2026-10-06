/// Aggregated package license entry holding the package name and its license texts.
class PackageLicense {
  /// The name of the package.
  final String packageName;

  /// The paragraphs of license text for this package.
  final List<String> paragraphs;

  /// Creates a [PackageLicense].
  const PackageLicense({required this.packageName, required this.paragraphs});
}
