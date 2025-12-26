# 🔨 Build Instructions for NovaMind Update 31.0

## Quick Build

Run this command to build the APK:

```bash
flutter build apk --release
```

The APK will be located at:
```
build\app\outputs\flutter-apk\app-release.apk
```

---

## If Build Fails

### Option 1: Clean Build
```bash
flutter clean
flutter pub get
flutter build apk --release
```

### Option 2: Debug Build (Faster)
```bash
flutter build apk --debug
```

### Option 3: Split APKs (Smaller size)
```bash
flutter build apk --split-per-abi --release
```

This creates 3 APKs:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM) ← Most common
- `app-x86_64-release.apk` (Intel)

---

## Testing Before Build

Check for errors:
```bash
flutter analyze
```

Run on connected device:
```bash
flutter run --release
```

---

## What's New in This Build

✅ 12/24 hour time format toggle
✅ Alarm times respect format preference
✅ Timetable shows full subject names
✅ IP Syllabus module with 5 units
✅ Enhanced timetable UI
✅ Live GPS attendance tracking
✅ Face verification for attendance

---

## APK Size Estimate

Expected size: ~185 MB (includes all assets, sounds, and dependencies)

---

## Installation

1. Transfer APK to phone
2. Enable "Install from Unknown Sources" if needed
3. Tap APK to install
4. Grant permissions (Camera, Location, Storage)
5. Enjoy NovaMind!
