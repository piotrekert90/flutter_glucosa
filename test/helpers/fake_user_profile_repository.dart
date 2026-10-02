import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/errors/result.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';

/// In-memory implementation of [UserProfileRepository] for use in tests.
class FakeUserProfileRepository implements UserProfileRepository {
  /// Creates a [FakeUserProfileRepository] seeded with [initialProfile] or defaults.
  FakeUserProfileRepository({UserProfile? initialProfile})
    : _profile = initialProfile ?? UserProfile.defaults();

  UserProfile _profile;
  final _streamController = StreamController<UserProfile>.broadcast();

  void _emit() {
    _streamController.add(_profile);
  }

  /// Releases internal stream resources. Call in [tearDown].
  void dispose() {
    _streamController.close();
  }

  @override
  Stream<UserProfile> watch() async* {
    yield _profile;
    yield* _streamController.stream;
  }

  @override
  Future<UserProfile> get() async {
    return _profile;
  }

  @override
  Future<CommandResult> save(UserProfile profile) async {
    _profile = profile;
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> updateThemeMode(UserThemeMode themeMode) async {
    _profile = _profile.copyWith(themeMode: themeMode);
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> updateNotificationsEnabled(bool isEnabled) async {
    _profile = _profile.copyWith(isNotificationsEnabled: isEnabled);
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> updateBiometricLockEnabled(bool isEnabled) async {
    _profile = _profile.copyWith(isBiometricLockEnabled: isEnabled);
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> updateFirstDayOfWeek(
    FirstDayOfWeek firstDayOfWeek,
  ) async {
    _profile = _profile.copyWith(firstDayOfWeek: firstDayOfWeek);
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> updateGlucoseUnit(GlucoseUnit unit) async {
    _profile = _profile.copyWith(preferredGlucoseUnit: unit);
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> updateTargetRange(GlucoseTargetRange range) async {
    _profile = _profile.copyWith(targetRange: range);
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> completeOnboarding() async {
    _profile = _profile.copyWith(isOnboardingCompleted: true);
    _emit();
    return (true, null);
  }

  @override
  Future<CommandResult> wipeAllData() async {
    _profile = UserProfile.defaults();
    _emit();
    return (true, null);
  }
}
