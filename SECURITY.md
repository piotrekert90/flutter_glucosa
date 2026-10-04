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

- **Local-First Data Isolation:** Health readings are persisted locally within the protected operating system sandbox and are never transmitted without explicit user action.
- **Hardware-Backed Biometrics & Secure Storage:** Biometric authentication leverages the platform hardware security enclave (Android BiometricPrompt / iOS LocalAuthentication), while sensitive flags and keys are backed by platform secure storage (Android Keystore / iOS Keychain via `flutter_secure_storage`).
- **Privacy-Preserving Diagnostics:** Diagnostic crash logs are stored strictly on-device in a rotating local file (`crash_log.txt`) and never contain personal health measurements, patient names, notes, or credentials.
