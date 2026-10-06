# Google Play release checklist

This document is intentionally limited to preparation and compliance work for Google Play. It does not publish the app, upload artifacts, or trigger a production release.

## 1. Compliance and policy readiness

Before any Play Console submission, complete the following checks:

- Confirm the app privacy policy matches the actual product behavior and Firebase usage.
- Review Health Connect / Apple HealthKit permission declarations and ensure all health-related rationale text is accurate.
- Complete the Google Play Data Safety form with the actual data flow used by the app.
- Confirm that the app is not making unsupported health claims or using medical-device language in store copy.
- Verify that the app title, descriptions, and screenshots do not claim features that are not yet launched or validated.
- Check whether the app needs age rating and content classification review.

## 2. Store listing and metadata

Prepare the store listing before release automation:

- App name and short description
- Full description with benefits, target audience, and functional limits
- App icon, feature graphic, and screenshots for all supported device sizes
- App category and tags
- Privacy policy URL
- Contact email or support URL
- Terms and support links if required by the chosen category

Recommended release copy should describe the app as a personal health-tracking tool and avoid medical-device claims unless explicitly validated by legal/compliance review.

## 3. Signing and release configuration

Google Play signing is managed in the Play Console, but the local Android signing file stays on the developer machine and must never be committed to the repository.

Required local setup:

1. Create a local `android/key.properties` file from the template in `android/key.properties.example`.
2. Generate a keystore only on a secure machine or CI secret store.
3. Keep the keystore and credentials in a secure location outside the repository.
4. Use Play App Signing to reduce the burden of key rotation and migration.

The project already has a release signing block in [android/app/build.gradle.kts](../android/app/build.gradle.kts), and it intentionally falls back to no signing unless the keystore is present. This protects the repo from accidental publishing with a developer key.

## 4. Play Console readiness

Before release candidate upload:

- Create a Play Console app record and verify the package name matches the app identifier.
- Add the proper app category and target countries.
- Configure tester tracks: internal testing, closed testing, open testing.
- Validate app bundle generation and upload using a non-production artifact flow.
- Run pre-launch reports and device compatibility checks.
- Review app permissions, notification behavior, and Health Connect declarations.
- Set versioning and release notes ahead of any production rollout.

## 5. Final non-publishing gate

This checklist is complete when:

- the app is technically ready for Play upload,
- store listing metadata is prepared,
- signing is configured locally but never committed,
- release policy and privacy checks are documented,
- the app is still not published.

The repository should remain in a safe, non-published state until the app owner explicitly approves a release.
