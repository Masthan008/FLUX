import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class BackupService {
  static const String _backupVersion = '1.0.0';

  /// Create a complete backup of all user data
  static Future<Map<String, dynamic>> createFullBackup() async {
    try {
      return {
        'version': _backupVersion,
        'timestamp': DateTime.now().toIso8601String(),
        'user_data': await _exportUserData(),
        'app_settings': await _exportSettings(),
        'academic_data': await _exportAcademicData(),
        'calculator_data': await _exportCalculatorData(),
        'chat_data': await _exportChatData(),
        'books_data': await _exportBooksData(),
      };
    } catch (e) {
      debugPrint('Error creating backup: $e');
      rethrow;
    }
  }

  /// Export user profile and preferences
  static Future<Map<String, dynamic>> _exportUserData() async {
    final box = Hive.box('user_prefs');
    return {
      'user_name': box.get('user_name'),
      'user_role': box.get('user_role'),
      'user_photo': box.get('user_photo'),
      'biometric_enabled': box.get('biometric_enabled', defaultValue: false),
      'theme_mode': box.get('theme_mode', defaultValue: 'dark'),
      'font_size': box.get('font_size', defaultValue: 16.0),
    };
  }

  /// Export app settings and preferences
  static Future<Map<String, dynamic>> _exportSettings() async {
    final box = Hive.box('user_prefs');
    return {
      'notifications_enabled': box.get('notifications_enabled', defaultValue: true),
      'sound_enabled': box.get('sound_enabled', defaultValue: true),
      'vibration_enabled': box.get('vibration_enabled', defaultValue: true),
      'auto_backup': box.get('auto_backup', defaultValue: false),
      'backup_frequency': box.get('backup_frequency', defaultValue: 'weekly'),
    };
  }

  /// Export academic data (timetable, attendance)
  static Future<Map<String, dynamic>> _exportAcademicData() async {
    final sessionsBox = Hive.box('class_sessions');
    final sessions = sessionsBox.values.map((session) => {
      'subject': session.subject,
      'startTime': session.startTime.toIso8601String(),
      'endTime': session.endTime.toIso8601String(),
      'location': session.location,
      'instructor': session.instructor,
      'dayOfWeek': session.dayOfWeek,
    }).toList();

    return {
      'class_sessions': sessions,
      'attendance_records': await _getAttendanceRecords(),
    };
  }

  /// Export calculator history
  static Future<Map<String, dynamic>> _exportCalculatorData() async {
    final box = Hive.box('calculator_history');
    return {
      'history': box.values.toList(),
      'favorites': box.get('favorites', defaultValue: []),
    };
  }

  /// Export chat data from Supabase
  static Future<Map<String, dynamic>> _exportChatData() async {
    try {
      final supabase = Supabase.instance.client;
      final userName = Hive.box('user_prefs').get('user_name', defaultValue: 'Unknown');
      
      // Test connection first
      await supabase.from('messages').select('count').limit(1);
      
      // Get user's messages
      final messages = await supabase
          .from('messages')
          .select()
          .eq('user_name', userName)
          .order('created_at', ascending: false)
          .limit(1000); // Last 1000 messages

      return {
        'messages': messages,
        'message_count': messages.length,
        'export_date': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error exporting chat data: $e');
      return {
        'messages': [], 
        'message_count': 0,
        'error': 'Database connection failed: $e',
        'export_date': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Export books and notes data
  static Future<Map<String, dynamic>> _exportBooksData() async {
    final box = Hive.box('books_notes');
    return {
      'notes': box.values.toList(),
      'bookmarks': box.get('bookmarks', defaultValue: []),
    };
  }

  /// Get attendance records from Supabase
  static Future<List<Map<String, dynamic>>> _getAttendanceRecords() async {
    try {
      final supabase = Supabase.instance.client;
      final userName = Hive.box('user_prefs').get('user_name', defaultValue: 'Unknown');
      
      // Test connection first
      await supabase.from('attendance').select('count').limit(1);
      
      final attendance = await supabase
          .from('attendance')
          .select()
          .eq('student_name', userName)
          .order('created_at', ascending: false)
          .limit(500); // Limit to last 500 records

      return List<Map<String, dynamic>>.from(attendance);
    } catch (e) {
      debugPrint('Error getting attendance records: $e');
      // Return empty list with error info
      return [
        {
          'error': 'Failed to fetch attendance records',
          'details': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        }
      ];
    }
  }

  /// Save backup to local file
  static Future<String> saveBackupToFile(Map<String, dynamic> backup) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'fluxflow_backup_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      
      final jsonString = const JsonEncoder.withIndent('  ').convert(backup);
      await file.writeAsString(jsonString);
      
      return file.path;
    } catch (e) {
      debugPrint('Error saving backup file: $e');
      rethrow;
    }
  }

  /// Share backup file
  static Future<void> shareBackup() async {
    try {
      final backup = await createFullBackup();
      final filePath = await saveBackupToFile(backup);
      
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'FluxFlow Backup - ${DateTime.now().toString().split(' ')[0]}',
        subject: 'FluxFlow Data Backup',
      );
    } catch (e) {
      debugPrint('Error sharing backup: $e');
      rethrow;
    }
  }

  /// Restore data from backup
  static Future<bool> restoreFromBackup(Map<String, dynamic> backup) async {
    try {
      // Validate backup version
      if (backup['version'] != _backupVersion) {
        debugPrint('Backup version mismatch');
        return false;
      }

      // Restore user data
      await _restoreUserData(backup['user_data']);
      
      // Restore settings
      await _restoreSettings(backup['app_settings']);
      
      // Restore academic data
      await _restoreAcademicData(backup['academic_data']);
      
      // Restore calculator data
      await _restoreCalculatorData(backup['calculator_data']);
      
      // Restore books data
      await _restoreBooksData(backup['books_data']);

      debugPrint('Backup restored successfully');
      return true;
    } catch (e) {
      debugPrint('Error restoring backup: $e');
      return false;
    }
  }

  /// Restore user data
  static Future<void> _restoreUserData(Map<String, dynamic>? userData) async {
    if (userData == null) return;
    
    final box = Hive.box('user_prefs');
    for (final entry in userData.entries) {
      await box.put(entry.key, entry.value);
    }
  }

  /// Restore app settings
  static Future<void> _restoreSettings(Map<String, dynamic>? settings) async {
    if (settings == null) return;
    
    final box = Hive.box('user_prefs');
    for (final entry in settings.entries) {
      await box.put(entry.key, entry.value);
    }
  }

  /// Restore academic data
  static Future<void> _restoreAcademicData(Map<String, dynamic>? academicData) async {
    if (academicData == null) return;
    
    // Note: This would require recreating ClassSession objects
    // For now, we'll store as raw data and let the app recreate sessions
    final box = Hive.box('user_prefs');
    await box.put('backup_sessions', academicData['class_sessions']);
    await box.put('backup_attendance', academicData['attendance_records']);
  }

  /// Restore calculator data
  static Future<void> _restoreCalculatorData(Map<String, dynamic>? calculatorData) async {
    if (calculatorData == null) return;
    
    final box = Hive.box('calculator_history');
    await box.clear();
    
    final history = calculatorData['history'] as List?;
    if (history != null) {
      for (int i = 0; i < history.length; i++) {
        await box.put(i, history[i]);
      }
    }
    
    await box.put('favorites', calculatorData['favorites'] ?? []);
  }

  /// Restore books data
  static Future<void> _restoreBooksData(Map<String, dynamic>? booksData) async {
    if (booksData == null) return;
    
    final box = Hive.box('books_notes');
    await box.clear();
    
    final notes = booksData['notes'] as List?;
    if (notes != null) {
      for (int i = 0; i < notes.length; i++) {
        await box.put(i, notes[i]);
      }
    }
    
    await box.put('bookmarks', booksData['bookmarks'] ?? []);
  }

  /// Create and export academic progress report
  static Future<String> exportAcademicReport() async {
    try {
      final backup = await createFullBackup();
      final report = _generateAcademicReport(backup);
      
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'fluxflow_report_$timestamp.txt';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(report);
      return file.path;
    } catch (e) {
      debugPrint('Error exporting academic report: $e');
      rethrow;
    }
  }

  /// Generate academic progress report
  static String _generateAcademicReport(Map<String, dynamic> backup) {
    final userData = backup['user_data'] as Map<String, dynamic>?;
    final academicData = backup['academic_data'] as Map<String, dynamic>?;
    final chatData = backup['chat_data'] as Map<String, dynamic>?;
    final calculatorData = backup['calculator_data'] as Map<String, dynamic>?;
    final booksData = backup['books_data'] as Map<String, dynamic>?;
    
    final buffer = StringBuffer();
    
    buffer.writeln('╔══════════════════════════════════════════════════════════╗');
    buffer.writeln('║                 FLUXFLOW ACADEMIC REPORT                 ║');
    buffer.writeln('╚══════════════════════════════════════════════════════════╝');
    buffer.writeln('Generated: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('Report Version: ${backup['version']}');
    buffer.writeln('');
    
    // User Information
    buffer.writeln('👤 STUDENT PROFILE:');
    buffer.writeln('   Name: ${userData?['user_name'] ?? 'Unknown'}');
    buffer.writeln('   Role: ${userData?['user_role'] ?? 'Student'}');
    buffer.writeln('   Theme: ${userData?['theme_mode'] ?? 'Dark'}');
    buffer.writeln('   Font Size: ${userData?['font_size'] ?? 16.0}');
    buffer.writeln('   Biometric Security: ${userData?['biometric_enabled'] == true ? 'Enabled' : 'Disabled'}');
    buffer.writeln('');
    
    // Academic Statistics
    buffer.writeln('📚 ACADEMIC PERFORMANCE:');
    final sessions = academicData?['class_sessions'] as List? ?? [];
    buffer.writeln('   Total Classes Scheduled: ${sessions.length}');
    
    if (sessions.isNotEmpty) {
      final subjects = sessions.map((s) => s['subject']).toSet();
      buffer.writeln('   Subjects Enrolled: ${subjects.length}');
      buffer.writeln('   Subject List: ${subjects.join(', ')}');
    }
    
    final attendance = academicData?['attendance_records'] as List? ?? [];
    buffer.writeln('   Attendance Records: ${attendance.length}');
    
    if (attendance.isNotEmpty && !attendance.first.containsKey('error')) {
      final presentCount = attendance.where((record) => record['status'] == 'present').length;
      final absentCount = attendance.where((record) => record['status'] == 'absent').length;
      final attendanceRate = (presentCount / attendance.length * 100).toStringAsFixed(1);
      buffer.writeln('   Present Days: $presentCount');
      buffer.writeln('   Absent Days: $absentCount');
      buffer.writeln('   Attendance Rate: $attendanceRate%');
      
      // Attendance grade
      final rate = double.parse(attendanceRate);
      String grade = rate >= 90 ? 'Excellent' : rate >= 80 ? 'Good' : rate >= 70 ? 'Average' : 'Needs Improvement';
      buffer.writeln('   Attendance Grade: $grade');
    }
    buffer.writeln('');
    
    // Study Tools Usage
    buffer.writeln('🧮 STUDY TOOLS USAGE:');
    final calculatorHistory = calculatorData?['history'] as List? ?? [];
    buffer.writeln('   Calculator Operations: ${calculatorHistory.length}');
    
    final favorites = calculatorData?['favorites'] as List? ?? [];
    buffer.writeln('   Saved Calculations: ${favorites.length}');
    
    final notes = booksData?['notes'] as List? ?? [];
    buffer.writeln('   Notes Created: ${notes.length}');
    
    final bookmarks = booksData?['bookmarks'] as List? ?? [];
    buffer.writeln('   Bookmarked Items: ${bookmarks.length}');
    buffer.writeln('');
    
    // Communication Activity
    buffer.writeln('💬 COMMUNICATION ACTIVITY:');
    final messageCount = chatData?['message_count'] ?? 0;
    buffer.writeln('   Messages Sent: $messageCount');
    
    if (messageCount > 0) {
      final avgPerDay = messageCount / 30; // Assuming last 30 days
      buffer.writeln('   Average Messages/Day: ${avgPerDay.toStringAsFixed(1)}');
      
      String activityLevel = avgPerDay >= 10 ? 'Very Active' : avgPerDay >= 5 ? 'Active' : avgPerDay >= 1 ? 'Moderate' : 'Low';
      buffer.writeln('   Activity Level: $activityLevel');
    }
    
    if (chatData?['error'] != null) {
      buffer.writeln('   ⚠️  Chat data unavailable: ${chatData!['error']}');
    }
    buffer.writeln('');
    
    // App Usage Statistics
    buffer.writeln('📱 APP USAGE STATISTICS:');
    buffer.writeln('   Data Export Date: ${backup['timestamp']}');
    buffer.writeln('   Backup Size: ${_formatBytes(_calculateBackupSize(backup))}');
    buffer.writeln('   Features Used: ${_countUsedFeatures(backup)}');
    buffer.writeln('');
    
    // Recommendations
    buffer.writeln('💡 RECOMMENDATIONS:');
    _generateRecommendations(buffer, backup);
    buffer.writeln('');
    
    // Footer
    buffer.writeln('═══════════════════════════════════════════════════════════');
    buffer.writeln('Report generated by FluxFlow - The Ultimate Student OS');
    buffer.writeln('For support, contact: support@fluxflow.app');
    buffer.writeln('═══════════════════════════════════════════════════════════');
    
    return buffer.toString();
  }

  /// Generate personalized recommendations
  static void _generateRecommendations(StringBuffer buffer, Map<String, dynamic> backup) {
    final academicData = backup['academic_data'] as Map<String, dynamic>?;
    final chatData = backup['chat_data'] as Map<String, dynamic>?;
    final calculatorData = backup['calculator_data'] as Map<String, dynamic>?;
    
    final attendance = academicData?['attendance_records'] as List? ?? [];
    final messageCount = chatData?['message_count'] ?? 0;
    final calculatorUsage = (calculatorData?['history'] as List? ?? []).length;
    
    // Attendance recommendations
    if (attendance.isNotEmpty && !attendance.first.containsKey('error')) {
      final presentCount = attendance.where((record) => record['status'] == 'present').length;
      final attendanceRate = (presentCount / attendance.length * 100);
      
      if (attendanceRate < 75) {
        buffer.writeln('   📈 Focus on improving attendance (current: ${attendanceRate.toStringAsFixed(1)}%)');
      } else if (attendanceRate >= 90) {
        buffer.writeln('   🎉 Excellent attendance! Keep up the great work!');
      }
    }
    
    // Study tools recommendations
    if (calculatorUsage < 10) {
      buffer.writeln('   🧮 Explore more calculator features for better problem solving');
    }
    
    // Communication recommendations
    if (messageCount < 5) {
      buffer.writeln('   💬 Consider participating more in class discussions');
    } else if (messageCount > 100) {
      buffer.writeln('   👥 Great communication! You\'re an active community member');
    }
    
    // General recommendations
    buffer.writeln('   📚 Use the roadmaps feature to plan your learning journey');
    buffer.writeln('   ⏰ Set regular study alarms to maintain consistency');
    buffer.writeln('   🎯 Try the focus forest for better concentration');
    buffer.writeln('   📊 Regular backups help keep your data safe');
  }

  /// Calculate backup size in bytes
  static int _calculateBackupSize(Map<String, dynamic> backup) {
    return backup.toString().length;
  }

  /// Format bytes to human readable format
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Count used features
  static int _countUsedFeatures(Map<String, dynamic> backup) {
    int count = 0;
    
    final academicData = backup['academic_data'] as Map<String, dynamic>?;
    final chatData = backup['chat_data'] as Map<String, dynamic>?;
    final calculatorData = backup['calculator_data'] as Map<String, dynamic>?;
    final booksData = backup['books_data'] as Map<String, dynamic>?;
    
    if ((academicData?['class_sessions'] as List? ?? []).isNotEmpty) count++;
    if ((academicData?['attendance_records'] as List? ?? []).isNotEmpty) count++;
    if ((chatData?['message_count'] ?? 0) > 0) count++;
    if ((calculatorData?['history'] as List? ?? []).isNotEmpty) count++;
    if ((booksData?['notes'] as List? ?? []).isNotEmpty) count++;
    
    return count;
  }

  /// Auto backup (called periodically)
  static Future<void> performAutoBackup() async {
    try {
      final box = Hive.box('user_prefs');
      final autoBackupEnabled = box.get('auto_backup', defaultValue: false);
      
      if (!autoBackupEnabled) return;
      
      final lastBackup = box.get('last_backup_time', defaultValue: 0);
      final now = DateTime.now().millisecondsSinceEpoch;
      final frequency = box.get('backup_frequency', defaultValue: 'weekly');
      
      int backupInterval;
      switch (frequency) {
        case 'daily':
          backupInterval = 24 * 60 * 60 * 1000; // 1 day
          break;
        case 'weekly':
          backupInterval = 7 * 24 * 60 * 60 * 1000; // 1 week
          break;
        case 'monthly':
          backupInterval = 30 * 24 * 60 * 60 * 1000; // 1 month
          break;
        default:
          backupInterval = 7 * 24 * 60 * 60 * 1000; // Default to weekly
      }
      
      if (now - lastBackup > backupInterval) {
        final backup = await createFullBackup();
        await saveBackupToFile(backup);
        await box.put('last_backup_time', now);
        debugPrint('Auto backup completed');
      }
    } catch (e) {
      debugPrint('Auto backup failed: $e');
    }
  }

  /// Get backup statistics
  static Future<Map<String, dynamic>> getBackupStats() async {
    try {
      final backup = await createFullBackup();
      
      return {
        'total_size': jsonEncode(backup).length,
        'user_data_size': jsonEncode(backup['user_data']).length,
        'academic_records': (backup['academic_data']['class_sessions'] as List).length,
        'chat_messages': backup['chat_data']['message_count'],
        'calculator_history': (backup['calculator_data']['history'] as List).length,
        'last_backup': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error getting backup stats: $e');
      return {};
    }
  }
}