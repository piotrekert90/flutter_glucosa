# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2026-09-30

### Release v1.4.0 — Android 15 Alignment, Store Rating & Modular DX Tooling

Targeted milestone release modernizing Android 15 system bar behaviors, future-proofing SDK 37 compilation, adding in-app store review routing, streamlining strict linter rules, and introducing modular screenshot test automation.

Compare: [`v1.3.0...v1.4.0`](https://github.com/EKER-Studio/flutter_riverpod_template/compare/v1.3.0...v1.4.0)

#### 🚀 Highlights & Features

* **Android 15 & Gradle Modernization:**
  * Configured `compileSdk = maxOf(flutter.compileSdkVersion, 37)` in `android/app/build.gradle.kts` to ensure out-of-the-box compatibility with modern AndroidX plugins and SDK 37 requirements.
  * Configured R8 full mode, resource optimizations, and non-transitive R class generation (`android.enableR8.fullMode=true`, `android.enableResourceOptimizations=true`, `android.nonTransitiveRClass=true`) in `android/gradle.properties`.
  * Removed deprecated `android:windowLayoutInDisplayCutoutMode="shortEdges"` across all `styles.xml` themes to ensure seamless native edge-to-edge system bar handling on Android 15 (API 35).

* **Linter, Code Quality & Const Optimization:**
  * Cleaned up 20+ redundant lint rules in `analysis_options.yaml` already included by `package:flutter_lints/flutter.yaml`.
  * Enforced strict const optimizations (`prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `prefer_const_declarations`) and unawaited async safety (`avoid_void_async`, `no_adjacent_strings_in_list`, `throw_in_finally`).
  * Updated test suites to satisfy const immutability standards.

* **Settings & Store Readiness:**
  * Added "Rate App" tile to `SettingsScreen` with dynamic `packageName` resolution from `PackageInfo` and store launch with fallback handling.
  * Localized rate app actions and error messaging across English and Polish ARB catalogs.

* **Modular Screenshot Automation:**
  * Modularized screenshot runners with dedicated per-feature target scripts (`generate_todos.sh`, `generate_settings.sh`).
  * Upgraded `generate_screenshots.sh` orchestrator supporting target delegation, device selection, and test suite execution summary.

* **UI & Adaptive Scaffolding:**
  * Integrated adaptive navigation scaffold supporting phones, tablets, and desktop layouts.
  * Centralized date formatting utilities in todo presentation layer.

## [1.3.0] - 2026-09-18

### Release v1.3.0 — Production Hardening, Store Readiness & DX Optimization

Comprehensive milestone release upgrading the Riverpod starter template with production resilience, store-ready UI components, automated screenshot testing, CI/CD artifact generation, and developer tooling optimizations.

Compare: [`v1.2.0...v1.3.0`](https://github.com/EKER-Studio/flutter_riverpod_boilerplate/compare/v1.2.0...v1.3.0)

#### 🚀 Highlights & Features

* **Tooling, Linter & Build Optimization (DX):**
  * Modernized `analysis_options.yaml` with 40+ strict analyzer rules (`avoid_void_async`, `directives_ordering`, `prefer_const_*`, unawaited futures enforcement) and excluded generated schema files.
  * Scoped code generation in `build.yaml` (`isar_community_generator` restricted to `data/**`, `riverpod_generator` scoped to presentation and data providers) speeding up build runner by 3–5×.
  * Pinned SDK constraints to `^3.12.2` and locked Flutter SDK version via `.flutter-version` (3.47.4).
  * Introduced centralized structured logging via `AppLogger` (`lib/core/utils/app_logger.dart`) wrapping `dart:developer.log` with log severity levels and automatic release mode filtering.
  * Expanded Failure hierarchy (`ValidationFailure`, `NotFoundFailure`, `NetworkFailure`, `UnauthorizedFailure`, `DatabaseFailure`) with UI presentation mapping.

* **CI/CD & Verification Scripts:**
  * Revamped `scripts/before_push.sh` with ANSI color formatting, step timing benchmarks, multi-directory formatting (`lib`, `test`, `integration_test`, `test_driver`), and test tag exclusions (`golden,screenshot`).
  * Enhanced GitHub Actions CI workflow ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) with Gradle caching, `.flutter-version` synchronization, and debug APK build verification.
  * Upgraded Release workflow ([`.github/workflows/release.yml`](.github/workflows/release.yml)) to build Android App Bundles (`.aab`) alongside APKs, uploading ProGuard mapping symbols and publishing GitHub Releases automatically on `v*` tags.

* **Core Resilience, Bootstrap & Lifecycle:**
  * Implemented robust bootstrap error handling in `lib/main.dart` with edge-to-edge mode, system UI overlay configuration, Flutter/platform dispatcher error hooks, and an `AppInitializationErrorScreen` fallback.
  * Integrated global `AppProviderObserver` for unhandled error logging and state transition diagnostics across all Riverpod providers.
  * Added on-device rotating crash log file (`crash_log.txt`, 1 MB limit) managed by `AppCrashReporter`.
  * Guarded typography in `lib/app.dart` by clamping `textScaler` between `0.85` and `2.0`.
  * Added cryptographic `FieldCipher` utility (`lib/core/utils/field_cipher.dart`) implementing AES-256-CBC + HMAC-SHA256 Encrypt-then-MAC with constant-time verification.

* **Design System, Accessibility & UI Primitives:**
  * Added responsive layout tokens (`lib/core/presentation/theme/app_layout_tokens.dart`) with `ContextLayout` extensions for phones, foldables, tablets, and desktop viewports.
  * Introduced `ClampedLayout` widget preventing view stretching on wide screens.
  * Added semantic feedback theming (`AppFeedbackTheme`) and floating `AppSnackBar` with status icons for Success, Error, Warning, and Info states.
  * Created accessible `StateMessageCard` component for empty, welcome, and error views with action buttons (`AppEmptyView`, `AppErrorView`).
  * Added string utility extension `capitalizeFirst()`.

* **Store-Ready Compliance & In-App Legal Screens:**
  * Built accessible settings components (`CustomSettingsTile`, `CustomSettingsToggle`, `SectionHeader`, `ThemeSelectionDialog`) with full accessibility semantics.
  * Added in-app Open Source Licenses screen (`LicensesScreen`) with searchable package list.
  * Added in-app Privacy Policy screen (`PrivacyPolicyScreen`) with external legal link launching via `url_launcher`.
  * Added top-level `SECURITY.md` and offline `doc/privacy_policy.md` documents.
  * Surfaced dynamic app version and build metadata via `package_info_plus`.

* **Platform Configurations (Android & iOS):**
  * Android: Added `proguard-rules.pro` keeping Isar native bindings and JNI callbacks; enabled `coreLibraryDesugaring` in `build.gradle.kts`; configured release R8 minification, resource shrinking, and ABI/language bundle splits.
  * iOS: Normalized deployment target to `14.0` across `Podfile` post_install hook.

* **Automated Screenshot Testing:**
  * Added automated integration test harness in `integration_test/app_screenshots_test.dart` for capturing App Store / Google Play marketing screenshots across English and Polish locales.
  * Added screenshot execution scripts in `scripts/screenshots/generate_screenshots.sh` and `scripts/screenshots/run_screenshot_target.sh`.

## [1.2.0] - 2026-09-08

### 🚀 Highlights & Features
* **CI/CD & Automated Release Pipeline:**
  * Adopted `develop` as the primary integration branch and default branch on GitHub.
  * Added dedicated `Release` workflow ([`release.yml`](.github/workflows/release.yml)) to build release APKs and automatically publish GitHub Releases on `v*` tags.
  * Enhanced CI test stability on Linux runners with dynamic caching and retrieval of the native `libisar.so` core binary.
  * Integrated automated test coverage calculation, summary tables in `$GITHUB_STEP_SUMMARY`, and `coverage/lcov.info` artifact reporting.
  * Aligned runner Flutter version to `3.47.2` for full Dart analyzer compatibility.
  * Added conditional release keystore signing via `key.properties` in Android Gradle with automatic fallback to debug keys.
* **Architecture & Clean Code Refinement:**
  * Relocated repository providers to the data layer (`lib/features/todos/data/providers/todo_repository_provider.dart`), adhering to clean architectural boundaries.
  * Comprehensive documentation and DartDoc cleanup across `core`, `todos`, and `settings` modules.
* **Developer Tooling & Architecture Audits:**
  * Added specialized AI audit prompts in `prompts/` covering Riverpod architecture, unit testing standards, i18n/l10n audits, and DartDoc cleanup.
  * Added GitHub Copilot project guidelines ([`.github/copilot-instructions.md`](.github/copilot-instructions.md)).
* **Repository Governance & Project Hygiene:**
  * Added standardized GitHub Issue and Pull Request templates for bugs, features, and chores.
  * Formalized contribution and release workflows in [`.github/CONTRIBUTING.md`](.github/CONTRIBUTING.md).
  * Hardened `.gitignore` against generated Android Kotlin caches and iOS SPM resolved artifacts.

## [1.1.0] - 2026-08-28

### 🚀 Highlights & Features
* **Declarative Routing (GoRouter):** Integrated `go_router` with centralized route definitions, eliminating direct cross-screen dependencies.
* **Architecture Evolution:** Implemented `AppStartup` initialization pattern for async database pre-warming and modernized error handling via `Result` / `Failure` abstractions.
* **Design System & Asset Pipeline:** Centralized `AppTheme`, adaptive icons, dynamic dark/light native splash screens, and asset normalization scripts.
* **CI/CD & Pre-Push Pipeline:** Automated code generation verification, static analysis, custom Riverpod lints, and test execution on pull requests.
* **AI-Native Tooling:** Added universal guardrail configs for Cline, Cursor (`.cursorrules`), Claude Code (`CLAUDE.md`), and Gemini (`GEMINI.md`).

## [1.0.0] - 2026-07-28

### Initial Release
* Minimalist production template frozen strictly around Clean Architecture, Riverpod 3.x, and Isar Community.
* Reactive CRUD Todo feature with Isar stream queries and auto-disposing Riverpod state notifiers.
* Settings feature with persistent theme mode using Isar singleton collection (`id=0`).
* Integrated localization (l10n) blueprint with English and Polish translations.
* Complete verification pipeline with unit, widget, and golden test coverage.

[1.4.0]: https://github.com/EKER-Studio/flutter_riverpod_template/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/EKER-Studio/flutter_riverpod_template/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/EKER-Studio/flutter_riverpod_template/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/EKER-Studio/flutter_riverpod_template/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/EKER-Studio/flutter_riverpod_template/releases/tag/v1.0.0
