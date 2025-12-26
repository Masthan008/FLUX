import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum DashboardWidgetType {
  quickStats,
  schedule,
  progressChart,
  quickActions,
  weather,
  motivational,
  recentActivity,
  deadlines,
}

class DashboardWidget {
  final String id;
  final DashboardWidgetType type;
  final int position;
  final Map<String, dynamic> config;

  DashboardWidget({
    required this.id,
    required this.type,
    required this.position,
    required this.config,
  });

  factory DashboardWidget.fromJson(Map<String, dynamic> json) {
    return DashboardWidget(
      id: json['id'] as String,
      type: DashboardWidgetType.values[json['type'] as int],
      position: json['position'] as int,
      config: Map<String, dynamic>.from(json['config'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'position': position,
      'config': config,
    };
  }

  DashboardWidget copyWith({
    String? id,
    DashboardWidgetType? type,
    int? position,
    Map<String, dynamic>? config,
  }) {
    return DashboardWidget(
      id: id ?? this.id,
      type: type ?? this.type,
      position: position ?? this.position,
      config: config ?? this.config,
    );
  }
}

class DashboardService {
  static const String _dashboardBoxKey = 'dashboard_widgets';
  late Box _dashboardBox;
  final SupabaseClient _supabase = Supabase.instance.client;

  DashboardService() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      _dashboardBox = await Hive.openBox(_dashboardBoxKey);
    } catch (e) {
      debugPrint('Error initializing dashboard service: $e');
    }
  }

  /// Get user's dashboard widgets
  Future<List<DashboardWidget>> getUserWidgets() async {
    try {
      await _initializeService();
      
      // Try to get from local storage first
      final localWidgets = _dashboardBox.get('user_widgets');
      if (localWidgets != null) {
        final List<dynamic> widgetsList = localWidgets as List<dynamic>;
        return widgetsList
            .map((json) => DashboardWidget.fromJson(Map<String, dynamic>.from(json)))
            .toList()
          ..sort((a, b) => a.position.compareTo(b.position));
      }

      // If no local widgets, return default layout
      return _getDefaultWidgets();
    } catch (e) {
      debugPrint('Error getting user widgets: $e');
      return _getDefaultWidgets();
    }
  }

  /// Save user's dashboard widgets
  Future<void> saveUserWidgets(List<DashboardWidget> widgets) async {
    try {
      await _initializeService();
      
      // Update positions
      final updatedWidgets = widgets.asMap().entries.map((entry) {
        return entry.value.copyWith(position: entry.key);
      }).toList();

      // Save to local storage
      final widgetsJson = updatedWidgets.map((w) => w.toJson()).toList();
      await _dashboardBox.put('user_widgets', widgetsJson);

      // TODO: Sync with cloud storage
      _syncWithCloud(updatedWidgets);
    } catch (e) {
      debugPrint('Error saving user widgets: $e');
    }
  }

  /// Get default dashboard layout
  List<DashboardWidget> _getDefaultWidgets() {
    return [
      DashboardWidget(
        id: 'quick_stats',
        type: DashboardWidgetType.quickStats,
        position: 0,
        config: {},
      ),
      DashboardWidget(
        id: 'schedule',
        type: DashboardWidgetType.schedule,
        position: 1,
        config: {},
      ),
      DashboardWidget(
        id: 'quick_actions',
        type: DashboardWidgetType.quickActions,
        position: 2,
        config: {},
      ),
      DashboardWidget(
        id: 'progress_chart',
        type: DashboardWidgetType.progressChart,
        position: 3,
        config: {},
      ),
    ];
  }

  /// Sync widgets with cloud storage
  Future<void> _syncWithCloud(List<DashboardWidget> widgets) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      // TODO: Implement cloud sync
      // This would save to a dashboard_widgets table in Supabase
      debugPrint('Cloud sync not implemented yet');
    } catch (e) {
      debugPrint('Error syncing with cloud: $e');
    }
  }

  /// Get widget data for specific widget type
  Future<Map<String, dynamic>> getWidgetData(DashboardWidgetType type) async {
    try {
      switch (type) {
        case DashboardWidgetType.quickStats:
          return await _getQuickStatsData();
        case DashboardWidgetType.schedule:
          return await _getScheduleData();
        case DashboardWidgetType.progressChart:
          return await _getProgressData();
        case DashboardWidgetType.quickActions:
          return _getQuickActionsData();
        case DashboardWidgetType.weather:
          return await _getWeatherData();
        case DashboardWidgetType.motivational:
          return _getMotivationalData();
        case DashboardWidgetType.recentActivity:
          return await _getRecentActivityData();
        case DashboardWidgetType.deadlines:
          return await _getDeadlinesData();
      }
    } catch (e) {
      debugPrint('Error getting widget data for $type: $e');
      return {'error': e.toString()};
    }
  }

  /// Get quick stats data
  Future<Map<String, dynamic>> _getQuickStatsData() async {
    try {
      // Get attendance data
      final attendanceBox = Hive.box('user_prefs');
      final totalClasses = attendanceBox.get('total_classes', defaultValue: 0);
      final attendedClasses = attendanceBox.get('attended_classes', defaultValue: 0);
      final attendanceRate = totalClasses > 0 ? (attendedClasses / totalClasses * 100) : 0.0;

      // Get study time from calculator usage (proxy)
      final calculatorBox = Hive.box('calculator_history');
      final calculatorUsage = calculatorBox.length;

      // Get messages count
      int messageCount = 0;
      try {
        final userName = attendanceBox.get('user_name', defaultValue: 'Unknown');
        final messages = await _supabase
            .from('messages')
            .select('count')
            .eq('user_name', userName);
        messageCount = messages.length;
      } catch (e) {
        debugPrint('Error getting message count: $e');
      }

      return {
        'attendance_rate': attendanceRate.toStringAsFixed(1),
        'total_classes': totalClasses,
        'study_sessions': calculatorUsage,
        'messages_sent': messageCount,
        'current_streak': _calculateStreak(),
      };
    } catch (e) {
      return {
        'attendance_rate': '0.0',
        'total_classes': 0,
        'study_sessions': 0,
        'messages_sent': 0,
        'current_streak': 0,
      };
    }
  }

  /// Get today's schedule data
  Future<Map<String, dynamic>> _getScheduleData() async {
    try {
      final sessionsBox = Hive.box('class_sessions');
      final today = DateTime.now();
      final todayWeekday = today.weekday;

      final todayClasses = sessionsBox.values
          .where((session) => session.dayOfWeek == todayWeekday)
          .map((session) => {
                'subject': session.subject,
                'time': '${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')}',
                'location': session.location,
                'instructor': session.instructor,
              })
          .toList();

      return {
        'classes': todayClasses,
        'total_classes_today': todayClasses.length,
        'next_class': todayClasses.isNotEmpty ? todayClasses.first : null,
      };
    } catch (e) {
      return {
        'classes': [],
        'total_classes_today': 0,
        'next_class': null,
      };
    }
  }

  /// Get progress chart data
  Future<Map<String, dynamic>> _getProgressData() async {
    try {
      // Generate sample progress data
      final now = DateTime.now();
      final progressData = List.generate(7, (index) {
        final date = now.subtract(Duration(days: 6 - index));
        return {
          'date': date.day.toString(),
          'study_time': (index + 1) * 30 + (index * 10), // Sample data
          'attendance': index % 2 == 0 ? 1 : 0,
        };
      });

      return {
        'weekly_progress': progressData,
        'total_study_time': progressData.fold(0, (sum, day) => sum + (day['study_time'] as int)),
        'average_daily': progressData.fold(0, (sum, day) => sum + (day['study_time'] as int)) / 7,
      };
    } catch (e) {
      return {
        'weekly_progress': [],
        'total_study_time': 0,
        'average_daily': 0,
      };
    }
  }

  /// Get quick actions data
  Map<String, dynamic> _getQuickActionsData() {
    return {
      'actions': [
        {'name': 'Calculator', 'icon': 'calculate', 'route': '/calculator'},
        {'name': 'Timer', 'icon': 'timer', 'route': '/focus'},
        {'name': 'Notes', 'icon': 'note', 'route': '/notes'},
        {'name': 'Chat', 'icon': 'chat', 'route': '/chat'},
      ],
    };
  }

  /// Get weather data (mock implementation)
  Future<Map<String, dynamic>> _getWeatherData() async {
    // TODO: Integrate with actual weather API
    return {
      'temperature': '22°C',
      'condition': 'Sunny',
      'humidity': '65%',
      'wind_speed': '10 km/h',
      'icon': 'sunny',
    };
  }

  /// Get motivational data
  Map<String, dynamic> _getMotivationalData() {
    final quotes = [
      'The expert in anything was once a beginner.',
      'Success is the sum of small efforts repeated daily.',
      'Education is the most powerful weapon to change the world.',
      'The beautiful thing about learning is nobody can take it away from you.',
      'Intelligence plus character - that is the goal of true education.',
    ];

    final tips = [
      'Take a 5-minute break every 25 minutes of study.',
      'Review your notes within 24 hours for better retention.',
      'Teach someone else to solidify your understanding.',
      'Use active recall instead of passive reading.',
      'Set specific, measurable study goals.',
    ];

    final now = DateTime.now();
    return {
      'quote': quotes[now.day % quotes.length],
      'tip': tips[now.hour % tips.length],
      'streak_days': _calculateStreak(),
    };
  }

  /// Get recent activity data
  Future<Map<String, dynamic>> _getRecentActivityData() async {
    try {
      final activities = <Map<String, dynamic>>[];
      
      // Get recent calculator usage
      final calculatorBox = Hive.box('calculator_history');
      if (calculatorBox.isNotEmpty) {
        activities.add({
          'type': 'calculator',
          'description': 'Used calculator',
          'time': '2 hours ago',
          'icon': 'calculate',
        });
      }

      // Add more activities based on app usage
      activities.addAll([
        {
          'type': 'chat',
          'description': 'Sent message in chat',
          'time': '3 hours ago',
          'icon': 'chat',
        },
        {
          'type': 'study',
          'description': 'Completed focus session',
          'time': '5 hours ago',
          'icon': 'timer',
        },
      ]);

      return {
        'activities': activities.take(5).toList(),
        'total_activities': activities.length,
      };
    } catch (e) {
      return {
        'activities': [],
        'total_activities': 0,
      };
    }
  }

  /// Get upcoming deadlines data
  Future<Map<String, dynamic>> _getDeadlinesData() async {
    // TODO: Integrate with actual assignment/deadline system
    final now = DateTime.now();
    final deadlines = [
      {
        'title': 'Math Assignment',
        'subject': 'Mathematics',
        'due_date': now.add(const Duration(days: 2)),
        'priority': 'high',
      },
      {
        'title': 'Physics Lab Report',
        'subject': 'Physics',
        'due_date': now.add(const Duration(days: 5)),
        'priority': 'medium',
      },
      {
        'title': 'English Essay',
        'subject': 'English',
        'due_date': now.add(const Duration(days: 7)),
        'priority': 'low',
      },
    ];

    return {
      'deadlines': deadlines,
      'urgent_count': deadlines.where((d) => d['priority'] == 'high').length,
      'total_count': deadlines.length,
    };
  }

  /// Calculate current study streak
  int _calculateStreak() {
    // TODO: Implement actual streak calculation based on daily usage
    final box = Hive.box('user_prefs');
    return box.get('current_streak', defaultValue: 1);
  }

  /// Reset dashboard to default layout
  Future<void> resetToDefault() async {
    try {
      await _initializeService();
      await _dashboardBox.delete('user_widgets');
    } catch (e) {
      debugPrint('Error resetting dashboard: $e');
    }
  }

  /// Export dashboard configuration
  Future<Map<String, dynamic>> exportDashboardConfig() async {
    try {
      final widgets = await getUserWidgets();
      return {
        'version': '1.0.0',
        'exported_at': DateTime.now().toIso8601String(),
        'widgets': widgets.map((w) => w.toJson()).toList(),
      };
    } catch (e) {
      debugPrint('Error exporting dashboard config: $e');
      return {};
    }
  }

  /// Import dashboard configuration
  Future<bool> importDashboardConfig(Map<String, dynamic> config) async {
    try {
      final widgetsList = config['widgets'] as List<dynamic>;
      final widgets = widgetsList
          .map((json) => DashboardWidget.fromJson(Map<String, dynamic>.from(json)))
          .toList();
      
      await saveUserWidgets(widgets);
      return true;
    } catch (e) {
      debugPrint('Error importing dashboard config: $e');
      return false;
    }
  }
}