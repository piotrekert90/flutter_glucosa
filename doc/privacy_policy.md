# Privacy Policy

**Last Updated:** October 4, 2026

**Glucosa** is engineered with a **local-first** architecture to ensure you retain ownership and control over your metabolic health records. This Privacy Policy discloses how your personal health data is processed, stored, and protected.

---

## 1. Local-First Data Persistence

All health measurements (blood glucose, HbA1c, blood pressure, ketones, cholesterol, and weight) and personal profile settings are stored primarily on your physical device using an embedded local database (Isar Community) within the operating system's application sandbox. Your data remains on your device unless you explicitly choose to export or synchronize it.

---

## 2. Platform Health Integrations (Apple Health & Google Health Connect)

Glucosa provides optional bidirectional integration with native platform health repositories:
- **Apple HealthKit (iOS)**
- **Google Health Connect (Android)**

When you grant permissions, Glucosa accesses only the specific health metric types you explicitly authorize (blood glucose, blood pressure, ketones, and body weight):
- **Read Access:** Used solely to display and aggregate historical health measurements within the application.
- **Write Access:** Used solely to export measurements logged inside Glucosa to your system health store upon your request.
- Glucosa **does not** transfer, sell, or use data received from HealthKit or Health Connect for advertising, marketing, or data broker purposes.

---

## 3. Home Screen Widgets

Glucosa offers optional home screen widgets to provide quick glanceability of recent glucose levels:
- Widget data is populated locally via secure inter-process communication (`home_widget`) on your device.
- Because widget contents may be visible when your device is unlocked, you can configure or remove widgets from your home screen at any time.

---

## 4. Biometric Authentication & App Lock

Glucosa offers optional biometric app lock (Face ID, Touch ID, or Android BiometricPrompt) and system PIN authentication (`local_auth`):
- All biometric verification is handled exclusively by your device's native hardware security enclave.
- Glucosa never accesses, collects, or stores your biometric raw data, fingerprints, or facial profiles.

---

## 5. Diagnostic Logging & Crash Reports

- **On-Device Logging:** Glucosa maintains an on-device rotating diagnostic crash log (`crash_log.txt`, capped at 1 MB) to assist with troubleshooting application defects.
- **Privacy Preservation:** Diagnostic logs record technical stack traces and exception types; they never contain personal health measurements, patient names, notes, or credentials.
- **Zero Cloud Transmission:** Diagnostic logs remain strictly on your physical device. No logs, analytics, or telemetry are transmitted to remote servers.

---

## 6. Data Ownership, Portability & Deletion

Your health data belongs entirely to you:
- **Export:** You can export all your health records at any time using the built-in CSV export tool via the native system share sheet.
- **Deletion:** You can permanently delete your data at any time by clearing application data in your device system settings or uninstalling the application.

---

## 7. Contact & Inquiries

If you have questions, feedback, or concerns regarding this Privacy Policy or your data, please contact the developer:

**Piotr Ekert**  
Email: **piotrekert90@gmail.com**  
GitHub: [https://github.com/piotrekert90/flutter_glucosa](https://github.com/piotrekert90/flutter_glucosa)
