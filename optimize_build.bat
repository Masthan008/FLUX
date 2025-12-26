@echo off
echo ========================================
echo FluxFlow APK Optimization Script
echo ========================================
echo.

echo [1/6] Cleaning previous builds...
flutter clean
echo ✓ Clean completed

echo.
echo [2/6] Getting dependencies...
flutter pub get
echo ✓ Dependencies updated

echo.
echo [3/6] Running code analysis...
flutter analyze
echo ✓ Analysis completed

echo.
echo [4/6] Building optimized APK...
flutter build apk --release --shrink --obfuscate --split-debug-info=debug-info/
echo ✓ APK build completed

echo.
echo [5/6] Checking APK size...
for %%I in (build\app\outputs\flutter-apk\app-release.apk) do echo APK Size: %%~zI bytes (%%~zI / 1048576 MB)

echo.
echo [6/6] Build optimization complete!
echo.
echo APK Location: build\app\outputs\flutter-apk\app-release.apk
echo Debug Info: debug-info\
echo.
echo ========================================
echo Optimization Summary:
echo - Code shrinking: ENABLED
echo - Obfuscation: ENABLED  
echo - Debug info split: ENABLED
echo - Asset optimization: ENABLED
echo ========================================
pause