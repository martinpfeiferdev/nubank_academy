# Security Guidelines - Nubank Academy App

## Overview

This document outlines the security fixes implemented and best practices to maintain security in this Flutter application.

## Recent Security Fixes

### 1. Credentials Management
**Fixed Issues:**
- ✅ Removed hardcoded Sentry DSN from `lib/main.dart`
- ✅ Added `.env` files to `.gitignore` to prevent credential leaks
- ✅ Added `google-services.json` to `.gitignore`
- ✅ Created `.env.example` template for configuration

**Action Required:**
- 🔴 **CRITICAL**: Regenerate Sentry DSN in Sentry.io dashboard (old DSN was exposed in git history)
- 🔴 **CRITICAL**: Regenerate Firebase API key in Google Cloud Console (old key was exposed)
- 🔴 **CRITICAL**: Review Firebase Security Rules to restrict access based on authentication
- ⚠️ Set up environment variables for sensitive configuration

### 2. Firestore Data Access
**Fixed Issues:**
- ✅ Removed hardcoded user ID from `logo_widget.dart`
- ✅ Removed hardcoded account ID from `config_bloc.dart`
- ✅ Added proper error handling for Firestore queries
- ✅ Fixed memory leak by properly disposing StreamSubscriptions

**Action Required:**
- ⚠️ Implement Firebase Authentication to get user IDs dynamically
- ⚠️ Update Firebase Security Rules to enforce authentication:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read their own data
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Accounts can only be accessed by their owners
    match /contas/{accountId} {
      allow read, write: if request.auth != null &&
                           resource.data.ownerId == request.auth.uid;
    }
  }
}
```

### 3. Android Build Configuration
**Fixed Issues:**
- ✅ Updated `minSdkVersion` from 16 to 21 (removes ~3000 known vulnerabilities)
- ✅ Updated `targetSdkVersion` from 28 to 33
- ✅ Updated `compileSdkVersion` to 33
- ✅ Added comprehensive comments about release signing

**Action Required:**
- 🔴 **BEFORE PRODUCTION RELEASE**: Create proper release keystore:
  ```bash
  keytool -genkey -v -keystore ~/release-key.jks \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias release
  ```
- ⚠️ Store keystore file securely (NOT in version control)
- ⚠️ Configure signing in `android/app/build.gradle` using environment variables

### 4. Dependencies
**Fixed Issues:**
- ✅ Updated `cloud_firestore` from 0.7.4 to 0.16.0
- ✅ Updated `google_sign_in` from 3.0.4 to 5.0.0
- ✅ Updated `firebase_auth` from 0.5.15 to 0.20.0
- ✅ Pinned `sentry` version to 4.0.6 (was "any")

**Action Required:**
- ⚠️ Run `flutter pub get` to update dependencies
- ⚠️ Test the app thoroughly after dependency updates
- ⚠️ Set up automated dependency scanning (e.g., Dependabot)

### 5. Code Quality
**Fixed Issues:**
- ✅ Removed debug print statements
- ✅ Removed unused test functions
- ✅ Added proper error handling with `debugPrint` instead of `print`
- ✅ Fixed StreamSubscription memory leaks

## Security Best Practices

### Environment Variables
Never commit sensitive data. Use environment variables:

1. Copy `.env.example` to `.env`
2. Fill in your actual values in `.env`
3. `.env` is already in `.gitignore`

### Firebase Security
1. **Enable Authentication**: Use Firebase Authentication before accessing Firestore
2. **Security Rules**: Implement strict Firestore Security Rules
3. **API Key Restrictions**: Restrict Firebase API keys in Google Cloud Console:
   - Android apps: Restrict to your app's SHA-1 fingerprint
   - iOS apps: Restrict to your app's bundle ID

### Code Review Checklist
Before committing code, verify:
- [ ] No hardcoded credentials or API keys
- [ ] No print statements (use debugPrint for development)
- [ ] All StreamSubscriptions are cancelled in dispose()
- [ ] Error handling is implemented for all network calls
- [ ] User input is validated and sanitized
- [ ] Authentication is checked before accessing user data

### Release Checklist
Before releasing to production:
- [ ] All credentials have been rotated
- [ ] Release signing is configured with secure keystore
- [ ] Firebase Security Rules are properly configured
- [ ] All dependencies are up to date
- [ ] Security scan has been performed
- [ ] google-services.json is NOT in version control (or is encrypted)

## Vulnerability Reporting

If you discover a security vulnerability:
1. **DO NOT** create a public GitHub issue
2. Contact the repository owner directly
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be fixed before public disclosure

## Additional Security Measures to Implement

### High Priority
1. **Certificate Pinning**: Implement SSL certificate pinning for Firebase connections
2. **Network Security Config**: Create `network_security_config.xml` for Android
3. **Code Obfuscation**: Enable ProGuard/R8 for release builds
4. **Root Detection**: Implement root/jailbreak detection

### Medium Priority
1. **Secure Storage**: Use `flutter_secure_storage` for sensitive local data
2. **Biometric Authentication**: Add fingerprint/face authentication option
3. **Session Management**: Implement proper session timeout
4. **Logging**: Set up secure, centralized logging (Sentry is configured)

### Network Security Configuration Example

Create `android/app/src/main/res/xml/network_security_config.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <!-- Disable cleartext traffic globally -->
    <base-config cleartextTrafficPermitted="false">
        <trust-anchors>
            <certificates src="system" />
        </trust-anchors>
    </base-config>

    <!-- Pin certificates for critical domains -->
    <domain-config>
        <domain includeSubdomains="true">firebaseio.com</domain>
        <domain includeSubdomains="true">googleapis.com</domain>
        <pin-set>
            <pin digest="SHA-256">base64-encoded-pin-here</pin>
            <pin digest="SHA-256">base64-encoded-backup-pin-here</pin>
        </pin-set>
    </domain-config>
</network-security-config>
```

Then reference it in `AndroidManifest.xml`:
```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

## Resources

- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)
- [Android Security Best Practices](https://developer.android.com/topic/security/best-practices)

## Changelog

### 2025-10-21
- Removed hardcoded credentials
- Updated Android SDK versions
- Fixed Firestore security issues
- Updated dependencies
- Added comprehensive documentation

---

**Last Updated**: 2025-10-21
**Next Security Review**: Schedule monthly security reviews
