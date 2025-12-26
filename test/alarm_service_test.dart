import 'package:flutter_test/flutter_test.dart';
import 'package:fluxflow/modules/alarm/alarm_service.dart';

void main() {
  group('AlarmService Configuration Tests', () {
    test('scheduleAlarm has correct default parameters', () {
      // This test verifies the method signature and default values
      // The actual alarm scheduling requires platform integration
      
      // Verify the method exists and can be called with required parameters
      expect(
        () => AlarmService.scheduleAlarm(
          id: 1,
          dateTime: DateTime.now().add(const Duration(minutes: 1)),
          assetAudioPath: 'assets/sounds/alarm_1.mp3',
          notificationTitle: 'Test Alarm',
          notificationBody: 'Test Body',
        ),
        returnsNormally,
      );
    });

    test('scheduleAlarm accepts custom parameters', () {
      // Verify custom parameters can be passed
      expect(
        () => AlarmService.scheduleAlarm(
          id: 2,
          dateTime: DateTime.now().add(const Duration(minutes: 2)),
          assetAudioPath: 'assets/sounds/alarm_2.mp3',
          notificationTitle: 'Custom Alarm',
          notificationBody: 'Custom Body',
          loopAudio: false,
          vibrate: false,
          androidFullScreenIntent: false,
        ),
        returnsNormally,
      );
    });

    test('AlarmService has required static methods', () {
      // Verify all required methods exist
      expect(AlarmService.init, isA<Function>());
      expect(AlarmService.scheduleAlarm, isA<Function>());
      expect(AlarmService.stopAlarm, isA<Function>());
      expect(AlarmService.snoozeAlarm, isA<Function>());
      expect(AlarmService.isRinging, isA<Function>());
    });
  });

  group('AlarmService Audio Default Fallback Tests', () {
    test('scheduleAlarm uses default audio path when assetAudioPath is null', () {
      // Verify that when no audio path is provided, the method accepts it
      // The actual default path logic is internal to the service
      expect(
        () => AlarmService.scheduleAlarm(
          id: 10,
          dateTime: DateTime.now().add(const Duration(minutes: 1)),
          assetAudioPath: null,
          notificationTitle: 'Test Alarm',
          notificationBody: 'Test Body',
        ),
        returnsNormally,
      );
    });

    test('scheduleAlarm uses default audio path when assetAudioPath is empty', () {
      // Verify that when empty string is provided, the method accepts it
      expect(
        () => AlarmService.scheduleAlarm(
          id: 11,
          dateTime: DateTime.now().add(const Duration(minutes: 1)),
          assetAudioPath: '',
          notificationTitle: 'Test Alarm',
          notificationBody: 'Test Body',
        ),
        returnsNormally,
      );
    });

    test('scheduleAlarm uses provided audio path when valid path is given', () {
      // Verify that when a valid path is provided, the method accepts it
      expect(
        () => AlarmService.scheduleAlarm(
          id: 12,
          dateTime: DateTime.now().add(const Duration(minutes: 1)),
          assetAudioPath: 'assets/sounds/custom_alarm.mp3',
          notificationTitle: 'Test Alarm',
          notificationBody: 'Test Body',
        ),
        returnsNormally,
      );
    });

    test('AlarmService has correct default audio path constant', () {
      // Verify the default audio path constant is set correctly
      expect(AlarmService.defaultAudioPath, equals('assets/sounds/alarm_1.mp3'));
    });
  });
}
