import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudySession {
  final String id;
  final String subject;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // in minutes
  final int focusScore; // 0-100
  final String notes;
  final Map<String, dynamic> metadata;

  StudySession({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.focusScore,
    required this.notes,
    required this.metadata,
  });

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'] as String,
      subject: json['subject'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      duration: json['duration'] as int,
      focusScore: json['focus_score'] as int,
      notes: json['notes'] as String? ?? '',
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'duration': duration,
      'focus_score': focusScore,
      'notes': notes,
      'metadata': metadata,
    };
  }
}

class StudyGoal {
  final String id;
  final String title;
  final String description;
  final DateTime targetDate;
  final int targetHours;
  final int currentHours;
  final bool isCompleted;
  final String category;

  StudyGoal({
    required this.id,
    required this.title,
    required this.description,
    required this.targetDate,
    required this.targetHours,
    required this.currentHours,
    required this.isCompleted,
    required this.category,
  });

  factory StudyGoal.fromJson(Map<String, dynamic> json) {
    return StudyGoal(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetDate: DateTime.parse(json['target_date'] as String),
      targetHours: json['target_hours'] as int,
      currentHours: json['current_hours'] as int,
      isCompleted: json['is_completed'] as bool,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'target_date': targetDate.toIso8601String(),
      'target_hours': targetHours,
      'current_hours': currentHours,
      'is_completed': isCompleted,
      'category': category,
    };
  }

  double get progressPercentage => (currentHours / targetHours * 100).clamp(0, 100);
}

class StudyCompanionService {
  static const String _studyBoxKey = 'study_companion';
  late Box _studyBox;
  final SupabaseClient _supabase = Supabase.instance.client;

  StudyCompanionService() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      _studyBox = await Hive.openBox(_studyBoxKey);
    } catch (e) {
      debugPrint('Error initializing study companion service: $e');
    }
  }

  /// Get dashboard data for overview
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      await _initializeService();
      
      final sessions = await getRecentSessions(limit: 10);
      final totalStudyTime = await getTotalStudyTime();
      final studyStreak = await getStudyStreak();
      final todayStudyTime = await getTodayStudyTime();
      final weeklyGoal = getWeeklyGoal();
      final weeklyProgress = await getWeeklyProgress();
      final focusScore = await calculateFocusScore();
      final aiInsights = await generateAIInsights();

      return {
        'total_study_time': totalStudyTime,
        'study_streak': studyStreak,
        'today_study_time': todayStudyTime,
        'weekly_goal': weeklyGoal,
        'weekly_progress': weeklyProgress,
        'focus_score': focusScore,
        'recent_sessions': sessions.map((s) => {
          'subject': s.subject,
          'duration': s.duration,
          'score': s.focusScore,
          'date': _formatDate(s.startTime),
        }).toList(),
        'ai_insights': aiInsights,
      };
    } catch (e) {
      debugPrint('Error getting dashboard data: $e');
      return _getDefaultDashboardData();
    }
  }

  /// Start a new study session
  Future<String> startStudySession({
    required String subject,
    required int plannedDuration,
    String notes = '',
  }) async {
    try {
      await _initializeService();
      
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      final startTime = DateTime.now();
      
      // Store session start info
      await _studyBox.put('current_session', {
        'id': sessionId,
        'subject': subject,
        'start_time': startTime.toIso8601String(),
        'planned_duration': plannedDuration,
        'notes': notes,
      });

      return sessionId;
    } catch (e) {
      debugPrint('Error starting study session: $e');
      rethrow;
    }
  }

  /// End current study session
  Future<StudySession> endStudySession({
    required int focusScore,
    String additionalNotes = '',
  }) async {
    try {
      await _initializeService();
      
      final currentSessionData = _studyBox.get('current_session');
      if (currentSessionData == null) {
        throw Exception('No active study session found');
      }

      final sessionMap = Map<String, dynamic>.from(currentSessionData);
      final startTime = DateTime.parse(sessionMap['start_time']);
      final endTime = DateTime.now();
      final actualDuration = endTime.difference(startTime).inMinutes;

      final session = StudySession(
        id: sessionMap['id'],
        subject: sessionMap['subject'],
        startTime: startTime,
        endTime: endTime,
        duration: actualDuration,
        focusScore: focusScore,
        notes: '${sessionMap['notes']} $additionalNotes'.trim(),
        metadata: {
          'planned_duration': sessionMap['planned_duration'],
          'actual_vs_planned': actualDuration / sessionMap['planned_duration'],
        },
      );

      // Save completed session
      await _saveStudySession(session);
      
      // Clear current session
      await _studyBox.delete('current_session');

      return session;
    } catch (e) {
      debugPrint('Error ending study session: $e');
      rethrow;
    }
  }

  /// Save study session to storage
  Future<void> _saveStudySession(StudySession session) async {
    try {
      // Save to local storage
      final sessions = _studyBox.get('study_sessions', defaultValue: <Map<String, dynamic>>[]);
      final sessionsList = List<Map<String, dynamic>>.from(sessions);
      sessionsList.add(session.toJson());
      
      // Keep only last 100 sessions locally
      if (sessionsList.length > 100) {
        sessionsList.removeRange(0, sessionsList.length - 100);
      }
      
      await _studyBox.put('study_sessions', sessionsList);

      // TODO: Sync with cloud storage
      _syncSessionWithCloud(session);
    } catch (e) {
      debugPrint('Error saving study session: $e');
    }
  }

  /// Get recent study sessions
  Future<List<StudySession>> getRecentSessions({int limit = 10}) async {
    try {
      await _initializeService();
      
      final sessions = _studyBox.get('study_sessions', defaultValue: <Map<String, dynamic>>[]);
      final sessionsList = List<Map<String, dynamic>>.from(sessions);
      
      return sessionsList
          .map((json) => StudySession.fromJson(json))
          .toList()
          .reversed
          .take(limit)
          .toList();
    } catch (e) {
      debugPrint('Error getting recent sessions: $e');
      return [];
    }
  }

  /// Get total study time in minutes
  Future<int> getTotalStudyTime() async {
    try {
      final sessions = await getRecentSessions(limit: 1000);
      return sessions.fold<int>(0, (total, session) => total + session.duration);
    } catch (e) {
      return 0;
    }
  }

  /// Get today's study time
  Future<int> getTodayStudyTime() async {
    try {
      final sessions = await getRecentSessions(limit: 50);
      final today = DateTime.now();
      
      return sessions
          .where((session) => 
              session.startTime.year == today.year &&
              session.startTime.month == today.month &&
              session.startTime.day == today.day)
          .fold<int>(0, (total, session) => total + session.duration);
    } catch (e) {
      return 0;
    }
  }

  /// Get weekly progress
  Future<int> getWeeklyProgress() async {
    try {
      final sessions = await getRecentSessions(limit: 100);
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      
      return sessions
          .where((session) => session.startTime.isAfter(weekStart))
          .fold<int>(0, (total, session) => total + session.duration);
    } catch (e) {
      return 0;
    }
  }

  /// Get study streak in days
  Future<int> getStudyStreak() async {
    try {
      final sessions = await getRecentSessions(limit: 100);
      if (sessions.isEmpty) return 0;

      final today = DateTime.now();
      int streak = 0;
      
      for (int i = 0; i < 30; i++) { // Check last 30 days
        final checkDate = today.subtract(Duration(days: i));
        final hasStudyOnDate = sessions.any((session) =>
            session.startTime.year == checkDate.year &&
            session.startTime.month == checkDate.month &&
            session.startTime.day == checkDate.day);
        
        if (hasStudyOnDate) {
          streak++;
        } else if (i > 0) { // Allow today to be empty
          break;
        }
      }
      
      return streak;
    } catch (e) {
      return 0;
    }
  }

  /// Calculate focus score based on recent sessions
  Future<int> calculateFocusScore() async {
    try {
      final recentSessions = await getRecentSessions(limit: 10);
      if (recentSessions.isEmpty) return 0;

      final averageScore = recentSessions
          .fold(0, (total, session) => total + session.focusScore) /
          recentSessions.length;

      return averageScore.round();
    } catch (e) {
      return 0;
    }
  }

  /// Generate AI insights based on study patterns
  Future<List<String>> generateAIInsights() async {
    try {
      final sessions = await getRecentSessions(limit: 50);
      final insights = <String>[];

      if (sessions.isEmpty) {
        insights.add('Start your first study session to get personalized insights!');
        return insights;
      }

      // Analyze study patterns
      final totalTime = sessions.fold(0, (total, session) => total + session.duration);
      final averageSession = totalTime / sessions.length;
      final averageFocus = sessions.fold(0, (total, session) => total + session.focusScore) / sessions.length;

      // Generate insights based on patterns
      if (averageSession < 25) {
        insights.add('Try longer study sessions (25-50 minutes) for better focus and retention.');
      }

      if (averageFocus < 70) {
        insights.add('Your focus score could improve. Try eliminating distractions during study time.');
      }

      final todayTime = await getTodayStudyTime();
      if (todayTime == 0) {
        insights.add('You haven\'t studied today yet. Even 15 minutes can make a difference!');
      }

      final streak = await getStudyStreak();
      if (streak >= 7) {
        insights.add('Amazing! You\'ve maintained a ${streak}-day study streak. Keep it up!');
      }

      // Subject-specific insights
      final subjectMap = <String, int>{};
      for (final session in sessions) {
        subjectMap[session.subject] = (subjectMap[session.subject] ?? 0) + session.duration;
      }

      if (subjectMap.length > 1) {
        final mostStudied = subjectMap.entries.reduce((a, b) => a.value > b.value ? a : b);
        final leastStudied = subjectMap.entries.reduce((a, b) => a.value < b.value ? a : b);
        
        if (mostStudied.value > leastStudied.value * 2) {
          insights.add('Consider balancing your study time. You\'ve focused heavily on ${mostStudied.key}.');
        }
      }

      return insights.take(5).toList();
    } catch (e) {
      debugPrint('Error generating AI insights: $e');
      return ['Unable to generate insights at this time.'];
    }
  }

  /// Get weekly goal (stored in preferences)
  int getWeeklyGoal() {
    try {
      return _studyBox.get('weekly_goal', defaultValue: 300); // 5 hours default
    } catch (e) {
      return 300;
    }
  }

  /// Set weekly goal
  Future<void> setWeeklyGoal(int minutes) async {
    try {
      await _initializeService();
      await _studyBox.put('weekly_goal', minutes);
    } catch (e) {
      debugPrint('Error setting weekly goal: $e');
    }
  }

  /// Get study analytics for charts and graphs
  Future<Map<String, dynamic>> getStudyAnalytics() async {
    try {
      final sessions = await getRecentSessions(limit: 100);
      
      // Daily study time for last 7 days
      final dailyData = <String, int>{};
      final now = DateTime.now();
      
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey = '${date.month}/${date.day}';
        dailyData[dateKey] = 0;
      }

      for (final session in sessions) {
        final dateKey = '${session.startTime.month}/${session.startTime.day}';
        if (dailyData.containsKey(dateKey)) {
          dailyData[dateKey] = dailyData[dateKey]! + session.duration;
        }
      }

      // Subject breakdown
      final subjectData = <String, int>{};
      for (final session in sessions) {
        subjectData[session.subject] = (subjectData[session.subject] ?? 0) + session.duration;
      }

      // Focus score trend
      final focusData = sessions.take(10).map((s) => s.focusScore).toList().reversed.toList();

      return {
        'daily_study_time': dailyData,
        'subject_breakdown': subjectData,
        'focus_trend': focusData,
        'total_sessions': sessions.length,
        'average_session_length': sessions.isNotEmpty 
            ? sessions.fold(0, (total, s) => total + s.duration) / sessions.length 
            : 0,
        'best_focus_score': sessions.isNotEmpty 
            ? sessions.map((s) => s.focusScore).reduce((a, b) => a > b ? a : b)
            : 0,
      };
    } catch (e) {
      debugPrint('Error getting study analytics: $e');
      return {};
    }
  }

  /// Sync session with cloud storage
  Future<void> _syncSessionWithCloud(StudySession session) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // TODO: Implement cloud sync to study_sessions table
      debugPrint('Cloud sync not implemented yet for study sessions');
    } catch (e) {
      debugPrint('Error syncing session with cloud: $e');
    }
  }

  /// Get default dashboard data
  Map<String, dynamic> _getDefaultDashboardData() {
    return {
      'total_study_time': 0,
      'study_streak': 0,
      'today_study_time': 0,
      'weekly_goal': 300,
      'weekly_progress': 0,
      'focus_score': 0,
      'recent_sessions': [],
      'ai_insights': ['Start studying to get personalized insights!'],
    };
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';
    return '${date.month}/${date.day}';
  }

  /// Export study data
  Future<Map<String, dynamic>> exportStudyData() async {
    try {
      final sessions = await getRecentSessions(limit: 1000);
      final analytics = await getStudyAnalytics();
      
      return {
        'version': '1.0.0',
        'exported_at': DateTime.now().toIso8601String(),
        'sessions': sessions.map((s) => s.toJson()).toList(),
        'analytics': analytics,
        'total_study_time': await getTotalStudyTime(),
        'study_streak': await getStudyStreak(),
        'weekly_goal': getWeeklyGoal(),
      };
    } catch (e) {
      debugPrint('Error exporting study data: $e');
      return {};
    }
  }

  /// Clear all study data
  Future<void> clearAllData() async {
    try {
      await _initializeService();
      await _studyBox.clear();
    } catch (e) {
      debugPrint('Error clearing study data: $e');
    }
  }
}