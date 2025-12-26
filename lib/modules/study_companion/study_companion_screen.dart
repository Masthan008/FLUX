import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/study_companion_service.dart';
import 'study_analytics_screen.dart';
import 'study_planner_screen.dart';
import 'habit_tracker_screen.dart';
import 'ai_recommendations_screen.dart';

class StudyCompanionScreen extends StatefulWidget {
  const StudyCompanionScreen({super.key});

  @override
  State<StudyCompanionScreen> createState() => _StudyCompanionScreenState();
}

class _StudyCompanionScreenState extends State<StudyCompanionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StudyCompanionService _studyService = StudyCompanionService();
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _studyService.getDashboardData();
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
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
              'Study Companion',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.psychology, color: Colors.purple),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AIRecommendationsScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.orange),
                onPressed: _loadDashboardData,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.cyanAccent,
              labelColor: Colors.cyanAccent,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
                Tab(icon: Icon(Icons.analytics), text: 'Analytics'),
                Tab(icon: Icon(Icons.calendar_today), text: 'Planner'),
                Tab(icon: Icon(Icons.track_changes), text: 'Habits'),
              ],
            ),
          ),
          body: Container(
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                const StudyAnalyticsScreen(),
                const StudyPlannerScreen(),
                const HabitTrackerScreen(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _startStudySession,
            backgroundColor: Colors.cyanAccent,
            foregroundColor: Colors.black,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Session'),
          )
          .animate()
          .fadeIn(duration: 600.ms)
          .slideY(begin: 1.0, end: 0.0, curve: Curves.elasticOut),
        );
      },
    );
  }

  Widget _buildOverviewTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.cyanAccent),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: Colors.cyanAccent,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 24),
            
            // AI Insights
            _buildAIInsights(),
            const SizedBox(height: 24),
            
            // Recent Sessions
            _buildRecentSessions(),
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final studyStreak = _dashboardData['study_streak'] ?? 0;
    final totalStudyTime = _dashboardData['total_study_time'] ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.3),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology, color: Colors.purple, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Study Journey',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'AI-powered insights for better learning',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey.shade300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip('${studyStreak}d', 'Study Streak', Colors.orange),
              const SizedBox(width: 12),
              _buildStatChip('${(totalStudyTime / 60).toStringAsFixed(1)}h', 'Total Time', Colors.green),
            ],
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(duration: 600.ms)
    .slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatChip(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade400,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final todayStudyTime = _dashboardData['today_study_time'] ?? 0;
    final weeklyGoal = _dashboardData['weekly_goal'] ?? 0;
    final weeklyProgress = _dashboardData['weekly_progress'] ?? 0;
    final focusScore = _dashboardData['focus_score'] ?? 0;

    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Progress',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Study Time',
                    '${todayStudyTime}min',
                    Icons.timer,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildProgressItem(
                    'Weekly Goal',
                    '${(weeklyProgress / weeklyGoal * 100).toStringAsFixed(0)}%',
                    Icons.flag,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildProgressItem(
                    'Focus Score',
                    '${focusScore}/100',
                    Icons.psychology,
                    Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: 200.ms, duration: 600.ms)
    .slideX(begin: -0.3, end: 0);
  }

  Widget _buildProgressItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAIInsights() {
    final insights = _dashboardData['ai_insights'] as List<dynamic>? ?? [];
    
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.yellow, size: 20),
                const SizedBox(width: 8),
                Text(
                  'AI Insights',
                  style: GoogleFonts.orbitron(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (insights.isEmpty)
              Text(
                'Study more to get personalized insights!',
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              )
            else
              ...insights.take(3).map((insight) => _buildInsightItem(insight)),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: 400.ms, duration: 600.ms)
    .slideX(begin: 0.3, end: 0);
  }

  Widget _buildInsightItem(dynamic insight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6),
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight.toString(),
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessions() {
    final recentSessions = _dashboardData['recent_sessions'] as List<dynamic>? ?? [];
    
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Study Sessions',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (recentSessions.isEmpty)
              Text(
                'No recent sessions. Start your first study session!',
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              )
            else
              ...recentSessions.take(3).map((session) => _buildSessionItem(session)),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionItem(dynamic session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.book, color: Colors.blue, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session['subject'] ?? 'Study Session',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${session['duration'] ?? 0} minutes • ${session['date'] ?? 'Today'}',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${session['score'] ?? 0}%',
              style: GoogleFonts.montserrat(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Set Goal',
                    Icons.flag,
                    Colors.green,
                    _setStudyGoal,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Schedule',
                    Icons.schedule,
                    Colors.blue,
                    _openScheduler,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Analytics',
                    Icons.analytics,
                    Colors.purple,
                    _openAnalytics,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
    .animate()
    .scale(duration: 200.ms)
    .fadeIn(duration: 400.ms);
  }

  void _startStudySession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Start Study Session',
          style: GoogleFonts.orbitron(color: Colors.cyanAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Subject',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Duration (minutes)',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyanAccent),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Study session started!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Start', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  void _setStudyGoal() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Goal setting feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _openScheduler() {
    _tabController.animateTo(2); // Switch to planner tab
  }

  void _openAnalytics() {
    _tabController.animateTo(1); // Switch to analytics tab
  }
}