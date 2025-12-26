@echo off
echo Testing Flutter Build...
echo.

echo Step 1: Cleaning project...
flutter clean

echo.
echo Step 2: Getting dependencies...
flutter pub get

echo.
echo Step 3: Analyzing code...
flutter analyze

echo.
echo Step 4: Testing compilation...
flutter build apk --debug

echo.
echo Build test completed!
pause