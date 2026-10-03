# 🩸 Glucosa — Modern Diabetes & Health Tracking App

[![Release](https://img.shields.io/badge/Release-v1.0.0-blue.svg)](CHANGELOG.md)
[![Flutter](https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State](https://img.shields.io/badge/State-Riverpod_3.x-0553B1)](https://riverpod.dev)
[![Database](https://img.shields.io/badge/Database-Isar_Community-00B4D8)](https://isar-community.dev)
[![Routing](https://img.shields.io/badge/Routing-GoRouter-teal)](https://pub.dev/packages/go_router)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Glucosa** is an offline-first, privacy-focused diabetes and metabolic health tracking application built with **Flutter**, **Riverpod 3.x**, **Isar Community**, and **Material 3**. Designed for individuals managing diabetes (Type 1, Type 2, Gestational, LADA, MODY), Glucosa provides seamless multi-metric health tracking, interactive trend analysis, clinical calculators, recurring reminders, and secure data export—with 100% on-device data sovereignty.

---

## 🎯 Core Features

### 📊 Multi-Metric Health Tracking
- **Blood Glucose**: Log readings with rich meal context (Fasting, Before/After Breakfast, Before/After Lunch, Before/After Dinner, Bedtime, Exercise, General). Automatic conversion and display in **mg/dL** or **mmol/L**.
- **HbA1c**: Record laboratory glycated hemoglobin in **%** or **mmol/mol**.
- **Blood Pressure**: Monitor systolic and diastolic pressures (mmHg) with clinical AHA stage indicators (Normal, Elevated, Stage 1, Stage 2, Crisis).
- **Ketones**: Track blood beta-hydroxybutyrate levels (mmol/L) with clinical warnings for ketoacidosis risk.
- **Cholesterol**: Record Total, LDL, and HDL lipid profiles (mg/dL).
- **Weight**: Track body weight in **kg** or **lbs**.

### 📈 Interactive Charts & Clinical Insights
- **Trend Charts**: Interactive `fl_chart` time-series visualization with selectable ranges (7, 14, 30, and 90 days).
- **Target Range Bounds**: Visual upper and lower target lines on charts based on personalized target ranges.
- **Estimated HbA1c (eA1c)**: Calculated dynamically from 90-day glucose averages.
- **Unified History Feed**: Chronological stream of all health metrics with filter chips, swipe-to-delete, and instant undo actions. Tested and optimized for high-volume datasets (1000+ entries).

### 🛠 Tools & Utilities
- **HbA1c Calculator**: Standalone utility screen offering bidirectional estimation between average glucose and HbA1c with direct reading persistence.
- **Scheduled Reminders**: Local notification reminders for medication, blood glucose checks, and lifestyle logging with recurring schedules.
- **CSV Data Export**: Filter readings by metric and date range, generating standard CSV files shareable directly via the native system share sheet.

### ⚙️ Personalization & Clinical Settings
- **Target Range Profiles**: Select clinical presets (ADA Standard, Tight Control, Relaxed, Pregnancy) or configure custom minimum/maximum glucose thresholds.
- **Diabetes Profiles**: Tailored tracking for Type 1, Type 2, Gestational, LADA, MODY, and Prediabetes.
- **Appearance**: Seamless switching between System, Light, and Dark themes.
- **Security & Privacy**: Zero remote tracking or telemetry. Local-first storage backed by Isar Community. (Note: Data is persisted unencrypted within the local application sandbox; full database-level encryption is tracked as conscious technical debt due to Isar Community engine constraints).

---

## 🏗 Architecture & Engineering

Glucosa adheres strictly to **Clean Architecture** organized with a **feature-first** package structure:

```text
lib/
├── main.dart                    # Application entry point & crash reporting
├── app.dart                     # MaterialApp.router configuration & theme bindings
├── core/
│   ├── config/                  # Environment flags & runtime configuration
│   ├── domain/                  # Shared value objects, clinical validators & converters
│   ├── errors/                  # Unified Failure hierarchy & Result types
│   ├── presentation/
│   │   ├── navigation/          # AdaptiveNavigationScaffold (Bottom Bar vs Side Rail)
│   │   ├── theme/               # Semantic color tokens, typography & feedback themes
│   │   └── widgets/             # Reusable UI primitives (empty, loading, error, charts)
│   ├── providers/               # Global Isar instance & Riverpod observers
│   └── router/                  # GoRouter routes and redirection logic
└── features/
    ├── blood_pressure/          # Blood pressure domain, Isar models & screens
    ├── cholesterol/             # Lipid panel tracking
    ├── export/                  # CSV compilation & native share service
    ├── glucose/                 # Glucose domain, statistics & entry forms
    ├── hba1c/                   # HbA1c readings & clinical calculator
    ├── history/                 # Merged chronological timeline & filtering
    ├── ketones/                 # Blood ketone tracking
    ├── onboarding/              # First-launch clinical setup wizard
    ├── overview/                # Dashboard summary & trend charts
    ├── reminders/               # Scheduled measurement alerts & notification service
    ├── settings/                # Profile, unit preferences & target ranges
    └── weight/                  # Body weight tracking
```

### Key Technical Stack
- **State Management**: [Riverpod 3.x](https://riverpod.dev) with code generation (`@riverpod`). Providers bind directly to reactive streams.
- **Database**: [Isar Community](https://isar-community.dev) fast NoSQL database with reactive watch queries.
- **Routing**: [GoRouter](https://pub.dev/packages/go_router) declarative navigation.
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart) smooth, reactive line charts.
- **Localization**: Native Flutter `intl` & `l10n` supporting 10 languages: English (`en`), German (`de`), Spanish (`es`), French (`fr`), Italian (`it`), Japanese (`ja`), Korean (`ko`), Dutch (`nl`), Polish (`pl`), and Portuguese (`pt`).
- **Testing**: 780+ unit, widget, and mapper tests covering 100% of domain and state logic.

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `3.47+`
- Dart SDK `3.12+`

### Setup Commands

```bash
# Clone the repository
git clone https://github.com/piotrekert90/flutter_glucosa.git
cd flutter_glucosa

# Install dependencies
flutter pub get

# Generate Riverpod & Isar code
dart run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Launch application
flutter run
```

---

## 🧪 Verification & Quality Assurance

Glucosa enforces a mandatory verification pipeline:

```bash
# Format code
dart format lib test

# Run static analysis
flutter analyze

# Execute Riverpod-specific linter rules
dart run custom_lint

# Run test suite
flutter test --exclude-tags "golden,screenshot"
```

---

## 📜 License & Privacy

Glucosa is open-source software licensed under the [MIT License](LICENSE).
Your health data belongs entirely to you. Learn more in our [Privacy Policy](doc/privacy_policy.md).
