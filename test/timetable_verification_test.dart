import 'package:flutter_test/flutter_test.dart';
import 'package:fluxflow/models/class_session.dart';
import 'package:fluxflow/services/timetable_service.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'dart:io';

// Mock PathProviderPlatform for testing
class MockPathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return Directory.systemTemp.path;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClassSession Model Tests', () {
    test('ClassSession can be created with all required fields', () {
      final session = ClassSession(
        id: '1_BCE_0900',
        subjectName: 'BCE',
        dayOfWeek: 1,
        startTime: DateTime(2024, 1, 1, 9, 0),
        endTime: DateTime(2024, 1, 1, 10, 40),
      );

      expect(session.id, equals('1_BCE_0900'));
      expect(session.subjectName, equals('BCE'));
      expect(session.dayOfWeek, equals(1));
      expect(session.startTime.hour, equals(9));
      expect(session.startTime.minute, equals(0));
      expect(session.endTime.hour, equals(10));
      expect(session.endTime.minute, equals(40));
    });

    test('ClassSession fields are accessible', () {
      final session = ClassSession(
        id: 'test_id',
        subjectName: 'Test Subject',
        dayOfWeek: 3,
        startTime: DateTime(2024, 1, 1, 14, 0),
        endTime: DateTime(2024, 1, 1, 15, 30),
      );

      expect(session.id, isNotEmpty);
      expect(session.subjectName, isNotEmpty);
      expect(session.dayOfWeek, greaterThan(0));
      expect(session.dayOfWeek, lessThanOrEqualTo(6));
      expect(session.startTime.isBefore(session.endTime), isTrue);
    });
  });

  group('Timetable v3/v5 Migration and Persistence Tests', () {
    late String testPath;

    setUp(() async {
      // Set up mock path provider
      PathProviderPlatform.instance = MockPathProviderPlatform();
      
      // Initialize Hive with test directory
      testPath = '${Directory.systemTemp.path}/hive_test_${DateTime.now().millisecondsSinceEpoch}';
      Hive.init(testPath);
      
      // Register adapter if not already registered
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(ClassSessionAdapter());
      }

      // Clear SharedPreferences
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() async {
      // Close all boxes
      await Hive.close();
      
      // Clean up test directory
      try {
        final dir = Directory(testPath);
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
      } catch (e) {
        print('Error cleaning up test directory: $e');
      }
    });

    test('Fresh install: timetable_v5 flag is set after initialization', () async {
      // Simulate fresh install - no flag set
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('timetable_v5'), isNull);

      // Initialize timetable
      await TimetableService.initializeTimetable();

      // Verify flag is now set
      final isSeeded = prefs.getBool('timetable_v5');
      expect(isSeeded, isTrue, reason: 'timetable_v5 flag should be set to true after initialization');
    });

    test('Hive database contains all 23 ClassSession objects after initialization', () async {
      // Initialize timetable
      await TimetableService.initializeTimetable();

      // Open the box and verify count
      final box = await Hive.openBox<ClassSession>('class_sessions');
      final sessionCount = box.length;
      
      expect(sessionCount, equals(23), 
        reason: 'Should have exactly 23 class sessions (v5 includes Saturday classes)');

      // Verify some sample sessions exist
      final mondayBCE = box.get('1_BCE_0900');
      expect(mondayBCE, isNotNull, reason: 'Monday BCE class should exist');
      expect(mondayBCE?.subjectName, equals('BCE'));
      expect(mondayBCE?.dayOfWeek, equals(1));

      final saturdayCHE = box.get('6_CHE_0900');
      expect(saturdayCHE, isNotNull, reason: 'Saturday CHE class should exist (v5 feature)');
      expect(saturdayCHE?.subjectName, equals('CHE'));
      expect(saturdayCHE?.dayOfWeek, equals(6));
    });

    test('Data persists across app restarts (box reopen)', () async {
      // First initialization
      await TimetableService.initializeTimetable();
      
      // Get initial data
      var box = await Hive.openBox<ClassSession>('class_sessions');
      final initialCount = box.length;
      final initialSession = box.get('1_BCE_0900');
      
      expect(initialCount, equals(23));
      expect(initialSession, isNotNull);
      
      // Close the box (simulate app restart)
      await box.close();

      // Reopen the box (simulate app restart)
      box = await Hive.openBox<ClassSession>('class_sessions');
      
      // Verify data persisted
      final persistedCount = box.length;
      final persistedSession = box.get('1_BCE_0900');
      
      expect(persistedCount, equals(initialCount), 
        reason: 'Session count should persist after box reopen');
      expect(persistedSession, isNotNull, 
        reason: 'Individual sessions should persist after box reopen');
      expect(persistedSession?.subjectName, equals(initialSession?.subjectName));
      expect(persistedSession?.dayOfWeek, equals(initialSession?.dayOfWeek));
    });

    test('Initialization is skipped when already seeded', () async {
      // First initialization
      await TimetableService.initializeTimetable();
      
      final box = await Hive.openBox<ClassSession>('class_sessions');
      final firstCount = box.length;
      expect(firstCount, equals(23));

      // Add a test marker to verify data isn't cleared
      final testSession = ClassSession(
        id: 'test_marker',
        subjectName: 'Test',
        dayOfWeek: 1,
        startTime: DateTime(2024, 1, 1, 8, 0),
        endTime: DateTime(2024, 1, 1, 9, 0),
      );
      await box.put('test_marker', testSession);
      
      expect(box.length, equals(24));

      // Second initialization (should skip)
      await TimetableService.initializeTimetable();

      // Verify data wasn't cleared (test marker still exists)
      final afterSecondInit = box.length;
      final markerStillExists = box.get('test_marker');
      
      expect(afterSecondInit, equals(24), 
        reason: 'Data should not be cleared on second initialization');
      expect(markerStillExists, isNotNull, 
        reason: 'Test marker should still exist, proving initialization was skipped');
    });

    test('All days of week have classes (Monday-Saturday)', () async {
      await TimetableService.initializeTimetable();
      
      final box = await Hive.openBox<ClassSession>('class_sessions');
      final allSessions = box.values.toList();

      // Check each day has at least one class
      for (int day = 1; day <= 6; day++) {
        final dayClasses = allSessions.where((s) => s.dayOfWeek == day).toList();
        expect(dayClasses.isNotEmpty, isTrue, 
          reason: 'Day $day should have at least one class');
      }

      // Verify no Sunday classes (day 7)
      final sundayClasses = allSessions.where((s) => s.dayOfWeek == 7).toList();
      expect(sundayClasses.isEmpty, isTrue, 
        reason: 'Sunday (day 7) should have no classes');
    });

    test('getTodayClasses returns correct classes for specific day', () async {
      await TimetableService.initializeTimetable();

      // Test Monday classes
      final mondayClasses = await TimetableService.getClassesForDay(1);
      expect(mondayClasses.length, greaterThan(0), 
        reason: 'Monday should have classes');
      expect(mondayClasses.every((s) => s.dayOfWeek == 1), isTrue,
        reason: 'All returned classes should be for Monday');

      // Test Saturday classes (v5 feature)
      final saturdayClasses = await TimetableService.getClassesForDay(6);
      expect(saturdayClasses.length, greaterThan(0), 
        reason: 'Saturday should have classes in v5');
      expect(saturdayClasses.every((s) => s.dayOfWeek == 6), isTrue,
        reason: 'All returned classes should be for Saturday');
    });

    test('Class sessions have valid time ranges', () async {
      await TimetableService.initializeTimetable();
      
      final box = await Hive.openBox<ClassSession>('class_sessions');
      final allSessions = box.values.toList();

      for (final session in allSessions) {
        expect(session.startTime.isBefore(session.endTime), isTrue,
          reason: 'Start time should be before end time for ${session.id}');
        
        expect(session.startTime.hour, greaterThanOrEqualTo(0));
        expect(session.startTime.hour, lessThan(24));
        expect(session.endTime.hour, greaterThanOrEqualTo(0));
        expect(session.endTime.hour, lessThan(24));
      }
    });
  });
}
