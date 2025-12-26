import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/class_session.dart';
import '../modules/alarm/alarm_service.dart';

class TimetableService {
  static const String _seedFlagKey = 'timetable_v6';
  static const String _boxName = 'class_sessions';

  // Subject Name Decoder Map
  static const Map<String, String> subjectNames = {
    'IP': 'Introduction to Programming',
    'LAAC': 'Linear Algebra & Advanced Calculus',
    'CE': 'Communicative English',
    'CHE': 'Chemistry',
    'BME': 'Basic Mechanical Engineering',
    'BCE': 'Basic Civil Engineering',
    'IP LAB': 'Computer Programming Lab',
    'EC LAB': 'Engineering Chemistry Lab',
    'EWS': 'Engineering Workshop',
    'EAA': 'Sports & Yoga',
    'SS': 'Soft Skills',
    'CE LAB': 'Communicative English Lab',
  };

  /// Initialize timetable by seeding data on first run
  static Future<void> initializeTimetable() async {
    try {
      // Check if already seeded
      final prefs = await SharedPreferences.getInstance();
      final isSeeded = prefs.getBool(_seedFlagKey) ?? false;

      if (isSeeded) {
        debugPrint('Timetable already seeded (v6), skipping initialization');
        return;
      }

      debugPrint('Seeding timetable v6...');

      // Ensure box is open
      final box = Hive.isBoxOpen(_boxName)
          ? Hive.box<ClassSession>(_boxName)
          : await Hive.openBox<ClassSession>(_boxName);

      // Clear any existing data (fresh start for v5)
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

      // Schedule alarms for each class (10 minutes before start time)
      debugPrint('Scheduling alarms for timetable classes...');
      final now = DateTime.now(); // Current time for comparison
      int alarmsScheduled = 0;
      for (final session in sessions) {
        try {
          // Calculate alarm time (10 minutes before class)
          DateTime alarmTime = session.startTime.subtract(const Duration(minutes: 10));
          
          // CRITICAL FIX: If the alarm time has passed for today, schedule for next week
          if (alarmTime.isBefore(now)) {
            debugPrint('Class ${session.subjectName} time has passed today, scheduling for next week');
            alarmTime = alarmTime.add(const Duration(days: 7));
          }
          
          // Generate unique alarm ID based on session
          final alarmId = session.id.hashCode.abs();
          
          // Schedule the alarm
          await AlarmService.scheduleAlarm(
            id: alarmId,
            dateTime: alarmTime,
            assetAudioPath: AlarmService.defaultAudioPath,
            notificationTitle: '📚 Class Starting Soon',
            notificationBody: '${session.subjectName} starts in 10 minutes',
            loopAudio: false, // Just a notification sound
            vibrate: true,
            androidFullScreenIntent: false,
          );
          
          alarmsScheduled++;
        } catch (e) {
          debugPrint('Error scheduling alarm for ${session.subjectName}: $e');
        }
      }
      debugPrint('Scheduled $alarmsScheduled alarms for timetable classes');

      // Mark as seeded only after successful save
      if (savedCount == sessions.length) {
        await prefs.setBool(_seedFlagKey, true);
        debugPrint('Timetable v6 seeded successfully with $alarmsScheduled alarms');
      } else {
        debugPrint('Warning: Expected ${sessions.length} sessions but saved $savedCount');
      }
    } catch (e) {
      debugPrint('Error initializing timetable v6: $e');
    }
  }

  /// Get classes for today
  static Future<List<ClassSession>> getTodayClasses() async {
    try {
      final now = DateTime.now();
      final dayOfWeek = now.weekday; // 1=Monday, 7=Sunday
      
      if (dayOfWeek > 6) {
        // Sunday, no classes
        return [];
      }

      return await getClassesForDay(dayOfWeek);
    } catch (e) {
      debugPrint('Error getting today\'s classes: $e');
      return [];
    }
  }

  /// Get classes for a specific day
  static Future<List<ClassSession>> getClassesForDay(int dayOfWeek) async {
    try {
      final box = await Hive.openBox<ClassSession>(_boxName);
      final allSessions = box.values.toList();
      
      return allSessions
          .where((session) => session.dayOfWeek == dayOfWeek)
          .toList();
    } catch (e) {
      debugPrint('Error getting classes for day $dayOfWeek: $e');
      return [];
    }
  }

  /// Create all class sessions for the week
  static List<ClassSession> _createAllSessions() {
    final sessions = <ClassSession>[];
    final now = DateTime.now();

    // Helper to create DateTime for a specific time
    DateTime createTime(int hour, int minute) {
      return DateTime(now.year, now.month, now.day, hour, minute);
    }

    // Monday (1)
    sessions.addAll([
      ClassSession(
        id: '1_BCE_0900',
        subjectName: 'BCE',
        dayOfWeek: 1,
        startTime: createTime(9, 0),
        endTime: createTime(10, 40),
      ),
      ClassSession(
        id: '1_CE_1100',
        subjectName: 'CE',
        dayOfWeek: 1,
        startTime: createTime(11, 0),
        endTime: createTime(11, 50),
      ),
      ClassSession(
        id: '1_LAAC_1300',
        subjectName: 'LAAC',
        dayOfWeek: 1,
        startTime: createTime(13, 0),
        endTime: createTime(14, 40),
      ),
      ClassSession(
        id: '1_CHE_1500',
        subjectName: 'CHE',
        dayOfWeek: 1,
        startTime: createTime(15, 0),
        endTime: createTime(17, 0),
      ),
    ]);

    // Tuesday (2)
    sessions.addAll([
      ClassSession(
        id: '2_EWS_0900',
        subjectName: 'EWS',
        dayOfWeek: 2,
        startTime: createTime(9, 0),
        endTime: createTime(11, 50),
      ),
      ClassSession(
        id: '2_IPLAB_1300',
        subjectName: 'IP LAB',
        dayOfWeek: 2,
        startTime: createTime(13, 0),
        endTime: createTime(14, 50),
      ),
      ClassSession(
        id: '2_SS_1500',
        subjectName: 'SS',
        dayOfWeek: 2,
        startTime: createTime(15, 0),
        endTime: createTime(17, 0),
      ),
    ]);

    // Wednesday (3)
    sessions.addAll([
      ClassSession(
        id: '3_ECLAB_0900',
        subjectName: 'EC LAB',
        dayOfWeek: 3,
        startTime: createTime(9, 0),
        endTime: createTime(11, 50),
      ),
      ClassSession(
        id: '3_BME_1300',
        subjectName: 'BME',
        dayOfWeek: 3,
        startTime: createTime(13, 0),
        endTime: createTime(14, 40),
      ),
      ClassSession(
        id: '3_IPLAB_1500',
        subjectName: 'IP LAB',
        dayOfWeek: 3,
        startTime: createTime(15, 0),
        endTime: createTime(17, 0),
      ),
    ]);

    // Thursday (4)
    sessions.addAll([
      ClassSession(
        id: '4_IP_0900',
        subjectName: 'IP',
        dayOfWeek: 4,
        startTime: createTime(9, 0),
        endTime: createTime(10, 40),
      ),
      ClassSession(
        id: '4_LAAC_1100',
        subjectName: 'LAAC',
        dayOfWeek: 4,
        startTime: createTime(11, 0),
        endTime: createTime(11, 50),
      ),
      ClassSession(
        id: '4_CHE_1300',
        subjectName: 'CHE',
        dayOfWeek: 4,
        startTime: createTime(13, 0),
        endTime: createTime(13, 50),
      ),
      ClassSession(
        id: '4_CELAB_1350',
        subjectName: 'CE LAB',
        dayOfWeek: 4,
        startTime: createTime(13, 50),
        endTime: createTime(17, 0),
      ),
    ]);

    // Friday (5)
    sessions.addAll([
      ClassSession(
        id: '5_CE_0900',
        subjectName: 'CE',
        dayOfWeek: 5,
        startTime: createTime(9, 0),
        endTime: createTime(10, 40),
      ),
      ClassSession(
        id: '5_BME_1100',
        subjectName: 'BME',
        dayOfWeek: 5,
        startTime: createTime(11, 0),
        endTime: createTime(11, 50),
      ),
      ClassSession(
        id: '5_LAAC_1300',
        subjectName: 'LAAC',
        dayOfWeek: 5,
        startTime: createTime(13, 0),
        endTime: createTime(14, 40),
      ),
      ClassSession(
        id: '5_EAA_1500',
        subjectName: 'EAA',
        dayOfWeek: 5,
        startTime: createTime(15, 0),
        endTime: createTime(17, 0),
      ),
    ]);

    // Saturday (6) - NEW in v6.0
    sessions.addAll([
      ClassSession(
        id: '6_CHE_0900',
        subjectName: 'CHE',
        dayOfWeek: 6,
        startTime: createTime(9, 0),
        endTime: createTime(10, 40),
      ),
      ClassSession(
        id: '6_BCE_1100',
        subjectName: 'BCE',
        dayOfWeek: 6,
        startTime: createTime(11, 0),
        endTime: createTime(11, 50),
      ),
      ClassSession(
        id: '6_IP_1300',
        subjectName: 'IP',
        dayOfWeek: 6,
        startTime: createTime(13, 0),
        endTime: createTime(14, 40),
      ),
      ClassSession(
        id: '6_CE_1500',
        subjectName: 'CE',
        dayOfWeek: 6,
        startTime: createTime(15, 0),
        endTime: createTime(17, 0),
      ),
    ]);

    return sessions;
  }
}
