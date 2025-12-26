import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  // Callback to notify listeners of badge count changes
  static Function(int)? _onUnreadCountChanged;

  static Future<void> init() async {
    // Using the transparent notification icon for status bar
    const androidSettings = AndroidInitializationSettings('notification_icon');
    const settings = InitializationSettings(android: androidSettings);
    
    await _notifications.initialize(settings);

    // Request permission for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    // Note: FCM push notifications require Firebase setup:
    // 1. Add firebase_core and firebase_messaging to pubspec.yaml
    // 2. Run flutterfire configure to generate google-services.json
    // 3. Uncomment _setupFCM() below after configuration
  }
  
  /// Get the last notified news ID from Hive
  static String _getLastNotifiedId() {
    final box = Hive.box('user_prefs');
    return box.get('last_notified_news_id', defaultValue: '');
  }
  
  /// Save the last notified news ID
  static Future<void> _setLastNotifiedId(String id) async {
    final box = Hive.box('user_prefs');
    await box.put('last_notified_news_id', id);
  }
  
  /// Get the last time user opened news screen
  static DateTime _getLastNewsOpenTime() {
    final box = Hive.box('user_prefs');
    final timeStr = box.get('last_news_open_time', defaultValue: '2000-01-01T00:00:00.000Z');
    return DateTime.parse(timeStr);
  }
  
  /// Save current time as last news open time (clears badge)
  static Future<void> markNewsAsRead() async {
    final box = Hive.box('user_prefs');
    await box.put('last_news_open_time', DateTime.now().toIso8601String());
    _onUnreadCountChanged?.call(0);
  }
  
  /// Get unread news count (news posted AFTER last open time)
  static Future<int> getUnreadCount() async {
    try {
      final lastSeenTime = _getLastNewsOpenTime();
      
      final response = await Supabase.instance.client
          .from('news')
          .select('id')
          .gt('created_at', lastSeenTime.toIso8601String());
      
      return (response as List).length;
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }
  
  /// Set listener for unread count changes
  static void setOnUnreadCountChanged(Function(int)? callback) {
    _onUnreadCountChanged = callback;
  }
  
  /// Clear unread count (call when user opens News screen)
  static Future<void> clearUnreadCount() async {
    await markNewsAsRead();
  }

  /// Check for new news and show notification if new
  /// Uses ID-based logic: only notify if news ID != last notified ID
  static Future<void> checkAndNotify() async {
    try {
      // 1. Get the latest news from Supabase
      final response = await Supabase.instance.client
          .from('news')
          .select()
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      
      if (response == null) return;
      
      final latestNewsId = response['id']?.toString() ?? '';
      final title = response['title'] ?? 'New Update';
      final description = response['description'] ?? 'Check the app for details';
      
      // 2. Get the ID we last notified about
      final lastNotifiedId = _getLastNotifiedId();
      
      // 3. THE MAGIC CHECK - Only notify if different ID
      if (latestNewsId.isNotEmpty && latestNewsId != lastNotifiedId) {
        // This is NEW news!
        await _showNotification(title, description);
        
        // Save this ID so we don't notify again
        await _setLastNotifiedId(latestNewsId);
        
        // Update badge count
        final unreadCount = await getUnreadCount();
        _onUnreadCountChanged?.call(unreadCount);
      }
    } catch (e) {
      print('Error checking for notifications: $e');
    }
  }
  
  /// Show notification for new news (called by checkAndNotify)
  static Future<void> _showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'news_channel',
      'News Updates',
      channelDescription: 'Notifications for new news updates',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF00FFFF), // Cyan color
      playSound: true,
      enableVibration: true,
    );
    
    const details = NotificationDetails(android: androidDetails);
    
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
      "📢 $title",
      body,
      details,
    );
  }

  /// Legacy method - now calls checkAndNotify internally
  static Future<void> showNewsAlert(String id, String title, String body) async {
    final lastNotifiedId = _getLastNotifiedId();
    
    // Only notify if different ID
    if (id.isNotEmpty && id != lastNotifiedId) {
      await _showNotification(title, body);
      await _setLastNotifiedId(id);
      
      // Update badge count
      final unreadCount = await getUnreadCount();
      _onUnreadCountChanged?.call(unreadCount);
    }
  }
  
  /// Reset all notification tracking (for debugging)
  static Future<void> resetNotificationTracking() async {
    final box = Hive.box('user_prefs');
    await box.delete('last_notified_news_id');
    await box.delete('last_news_open_time');
    _onUnreadCountChanged?.call(0);
  }
}
