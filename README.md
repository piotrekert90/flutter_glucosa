# 🚀 Flutter GitHub Template — Clean Architecture, Riverpod 3.x & Isar Community (v1.4.0)

[![Release](https://img.shields.io/badge/Release-v1.4.0-blue.svg)](CHANGELOG.md)
[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State](https://img.shields.io/badge/State-Riverpod_3.x-0553B1)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-Isar_Community-00B4D8)](https://isar-community.dev)
[![Routing](https://img.shields.io/badge/Routing-GoRouter-teal)](https://pub.dev/packages/go_router)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A production-grade, store-ready reference architecture and starter template for Flutter applications, engineered for offline resilience, predictable state boundaries, and lean scalability.

---

## 🎯 Core Pillars

### 1. Clean Architecture (Feature-First)
Organized by features (`lib/features/<feature>/`), isolating Domain logic from technical Data implementations and Presentation UI components:
- **Domain Layer**: Pure Dart entities, repository contracts, and functional `Result` types (`CommandResult`, `DataResult<T>`).
- **Data Layer**: Isar models, synchronous mappers, and repository implementations.
- **Presentation Layer**: Riverpod state notifiers (`@riverpod`), Material 3 UI widgets, and accessible design system components.

### 2. Riverpod 3.x
Strict code generation via `@riverpod` annotations. All state updates are stream-driven directly from persistence layers into `AsyncValue` state.

### 3. Isar Community
Ultra-fast, offline-first local database providing reactive queries and watch streams as the single source of truth.

---

## ✨ Features & Capabilities

### 📱 Applications & Screens
- **Todo Management**: Complete reactive CRUD operations (add via modal dialog, checkbox toggling, swipe-to-delete with SnackBar confirmation).
- **Todo Detail Screen**: Dedicated view (`/todos/:id`) displaying status, creation timestamps, and reactive stream sync.
- **Settings Module**:
  - Theme mode selection (System, Light, Dark) with custom dialog and accessible radio group.
  - Notification toggle backed by an Isar database singleton collection (`id=0`).
  - In-app Open Source Licenses screen (`LicensesScreen`) with searchable package list.
  - In-app Privacy Policy screen (`PrivacyPolicyScreen`) with external legal link launching via `url_launcher`.
  - Dynamic app version and build metadata display via `package_info_plus`.

### 🎨 Design System & Accessibility
- **Responsive Layout Tokens**: `ContextLayout` extensions (`context.layout`, `context.isPhone`, `context.isTablet`) supporting phones, foldables, tablets, and desktop form factors.
- **ClampedLayout**: Container widget enforcing ergonomic content widths on wide screens.
- **AdaptiveNavigationScaffold**: Responsive navigation shell switching between bottom `NavigationBar` on compact screens and side `NavigationRail` on tablets/desktops.
- **Semantic Feedback & Theming**: `AppFeedbackTheme` and floating `AppSnackBar` with status icons for Success, Error, Warning, and Info states.
- **State Cards**: Reusable, accessible `StateMessageCard` components for empty, loading, and error states (`AppEmptyView`, `AppErrorView`, `AppLoadingIndicator`).

### 🛡️ Core Resilience & Security
- **Bootstrap & Error Handling**: Robust edge-to-edge startup with system UI overlay configuration, platform dispatcher error hooks, and `AppInitializationErrorScreen` fallback.
- **Global Diagnostics**: `AppProviderObserver` logging state transitions and unhandled errors across all Riverpod providers.
- **Rotating Crash Log**: On-device crash reporting (`crash_log.txt`, 1 MB limit) managed by `AppCrashReporter`.
- **Typography Guards**: Clamped `textScaler` between `0.85` and `2.0` in `lib/app.dart` preventing UI distortion from extreme system accessibility settings.
- **Data Encryption**: `FieldCipher` utility (`lib/core/utils/field_cipher.dart`) implementing AES-256-CBC + HMAC-SHA256 Encrypt-then-MAC with constant-time verification.
- **Store Compliance**: Top-level `SECURITY.md` vulnerability reporting policy and offline `doc/privacy_policy.md`.

### 📸 Automated Screenshot Testing
- Headless automated integration test harness (`integration_test/app_screenshots_test.dart`) capturing App Store / Google Play marketing screenshots across English and Polish locales.
- CLI generation scripts (`scripts/screenshots/generate_screenshots.sh` and `scripts/screenshots/run_screenshot_target.sh`) with emulator orchestration.

### ⚙️ Platform & CI/CD Hardening
- **Android**: Enabled R8 full-mode optimization (`proguard-rules.pro`), Java 17 desugaring (`desugar_jdk_libs:2.1.5`), release R8 minification, resource shrinking, and language/density/ABI bundle splits.
- **iOS**: Normalized minimum deployment target to `14.0` in `Podfile` post-install configuration.
- **Workflows**: GitHub Actions CI ([`ci.yml`](.github/workflows/ci.yml)) with Gradle caching, `.flutter-version` synchronization, and debug APK build verification.
- **Release Workflow**: Automated release packaging ([`release.yml`](.github/workflows/release.yml)) generating Android App Bundles (`.aab`) alongside APKs, uploading ProGuard debug symbols, and drafting GitHub Releases on `v*` tags.

---

## 🛠 Project Structure

```text
lib/
├── main.dart                    # Bootstrap entry point (error hooks & System UI)
├── app.dart                     # MaterialApp.router configuration & typography clamping
├── core/
│   ├── config/                  # AppEnvironment runtime configuration
│   ├── errors/                  # Failure hierarchy (Database, Network, Validation) & Result types
│   ├── presentation/
│   │   ├── navigation/          # AdaptiveNavigationScaffold (Bar vs Rail)
│   │   ├── screens/             # AppStartupWidget & AppInitializationErrorScreen
│   │   ├── theme/               # AppTheme, AppColors, AppFeedbackTheme, AppLayoutTokens
│   │   ├── utils/               # AppSnackBar, UI extensions
│   │   └── widgets/             # ClampedLayout, AppEmptyView, AppErrorView, StateMessageCard
│   ├── providers/               # Global observers (AppProviderObserver, isarProvider)
│   ├── router/                  # GoRouter declarative routes & redirection
│   └── utils/                   # AppLogger, AppCrashReporter, FieldCipher
└── features/
    ├── todos/                   # Feature: Todos
    │   ├── domain/              # Entities & Repository contracts
    │   ├── data/                # Isar models, Synchronous Mappers & Repository impl
    │   └── presentation/        # Notifiers (@riverpod), Screens & Widgets
    └── settings/                # Feature: Settings
        ├── domain/              # User preferences domain contracts
        ├── data/                # Isar singleton model & Repository impl
        └── presentation/        # Settings Notifier, Licenses, Privacy Policy & Dialogs
```

---

## 🚀 Setup & Commands

```bash
# Fetch workspace dependencies
flutter pub get

# Generate Riverpod & Isar code
dart run build_runner build --delete-conflicting-outputs

# Generate App Icons
dart run flutter_launcher_icons

# Generate Native Splash Screen
dart run flutter_native_splash:create

# Run full pre-push verification pipeline
bash scripts/before_push.sh
```

## 🧪 Verification & Testing

```bash
# Multi-directory formatting
dart format lib test integration_test test_driver

# Static analysis
flutter analyze

# Riverpod custom lint checks
dart run custom_lint

# Unit & Widget tests
flutter test --exclude-tags "golden,screenshot"

# Golden regression tests
flutter test --tags golden

# Automated App Store screenshots
./scripts/screenshots/generate_screenshots.sh all en
```

---

## 📜 Changelog

All notable changes, architectural enhancements, and release notes are documented in [CHANGELOG.md](CHANGELOG.md).
