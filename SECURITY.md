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

- **Local-First Hardware Sandbox Isolation:** Health readings are persisted strictly locally within the protected operating system sandbox. At rest, database files are encrypted by platform hardware security subsystems (Android File-Based Encryption backed by TEE/Keymaster; iOS APFS Data Protection backed by the Secure Enclave). Cross-application access is blocked by the OS kernel, unencrypted cloud or ADB backups are disabled via `android:allowBackup="false"`, and temporary export files are deleted immediately after sharing.
- **Hardware-Backed Biometrics:** Runtime access can be gated using the device's hardware security enclave (Android BiometricPrompt / iOS LocalAuthentication), ensuring unauthorized users cannot access clinical records even on unlocked devices.
- **Privacy-Preserving Diagnostics & User Opt-Out:** On-device crash logs (`crash_log.txt`) store diagnostics locally without health metrics, notes, or patient identifiers, and are fully cleared during a data wipe. Cloud diagnostics (Firebase Crashlytics and Analytics) can be toggled off at any time under Settings → Security & Privacy → "Share diagnostics".
