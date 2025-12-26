# Unused Dependencies Audit Report

## 📊 Executive Summary

**Current APK Size**: 188.6 MB  
**Unused Dependencies Found**: 3 packages  
**Potential Size Reduction**: ~15-20 MB  

---

## 🔴 UNUSED DEPENDENCIES (Safe to Remove)

### 1. **geolocator** (11.0.0)
- **Status**: ❌ **NOT USED** (0 references found)
- **Size Impact**: ~8-10 MB
- **Original Purpose**: GPS location tracking (likely for attendance features)
- **Current State**: No code references found in entire codebase
- **Recommendation**: **REMOVE IMMEDIATELY**

**Remove from pubspec.yaml**:
```yaml
# Line 32 - DELETE THIS LINE
geolocator: ^11.0.0
```

---

### 2. **flutter_colorpicker** (1.1.0)
- **Status**: ❌ **NOT USED** (0 references found)
- **Size Impact**: ~3-4 MB
- **Original Purpose**: Color picker UI component
- **Current State**: No code references found
- **Recommendation**: **REMOVE**

**Remove from pubspec.yaml**:
```yaml
# Line 60 - DELETE THIS LINE
flutter_colorpicker: ^1.1.0
```

---

### 3. **showcaseview** (2.0.3)
- **Status**: ❌ **NOT USED** (0 references found)
- **Size Impact**: ~2-3 MB
- **Original Purpose**: Onboarding tour/tutorial overlays
- **Current State**: No code references found
- **Recommendation**: **REMOVE**

**Remove from pubspec.yaml**:
```yaml
# Line 78 - DELETE THIS LINE
showcaseview: ^2.0.3
```

---

## 🟡 PARTIALLY USED (Consider Removing)

### 4. **image_picker** (1.0.7)
- **Status**: ⚠️ **FEATURE DISABLED** but code still exists
- **Size Impact**: ~5-6 MB
- **Usage**: 
  - `student_auth_service.dart` - Profile image upload (DISABLED)
  - `settings_screen.dart` - Settings (unknown if active)
  - `auth_screen.dart` - Registration (unknown if active)
- **Current State**: Profile image upload feature is **FROZEN** (disabled for Dec 31 launch)
- **Recommendation**: **KEEP FOR NOW** (may re-enable post-launch)

**Note**: If you decide profile photos will NEVER be supported, remove this package.

---

### 5. **speech_to_text** (7.0.0)
- **Status**: ⚠️ **MINIMAL USE** (1 reference)
- **Size Impact**: ~12-15 MB (LARGE!)
- **Usage**: Only in `accessibility_provider.dart`
- **Current State**: Accessibility feature for voice input
- **Recommendation**: **EVALUATE** - Is voice input actively used by students?

**If voice input is not essential**, remove this package for significant size savings.

---

### 6. **flutter_tts** (4.0.2)
- **Status**: ⚠️ **MINIMAL USE** (1 reference)
- **Size Impact**: ~8-10 MB
- **Usage**: Only in `accessibility_provider.dart`
- **Current State**: Text-to-speech for accessibility
- **Recommendation**: **EVALUATE** - Is TTS actively used?

**If TTS is not essential**, remove for size savings.

---

## ✅ ACTIVELY USED (Keep)

### QR Code Packages
- **qr_flutter** (4.1.0) - ✅ Used in `qr_handshake_screen.dart`
- **mobile_scanner** (3.5.5) - ✅ Used in `qr_handshake_screen.dart`
- **Status**: Both actively used for QR code features
- **Recommendation**: **KEEP**

### File Management
- **file_picker** (8.0.0+1) - ✅ Used in 7 files (books, community resources, settings)
- **open_file** (3.3.2) - ✅ Used in `books_notes_screen.dart`
- **Status**: Actively used for file uploads/downloads
- **Recommendation**: **KEEP**

### Audio
- **audioplayers** (6.5.1) - ✅ Used in 3 files (audio preview, notifications, focus)
- **Status**: Actively used for sound effects and audio playback
- **Recommendation**: **KEEP**

---

## 📋 Removal Action Plan

### Phase 1: Immediate Removals (Safe)

Run these commands to remove unused packages:

```bash
# 1. Edit pubspec.yaml and DELETE these lines:
#    Line 32: geolocator: ^11.0.0
#    Line 60: flutter_colorpicker: ^1.1.0
#    Line 78: showcaseview: ^2.0.3

# 2. Update dependencies
flutter pub get

# 3. Rebuild APK
flutter build apk --release
```

**Expected Result**: APK size reduced from 188.6 MB to ~175 MB

---

### Phase 2: Evaluate Accessibility Features

**Question to answer**: Are students actively using voice input and text-to-speech?

**If NO**:
```yaml
# Remove from pubspec.yaml:
speech_to_text: ^7.0.0  # Line 48
flutter_tts: ^4.0.2     # Line 46
```

**Expected Additional Savings**: ~20-25 MB  
**New APK Size**: ~150-155 MB

---

### Phase 3: Post-Launch Cleanup

After December 31st launch, if you decide profile photos will NEVER be supported:

```yaml
# Remove from pubspec.yaml:
image_picker: ^1.0.7  # Line 31
```

**Expected Additional Savings**: ~5-6 MB

---

## 🎯 Summary Table

| Package | Status | Size Impact | Action |
|---------|--------|-------------|--------|
| `geolocator` | ❌ Unused | ~10 MB | **Remove Now** |
| `flutter_colorpicker` | ❌ Unused | ~4 MB | **Remove Now** |
| `showcaseview` | ❌ Unused | ~3 MB | **Remove Now** |
| `speech_to_text` | ⚠️ Minimal | ~15 MB | **Evaluate** |
| `flutter_tts` | ⚠️ Minimal | ~10 MB | **Evaluate** |
| `image_picker` | ⚠️ Disabled | ~6 MB | **Keep (for now)** |
| QR packages | ✅ Active | N/A | **Keep** |
| File packages | ✅ Active | N/A | **Keep** |
| `audioplayers` | ✅ Active | N/A | **Keep** |

---

## 💰 Potential Savings

### Conservative (Phase 1 Only):
- **Remove**: geolocator, flutter_colorpicker, showcaseview
- **Savings**: ~17 MB
- **New Size**: ~171 MB

### Aggressive (Phase 1 + 2):
- **Remove**: Above + speech_to_text + flutter_tts
- **Savings**: ~42 MB
- **New Size**: ~146 MB

### Maximum (All Phases):
- **Remove**: All unused + image_picker
- **Savings**: ~48 MB
- **New Size**: ~140 MB

---

## ⚠️ Important Notes

1. **Already Removed**: You've already commented out several large packages:
   - `camera` (~15 MB)
   - `google_mlkit_face_detection` (~10 MB)
   - `pdf` (~3 MB)
   - `printing` (~4 MB)
   - `flutter_quill` (~8 MB)
   - `webview_flutter` (~6 MB)
   - `flutter_week_view` (~5 MB)

2. **Good Job!** You've already optimized ~51 MB by removing those packages.

3. **Test After Removal**: Always test the app after removing packages to ensure no runtime errors.

4. **Backup First**: Commit your current code to Git before making changes.

---

## 🚀 Recommended Next Steps

1. **Immediate**: Remove `geolocator`, `flutter_colorpicker`, `showcaseview`
2. **This Week**: Evaluate if accessibility features (TTS, STT) are used
3. **Post-Launch**: Decide on profile photo feature future
4. **Rebuild**: Create new APK and verify size reduction

**Final Target**: ~140-150 MB APK (from current 188.6 MB)
