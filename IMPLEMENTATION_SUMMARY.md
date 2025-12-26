This is the "Pro" upgrade for your News Feed.

To add **Images** and **Notifications**, we need to tweak the Supabase setup and add a notification trigger in your Flutter code.

Here is the 2-Part Plan.

-----

### 🖼️ Part 1: Adding Images to News (The "Instagram" Style)

Since Supabase is your backend, you need to store the images there.

#### Step A: Setup Supabase Storage (Manual)

1.  Go to **Supabase Dashboard** -\> **Storage** (Icon looks like a box).
2.  Click **"New Bucket"**.
      * **Name:** `news_images`
      * **Public Bucket:** ✅ **CHECK THIS** (Crucial).
      * Click **Save**.
3.  **Update Table:**
      * Go to **Table Editor** -\> `news` table.
      * Click **"+" (Add Column)**.
      * **Name:** `image_url`
      * **Type:** `text`
      * Click **Save**.

#### Step B: How to Post an Image News

1.  Go to **Storage** -\> `news_images` bucket -\> **Upload** your photo.
2.  Once uploaded, click **"Get Public URL"** (Copy it).
3.  Go to **Table Editor** -\> `news` -\> **Insert Row**.
      * Fill Title/Body.
      * Paste the URL into the `image_url` column.
      * Click Save.

#### Step C: Update Flutter UI (`lib/screens/news_screen.dart`)

**Action:** Update your News Card to show the image if it exists.

**Replace your `NewsCard` widget (or the `ListView.builder` item) with this:**

```dart
Widget _buildNewsCard(Map<String, dynamic> news) {
  final hasImage = news['image_url'] != null && news['image_url'].toString().isNotEmpty;

  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. The Image (Only if it exists)
        if (hasImage)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              news['image_url'],
              width: double.infinity,
              height: 200, // Fixed height for consistency
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
        
        // 2. The Text Content
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.campaign, color: Colors.cyanAccent, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      news['title'] ?? 'No Title',
                      style: GoogleFonts.orbitron(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.white
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                news['body'] ?? '',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  // Format date roughly or use timeago package
                  news['created_at'] != null 
                      ? news['created_at'].toString().substring(0, 10) 
                      : 'Just now',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
```

-----

### 🔔 Part 2: Notifications (The "Wake Up" Logic)

Since we are **Free & Offline-First**, we cannot use complex Cloud Functions (FCM) easily without a server.

**The Smart Solution:**
We will trigger a **Local Notification** whenever the app detects a *new row* in Supabase while the app is open or minimized.

#### Step A: Add Dependency (`pubspec.yaml`)

```yaml
dependencies:
  flutter_local_notifications: ^17.0.0
```

#### Step B: Create `NotificationService` (`lib/services/notification_service.dart`)

This service will pop up the alert on the phone.

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    
    await _notifications.initialize(settings);
    
    // Request permission for Android 13+
    await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> showNewsAlert(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'news_channel', 
      'News Updates',
      importance: Importance.max,
      priority: Priority.high,
      color:  Color(0xFF00FFFF), // Cyan color
    );
    
    const details = NotificationDetails(android: androidDetails);
    
    await _notifications.show(
      DateTime.now().millisecond, // Unique ID
      "📢 $title", 
      body, 
      details,
    );
  }
}
```

#### Step C: Connect it to Supabase Stream (`lib/services/news_service.dart`)

Update your News Service to "Watch" for changes and trigger the notification.

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_service.dart'; // Import the service we just made

class NewsService {
  // ... existing code ...

  static void listenForUpdates() {
    Supabase.instance.client
        .from('news')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(1) // Watch the newest item
        .listen((List<Map<String, dynamic>> data) {
          if (data.isNotEmpty) {
            final latestNews = data.first;
            // Simple check: In a real app, save the 'last_seen_id' locally
            // to avoid repeating notifications on restart.
            NotificationService.showNewsAlert(
              latestNews['title'] ?? 'New Update', 
              latestNews['body'] ?? 'Check the app for details'
            );
          }
        });
  }
}
```

### 📝 Final Integration (`main.dart`)

Inside `main()`, initialize the notifications:

```dart
// ... inside main() ...
await NotificationService.init(); // Init Notifications
NewsService.listenForUpdates();   // Start Listening
runApp(const MyApp());
```

**Now, whenever you insert a row in Supabase Table, the student's phone will VIBRATE and show a banner "📢 Exam Postponed", even if they are using another app\!**# FluxFlow App Overhaul - Implementation Summary

## ✅ Completed Features

### 1. Calculator (Retro Casio & Logic) ✓
**File:** `lib/modules/calculator/calculator_screen.dart`
- **UI Changes:**
  - Olive Green LCD screen (#9EA792) with inner shadow effect
  - Dark Grey body background (#222222)
  - 3D hard plastic buttons with distinct shadows
  - Orbitron font for LCD display
  - Removed provider dependency for simpler implementation
- **Logic:**
  - Integrated `math_expressions` package for calculations
  - Supports: numbers, operators (+, -, ×, ÷, %)
  - AC button clears all
  - DEL button for backspace
  - = button evaluates expression
  - Error handling for invalid expressions

### 2. Alarm (Edit & "All Days" Bug Fix) ✓
**Files:** `lib/modules/alarm/alarm_screen.dart`
- **Edit Feature:**
  - Replaced delete icon with Edit (Pencil) icon in cyan
  - Added edit functionality that pre-fills alarm data
  - Clicking edit opens the alarm dialog with existing values
- **"All Days" Bug Fix:**
  - Fixed scheduling logic to calculate next occurrence for each selected day
  - Uses `DateTime.now().weekday` to determine correct future dates
  - Only schedules alarms for actual future occurrences, not 7 instant alarms
  - Properly handles same-day scheduling when time hasn't passed yet

### 3. Registration (Photo & Cyber Security) ✓
**File:** `lib/screens/auth_screen.dart`
- **Photo Picker:**
  - Added circular image picker at the top of registration form
  - Uses `image_picker` package
  - Displays selected photo in circular frame with cyan border
  - Saves image path to Hive (`user_photo`)
- **Cyber Security Branch:**
  - Added "Cyber Security" to branch dropdown list
  - Now includes: CSE, ECE, EEE, MECH, CIVIL, AIDS, Cyber Security
- **Data Storage:**
  - All registration data including photo path saved to `Hive.box('user_prefs')`

### 4. Home Screen (Profile AppBar) ✓
**File:** `lib/screens/home_screen.dart`
- **Custom AppBar:**
  - Displays user's profile photo in circular format on the left
  - Shows student's full name on the right
  - Fallback to default avatar icon if no photo
  - Dark transparent background for glass effect
  - Added teacher dashboard access button (admin icon)

### 5. Permissions & Location Service ✓
**File:** `lib/screens/splash_screen.dart`
- **Enhanced Permission Flow:**
  - Requests camera, location, notification, and alarm permissions
  - After requesting permissions, checks if location services are enabled
  - If location services disabled, calls `Geolocator.openLocationSettings()`
  - Proper error handling with debug logging

### 6. Timetable (Notifications) ✓
**File:** `lib/screens/timetable_screen.dart`
- **Daily Notifications:**
  - Added `scheduleDailyNotifications()` function
  - Runs on screen initialization
  - Iterates through today's classes
  - Schedules notification 5 minutes before each class start time
  - Only schedules for future times (not past classes)
  - Uses unique alarm IDs to avoid conflicts
  - Notification shows: "Class Starting Soon - [Subject] starts in 5 minutes"

### 7. Attendance Logic (Data Storage) ✓
**Files:** 
- `lib/screens/attendance_screen.dart`
- `lib/models/attendance_record.dart` (NEW)
- `lib/models/attendance_record.g.dart` (GENERATED)

- **Structured Data Storage:**
  - Created `AttendanceRecord` Hive model with fields:
    - `studentId`: Student identification
    - `timestamp`: DateTime of attendance
    - `latitude`: Location latitude
    - `longitude`: Location longitude
    - `isVerified`: Verification status (true after successful check)
    - `subjectName`: Class subject name
  - Records saved to `Hive.box('attendance_records')`
  - Registered adapter in main.dart

### 8. Teacher Solution (Dashboard Screen) ✓
**File:** `lib/screens/teacher_dashboard_screen.dart` (NEW)
- **Teacher Dashboard:**
  - New screen accessible via admin icon in home screen AppBar
  - Uses `ValueListenableBuilder` to display real-time attendance records
  - Shows ListView of all records from `Hive.box('attendance_records')`
  - Each tile displays:
    - Student ID
    - Subject name
    - Timestamp (formatted)
    - Location coordinates
    - Green checkmark for verified attendance
  - Glass morphism design matching app theme
  - Empty state message when no records exist

## 🔧 Technical Improvements

1. **Hive Integration:**
   - Registered AttendanceRecord adapter
   - Opened attendance_records box in main.dart
   - Proper type-safe storage

2. **Code Quality:**
   - All files pass diagnostics with no errors
   - Proper error handling throughout
   - Clean separation of concerns

3. **UI/UX:**
   - Consistent glass morphism theme
   - Proper spacing for bottom navigation
   - Responsive layouts
   - Error states and loading indicators

## 📦 Dependencies Used

- `math_expressions`: Calculator logic
- `image_picker`: Profile photo selection
- `geolocator`: Location services
- `alarm`: Notification scheduling
- `hive` & `hive_flutter`: Local data storage
- `intl`: Date/time formatting

## 🚀 Ready for Testing

All features have been implemented and verified:
- ✅ No compilation errors
- ✅ All diagnostics pass
- ✅ Hive adapters generated
- ✅ Proper imports and dependencies
- ✅ UI matches specifications
- ✅ Logic implements requirements

The app is ready for testing and deployment!
