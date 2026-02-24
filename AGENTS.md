# AGENTS.md

## Cursor Cloud specific instructions

### Project Overview
This is a **nubank_layout** Flutter mobile app — a Nubank UI clone built with Flutter 1.9.x (pre-null-safety, Dart 2.5). Uses BLoC pattern (`bloc_pattern`), Cloud Firestore, and Sentry for error reporting.

### Environment Setup
- **Flutter SDK**: 1.9.1+hotfix.6 installed at `/opt/flutter_install/flutter`
- **Android SDK**: installed at `/opt/android-sdk` (platform 28, build-tools 28.0.3)
- **Java**: OpenJDK 8 required for Gradle builds (`JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64`)
- All paths are configured in `~/.bashrc`

### Key Gotchas
- The project **only compiles with Flutter 1.9.x**. Newer Flutter versions (1.17+) break `flutter_svg 0.14.x` (`Diagnosticable` constructor change) and `sentry` API (`pub upgrade` resolves incompatible versions).
- `pubspec.lock` is pinned to `flutter: ">=1.5.9-pre.94 <2.0.0"` — do NOT run `flutter pub upgrade`, use `flutter pub get` only.
- Android builds require **Java 8** — the Gradle 4.10.2 / Android Gradle Plugin 3.2.1 are incompatible with Java 11+.
- Flutter Web is **not supported** in Flutter 1.9.x stable channel.
- `flutter analyze` returns exit code 1 due to pre-existing info-level issues (unused imports); this is expected, there are no actual errors.
- The test suite has **no actual test cases** — `test/widget_test.dart` has an empty `main()`.

### Common Commands
```bash
flutter pub get           # Install dependencies
flutter analyze           # Lint (expect info-level warnings only)
flutter test              # Run tests (currently no tests defined)
flutter build apk --debug # Build debug APK (requires JAVA_HOME set to Java 8)
```

### Firebase / External Services
- The app connects to Firebase project `flutter-descomplicado` for Cloud Firestore data.
- Sentry DSN is hardcoded in `lib/main.dart`. App functions without Sentry connectivity.
- Firebase credentials (`google-services.json`) are committed to the repo.
