import 'dart:io';

/// Allows platform-specific behaviour to be mocked in tests without modifying global state.
abstract class PlatformDetector {
  /// Whether the app is running on Android.
  bool get isAndroid;

  /// Whether the app is running on iOS.
  bool get isIOS;
}

/// Default [PlatformDetector] implementation backed by `dart:io`.
class NativePlatformDetector implements PlatformDetector {
  @override
  bool get isAndroid => Platform.isAndroid;
  @override
  bool get isIOS => Platform.isIOS;
}
