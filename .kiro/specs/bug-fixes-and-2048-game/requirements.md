# Requirements Document

## Introduction

This document specifies requirements for critical bug fixes in the FluxFlow application's alarm and timetable systems, along with the addition of new features including reminder notes and a 2048 game module. The system shall ensure reliable alarm notifications with proper permissions, fix timetable data persistence issues, and provide an engaging game experience within the app's glassmorphic design aesthetic.

## Glossary

- **Alarm System**: The component responsible for scheduling and triggering alarm notifications with sound and visual alerts
- **Permission Handler**: Android system component that manages app permissions for notifications, alarms, and system alerts
- **Timetable Service**: The service that manages class schedule data initialization and persistence
- **Hive Box**: A NoSQL database container for storing structured data locally
- **RingScreen**: The full-screen UI displayed when an alarm triggers
- **Glassmorphism**: A UI design style featuring frosted glass effects with transparency and blur
- **2048 Game**: A sliding tile puzzle game where players combine matching numbered tiles
- **SharedPreferences**: A key-value storage system for app configuration flags

## Requirements

### Requirement 1: Android Permission Management

**User Story:** As a student, I want the app to request all necessary permissions on startup, so that alarms trigger reliably with sound and full-screen notifications on Android 13+ devices.

#### Acceptance Criteria

1. WHEN the app launches, THE Alarm System SHALL request Permission.notification from the user
2. WHEN the app launches on Android 13+ devices, THE Alarm System SHALL request Permission.scheduleExactAlarm from the user
3. WHEN the app launches, THE Alarm System SHALL request Permission.systemAlertWindow from the user
4. WHEN permission requests are made, THE Alarm System SHALL use the permission_handler package
5. WHEN permissions are denied, THE Alarm System SHALL log the denial and continue app initialization without crashing

### Requirement 2: Alarm Audio Configuration

**User Story:** As a student, I want alarms to always play a sound when triggered, so that I receive audible notifications even if I haven't customized the alarm sound.

#### Acceptance Criteria

1. WHEN an alarm is created without a user-selected audio file, THE Alarm System SHALL default assetAudioPath to 'assets/sounds/mozart.mp3'
2. WHEN assetAudioPath is null or empty, THE Alarm System SHALL validate and replace it with the default audio path
3. WHEN an alarm triggers, THE Alarm System SHALL play the configured audio file
4. THE Alarm System SHALL verify that the default audio file exists in the assets directory before scheduling alarms

### Requirement 3: Timetable Data Persistence Fix

**User Story:** As a student, I want the timetable to load correctly every time I open the app, so that my class schedule is always available even if previous seeding attempts failed.

#### Acceptance Criteria

1. WHEN checking for timetable initialization, THE Timetable Service SHALL use the key 'timetable_seeded_v3' in SharedPreferences
2. WHEN 'timetable_seeded_v3' is false or null, THE Timetable Service SHALL create all ClassSession objects
3. WHEN ClassSession objects are created, THE Timetable Service SHALL save each object to the Hive box named 'class_sessions'
4. WHEN all ClassSession objects are saved, THE Timetable Service SHALL set 'timetable_seeded_v3' to true in SharedPreferences
5. WHEN the TimetableScreen displays data, THE Timetable Service SHALL use ValueListenableBuilder to listen to the 'class_sessions' Hive box
6. WHEN the Hive box updates, THE Timetable Service SHALL automatically refresh the UI with current data

### Requirement 4: Alarm Reminder Notes

**User Story:** As a student, I want to add custom reminder notes to my alarms, so that I can see important context when the alarm rings (like "Review Chemistry Formula!").

#### Acceptance Criteria

1. THE Alarm System SHALL support an optional String field named 'note' in alarm configuration
2. WHEN an alarm is created with a note, THE Alarm System SHALL store the note value with the alarm settings
3. WHEN an alarm triggers, THE RingScreen SHALL retrieve the associated note if one exists
4. WHEN a note exists, THE RingScreen SHALL display the note text in large font size
5. WHEN no note exists, THE RingScreen SHALL display only the standard alarm information without the note section

### Requirement 5: 2048 Game Module

**User Story:** As a student, I want to play a 2048 game within the app during breaks, so that I can relax and have fun without leaving the FluxFlow environment.

#### Acceptance Criteria

1. THE 2048 Game SHALL implement a 4x4 grid of tiles
2. WHEN the game starts, THE 2048 Game SHALL spawn two random tiles with value 2 or 4
3. WHEN the user swipes up, THE 2048 Game SHALL move all tiles upward and merge matching adjacent tiles
4. WHEN the user swipes down, THE 2048 Game SHALL move all tiles downward and merge matching adjacent tiles
5. WHEN the user swipes left, THE 2048 Game SHALL move all tiles leftward and merge matching adjacent tiles
6. WHEN the user swipes right, THE 2048 Game SHALL move all tiles rightward and merge matching adjacent tiles
7. WHEN two tiles with the same value merge, THE 2048 Game SHALL create a new tile with double the value
8. WHEN tiles merge, THE 2048 Game SHALL add the merged tile value to the score
9. WHEN a move is completed, THE 2048 Game SHALL spawn one new tile with value 2 or 4 in a random empty position
10. THE 2048 Game SHALL use GestureDetector to capture swipe gestures
11. THE 2048 Game SHALL apply the glassmorphism design style with frosted glass effects
12. THE 2048 Game SHALL use neon colors for tiles on a dark background
13. THE 2048 Game SHALL display the current score prominently
14. WHEN no valid moves remain, THE 2048 Game SHALL detect game over state
15. WHEN the game is over, THE 2048 Game SHALL display a game over message with the final score

