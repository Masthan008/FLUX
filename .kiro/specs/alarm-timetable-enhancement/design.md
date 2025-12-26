# Design Document

## Overview

This design document outlines the implementation approach for enhancing the FluxFlow alarm system with improved looping capabilities and adding an automated timetable seeding system for RGMCET class schedules. The solution integrates with the existing alarm infrastructure and Hive database while maintaining clean separation of concerns.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Main App                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Alarm System │  │  Timetable   │  │    Hive DB   │      │
│  │   Enhanced   │◄─┤   Seeder     │◄─┤  ClassSession│      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│         │                  │                   │             │
│         ▼                  ▼                   ▼             │
│  ┌──────────────────────────────────────────────────┐       │
│  │         SharedPreferences & Storage              │       │
│  └──────────────────────────────────────────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### Component Interaction Flow

1. **App Initialization**: Main app initializes Hive, registers adapters, and calls TimetableService
2. **Timetable Seeding**: TimetableService checks if seeding is needed and populates data
3. **Alarm Enhancement**: AlarmService uses updated settings for all alarm operations
4. **Data Persistence**: ClassSession objects stored in Hive, seeding flag in SharedPreferences

## Components and Interfaces

### 1. ClassSession Data Model

**File**: `lib/models/class_session.dart`

**Purpose**: Represents a single class period with all necessary scheduling information.

**Structure**:
```dart
@HiveType(typeId: 0)
class ClassSession extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String subjectName;
  
  @HiveField(2)
  int dayOfWeek; // 1=Monday, 2=Tuesday, ..., 6=Saturday
  
  @HiveField(3)
  DateTime startTime;
  
  @HiveField(4)
  DateTime endTime;
  
  ClassSession({
    required this.id,
    required this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
  });
}
```

**Design Decisions**:
- Uses Hive annotations for automatic serialization
- `typeId: 0` assigned for Hive adapter registration
- `dayOfWeek` as int (1-6) for easy comparison and sorting
- DateTime objects for precise time handling
- Extends HiveObject for built-in Hive functionality

### 2. TimetableService

**File**: `lib/services/timetable_service.dart`

**Purpose**: Manages initialization and seeding of the RGMCET class schedule.

**Public Interface**:
```dart
class TimetableService {
  static Future<void> initializeTimetable() async;
  static Future<List<ClassSession>> getTodayClasses() async;
  static Future<List<ClassSession>> getClassesForDay(int dayOfWeek) async;
}
```

**Key Methods**:

1. **initializeTimetable()**
   - Checks SharedPreferences for 'timetable_seeded' flag
   - If not seeded, creates all ClassSession objects
   - Stores sessions in Hive box 'class_sessions'
   - Sets 'timetable_seeded' to true
   - Handles errors gracefully with try-catch

2. **getTodayClasses()**
   - Returns list of classes for current day
   - Useful for UI display and scheduling

3. **getClassesForDay(int dayOfWeek)**
   - Returns classes for specific day
   - Enables weekly view functionality

**Timetable Data Structure**:

| Day | Classes |
|-----|---------|
| Monday (1) | BCE (9:00-10:40), CE (11:00-11:50), LAAC (13:00-13:50), CHE (15:00-17:00) |
| Tuesday (2) | EWS (9:00-11:50), IP LAB (13:50-15:00), SS (15:00-17:00) |
| Wednesday (3) | EC LAB (9:00-11:50), BME (13:50-14:40), IP LAB (15:00-17:00) |
| Thursday (4) | IP (9:00-10:40), LAAC (11:00-11:50), CHE (13:00-13:50), CE LAB (13:50-17:00) |
| Friday (5) | CE (9:00-10:40), BME (11:00-11:50), LAAC (13:50-14:40), EAA (15:00-16:50) |

**ID Generation Strategy**:
- Format: `{dayOfWeek}_{subjectCode}_{startHour}{startMinute}`
- Example: `1_BCE_0900` for Monday BCE class at 9:00
- Ensures uniqueness and readability

### 3. Enhanced AlarmService

**File**: `lib/modules/alarm/alarm_service.dart` (Modified)

**Changes Required**:

1. **Update scheduleAlarm() method**:
   - Change `VolumeSettings.fixed()` to `VolumeSettings.fade()`
   - Set volume to 1.0 (maximum)
   - Set fadeDuration to 5 seconds
   - Ensure volumeEnforced is true
   - Add androidFullScreenIntent parameter

**Updated Method Signature**:
```dart
static Future<void> scheduleAlarm({
  required int id,
  required DateTime dateTime,
  required String assetAudioPath,
  required String notificationTitle,
  required String notificationBody,
  bool loopAudio = true,
  bool vibrate = true,
  bool androidFullScreenIntent = true,
}) async {
  final alarmSettings = AlarmSettings(
    id: id,
    dateTime: dateTime,
    assetAudioPath: assetAudioPath,
    loopAudio: loopAudio,
    vibrate: vibrate,
    androidFullScreenIntent: androidFullScreenIntent,
    volumeSettings: VolumeSettings.fade(
      volume: 1.0,
      fadeDuration: const Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: NotificationSettings(
      title: notificationTitle,
      body: notificationBody,
      stopButton: 'Stop',
    ),
  );
  
  await Alarm.set(alarmSettings: alarmSettings);
}
```

**Design Rationale**:
- **VolumeSettings.fade()**: Gradually increases volume from 0 to 1.0 over 5 seconds, providing a gentler wake-up experience
- **volume: 1.0**: Ensures alarm is audible even in noisy environments
- **volumeEnforced: true**: Overrides device volume settings to guarantee alarm sounds
- **androidFullScreenIntent: true**: Critical for Android 14+ to show full-screen alarm notifications
- **loopAudio: true**: Ensures alarm continues until dismissed

### 4. Main App Integration

**File**: `lib/main.dart` (Modified)

**Changes Required**:

1. **Register ClassSession Hive Adapter**:
   - Add after `Hive.initFlutter()`
   - Before opening any boxes

2. **Open class_sessions Box**:
   - Create/open box for ClassSession storage

3. **Initialize Timetable**:
   - Call `TimetableService.initializeTimetable()`
   - Execute before app UI loads

4. **Add SharedPreferences Dependency**:
   - Import `shared_preferences` package

**Updated Initialization Flow**:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(ClassSessionAdapter());
  
  // Open Boxes
  await Hive.openBox('calculator_history');
  await Hive.openBox<ClassSession>('class_sessions');
  
  // Initialize Alarm Service
  await AlarmService.init();
  
  // Initialize Timetable (seeds on first run)
  await TimetableService.initializeTimetable();
  
  // Request Permissions
  await _requestPermissions();
  
  runApp(/* ... */);
}
```

## Data Models

### ClassSession Schema

| Field | Type | Description | Hive Index |
|-------|------|-------------|------------|
| id | String | Unique identifier | 0 |
| subjectName | String | Subject/course name | 1 |
| dayOfWeek | int | Day (1-6) | 2 |
| startTime | DateTime | Class start time | 3 |
| endTime | DateTime | Class end time | 4 |

### Storage Strategy

**Hive Box**: `class_sessions`
- Type: `Box<ClassSession>`
- Key: Auto-generated by Hive or use ClassSession.id
- Persistence: Local device storage

**SharedPreferences Keys**:
- `timetable_seeded`: Boolean flag indicating if initial seeding is complete

## Error Handling

### TimetableService Error Handling

1. **SharedPreferences Access Failure**:
   - Log error with debugPrint
   - Assume not seeded and proceed with initialization
   - Prevents app crash on storage issues

2. **Hive Box Access Failure**:
   - Wrap in try-catch block
   - Log error details
   - Return empty list for query methods
   - Prevents data corruption

3. **DateTime Parsing Errors**:
   - Validate time inputs before creating ClassSession
   - Use default times if parsing fails
   - Log warnings for debugging

### AlarmService Error Handling

1. **Invalid AlarmSettings**:
   - Validate all required fields before calling Alarm.set()
   - Throw descriptive exceptions for missing data
   - Log configuration errors

2. **Permission Denied**:
   - Already handled in main.dart
   - AlarmService assumes permissions granted
   - Graceful degradation if alarm fails to set

## Testing Strategy

### Unit Tests

1. **ClassSession Model Tests**:
   - Test Hive serialization/deserialization
   - Validate field constraints
   - Test equality and hashCode

2. **TimetableService Tests**:
   - Mock SharedPreferences
   - Mock Hive box operations
   - Test seeding logic with various states
   - Verify correct ClassSession creation
   - Test query methods (getTodayClasses, getClassesForDay)

3. **AlarmService Tests**:
   - Verify VolumeSettings.fade configuration
   - Test androidFullScreenIntent setting
   - Validate loopAudio behavior
   - Mock Alarm.set() calls

### Integration Tests

1. **First Launch Scenario**:
   - Clean app state
   - Verify timetable seeding occurs
   - Confirm SharedPreferences flag set
   - Validate all 19 classes created

2. **Subsequent Launch Scenario**:
   - Pre-seeded state
   - Verify seeding skipped
   - Confirm data persists

3. **Alarm Scheduling**:
   - Schedule alarm with new settings
   - Verify volume fade configuration
   - Test on Android device for full-screen intent

### Manual Testing Checklist

- [ ] First app launch seeds timetable correctly
- [ ] Second launch skips seeding
- [ ] All 19 classes appear in Hive database
- [ ] Alarm loops continuously when triggered
- [ ] Volume fades from 0 to max over 5 seconds
- [ ] Full-screen notification appears on Android 14+
- [ ] Alarm overrides device volume settings
- [ ] getTodayClasses returns correct classes for current day

## Dependencies

### New Dependencies Required

Add to `pubspec.yaml`:
```yaml
dependencies:
  shared_preferences: ^2.2.2  # For seeding flag storage
```

### Existing Dependencies Used

- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Flutter integration
- `alarm: ^5.1.5` - Alarm functionality
- `provider: ^6.1.5+1` - State management

## Migration Considerations

### Backward Compatibility

- Existing alarms will continue to work
- New alarm settings apply only to newly created alarms
- No data migration needed for existing users
- Timetable seeding is additive (doesn't affect existing data)

### Version Considerations

- Hive typeId 0 reserved for ClassSession
- Future models should use typeId 1, 2, etc.
- SharedPreferences key namespace: `timetable_*`

## Performance Considerations

1. **Timetable Seeding**:
   - One-time operation on first launch
   - ~19 database writes (negligible impact)
   - Completes in <100ms on average devices

2. **Query Performance**:
   - Hive queries are synchronous and fast
   - Filtering by dayOfWeek is O(n) but n is small (~19 items)
   - No performance concerns for current scale

3. **Memory Usage**:
   - ClassSession objects are lightweight (~200 bytes each)
   - Total memory footprint: <4KB for all sessions
   - Negligible impact on app memory

## Security Considerations

- No sensitive data stored in ClassSession
- SharedPreferences not encrypted (flag only)
- Hive database stored in app-private directory
- No network communication required
- No user authentication needed for timetable feature

## Future Enhancements

1. **Dynamic Timetable Updates**:
   - Allow users to edit/add/remove classes
   - Sync with cloud service
   - Support multiple timetables

2. **Smart Reminders**:
   - Auto-schedule alarms based on ClassSession data
   - Configurable reminder times (e.g., 10 mins before class)
   - Skip reminders for holidays

3. **Analytics**:
   - Track alarm effectiveness
   - Class attendance patterns
   - Optimal reminder timing

4. **Notification Enhancements**:
   - Rich notifications with class details
   - Quick actions (snooze, dismiss, view details)
   - Custom notification sounds per subject
