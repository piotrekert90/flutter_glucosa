# Security Policy

## Supported Versions

Only the latest released version of the application receives security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security and privacy of our users very seriously.

If you believe you have discovered a security vulnerability in this project, please do NOT create a public issue on GitHub. Instead, report it privately:

1. Send an email to **piotrekert90@gmail.com** (or open a private security advisory on GitHub).
2. Include a detailed description of the vulnerability, steps to reproduce, and potential impact.
3. Allow up to 48 hours for an initial response from the development team.
4. We will coordinate a fix and release before any public disclosure.

## Security Architecture Highlights

- **Local-First Data Isolation:** Health readings are persisted locally within the protected operating system sandbox and are never transmitted without explicit user action. The local database is currently **not encrypted at rest** (see Technical Debt below); protection relies on OS sandboxing, disabled Android auto-backup (`allowBackup="false"`), and the optional biometric app lock (which gates UI access but does not encrypt data).
- **Hardware-Backed Biometrics & Platform Sandboxing:** Biometric authentication leverages the platform hardware security enclave (Android BiometricPrompt / iOS LocalAuthentication), while application state and preferences remain isolated within the protected operating system sandbox.
- **Diagnostics (Local + Limited Cloud):** A rotating on-device crash log (`crash_log.txt`) stores diagnostics locally and must never contain personal health measurements, patient names, notes, or credentials. **Separately, Firebase Crashlytics and Firebase Analytics transmit limited cloud diagnostics (crash reports, app-open events, device identifiers) to Firebase** for reliability monitoring — see `doc/privacy_policy.md` ("Limited Cloud Diagnostics") and the Data Safety / `PrivacyInfo.xcprivacy` declarations, which are the sources of truth for what leaves the device.

## Technical Debt

- **Unencrypted local database:** Isar Community currently runs without database-level encryption, so anyone with physical access to an unlocked/rooted device could read stored health data. Native database encryption (key in Android Keystore / iOS Keychain) is planned.
- **No telemetry opt-out yet:** Crashlytics/Analytics collection is currently always on. A user-facing opt-out toggle is planned.
