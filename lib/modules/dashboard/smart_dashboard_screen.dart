import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/dashboard_service.dart';
import '../../widgets/dashboard_widgets/quick_stats_widget.dart';
import '../../widgets/dashboard_widgets/schedule_widget.dart';
import '../../widgets/dashboard_widgets/progress_chart_widget.dart';
import '../../widgets/dashboard_widgets/quick_actions_widget.dart';
import '../../widgets/dashboard_widgets/weather_widget.dart';
import '../../widgets/dashboard_widgets/motivational_widget.dart';
import '../../widgets/dashboard_widgets/recent_activity_widget.dart';
import '../../widgets/dashboard_widgets/deadlines_widget.dart';

class SmartDashboardScreen extends StatefulWidget {
  const SmartDashboardScreen({super.key});

  @override
  State<SmartDashboardScreen> createState() => _SmartDashboardScreenState();
}

class _SmartDashboardScreenState extends State<SmartDashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  List<DashboardWidget> _widgets = [];
  bool _isEditMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => _isLoading = true);
    try {
      final widgets = await _dashboardService.getUserWidgets();
      setState(() {
        _widgets = widgets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dashboard: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.grey.shade900,
            title: Text(
              'Smart Dashboard',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isEditMode ? Icons.done : Icons.edit,
                  color: Colors.cyanAccent,
                ),
                onPressed: () {
                  setState(() => _isEditMode = !_isEditMode);
                  if (!_isEditMode) {
                    _saveDashboardLayout();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: _showAddWidgetDialog,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.orange),
                onPressed: _refreshDashboard,
              ),
            ],
          ),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.cyanAccent),
                )
              : _buildDashboard(),
        );
      },
    );
  }

  Widget _buildDashboard() {
    if (_widgets.isEmpty) {
      return _buildEmptyDashboard();
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.grey.shade900,
            Colors.black,
          ],
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _refreshDashboard,
        color: Colors.cyanAccent,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(),
              const SizedBox(height: 24),
              
              // Widgets Grid
              _buildWidgetsGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final box = Hive.box('user_prefs');
    final userName = box.get('user_name', defaultValue: 'Student');
    final now = DateTime.now();
    final hour = now.hour;
    
    String greeting;
    if (hour < 12) {
      greeting = 'Good Morning';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
    } else {
      greeting = 'Good Evening';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.3),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $userName!',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to achieve your goals today?',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade300,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _getMotivationalMessage(),
                  style: GoogleFonts.montserrat(
                    color: Colors.cyanAccent,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.dashboard,
            color: Colors.cyanAccent,
            size: 48,
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(duration: 600.ms)
    .slideY(begin: -0.2, end: 0);
  }

  Widget _buildWidgetsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _widgets.length,
      itemBuilder: (context, index) {
        final widget = _widgets[index];
        return _buildDashboardWidget(widget, index);
      },
    );
  }

  Widget _buildDashboardWidget(DashboardWidget widget, int index) {
    Widget child;
    
    switch (widget.type) {
      case DashboardWidgetType.quickStats:
        child = QuickStatsWidget();
        break;
      case DashboardWidgetType.schedule:
        child = ScheduleWidget();
        break;
      case DashboardWidgetType.progressChart:
        child = ProgressChartWidget();
        break;
      case DashboardWidgetType.quickActions:
        child = QuickActionsWidget();
        break;
      case DashboardWidgetType.weather:
        child = WeatherWidget();
        break;
      case DashboardWidgetType.motivational:
        child = MotivationalWidget();
        break;
      case DashboardWidgetType.recentActivity:
        child = RecentActivityWidget();
        break;
      case DashboardWidgetType.deadlines:
        child = DeadlinesWidget();
        break;
      default:
        child = _buildPlaceholderWidget(widget.type.toString());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isEditMode ? Colors.cyanAccent : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: child,
          ),
          if (_isEditMode) ...[
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _removeWidget(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _configureWidget(widget),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    )
    .animate()
    .fadeIn(delay: (index * 100).ms, duration: 600.ms)
    .slideY(begin: 0.3, end: 0);
  }

  Widget _buildPlaceholderWidget(String type) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.widgets,
            color: Colors.grey.shade600,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            type,
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDashboard() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dashboard_outlined,
            size: 80,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            'Your Dashboard is Empty',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add widgets to personalize your experience',
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showAddWidgetDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Your First Widget'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddWidgetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Add Widget',
          style: GoogleFonts.orbitron(color: Colors.cyanAccent),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: DashboardWidgetType.values.map((type) {
              return ListTile(
                leading: Icon(_getWidgetIcon(type), color: Colors.cyanAccent),
                title: Text(
                  _getWidgetName(type),
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  _getWidgetDescription(type),
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _addWidget(type);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _addWidget(DashboardWidgetType type) {
    final newWidget = DashboardWidget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      position: _widgets.length,
      config: {},
    );
    
    setState(() {
      _widgets.add(newWidget);
    });
    
    _saveDashboardLayout();
  }

  void _removeWidget(int index) {
    setState(() {
      _widgets.removeAt(index);
    });
    _saveDashboardLayout();
  }

  void _configureWidget(DashboardWidget widget) {
    // TODO: Implement widget configuration dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Widget configuration coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _saveDashboardLayout() async {
    try {
      await _dashboardService.saveUserWidgets(_widgets);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving layout: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshDashboard() async {
    await _loadDashboard();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dashboard refreshed!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getMotivationalMessage() {
    final messages = [
      'Every expert was once a beginner.',
      'Success is the sum of small efforts repeated daily.',
      'The future belongs to those who learn more skills.',
      'Knowledge is power, but applied knowledge is freedom.',
      'Your only limit is your mind.',
    ];
    return messages[DateTime.now().day % messages.length];
  }

  IconData _getWidgetIcon(DashboardWidgetType type) {
    switch (type) {
      case DashboardWidgetType.quickStats:
        return Icons.analytics;
      case DashboardWidgetType.schedule:
        return Icons.schedule;
      case DashboardWidgetType.progressChart:
        return Icons.trending_up;
      case DashboardWidgetType.quickActions:
        return Icons.flash_on;
      case DashboardWidgetType.weather:
        return Icons.wb_sunny;
      case DashboardWidgetType.motivational:
        return Icons.psychology;
      case DashboardWidgetType.recentActivity:
        return Icons.history;
      case DashboardWidgetType.deadlines:
        return Icons.event_note;
    }
  }

  String _getWidgetName(DashboardWidgetType type) {
    switch (type) {
      case DashboardWidgetType.quickStats:
        return 'Quick Stats';
      case DashboardWidgetType.schedule:
        return 'Today\'s Schedule';
      case DashboardWidgetType.progressChart:
        return 'Progress Chart';
      case DashboardWidgetType.quickActions:
        return 'Quick Actions';
      case DashboardWidgetType.weather:
        return 'Weather';
      case DashboardWidgetType.motivational:
        return 'Daily Motivation';
      case DashboardWidgetType.recentActivity:
        return 'Recent Activity';
      case DashboardWidgetType.deadlines:
        return 'Upcoming Deadlines';
    }
  }

  String _getWidgetDescription(DashboardWidgetType type) {
    switch (type) {
      case DashboardWidgetType.quickStats:
        return 'View attendance, grades, and study time';
      case DashboardWidgetType.schedule:
        return 'See today\'s classes and tasks';
      case DashboardWidgetType.progressChart:
        return 'Visual progress tracking';
      case DashboardWidgetType.quickActions:
        return 'Quick access to tools';
      case DashboardWidgetType.weather:
        return 'Local weather information';
      case DashboardWidgetType.motivational:
        return 'Daily quotes and inspiration';
      case DashboardWidgetType.recentActivity:
        return 'Latest app usage';
      case DashboardWidgetType.deadlines:
        return 'Assignment reminders';
    }
  }
}