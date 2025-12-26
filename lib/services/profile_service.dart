import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  static final _supabase = Supabase.instance.client;
  
  // Get current user ID
  static String getCurrentUserId() {
    final box = Hive.box('user_prefs');
    return box.get('user_id', defaultValue: 'guest');
  }
  
  // Get current user name
  static String getCurrentUserName() {
    final box = Hive.box('user_prefs');
    return box.get('user_name', defaultValue: 'Student');
  }
  
  // Create or update user profile in Supabase
  static Future<void> syncProfile() async {
    try {
      final box = Hive.box('user_prefs');
      final userId = box.get('user_id', defaultValue: 'guest');
      final userName = box.get('user_name', defaultValue: 'Student');
      final branch = box.get('branch', defaultValue: '');
      final role = box.get('user_role', defaultValue: 'student');
      final photoPath = box.get('user_photo');
      
      // Check if profile exists
      final existing = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      if (existing == null) {
        // Create new profile
        await _supabase.from('user_profiles').insert({
          'user_id': userId,
          'user_name': userName,
          'branch': branch,
          'role': role,
          'photo_url': photoPath,
          'created_at': DateTime.now().toIso8601String(),
          'last_login': DateTime.now().toIso8601String(),
          'login_count': 1,
          'is_online': true,
        });
        
        debugPrint('✅ Profile created for $userName');
      } else {
        // Update existing profile
        await _supabase.from('user_profiles').update({
          'user_name': userName,
          'branch': branch,
          'role': role,
          'photo_url': photoPath,
          'last_login': DateTime.now().toIso8601String(),
          'login_count': (existing['login_count'] ?? 0) + 1,
          'is_online': true,
        }).eq('user_id', userId);
        
        debugPrint('✅ Profile updated for $userName');
      }
    } catch (e) {
      debugPrint('⚠️ Profile sync error: $e');
    }
  }
  
  // Log login activity
  static Future<void> logLogin() async {
    try {
      final userId = getCurrentUserId();
      final userName = getCurrentUserName();
      
      await _supabase.from('login_history').insert({
        'user_id': userId,
        'user_name': userName,
        'login_time': DateTime.now().toIso8601String(),
        'device_info': 'Android', // Can be enhanced with device_info package
      });
      
      debugPrint('✅ Login logged for $userName');
    } catch (e) {
      debugPrint('⚠️ Login log error: $e');
    }
  }
  
  // Log user activity
  static Future<void> logActivity(String activityType, Map<String, dynamic>? data) async {
    try {
      final userId = getCurrentUserId();
      
      await _supabase.from('user_activity').insert({
        'user_id': userId,
        'activity_type': activityType,
        'activity_data': data,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      debugPrint('✅ Activity logged: $activityType');
    } catch (e) {
      debugPrint('⚠️ Activity log error: $e');
    }
  }
  
  // Set user online status
  static Future<void> setOnlineStatus(bool isOnline) async {
    try {
      final userId = getCurrentUserId();
      
      await _supabase.from('user_profiles').update({
        'is_online': isOnline,
      }).eq('user_id', userId);
    } catch (e) {
      debugPrint('⚠️ Online status error: $e');
    }
  }
  
  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      return response;
    } catch (e) {
      debugPrint('⚠️ Get profile error: $e');
      return null;
    }
  }
  
  // Get all online users
  static Future<List<Map<String, dynamic>>> getOnlineUsers() async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('is_online', true)
          .order('last_login', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get online users error: $e');
      return [];
    }
  }
  
  // Get login history
  static Future<List<Map<String, dynamic>>> getLoginHistory() async {
    try {
      final userId = getCurrentUserId();
      
      final response = await _supabase
          .from('login_history')
          .select()
          .eq('user_id', userId)
          .order('login_time', ascending: false)
          .limit(50);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get login history error: $e');
      return [];
    }
  }
  
  // Update profile bio
  static Future<void> updateBio(String bio) async {
    try {
      final userId = getCurrentUserId();
      
      await _supabase.from('user_profiles').update({
        'bio': bio,
      }).eq('user_id', userId);
      
      debugPrint('✅ Bio updated');
    } catch (e) {
      debugPrint('⚠️ Bio update error: $e');
    }
  }
  
  // Get user statistics
  static Future<Map<String, dynamic>> getUserStats() async {
    try {
      final userId = getCurrentUserId();
      
      // Get focus sessions count
      final focusResponse = await _supabase
          .from('focus_sessions')
          .select('duration_minutes, status')
          .eq('user_id', userId);
      
      final focusSessions = List<Map<String, dynamic>>.from(focusResponse);
      final totalMinutes = focusSessions.fold<int>(
        0,
        (sum, session) => sum + (session['duration_minutes'] as int? ?? 0),
      );
      final completedSessions = focusSessions.where((s) => s['status'] == 'completed').length;
      
      // Get study streak
      final streakResponse = await _supabase
          .from('study_streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      final currentStreak = streakResponse?['current_streak'] ?? 0;
      final longestStreak = streakResponse?['longest_streak'] ?? 0;
      
      // Get achievements count
      final achievementsResponse = await _supabase
          .from('user_achievements')
          .select('id')
          .eq('user_id', userId);
      
      final achievementsCount = (achievementsResponse as List).length;
      
      return {
        'total_focus_minutes': totalMinutes,
        'completed_sessions': completedSessions,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'achievements_count': achievementsCount,
      };
    } catch (e) {
      debugPrint('⚠️ Get stats error: $e');
      return {
        'total_focus_minutes': 0,
        'completed_sessions': 0,
        'current_streak': 0,
        'longest_streak': 0,
        'achievements_count': 0,
      };
    }
  }
}
