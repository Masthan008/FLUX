# Requirements Document

## Introduction

This document specifies the requirements for enhancing the FluxFlow application with improved alarm looping functionality and an automated timetable seeding system for RGMCET class schedules. The system shall provide reliable alarm notifications with proper looping behavior and pre-populate class schedules on first app launch.

## Glossary

- **Alarm System**: The component responsible for scheduling and triggering alarm notifications
- **Timetable Seeder**: The service that initializes the class schedule data on first app run
- **ClassSession**: A data model representing a single class period with subject, day, and time information
- **Hive**: The local database system used for persistent storage
- **SharedPreferences**: A key-value storage system for app configuration flags
- **AlarmSettings**: Configuration object for alarm behavior including looping and volume
- **RGMCET**: Rajiv Gandhi Memorial College of Engineering and Technology

## Requirements

### Requirement 1: Alarm Looping Enhancement

**User Story:** As a student, I want alarms to loop continuously with proper volume control, so that I don't miss important class reminders even if I'm not immediately near my device.

#### Acceptance Criteria

1. WHEN an alarm is scheduled, THE Alarm System SHALL configure AlarmSettings with loopAudio set to true
2. WHEN an alarm is scheduled on Android devices, THE Alarm System SHALL configure AlarmSettings with androidFullScreenIntent set to true
3. WHEN an alarm triggers, THE Alarm System SHALL apply VolumeSettings with fade configuration starting at volume 1.0 over 5 seconds duration
4. WHEN volume settings are applied, THE Alarm System SHALL enforce volume with volumeEnforced set to true
5. WHEN an alarm is created, THE Alarm System SHALL validate that all required settings are properly configured before scheduling

### Requirement 2: Timetable Data Model

**User Story:** As a developer, I want a structured data model for class sessions, so that class schedule information can be stored and retrieved efficiently from the local database.

#### Acceptance Criteria

1. THE ClassSession model SHALL define a field named id of type String
2. THE ClassSession model SHALL define a field named subjectName of type String
3. THE ClassSession model SHALL define a field named dayOfWeek of type int where 1 represents Monday and 6 represents Saturday
4. THE ClassSession model SHALL define a field named startTime of type DateTime
5. THE ClassSession model SHALL define a field named endTime of type DateTime
6. THE ClassSession model SHALL use HiveType annotation for database serialization
7. THE ClassSession model SHALL use HiveField annotations for each field with unique index values

### Requirement 3: Timetable Initialization Service

**User Story:** As a student, I want the RGMCET class schedule to be automatically loaded when I first open the app, so that I don't have to manually enter all my classes.

#### Acceptance Criteria

1. WHEN the app launches, THE Timetable Seeder SHALL check SharedPreferences for a key named 'timetable_seeded'
2. IF 'timetable_seeded' is true, THEN THE Timetable Seeder SHALL skip initialization and return immediately
3. IF 'timetable_seeded' is false or null, THEN THE Timetable Seeder SHALL create ClassSession objects for all scheduled classes
4. WHEN creating class sessions, THE Timetable Seeder SHALL store each ClassSession object in the Hive database
5. WHEN all class sessions are stored, THE Timetable Seeder SHALL set 'timetable_seeded' to true in SharedPreferences
6. THE Timetable Seeder SHALL create sessions for Monday with BCE (9:00-10:40), CE (11:00-11:50), LAAC (13:00-13:50), and CHE (15:00-17:00)
7. THE Timetable Seeder SHALL create sessions for Tuesday with EWS (9:00-11:50), IP LAB (13:50-15:00), and SS (15:00-17:00)
8. THE Timetable Seeder SHALL create sessions for Wednesday with EC LAB (9:00-11:50), BME (13:50-14:40), and IP LAB (15:00-17:00)
9. THE Timetable Seeder SHALL create sessions for Thursday with IP (9:00-10:40), LAAC (11:00-11:50), CHE (13:00-13:50), and CE LAB (13:50-17:00)
10. THE Timetable Seeder SHALL create sessions for Friday with CE (9:00-10:40), BME (11:00-11:50), LAAC (13:50-14:40), and EAA (15:00-16:50)
11. THE Timetable Seeder SHALL handle errors gracefully and log failures without crashing the application

### Requirement 4: Timetable Integration

**User Story:** As a student, I want the timetable to be initialized automatically when the app starts, so that my class schedule is ready to use immediately.

#### Acceptance Criteria

1. WHEN the application initializes, THE Alarm System SHALL call the Timetable Seeder initialization function
2. WHEN Hive is initialized, THE Alarm System SHALL register the ClassSession adapter before opening any boxes
3. WHEN the timetable is seeded, THE Alarm System SHALL open or create a Hive box named 'class_sessions' for storing ClassSession objects
4. THE Alarm System SHALL ensure timetable initialization completes before the main app UI is displayed
