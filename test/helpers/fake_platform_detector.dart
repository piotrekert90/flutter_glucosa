import 'package:flutter_glucosa/core/integrations/health/platform_detector.dart';

/// Test [PlatformDetector] with fixed platform flags.
class FakePlatformDetector implements PlatformDetector {
  /// Whether to report Android.
  final bool android;

  /// Whether to report iOS.
  final bool ios;

  /// Creates a [FakePlatformDetector] reporting [android] and [ios].
  const FakePlatformDetector({this.android = false, this.ios = false});

  @override
  bool get isAndroid => android;
  @override
  bool get isIOS => ios;
}
