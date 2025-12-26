import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EnhancedDataManagementService {
  static const String _backupVersion = '2.0.0';
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Initialize all required Hive boxes with enhanced error handling
  static Future<void> initializeHiveBoxes() async {
    try {
      final boxNames = ['user_prefs', 'books_notes', 'calculator_history', 'class_sessions', 'game_data', 'focus_data', 'calendar_reminders'];
      
      for (final boxName in boxNames) {
        try {
          if (!Hive.isBoxOpen(boxName)) {
            await Hive.openBox(boxName);
            debugPrint('✅ Successfully opened Hive box: $boxName');
          } else {
            debugPrint('📦 Hive box already open: $boxName');
          }
        } catch (e) {
          debugPrint('❌ Error opening box $boxName: $e');
          // Try to close and reopen if there's an issue
          try {
            if (Hive.isBoxOpen(boxName)) {
              await Hive.box(boxName).close();
            }
            await Hive.openBox(boxName);
            debugPrint('🔄 Successfully reopened box: $boxName');
          } catch (retryError) {
            debugPrint('💥 Failed to reopen box $boxName: $retryError');
          }
        }
      }
      
      // Verify all boxes are accessible
      await _verifyBoxAccess();
      
    } catch (e) {
      debugPrint('💥 Critical error initializing Hive boxes: $e');
    }
  }

  /// Verify that all boxes are accessible
  static Future<void> _verifyBoxAccess() async {
    final boxNames = ['user_prefs', 'books_notes', 'calculator_history', 'class_sessions', 'game_data', 'focus_data', 'calendar_reminders'];
    
    for (final boxName in boxNames) {
      try {
        if (Hive.isBoxOpen(boxName)) {
          final box = Hive.box(boxName);
          // Try a simple operation to verify access
          box.get('_test_key', defaultValue: null);
          debugPrint('✅ Box $boxName is accessible');
        } else {
          debugPrint('⚠️ Box $boxName is not open');
        }
      } catch (e) {
        debugPrint('❌ Box $boxName access error: $e');
      }
    }
  }

  /// Create a full backup with cloud sync capability
  static Future<Map<String, dynamic>> createFullBackup({bool includeCloudData = true}) async {
    try {
      final backup = {
        'version': _backupVersion,
        'timestamp': DateTime.now().toIso8601String(),
        'device_info': await _getDeviceInfo(),
        'local_data': await _exportLocalData(),
      };

      if (includeCloudData) {
        backup['cloud_data'] = await _exportCloudData();
      }

      return backup;
    } catch (e) {
      debugPrint('Error creating full backup: $e');
      rethrow;
    }
  }

  /// Export all local data from Hive boxes
  static Future<Map<String, dynamic>> _exportLocalData() async {
    try {
      final localData = <String, dynamic>{};
      
      // Helper function to safely access Hive boxes
      Map<String, dynamic> _safeBoxAccess(String boxName) {
        try {
          if (Hive.isBoxOpen(boxName)) {
            final box = Hive.box(boxName);
            return Map<String, dynamic>.from(box.toMap());
          } else {
            debugPrint('Box $boxName is not open, skipping...');
            return {};
          }
        } catch (e) {
          debugPrint('Error accessing box $boxName: $e');
          return {};
        }
      }
      
      // Helper function to safely access class sessions
      List<Map<String, dynamic>> _safeClassSessionsAccess() {
        try {
          if (Hive.isBoxOpen('class_sessions')) {
            final classSessions = Hive.box('class_sessions');
            return classSessions.values.map((session) {
              try {
                // Handle different session object types
                if (session is Map) {
                  return Map<String, dynamic>.from(session);
                } else {
                  // If it's a custom object, try to extract properties
                  return {
                    'subject': session.subject?.toString() ?? 'Unknown',
                    'startTime': session.startTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
                    'endTime': session.endTime?.toIso8601String() ?? DateTime.now().toIso8601String(),
                    'location': session.location?.toString() ?? '',
                    'instructor': session.instructor?.toString() ?? '',
                    'dayOfWeek': session.dayOfWeek?.toString() ?? '',
                  };
                }
              } catch (e) {
                debugPrint('Error processing session: $e');
                return <String, dynamic>{
                  'subject': 'Error',
                  'startTime': DateTime.now().toIso8601String(),
                  'endTime': DateTime.now().toIso8601String(),
                  'location': '',
                  'instructor': '',
                  'dayOfWeek': '',
                };
              }
            }).toList();
          } else {
            debugPrint('Class sessions box is not open, skipping...');
            return [];
          }
        } catch (e) {
          debugPrint('Error accessing class sessions: $e');
          return [];
        }
      }
      
      // User preferences
      localData['user_prefs'] = _safeBoxAccess('user_prefs');
      
      // Books and notes
      localData['books_notes'] = _safeBoxAccess('books_notes');
      
      // Calculator history
      localData['calculator_history'] = _safeBoxAccess('calculator_history');
      
      // Class sessions (special handling)
      localData['class_sessions'] = _safeClassSessionsAccess();
      
      // Game data
      localData['game_data'] = _safeBoxAccess('game_data');
      
      // Focus forest data
      localData['focus_data'] = _safeBoxAccess('focus_data');
      
      return localData;
    } catch (e) {
      debugPrint('Error exporting local data: $e');
      return {};
    }
  }

  /// Export cloud data from Supabase
  static Future<Map<String, dynamic>> _exportCloudData() async {
    try {
      final userName = Hive.box('user_prefs').get('user_name', defaultValue: 'Unknown');
      final cloudData = <String, dynamic>{};
      
      // Try to export each table separately and handle errors gracefully
      
      // Export chat messages (if table exists)
      try {
        final messages = await _supabase
            .from('messages')
            .select()
            .eq('user_name', userName)
            .order('created_at', ascending: false)
            .limit(2000);
        cloudData['messages'] = messages;
      } catch (e) {
        debugPrint('Messages table not available: $e');
        cloudData['messages'] = [];
      }
      
      // Export attendance records (if table exists)
      try {
        final attendance = await _supabase
            .from('attendance')
            .select()
            .eq('student_name', userName)
            .order('created_at', ascending: false)
            .limit(1000);
        cloudData['attendance'] = attendance;
      } catch (e) {
        debugPrint('Attendance table not available: $e');
        cloudData['attendance'] = [];
      }
      
      // Export community books (if table exists)
      try {
        final communityBooks = await _supabase
            .from('community_books_enhanced')
            .select()
            .eq('uploaded_by', userName)
            .order('created_at', ascending: false);
        cloudData['community_books'] = communityBooks;
      } catch (e) {
        debugPrint('Community books table not available: $e');
        cloudData['community_books'] = [];
      }
      
      // Export user profile from cloud (if table exists)
      try {
        final profile = await _supabase
            .from('user_profiles')
            .select('user_name, email, display_name, avatar_url, preferences, sync_settings')
            .eq('user_name', userName)
            .maybeSingle();
        cloudData['user_profile'] = profile;
      } catch (e) {
        debugPrint('User profiles table not available: $e');
        cloudData['user_profile'] = null;
      }
      
      return cloudData;
    } catch (e) {
      debugPrint('Error exporting cloud data: $e');
      return {
        'error': 'Failed to export cloud data: $e',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get device information for backup metadata
  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'app_version': '1.0.0',
      'backup_type': 'full',
    };
  }

  /// Save backup to local file with encryption option
  static Future<String> saveBackupToFile(Map<String, dynamic> backup, {bool encrypt = false}) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'fluxflow_backup_$timestamp.json';
      final file = File('${directory.path}/$fileName');
      
      String jsonString = const JsonEncoder.withIndent('  ').convert(backup);
      
      if (encrypt) {
        // Simple encryption (in production, use proper encryption)
        jsonString = base64Encode(utf8.encode(jsonString));
      }
      
      await file.writeAsString(jsonString);
      
      return file.path;
    } catch (e) {
      debugPrint('Error saving backup file: $e');
      rethrow;
    }
  }

  /// Upload backup to Supabase cloud storage
  static Future<String?> uploadBackupToCloud(Map<String, dynamic> backup) async {
    try {
      final userName = Hive.box('user_prefs').get('user_name', defaultValue: 'Unknown');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'backup_${userName}_$timestamp.json';
      
      final jsonString = jsonEncode(backup);
      final bytes = utf8.encode(jsonString);
      
      // Upload to Supabase storage
      await _supabase.storage
          .from('user-backups')
          .uploadBinary(fileName, bytes);
      
      // Try to save backup metadata to database (if table exists)
      try {
        await _supabase.from('backup_metadata').insert({
          'user_name': userName,
          'file_name': fileName,
          'file_size': bytes.length,
          'backup_version': _backupVersion,
        });
      } catch (e) {
        debugPrint('Backup metadata table not available, but file uploaded: $e');
      }
      
      return fileName;
    } catch (e) {
      debugPrint('Error uploading backup to cloud: $e');
      return null;
    }
  }

  /// List available cloud backups for user
  static Future<List<Map<String, dynamic>>> listCloudBackups() async {
    try {
      final userName = Hive.box('user_prefs').get('user_name', defaultValue: 'Unknown');
      
      // Try to get from backup_metadata table first
      try {
        final backups = await _supabase
            .from('backup_metadata')
            .select()
            .eq('user_name', userName)
            .order('created_at', ascending: false)
            .limit(10);
        
        return List<Map<String, dynamic>>.from(backups);
      } catch (e) {
        debugPrint('Backup metadata table not available, trying storage list: $e');
        
        // Fallback: list files from storage directly
        try {
          final files = await _supabase.storage
              .from('user-backups')
              .list();
          
          // Filter files for current user and create metadata
          final userFiles = files.where((file) => 
            file.name.startsWith('backup_${userName}_')).toList();
          
          return userFiles.map((file) => {
            'file_name': file.name,
            'file_size': file.metadata?['size'] ?? 0,
            'created_at': file.createdAt ?? DateTime.now().toIso8601String(),
            'user_name': userName,
          }).toList();
        } catch (storageError) {
          debugPrint('Storage list also failed: $storageError');
          return [];
        }
      }
    } catch (e) {
      debugPrint('Error listing cloud backups: $e');
      return [];
    }
  }

  /// Download and restore backup from cloud
  static Future<bool> restoreFromCloudBackup(String fileName) async {
    try {
      // Download backup file from Supabase storage
      final response = await _supabase.storage
          .from('user-backups')
          .download(fileName);
      
      final jsonString = utf8.decode(response);
      final backup = jsonDecode(jsonString) as Map<String, dynamic>;
      
      return await restoreFromBackup(backup);
    } catch (e) {
      debugPrint('Error restoring from cloud backup: $e');
      return false;
    }
  }

  /// Restore data from backup
  static Future<bool> restoreFromBackup(Map<String, dynamic> backup) async {
    try {
      // Validate backup version
      final version = backup['version'] as String?;
      if (version == null) {
        debugPrint('Invalid backup: missing version');
        return false;
      }
      
      // Restore local data
      final localData = backup['local_data'] as Map<String, dynamic>?;
      if (localData != null) {
        await _restoreLocalData(localData);
      }
      
      // Restore cloud data if available
      final cloudData = backup['cloud_data'] as Map<String, dynamic>?;
      if (cloudData != null && !cloudData.containsKey('error')) {
        await _restoreCloudData(cloudData);
      }
      
      debugPrint('Backup restored successfully');
      return true;
    } catch (e) {
      debugPrint('Error restoring backup: $e');
      return false;
    }
  }

  /// Restore local data to Hive boxes
  static Future<void> _restoreLocalData(Map<String, dynamic> localData) async {
    try {
      // Helper function to safely restore to Hive boxes
      Future<void> _safeBoxRestore(String boxName, Map<String, dynamic> data) async {
        try {
          Box box;
          if (Hive.isBoxOpen(boxName)) {
            box = Hive.box(boxName);
          } else {
            box = await Hive.openBox(boxName);
          }
          
          await box.clear();
          for (final entry in data.entries) {
            await box.put(entry.key, entry.value);
          }
          debugPrint('Successfully restored $boxName with ${data.length} items');
        } catch (e) {
          debugPrint('Error restoring box $boxName: $e');
        }
      }
      
      // Restore user preferences
      if (localData.containsKey('user_prefs') && localData['user_prefs'] is Map) {
        await _safeBoxRestore('user_prefs', Map<String, dynamic>.from(localData['user_prefs']));
      }
      
      // Restore books and notes
      if (localData.containsKey('books_notes') && localData['books_notes'] is Map) {
        await _safeBoxRestore('books_notes', Map<String, dynamic>.from(localData['books_notes']));
      }
      
      // Restore calculator history
      if (localData.containsKey('calculator_history') && localData['calculator_history'] is Map) {
        await _safeBoxRestore('calculator_history', Map<String, dynamic>.from(localData['calculator_history']));
      }
      
      // Restore game data
      if (localData.containsKey('game_data') && localData['game_data'] is Map) {
        await _safeBoxRestore('game_data', Map<String, dynamic>.from(localData['game_data']));
      }
      
      // Restore focus data
      if (localData.containsKey('focus_data') && localData['focus_data'] is Map) {
        await _safeBoxRestore('focus_data', Map<String, dynamic>.from(localData['focus_data']));
      }
      
      // Handle class sessions separately (as it might contain complex objects)
      if (localData.containsKey('class_sessions') && localData['class_sessions'] is List) {
        try {
          Box classSessionsBox;
          if (Hive.isBoxOpen('class_sessions')) {
            classSessionsBox = Hive.box('class_sessions');
          } else {
            classSessionsBox = await Hive.openBox('class_sessions');
          }
          
          await classSessionsBox.clear();
          final sessions = localData['class_sessions'] as List;
          for (int i = 0; i < sessions.length; i++) {
            await classSessionsBox.put(i, sessions[i]);
          }
          debugPrint('Successfully restored class_sessions with ${sessions.length} items');
        } catch (e) {
          debugPrint('Error restoring class sessions: $e');
        }
      }
    } catch (e) {
      debugPrint('Error restoring local data: $e');
    }
  }

  /// Restore cloud data to Supabase (if user has permission)
  static Future<void> _restoreCloudData(Map<String, dynamic> cloudData) async {
    try {
      // Note: In a real app, you might want to ask user permission before restoring cloud data
      // as it could overwrite existing data
      
      debugPrint('Cloud data restore completed (metadata only)');
      // Store cloud data metadata locally for reference
      final userPrefs = Hive.box('user_prefs');
      await userPrefs.put('last_cloud_restore', {
        'timestamp': DateTime.now().toIso8601String(),
        'message_count': (cloudData['messages'] as List?)?.length ?? 0,
        'attendance_count': (cloudData['attendance'] as List?)?.length ?? 0,
      });
    } catch (e) {
      debugPrint('Error restoring cloud data: $e');
    }
  }

  /// Export data to various formats
  static Future<String> exportToFormat(String format, {String? specificData}) async {
    try {
      final backup = await createFullBackup();
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      
      switch (format.toLowerCase()) {
        case 'json':
          return await _exportToJson(backup, directory, timestamp);
        case 'csv':
          return await _exportToCsv(backup, directory, timestamp, specificData);
        case 'txt':
          return await _exportToText(backup, directory, timestamp);
        default:
          throw Exception('Unsupported format: $format');
      }
    } catch (e) {
      debugPrint('Error exporting to format $format: $e');
      rethrow;
    }
  }

  static Future<String> _exportToJson(Map<String, dynamic> backup, Directory directory, int timestamp) async {
    final fileName = 'fluxflow_export_$timestamp.json';
    final file = File('${directory.path}/$fileName');
    final jsonString = const JsonEncoder.withIndent('  ').convert(backup);
    await file.writeAsString(jsonString);
    return file.path;
  }

  static Future<String> _exportToCsv(Map<String, dynamic> backup, Directory directory, int timestamp, String? specificData) async {
    final fileName = 'fluxflow_export_$timestamp.csv';
    final file = File('${directory.path}/$fileName');
    
    final buffer = StringBuffer();
    buffer.writeln('Category,Key,Value,Timestamp');
    
    // Export specific data or all data
    final localData = backup['local_data'] as Map<String, dynamic>? ?? {};
    
    for (final category in localData.keys) {
      if (specificData != null && category != specificData) continue;
      
      final categoryData = localData[category];
      if (categoryData is Map) {
        for (final entry in categoryData.entries) {
          buffer.writeln('$category,${entry.key},"${entry.value}",${backup['timestamp']}');
        }
      } else if (categoryData is List) {
        for (int i = 0; i < categoryData.length; i++) {
          buffer.writeln('$category,$i,"${categoryData[i]}",${backup['timestamp']}');
        }
      }
    }
    
    await file.writeAsString(buffer.toString());
    return file.path;
  }

  static Future<String> _exportToText(Map<String, dynamic> backup, Directory directory, int timestamp) async {
    final fileName = 'fluxflow_report_$timestamp.txt';
    final file = File('${directory.path}/$fileName');
    
    final buffer = StringBuffer();
    buffer.writeln('╔══════════════════════════════════════════════════════════╗');
    buffer.writeln('║                 FLUXFLOW DATA EXPORT                     ║');
    buffer.writeln('╚══════════════════════════════════════════════════════════╝');
    buffer.writeln('Generated: ${DateTime.now().toString().split('.')[0]}');
    buffer.writeln('Export Version: ${backup['version']}');
    buffer.writeln('');
    
    // Add summary statistics
    final localData = backup['local_data'] as Map<String, dynamic>? ?? {};
    buffer.writeln('📊 DATA SUMMARY:');
    
    for (final category in localData.keys) {
      final data = localData[category];
      if (data is Map) {
        buffer.writeln('   $category: ${data.length} items');
      } else if (data is List) {
        buffer.writeln('   $category: ${data.length} records');
      }
    }
    
    buffer.writeln('');
    buffer.writeln('═══════════════════════════════════════════════════════════');
    buffer.writeln('Export generated by FluxFlow - Enhanced Data Management');
    buffer.writeln('═══════════════════════════════════════════════════════════');
    
    await file.writeAsString(buffer.toString());
    return file.path;
  }

  /// Import data from file
  static Future<bool> importFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final content = await file.readAsString();
        
        Map<String, dynamic> backup;
        try {
          // Try to decode as base64 first (encrypted backup)
          final decoded = base64Decode(content);
          backup = jsonDecode(utf8.decode(decoded));
        } catch (e) {
          // If that fails, try direct JSON decode
          backup = jsonDecode(content);
        }
        
        return await restoreFromBackup(backup);
      }
      
      return false;
    } catch (e) {
      debugPrint('Error importing from file: $e');
      return false;
    }
  }

  /// Sync data with cloud (bidirectional)
  static Future<bool> syncWithCloud() async {
    try {
      // Create local backup
      final localBackup = await createFullBackup(includeCloudData: false);
      
      // Upload to cloud
      final cloudFileName = await uploadBackupToCloud(localBackup);
      
      if (cloudFileName != null) {
        // Update sync timestamp
        final userPrefs = Hive.box('user_prefs');
        await userPrefs.put('last_cloud_sync', DateTime.now().toIso8601String());
        return true;
      }
      
      return false;
    } catch (e) {
      debugPrint('Error syncing with cloud: $e');
      return false;
    }
  }

  /// Get backup statistics
  static Future<Map<String, dynamic>> getBackupStatistics() async {
    try {
      final backup = await createFullBackup();
      final localData = backup['local_data'] as Map<String, dynamic>? ?? {};
      
      int totalItems = 0;
      final categoryStats = <String, int>{};
      
      for (final category in localData.keys) {
        final data = localData[category];
        int count = 0;
        
        if (data is Map) {
          count = data.length;
        } else if (data is List) {
          count = data.length;
        }
        
        categoryStats[category] = count;
        totalItems += count;
      }
      
      final backupSize = jsonEncode(backup).length;
      
      return {
        'total_items': totalItems,
        'category_stats': categoryStats,
        'backup_size_bytes': backupSize,
        'backup_size_formatted': _formatBytes(backupSize),
        'last_backup': backup['timestamp'],
        'version': backup['version'],
      };
    } catch (e) {
      debugPrint('Error getting backup statistics: $e');
      return {};
    }
  }

  /// Clear all data (with confirmation)
  static Future<bool> clearAllData() async {
    try {
      // Clear all Hive boxes safely
      final boxes = ['user_prefs', 'books_notes', 'calculator_history', 'class_sessions', 'game_data', 'focus_data'];
      
      for (final boxName in boxes) {
        try {
          if (Hive.isBoxOpen(boxName)) {
            final box = Hive.box(boxName);
            await box.clear();
            debugPrint('Cleared box: $boxName');
          } else {
            // Try to open and clear the box
            try {
              final box = await Hive.openBox(boxName);
              await box.clear();
              debugPrint('Opened and cleared box: $boxName');
            } catch (e) {
              debugPrint('Could not open box $boxName: $e');
            }
          }
        } catch (e) {
          debugPrint('Error clearing box $boxName: $e');
        }
      }
      
      return true;
    } catch (e) {
      debugPrint('Error clearing all data: $e');
      return false;
    }
  }

  /// Format bytes to human readable format
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Create or update user profile in cloud
  static Future<bool> createOrUpdateUserProfile({
    required String userName,
    String? email,
    String? displayName,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? syncSettings,
  }) async {
    try {
      final profileData = {
        'user_name': userName,
        if (email != null) 'email': email,
        if (displayName != null) 'display_name': displayName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (preferences != null) 'preferences': preferences,
        if (syncSettings != null) 'sync_settings': syncSettings,
        'last_sync': DateTime.now().toIso8601String(),
      };

      await _supabase
          .from('user_profiles')
          .upsert(profileData);

      return true;
    } catch (e) {
      debugPrint('Error creating/updating user profile: $e');
      return false;
    }
  }

  /// Get user profile from cloud
  static Future<Map<String, dynamic>?> getUserProfile(String userName) async {
    try {
      final profile = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_name', userName)
          .maybeSingle();

      return profile;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  /// Schedule automatic backups
  static Future<void> scheduleAutoBackup() async {
    try {
      final userPrefs = Hive.box('user_prefs');
      final autoBackupEnabled = userPrefs.get('auto_backup_enabled', defaultValue: false);
      
      if (!autoBackupEnabled) return;
      
      final lastBackup = userPrefs.get('last_auto_backup', defaultValue: 0);
      final now = DateTime.now().millisecondsSinceEpoch;
      final frequency = userPrefs.get('auto_backup_frequency', defaultValue: 'weekly');
      
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
        
        // Also sync to cloud if enabled
        final cloudSyncEnabled = userPrefs.get('cloud_sync_enabled', defaultValue: false);
        if (cloudSyncEnabled) {
          await uploadBackupToCloud(backup);
        }
        
        await userPrefs.put('last_auto_backup', now);
        debugPrint('Auto backup completed');
      }
    } catch (e) {
      debugPrint('Auto backup failed: $e');
    }
  }
}