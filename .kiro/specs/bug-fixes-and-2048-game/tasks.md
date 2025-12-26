# Implementation Plan

- [x] 1. Fix Android permission management in main.dart


  - Update _requestPermissions() function to request Permission.notification, Permission.scheduleExactAlarm, and Permission.systemAlertWindow
  - Add debug logging for each permission request result
  - Ensure permissions are requested before runApp() is called
  - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

- [x] 2. Fix alarm audio default path

  - [x] 2.1 Add default audio path constant to AlarmService


    - Define `static const String defaultAudioPath = 'assets/sounds/mozart.mp3'` in AlarmService class
    - _Requirements: 2.1, 2.2_

  - [x] 2.2 Update scheduleAlarm() method to validate and default audio path


    - Change assetAudioPath parameter to nullable String?
    - Add validation logic to check if assetAudioPath is null or empty
    - Use defaultAudioPath when assetAudioPath is invalid
    - Pass validated audioPath to AlarmSettings constructor
    - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [x] 3. Fix timetable persistence with v3 migration

  - [x] 3.1 Update TimetableService seed flag key


    - Change _seedFlagKey constant from 'timetable_seeded' to 'timetable_seeded_v3'
    - _Requirements: 3.1_

  - [x] 3.2 Enhance initializeTimetable() method with proper Hive box handling



    - Add check for whether box is already open using Hive.isBoxOpen()
    - Use existing box if open, otherwise open new box
    - Clear existing data with box.clear() for fresh v3 start
    - Add verification to count saved sessions after storing
    - Only set 'timetable_seeded_v3' flag if savedCount matches expected count
    - Add debug logging for verification results
    - _Requirements: 3.2, 3.3, 3.4, 3.5_

  - [x] 3.3 Update TimetableScreen to use ValueListenableBuilder


    - Wrap timetable UI with ValueListenableBuilder listening to 'class_sessions' box
    - Ensure UI automatically updates when Hive box changes
    - Handle empty state when no sessions exist
    - _Requirements: 3.6_

- [x] 4. Implement alarm reminder notes feature

  - [x] 4.1 Add reminderNote parameter to scheduleAlarm() method


    - Add optional String? reminderNote parameter to scheduleAlarm()
    - Append reminder note to notification body with delimiter '\n\n📝 ' if note exists
    - Pass enhanced notification body to AlarmSettings
    - _Requirements: 4.1, 4.2_

  - [x] 4.2 Update RingScreen to extract and display reminder notes


    - Add _reminderNote field to _AlarmRingScreenState
    - Create _extractReminderNote() method to parse note from notification body using delimiter
    - Call _extractReminderNote() in initState()
    - Add conditional UI section to display note in GlassContainer with icon and large text
    - Position note display prominently above math problem section
    - _Requirements: 4.3, 4.4, 4.5_

- [x] 5. Create 2048 game module

  - [x] 5.1 Create game_2048_screen.dart file and basic structure


    - Create lib/modules/games/game_2048_screen.dart file
    - Define Game2048Screen StatefulWidget
    - Create _Game2048ScreenState with _grid, _score, and _gameOver fields
    - Import required packages (dart:math for Random, dart:ui for Point)
    - _Requirements: 5.1_

  - [x] 5.2 Implement game initialization and tile generation

    - Create _initializeGame() method to reset grid, score, and gameOver state
    - Implement _addRandomTile() method to find empty cells and add random 2 or 4 tile
    - Call _initializeGame() in initState() to start with two random tiles
    - _Requirements: 5.2_

  - [x] 5.3 Implement swipe gesture detection

    - Wrap game UI with GestureDetector
    - Implement onVerticalDragEnd to detect up/down swipes based on velocity
    - Implement onHorizontalDragEnd to detect left/right swipes based on velocity
    - Use velocity threshold of 100 to distinguish intentional swipes
    - Call _move() method with appropriate Direction enum
    - _Requirements: 5.3, 5.4, 5.5, 5.6, 5.10_

  - [x] 5.4 Implement move and merge logic for all directions


    - Create Direction enum with up, down, left, right values
    - Implement _move(Direction) method to handle grid state changes
    - Implement _moveLeft() with compress, merge, and fill logic
    - Implement _moveRight() by reversing rows, calling _moveLeft(), and reversing back
    - Implement _moveUp() by transposing grid, calling _moveLeft(), and transposing back
    - Implement _moveDown() by transposing grid, calling _moveRight(), and transposing back
    - Add grid change detection to only add new tile if move was valid
    - Update score when tiles merge by adding merged value
    - _Requirements: 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9_

  - [x] 5.5 Implement game over detection

    - Create _checkGameOver() method to detect when no moves are possible
    - Check for empty cells (if any exist, game continues)
    - Check for possible horizontal merges (adjacent equal tiles in rows)
    - Check for possible vertical merges (adjacent equal tiles in columns)
    - Set _gameOver to true if no empty cells and no possible merges
    - _Requirements: 5.14_

  - [x] 5.6 Create glassmorphic UI with neon-colored tiles

    - Implement _buildTile(int value) method to create individual tile widgets
    - Use GlassContainer for each tile with 70x70 size and 10px border radius
    - Create _getTileColor(int value) method with neon color mapping for each tile value
    - Use cyan for 2, green for 4, yellow for 8, magenta for 16, red for 32, blue for 64, orange for 128, purple for 256, pink for 512, mint for 1024, gold for 2048
    - Display tile value in white text with responsive font size
    - Build 4x4 grid layout using GridView or Column/Row widgets
    - _Requirements: 5.11, 5.12_

  - [x] 5.7 Create score display and game over overlay

    - Implement _buildScoreBoard() method with GlassContainer showing current score
    - Display "SCORE" label and score value prominently
    - Implement _buildGameOverOverlay() method with semi-transparent black background
    - Show "GAME OVER" message, final score, and "PLAY AGAIN" button in GlassContainer
    - Wire "PLAY AGAIN" button to call _initializeGame()
    - _Requirements: 5.13, 5.15_

  - [x] 5.8 Integrate game screen into app navigation


    - Add navigation route to Game2048Screen from main menu or games section
    - Ensure game screen has proper app bar with back button
    - Apply dark background gradient consistent with FluxFlow theme
    - _Requirements: 5.11_

- [ ] 6. Testing and verification


  - [x] 6.1 Test permission requests on Android device


    - Clear app data and reinstall
    - Verify all three permission dialogs appear on first launch
    - Test with permissions granted and denied
    - Verify app continues without crashing if permissions denied
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_


  - [x] 6.2 Test alarm audio default fallback




    - Schedule alarm without providing assetAudioPath
    - Verify alarm uses mozart.mp3 as default
    - Trigger alarm and confirm sound plays
    - _Requirements: 2.1, 2.2, 2.3, 2.4_


  - [ ] 6.3 Test timetable v3 migration and persistence




    - Clear app data to simulate fresh install
    - Launch app and verify timetable_seeded_v3 flag is set
    - Check Hive database contains all 19 ClassSession objects
    - Restart app and verify data persists
    - Verify TimetableScreen displays all classes correctly

    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_


  - [ ] 6.4 Test alarm reminder notes feature

    - Schedule alarm with reminder note "Review Chemistry Formula!"
    - Trigger alarm and verify note displays prominently on RingScreen

    - Test alarm without note and verify UI handles absence gracefully
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

  - [ ] 6.5 Test 2048 game functionality
    - Launch game and verify two initial tiles appear
    - Test swipe in all four directions
    - Verify tiles move and merge correctly
    - Verify score updates when tiles merge
    - Play until game over and verify detection works
    - Test "PLAY AGAIN" button resets game properly
    - Verify glassmorphic design and neon colors display correctly
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9, 5.10, 5.11, 5.12, 5.13, 5.14, 5.15_

