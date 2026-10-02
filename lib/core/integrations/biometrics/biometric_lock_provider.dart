import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_lock_provider.g.dart';

/// State notifier managing whether the application is currently locked behind the biometric shield.
@Riverpod(keepAlive: true)
class BiometricLock extends _$BiometricLock {
  @override
  bool build() {
    return false;
  }

  /// Updates whether the application is currently locked behind the biometric shield.
  ///
  /// [isLocked] `true` mounts the biometric shield overlay; `false` unlocks the app.
  void setLocked(bool isLocked) {
    state = isLocked;
  }
}
