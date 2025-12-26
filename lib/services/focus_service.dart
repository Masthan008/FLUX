import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FocusService {
  static final _supabase = Supabase.instance.client;
  
  // Get current user ID
  static String _getCurrentUserId() {
    final box = Hive.box('user_prefs');
    return box.get('user_id', defaultValue: 'guest');
  }
  
  // Save focus session to Supabase
  static Future<void> saveFocusSession({
    required int durationMinutes,
    required String status,
    String? ambientSound,
  }) async {
    try {
      final userId = _getCurrentUserId();
      
      await _supabase.from('focus_sessions').insert({
        'user_id': userId,
        'duration_minutes': durationMinutes,
        'status': status,
        'ambient_sound': ambientSound,
        'created_at': DateTime.now().toIso8601String(),
      });
      
      // Update study streak
      await _updateStudyStreak();
      
      // Check for achievements
      await _checkFocusAchievements(durationMinutes);
      
      debugPrint('✅ Focus session saved: $durationMinutes min, $status');
    } catch (e) {
      debugPrint('⚠️ Save focus session error: $e');
    }
  }
  
  // Update study streak
  static Future<void> _updateStudyStreak() async {
    try {
      final userId = _getCurrentUserId();
      await _supabase.rpc('update_study_streak', params: {'p_user_id': userId});
      debugPrint('✅ Study streak updated');
    } catch (e) {
      debugPrint('⚠️ Update streak error: $e');
    }
  }
  
  // Check and award focus achievements
  static Future<void> _checkFocusAchievements(int minutes) async {
    try {
      final userId = _getCurrentUserId();
      
      // Get total focus sessions
      final sessions = await _supabase
          .from('focus_sessions')
          .select('duration_minutes')
          .eq('user_id', userId)
          .eq('status', 'completed');
      
      final sessionCount = (sessions as List).length;
      final totalMinutes = sessions.fold<int>(
        0,
        (sum, session) => sum + (session['duration_minutes'] as int? ?? 0),
      );
      
      // Award achievements based on milestones
      if (sessionCount == 1) {
        await _awardAchievement('focus', 'First Focus Session');
      }
      if (sessionCount == 10) {
        await _awardAchievement('focus', '10 Focus Sessions');
      }
      if (sessionCount == 50) {
        await _awardAchievement('focus', '50 Focus Sessions');
      }
      if (sessionCount == 100) {
        await _awardAchievement('focus', '100 Focus Sessions');
      }
      
      if (totalMinutes >= 60) {
        await _awardAchievement('focus', '1 Hour Focused');
      }
      if (totalMinutes >= 600) {
        await _awardAchievement('focus', '10 Hours Focused');
      }
      if (totalMinutes >= 6000) {
        await _awardAchievement('focus', '100 Hours Focused');
      }
      
      // Long session achievements
      if (minutes >= 60) {
        await _awardAchievement('focus', 'Marathon Session (60+ min)');
      }
      if (minutes >= 120) {
        await _awardAchievement('focus', 'Ultra Marathon (120+ min)');
      }
    } catch (e) {
      debugPrint('⚠️ Check achievements error: $e');
    }
  }
  
  // Award achievement
  static Future<void> _awardAchievement(String type, String name) async {
    try {
      final userId = _getCurrentUserId();
      await _supabase.rpc('award_achievement', params: {
        'p_user_id': userId,
        'p_achievement_type': type,
        'p_achievement_name': name,
      });
      debugPrint('🏆 Achievement awarded: $name');
    } catch (e) {
      debugPrint('⚠️ Award achievement error: $e');
    }
  }
  
  // Get focus leaderboard
  static Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 50}) async {
    try {
      final response = await _supabase
          .from('focus_leaderboard')
          .select()
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get leaderboard error: $e');
      return [];
    }
  }
  
  // Get user's focus statistics
  static Future<Map<String, dynamic>> getUserFocusStats() async {
    try {
      final userId = _getCurrentUserId();
      
      final sessions = await _supabase
          .from('focus_sessions')
          .select()
          .eq('user_id', userId);
      
      final sessionsList = List<Map<String, dynamic>>.from(sessions);
      
      final totalSessions = sessionsList.length;
      final completedSessions = sessionsList.where((s) => s['status'] == 'completed').length;
      final failedSessions = sessionsList.where((s) => s['status'] == 'failed').length;
      
      final totalMinutes = sessionsList.fold<int>(
        0,
        (sum, session) => sum + (session['duration_minutes'] as int? ?? 0),
      );
      
      final avgMinutes = totalSessions > 0 ? totalMinutes / totalSessions : 0;
      
      // Get streak info
      final streakResponse = await _supabase
          .from('study_streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      final currentStreak = streakResponse?['current_streak'] ?? 0;
      final longestStreak = streakResponse?['longest_streak'] ?? 0;
      
      // Get rank
      final leaderboard = await getLeaderboard();
      final userRank = leaderboard.indexWhere((user) => user['user_id'] == userId) + 1;
      
      return {
        'total_sessions': totalSessions,
        'completed_sessions': completedSessions,
        'failed_sessions': failedSessions,
        'total_minutes': totalMinutes,
        'total_hours': (totalMinutes / 60).toStringAsFixed(1),
        'avg_minutes': avgMinutes.toStringAsFixed(1),
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'rank': userRank > 0 ? userRank : null,
      };
    } catch (e) {
      debugPrint('⚠️ Get focus stats error: $e');
      return {};
    }
  }
  
  // Get focus history (last 30 days)
  static Future<List<Map<String, dynamic>>> getFocusHistory({int days = 30}) async {
    try {
      final userId = _getCurrentUserId();
      final startDate = DateTime.now().subtract(Duration(days: days));
      
      final response = await _supabase
          .from('focus_sessions')
          .select()
          .eq('user_id', userId)
          .gte('created_at', startDate.toIso8601String())
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get focus history error: $e');
      return [];
    }
  }
  
  // Get daily focus summary
  static Future<Map<String, int>> getDailyFocusSummary({int days = 7}) async {
    try {
      final userId = _getCurrentUserId();
      final startDate = DateTime.now().subtract(Duration(days: days));
      
      final sessions = await _supabase
          .from('focus_sessions')
          .select()
          .eq('user_id', userId)
          .gte('created_at', startDate.toIso8601String());
      
      final sessionsList = List<Map<String, dynamic>>.from(sessions);
      
      // Group by date
      final Map<String, int> dailySummary = {};
      
      for (var session in sessionsList) {
        final date = DateTime.parse(session['created_at']).toLocal();
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        
        dailySummary[dateKey] = (dailySummary[dateKey] ?? 0) + (session['duration_minutes'] as int? ?? 0);
      }
      
      return dailySummary;
    } catch (e) {
      debugPrint('⚠️ Get daily summary error: $e');
      return {};
    }
  }
  
  // Get user achievements
  static Future<List<Map<String, dynamic>>> getUserAchievements() async {
    try {
      final userId = _getCurrentUserId();
      
      final response = await _supabase
          .from('user_achievements')
          .select()
          .eq('user_id', userId)
          .order('earned_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('⚠️ Get achievements error: $e');
      return [];
    }
  }
  
  // Get study streak info
  static Future<Map<String, dynamic>?> getStudyStreak() async {
    try {
      final userId = _getCurrentUserId();
      
      final response = await _supabase
          .from('study_streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      return response;
    } catch (e) {
      debugPrint('⚠️ Get streak error: $e');
      return null;
    }
  }
  
  // Get focus insights
  static Future<Map<String, dynamic>> getFocusInsights() async {
    try {
      final userId = _getCurrentUserId();
      
      // Get all sessions
      final sessions = await _supabase
          .from('focus_sessions')
          .select()
          .eq('user_id', userId);
      
      final sessionsList = List<Map<String, dynamic>>.from(sessions);
      
      if (sessionsList.isEmpty) {
        return {
          'most_productive_time': 'No data yet',
          'favorite_ambient_sound': 'None',
          'success_rate': 0.0,
          'total_trees_planted': 0,
        };
      }
      
      // Calculate most productive time (hour of day)
      final hourCounts = <int, int>{};
      for (var session in sessionsList) {
        if (session['status'] == 'completed') {
          final hour = DateTime.parse(session['created_at']).hour;
          hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
        }
      }
      
      final mostProductiveHour = hourCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      
      final timeOfDay = mostProductiveHour < 12
          ? 'Morning (${mostProductiveHour}:00)'
          : mostProductiveHour < 17
              ? 'Afternoon (${mostProductiveHour}:00)'
              : 'Evening (${mostProductiveHour}:00)';
      
      // Calculate favorite ambient sound
      final soundCounts = <String, int>{};
      for (var session in sessionsList) {
        final sound = session['ambient_sound'] ?? 'Silence';
        soundCounts[sound] = (soundCounts[sound] ?? 0) + 1;
      }
      
      final favoriteSound = soundCounts.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      
      // Calculate success rate
      final completedCount = sessionsList.where((s) => s['status'] == 'completed').length;
      final successRate = (completedCount / sessionsList.length) * 100;
      
      return {
        'most_productive_time': timeOfDay,
        'favorite_ambient_sound': favoriteSound,
        'success_rate': successRate.toStringAsFixed(1),
        'total_trees_planted': completedCount,
      };
    } catch (e) {
      debugPrint('⚠️ Get insights error: $e');
      return {};
    }
  }
}
