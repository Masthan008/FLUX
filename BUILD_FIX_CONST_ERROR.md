# 🛠️ Build Fix - Const Error

## Error
```
lib/screens/home_screen.dart:219:49: Error: Not a constant expression.
builder: (context) => const NovaChatScreen(),
                       ^^^^^^^^^^^^^^
```

## Root Cause
`NovaChatScreen` is a `StatefulWidget`, which cannot be instantiated as `const` because it has mutable state.

## Fix Applied
```dart
// BEFORE (Error):
builder: (context) => const NovaChatScreen(),

// AFTER (Fixed):
builder: (context) => NovaChatScreen(),
```

## Why This Matters
- `const` keyword is for compile-time constants
- StatefulWidgets have runtime state
- Removing `const` allows proper instantiation

## Status
✅ **FIXED** - Build should now succeed

## Build Command
```bash
flutter build apk --release --split-per-abi
```

---

**Date:** November 28, 2025  
**Fix:** Removed const from StatefulWidget instantiation
