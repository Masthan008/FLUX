# Design Document

## Overview

This design document outlines the implementation approach for critical bug fixes in the FluxFlow alarm and timetable systems, along with new features including reminder notes and a 2048 game module. The solution addresses permission issues on Android 13+, fixes silent alarm problems, resolves timetable persistence bugs, and adds engaging new functionality while maintaining the app's glassmorphic design aesthetic.

## Architecture

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         Main App (Enhanced)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │ Permission   │  │  Alarm System│  │  Timetable   │          │
│  │  Manager     │◄─┤  (Enhanced)  │  │  Service v3  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│         │                  │                   │                 │
│         ▼                  ▼                   ▼                 │
│  ┌──────────────────────────────────────────────────┐           │
│  │         RingScreen (with Notes Display)          │           │
│  └──────────────────────────────────────────────────┘           │
│                                                                  │
│  ┌──────────────────────────────────────────────────┐           │
│  │         2048 Game Module (New)                   │           │
│  │  ┌────────────┐  ┌────────────┐  ┌────────────┐ │           │
│  │  │ Game Logic │  │ Swipe      │  │ UI Renderer│ │           │
│  │  │ Controller │◄─┤ Detector   │◄─┤ (Glass)    │ │           │
│  │  └────────────┘  └────────────┘  └────────────┘ │           │
│  └──────────────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────────┘
```

## Components and Interfaces

### 1. Permission Management Enhancement

**File**: `lib/main.dart` (Modified)

**Purpose**: Request all necessary Android permissions before app initialization to ensure alarms work reliably.

**Changes Required**:

1. **Update _requestPermissions() function**:
```dart
Future<void> _requestPermissions() async {
  // Notification permission (Android 13+)
  if (await Permission.notification.isDenied) {
    final status = await Permission.notification.request();
    debugPrint('Notification permission: $status');
  }
  
  // Exact alarm permission (Android 14+)
  if (await Permission.scheduleExactAlarm.isDenied) {
    final status = await Permission.scheduleExactAlarm.request();
    debugPrint('Schedule exact alarm permission: $status');
  }
  
  // System alert window permission (for full-screen intent)
  if (await Permission.systemAlertWindow.isDenied) {
    final status = await Permission.systemAlertWindow.request();
    debugPrint('System alert window permission: $status');
  }
}
```

**Design Rationale**:
- **Permission.notification**: Required for Android 13+ to show any notifications
- **Permission.scheduleExactAlarm**: Required for Android 14+ to schedule exact alarms
- **Permission.systemAlertWindow**: Enables full-screen alarm notifications even when device is locked
- **Logging**: Debug prints help diagnose permission issues during development
- **Non-blocking**: App continues even if permissions denied (graceful degradation)

### 2. Alarm Audio Default Path Fix

**File**: `lib/modules/alarm/alarm_service.dart` (Modified)

**Purpose**: Ensure alarms always have a valid audio file to prevent silent alarms.

**Changes Required**:

1. **Add default audio path constant**:
```dart
class AlarmService {
  static const String defaultAudioPath = 'assets/sounds/mozart.mp3';
  
  // ... existing code
}
```

2. **Update scheduleAlarm() method**:
```dart
static Future<void> scheduleAlarm({
  required int id,
  required DateTime dateTime,
  String? assetAudioPath, // Changed to nullable
  required String notificationTitle,
  required String notificationBody,
  bool loopAudio = true,
  bool vibrate = true,
  bool androidFullScreenIntent = true,
}) async {
  // Validate and default audio path
  final audioPath = (assetAudioPath == null || assetAudioPath.isEmpty)
      ? defaultAudioPath
      : assetAudioPath;
  
  final alarmSettings = AlarmSettings(
    id: id,
    dateTime: dateTime,
    assetAudioPath: audioPath, // Use validated path
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
- **Nullable parameter**: Allows callers to omit audio path
- **Validation**: Checks for null or empty string
- **Default fallback**: Uses mozart.mp3 which already exists in assets
- **Backward compatible**: Existing code with explicit paths continues to work

### 3. Timetable Persistence Fix (v3)

**File**: `lib/services/timetable_service.dart` (Modified)

**Purpose**: Fix timetable data not persisting correctly by using a new version key and ensuring proper Hive box operations.

**Changes Required**:

1. **Update seed flag key**:
```dart
class TimetableService {
  static const String _seedFlagKey = 'timetable_seeded_v3'; // Changed from 'timetable_seeded'
  static const String _boxName = 'class_sessions';
  
  // ... rest of code
}
```

2. **Ensure proper Hive box handling**:
```dart
static Future<void> initializeTimetable() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final isSeeded = prefs.getBool(_seedFlagKey) ?? false;

    if (isSeeded) {
      debugPrint('Timetable already seeded (v3), skipping initialization');
      return;
    }

    debugPrint('Seeding timetable v3...');

    // Ensure box is open
    final box = Hive.isBoxOpen(_boxName)
        ? Hive.box<ClassSession>(_boxName)
        : await Hive.openBox<ClassSession>(_boxName);

    // Clear any existing data (fresh start for v3)
    await box.clear();

    // Create all class sessions
    final sessions = _createAllSessions();

    // Store in Hive with explicit keys
    for (final session in sessions) {
      await box.put(session.id, session);
    }

    // Verify data was saved
    final savedCount = box.length;
    debugPrint('Saved $savedCount sessions to Hive');

    // Mark as seeded only after successful save
    if (savedCount == sessions.length) {
      await prefs.setBool(_seedFlagKey, true);
      debugPrint('Timetable v3 seeded successfully');
    } else {
      debugPrint('Warning: Expected ${sessions.length} sessions but saved $savedCount');
    }
  } catch (e) {
    debugPrint('Error initializing timetable v3: $e');
  }
}
```

**Design Rationale**:
- **Version key (v3)**: Forces re-seeding for users with corrupted data
- **Box state check**: Prevents errors from opening already-open boxes
- **Clear existing data**: Ensures clean slate for v3 migration
- **Verification**: Confirms data was actually saved before marking as seeded
- **Explicit keys**: Uses session.id as key for predictable retrieval

### 4. Timetable UI Integration

**File**: `lib/screens/timetable_screen.dart` (Modified - if exists)

**Purpose**: Ensure UI reactively updates when Hive data changes.

**Implementation Pattern**:
```dart
class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<ClassSession>('class_sessions').listenable(),
      builder: (context, Box<ClassSession> box, _) {
        final sessions = box.values.toList();
        
        if (sessions.isEmpty) {
          return Center(child: Text('No classes scheduled'));
        }
        
        // Render timetable UI
        return ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return ClassSessionCard(session: session);
          },
        );
      },
    );
  }
}
```

**Design Rationale**:
- **ValueListenableBuilder**: Automatically rebuilds when Hive box changes
- **Reactive**: No manual refresh needed
- **Efficient**: Only rebuilds when data actually changes

### 5. Alarm Reminder Notes Feature

**File**: `lib/modules/alarm/alarm_service.dart` (Modified)

**Purpose**: Support optional reminder notes that display when alarm rings.

**Data Model Enhancement**:

Since `AlarmSettings` from the alarm package doesn't support custom fields, we'll use the notification body to store the note:

```dart
static Future<void> scheduleAlarm({
  required int id,
  required DateTime dateTime,
  String? assetAudioPath,
  required String notificationTitle,
  required String notificationBody,
  String? reminderNote, // New parameter
  bool loopAudio = true,
  bool vibrate = true,
  bool androidFullScreenIntent = true,
}) async {
  final audioPath = (assetAudioPath == null || assetAudioPath.isEmpty)
      ? defaultAudioPath
      : assetAudioPath;
  
  // Append reminder note to notification body if provided
  final fullBody = reminderNote != null && reminderNote.isNotEmpty
      ? '$notificationBody\n\n📝 $reminderNote'
      : notificationBody;
  
  final alarmSettings = AlarmSettings(
    id: id,
    dateTime: dateTime,
    assetAudioPath: audioPath,
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
      body: fullBody,
      stopButton: 'Stop',
    ),
  );

  await Alarm.set(alarmSettings: alarmSettings);
}
```

**File**: `lib/screens/ring_screen.dart` (Modified)

**Purpose**: Display reminder note prominently when alarm rings.

**Changes Required**:

1. **Extract note from notification body**:
```dart
class _AlarmRingScreenState extends State<AlarmRingScreen> {
  String? _reminderNote;
  
  @override
  void initState() {
    super.initState();
    _extractReminderNote();
    _generateMathProblem();
    _controller.addListener(_checkAnswer);
  }
  
  void _extractReminderNote() {
    final body = widget.alarmSettings.notificationSettings.body;
    if (body.contains('\n\n📝 ')) {
      final parts = body.split('\n\n📝 ');
      if (parts.length > 1) {
        _reminderNote = parts[1];
      }
    }
  }
  
  // ... rest of code
}
```

2. **Display note in UI**:
```dart
@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    child: Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(/* ... */),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("ALARM RINGING", /* ... */),
                const SizedBox(height: 20),
                
                // Reminder Note Display (NEW)
                if (_reminderNote != null) ...[
                  GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.note_alt_outlined,
                          color: Colors.yellowAccent,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _reminderNote!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                
                // Existing math problem UI
                GlassContainer(/* ... */),
                // ... rest of UI
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
```

**Design Rationale**:
- **Embedded in notification**: Leverages existing AlarmSettings structure
- **Delimiter pattern**: Uses `\n\n📝 ` as a unique separator
- **Optional**: Only displays if note exists
- **Prominent**: Large font and icon make it impossible to miss
- **Glassmorphic**: Matches app's design language

### 6. 2048 Game Module

**File**: `lib/modules/games/game_2048_screen.dart` (New)

**Purpose**: Provide an engaging 2048 game with glassmorphic design.

**Architecture**:

```
Game2048Screen (StatefulWidget)
├── Game2048State
│   ├── _grid: List<List<int>> (4x4)
│   ├── _score: int
│   ├── _gameOver: bool
│   └── Methods:
│       ├── _initializeGame()
│       ├── _addRandomTile()
│       ├── _move(Direction)
│       ├── _mergeTiles(Direction)
│       ├── _checkGameOver()
│       └── _handleSwipe(DragEndDetails)
└── UI Components:
    ├── Score Display
    ├── 4x4 Grid (GestureDetector)
    └── Game Over Overlay
```

**Core Game Logic**:

1. **Grid Representation**:
```dart
class _Game2048ScreenState extends State<Game2048Screen> {
  late List<List<int>> _grid;
  int _score = 0;
  bool _gameOver = false;
  
  @override
  void initState() {
    super.initState();
    _initializeGame();
  }
  
  void _initializeGame() {
    _grid = List.generate(4, (_) => List.filled(4, 0));
    _score = 0;
    _gameOver = false;
    _addRandomTile();
    _addRandomTile();
  }
  
  void _addRandomTile() {
    final emptyCells = <Point<int>>[];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) {
          emptyCells.add(Point(i, j));
        }
      }
    }
    
    if (emptyCells.isEmpty) return;
    
    final random = Random();
    final cell = emptyCells[random.nextInt(emptyCells.length)];
    _grid[cell.x][cell.y] = random.nextDouble() < 0.9 ? 2 : 4;
  }
}
```

2. **Swipe Detection**:
```dart
Widget build(BuildContext context) {
  return GestureDetector(
    onVerticalDragEnd: (details) {
      if (details.primaryVelocity! < -100) {
        _move(Direction.up);
      } else if (details.primaryVelocity! > 100) {
        _move(Direction.down);
      }
    },
    onHorizontalDragEnd: (details) {
      if (details.primaryVelocity! < -100) {
        _move(Direction.left);
      } else if (details.primaryVelocity! > 100) {
        _move(Direction.right);
      }
    },
    child: _buildGameUI(),
  );
}
```

3. **Move and Merge Logic**:
```dart
void _move(Direction direction) {
  if (_gameOver) return;
  
  final oldGrid = _grid.map((row) => List<int>.from(row)).toList();
  
  switch (direction) {
    case Direction.up:
      _moveUp();
      break;
    case Direction.down:
      _moveDown();
      break;
    case Direction.left:
      _moveLeft();
      break;
    case Direction.right:
      _moveRight();
      break;
  }
  
  // Check if grid changed
  bool gridChanged = false;
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (oldGrid[i][j] != _grid[i][j]) {
        gridChanged = true;
        break;
      }
    }
  }
  
  if (gridChanged) {
    _addRandomTile();
    _checkGameOver();
    setState(() {});
  }
}

void _moveLeft() {
  for (int i = 0; i < 4; i++) {
    // Compress: move all non-zero tiles left
    final row = _grid[i].where((val) => val != 0).toList();
    
    // Merge: combine adjacent equal tiles
    for (int j = 0; j < row.length - 1; j++) {
      if (row[j] == row[j + 1]) {
        row[j] *= 2;
        _score += row[j];
        row.removeAt(j + 1);
      }
    }
    
    // Fill remaining with zeros
    while (row.length < 4) {
      row.add(0);
    }
    
    _grid[i] = row;
  }
}

// Similar implementations for _moveRight(), _moveUp(), _moveDown()
```

4. **Game Over Detection**:
```dart
void _checkGameOver() {
  // Check for empty cells
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      if (_grid[i][j] == 0) return;
    }
  }
  
  // Check for possible merges
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      final current = _grid[i][j];
      // Check right
      if (j < 3 && _grid[i][j + 1] == current) return;
      // Check down
      if (i < 3 && _grid[i + 1][j] == current) return;
    }
  }
  
  _gameOver = true;
}
```

**UI Design**:

1. **Glassmorphic Tiles**:
```dart
Widget _buildTile(int value) {
  final color = _getTileColor(value);
  
  return GlassContainer(
    width: 70,
    height: 70,
    borderRadius: 10,
    child: Center(
      child: value == 0
          ? const SizedBox.shrink()
          : Text(
              value.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: value < 100 ? 32 : (value < 1000 ? 28 : 24),
                fontWeight: FontWeight.bold,
              ),
            ),
    ),
  );
}

Color _getTileColor(int value) {
  switch (value) {
    case 2: return const Color(0xFF00FFFF); // Cyan
    case 4: return const Color(0xFF00FF00); // Green
    case 8: return const Color(0xFFFFFF00); // Yellow
    case 16: return const Color(0xFFFF00FF); // Magenta
    case 32: return const Color(0xFFFF0000); // Red
    case 64: return const Color(0xFF0000FF); // Blue
    case 128: return const Color(0xFFFF6600); // Orange
    case 256: return const Color(0xFF9900FF); // Purple
    case 512: return const Color(0xFFFF0099); // Pink
    case 1024: return const Color(0xFF00FF99); // Mint
    case 2048: return const Color(0xFFFFD700); // Gold
    default: return Colors.white24;
  }
}
```

2. **Score Display**:
```dart
Widget _buildScoreBoard() {
  return GlassContainer(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'SCORE',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _score.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
```

3. **Game Over Overlay**:
```dart
Widget _buildGameOverOverlay() {
  return Container(
    color: Colors.black87,
    child: Center(
      child: GlassContainer(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Final Score: $_score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _initializeGame();
                });
              },
              child: const Text('PLAY AGAIN'),
            ),
          ],
        ),
      ),
    ),
  );
}
```

**Design Rationale**:
- **Standard 2048 rules**: Familiar gameplay
- **Neon colors**: Matches FluxFlow's vibrant aesthetic
- **Glassmorphism**: Consistent with app design
- **Swipe gestures**: Natural mobile interaction
- **Score tracking**: Provides progression feedback
- **Game over detection**: Proper end-game handling

## Data Models

### Enhanced Alarm Data (Conceptual)

Since we're embedding notes in notification body, no new model needed:

```dart
// Conceptual representation
{
  "id": 1,
  "dateTime": "2024-11-25T07:00:00",
  "assetAudioPath": "assets/sounds/mozart.mp3",
  "notificationTitle": "Morning Alarm",
  "notificationBody": "Time to wake up!\n\n📝 Review Chemistry Formula!",
  "loopAudio": true,
  "vibrate": true,
  "androidFullScreenIntent": true
}
```

### 2048 Game State

```dart
class Game2048State {
  List<List<int>> grid; // 4x4 grid
  int score;
  bool gameOver;
}
```

## Error Handling

### Permission Handling

1. **Permission Denied**:
   - Log denial with debugPrint
   - Continue app initialization
   - Alarms may not work reliably but app doesn't crash

2. **Permission Permanently Denied**:
   - Show dialog explaining why permissions are needed
   - Provide button to open app settings

### Alarm Audio Handling

1. **Missing Audio File**:
   - Default to mozart.mp3
   - Log warning if default also missing
   - Alarm still triggers (may be silent)

2. **Invalid Audio Path**:
   - Validate path format
   - Fall back to default
   - Log error for debugging

### Timetable Persistence

1. **Hive Box Access Failure**:
   - Wrap in try-catch
   - Log error details
   - Retry once after delay
   - If still fails, show error to user

2. **SharedPreferences Failure**:
   - Assume not seeded
   - Proceed with initialization
   - May result in duplicate data (acceptable)

### 2048 Game

1. **Invalid Move**:
   - Silently ignore (no grid change)
   - Don't add new tile
   - Don't update state

2. **Grid Corruption**:
   - Detect invalid state
   - Reset game
   - Log error for debugging

## Testing Strategy

### Unit Tests

1. **Permission Manager**:
   - Mock permission_handler
   - Test all permission combinations
   - Verify logging

2. **Alarm Audio Default**:
   - Test with null path
   - Test with empty string
   - Test with valid path
   - Verify default fallback

3. **Timetable v3 Migration**:
   - Test fresh install
   - Test upgrade from v2
   - Verify data persistence
   - Test box operations

4. **2048 Game Logic**:
   - Test move operations (all directions)
   - Test merge logic
   - Test score calculation
   - Test game over detection
   - Test random tile generation

### Integration Tests

1. **Permission Flow**:
   - Launch app
   - Verify permission dialogs appear
   - Test with granted/denied permissions

2. **Alarm with Note**:
   - Schedule alarm with note
   - Trigger alarm
   - Verify note displays on RingScreen

3. **Timetable Persistence**:
   - Clear app data
   - Launch app
   - Verify 19 classes created
   - Restart app
   - Verify data persists

4. **2048 Gameplay**:
   - Play full game
   - Test all swipe directions
   - Verify merges work correctly
   - Reach game over state

### Manual Testing Checklist

- [ ] Permissions requested on first launch
- [ ] Alarm plays sound even without custom audio
- [ ] Timetable loads correctly after fresh install
- [ ] Timetable persists across app restarts
- [ ] Alarm note displays prominently on RingScreen
- [ ] 2048 game responds to swipes
- [ ] Tiles merge correctly in all directions
- [ ] Score updates properly
- [ ] Game over detected correctly
- [ ] Glassmorphic design consistent throughout

## Dependencies

### Existing Dependencies (No Changes)

- `permission_handler: ^12.0.1` - Already in pubspec.yaml
- `alarm: ^5.1.5` - Already in use
- `hive: ^2.2.3` - Already in use
- `shared_preferences: ^2.5.3` - Already in use
- `glassmorphism: ^3.0.0` - For 2048 UI

### Assets Required

- `assets/sounds/mozart.mp3` - Must exist for default alarm sound

## Performance Considerations

1. **Permission Requests**:
   - Minimal overhead (<50ms)
   - Non-blocking

2. **Timetable v3 Migration**:
   - One-time operation
   - ~19 database operations
   - Completes in <100ms

3. **Alarm Note Parsing**:
   - String split operation
   - Negligible overhead (<1ms)

4. **2048 Game**:
   - Grid operations: O(16) per move
   - UI rebuilds: Only on state change
   - Memory: ~1KB for game state
   - Smooth 60fps gameplay expected

## Security Considerations

- No sensitive data in reminder notes
- Permissions follow Android best practices
- No network communication
- All data stored locally
- No user authentication required

## Future Enhancements

1. **Permission Education**:
   - Show rationale before requesting
   - Provide in-app settings link

2. **Rich Alarm Notes**:
   - Support markdown formatting
   - Add images/emojis
   - Voice notes

3. **2048 Enhancements**:
   - Leaderboard (local)
   - Different grid sizes (3x3, 5x5)
   - Themes and color schemes
   - Undo functionality
   - Save game state

4. **Timetable Sync**:
   - Cloud backup
   - Multi-device sync
   - Share timetables with friends

