# Implementation Plan

- [x] 1. Add SharedPreferences dependency


  - Add `shared_preferences: ^2.2.2` to pubspec.yaml dependencies section
  - Run `flutter pub get` to install the new dependency
  - _Requirements: 3.1_

- [x] 2. Create ClassSession data model with Hive integration

  - [x] 2.1 Create lib/models/class_session.dart file


    - Define ClassSession class with @HiveType(typeId: 0) annotation
    - Add id field (String) with @HiveField(0)
    - Add subjectName field (String) with @HiveField(1)
    - Add dayOfWeek field (int) with @HiveField(2)
    - Add startTime field (DateTime) with @HiveField(3)
    - Add endTime field (DateTime) with @HiveField(4)
    - Extend HiveObject for built-in Hive functionality
    - Create constructor with all required fields
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7_
  
  - [x] 2.2 Generate Hive adapter


    - Add `build_runner` and `hive_generator` to dev_dependencies if not present
    - Add part directive for generated file: `part 'class_session.g.dart';`
    - Run `flutter packages pub run build_runner build` to generate adapter
    - _Requirements: 2.6_

- [x] 3. Create TimetableService for schedule initialization

  - [x] 3.1 Create lib/services/timetable_service.dart file


    - Import required packages (hive, shared_preferences, class_session model)
    - Create TimetableService class with static methods
    - _Requirements: 3.1_
  
  - [x] 3.2 Implement initializeTimetable() method

    - Get SharedPreferences instance
    - Check for 'timetable_seeded' flag
    - Return early if flag is true
    - Open Hive box 'class_sessions'
    - Create ClassSession objects for Monday: BCE (9:00-10:40), CE (11:00-11:50), LAAC (13:00-13:50), CHE (15:00-17:00)
    - Create ClassSession objects for Tuesday: EWS (9:00-11:50), IP LAB (13:50-15:00), SS (15:00-17:00)
    - Create ClassSession objects for Wednesday: EC LAB (9:00-11:50), BME (13:50-14:40), IP LAB (15:00-17:00)
    - Create ClassSession objects for Thursday: IP (9:00-10:40), LAAC (11:00-11:50), CHE (13:00-13:50), CE LAB (13:50-17:00)
    - Create ClassSession objects for Friday: CE (9:00-10:40), BME (11:00-11:50), LAAC (13:50-14:40), EAA (15:00-16:50)
    - Store all ClassSession objects in Hive box
    - Set 'timetable_seeded' to true in SharedPreferences
    - Wrap in try-catch block with error logging
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 3.10, 3.11_
  
  - [x] 3.3 Implement getTodayClasses() helper method

    - Get current day of week
    - Query Hive box for classes matching current day
    - Return filtered list of ClassSession objects
    - Handle errors and return empty list on failure
    - _Requirements: 3.1_
  
  - [x] 3.4 Implement getClassesForDay(int dayOfWeek) helper method

    - Query Hive box for classes matching specified day
    - Return filtered list of ClassSession objects
    - Handle errors and return empty list on failure
    - _Requirements: 3.1_

- [x] 4. Update AlarmService with enhanced looping configuration

  - [x] 4.1 Modify scheduleAlarm() method in lib/modules/alarm/alarm_service.dart


    - Add androidFullScreenIntent parameter with default value true
    - Replace VolumeSettings.fixed() with VolumeSettings.fade()
    - Set volume to 1.0 (maximum volume)
    - Set fadeDuration to Duration(seconds: 5)
    - Ensure volumeEnforced is true
    - Ensure loopAudio parameter is passed to AlarmSettings
    - Add vibrate parameter to AlarmSettings constructor
    - Add androidFullScreenIntent parameter to AlarmSettings constructor
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

- [x] 5. Integrate timetable initialization into main app

  - [x] 5.1 Update lib/main.dart initialization sequence


    - Import ClassSession model and generated adapter
    - Import TimetableService
    - Import shared_preferences package
    - Register ClassSessionAdapter with Hive after Hive.initFlutter()
    - Open Hive box 'class_sessions' with type Box<ClassSession>
    - Call TimetableService.initializeTimetable() after AlarmService.init()
    - Ensure all initialization completes before runApp()
    - _Requirements: 4.1, 4.2, 4.3, 4.4_

- [ ] 6. Verify and test implementation




  - [x] 6.1 Test timetable seeding on first launch


    - Clear app data to simulate first launch
    - Run app and verify timetable_seeded flag is set
    - Check Hive database contains all 19 ClassSession objects
    - Verify correct data for each class (subject, day, times)
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_
  
  - [x] 6.2 Test timetable persistence on subsequent launches

    - Restart app without clearing data
    - Verify initializeTimetable() returns early
    - Confirm existing ClassSession data is preserved
    - _Requirements: 3.2_
  
  - [x] 6.3 Test enhanced alarm functionality


    - Schedule a test alarm
    - Verify alarm triggers with looping audio
    - Confirm volume fades from 0 to maximum over 5 seconds
    - Test on Android device to verify full-screen intent appears
    - Verify alarm overrides device volume settings
    - _Requirements: 1.1, 1.2, 1.3, 1.4_
  
  - [x] 6.4 Test query methods

    - Call getTodayClasses() and verify correct classes returned
    - Call getClassesForDay() for each day (1-5) and verify results
    - Test with invalid day numbers (0, 7) to ensure graceful handling
    - _Requirements: 3.1_
