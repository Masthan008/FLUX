import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/career_guidance_service.dart';
import 'career_assessment_screen.dart';
import 'industry_insights_screen.dart';
import 'skill_tracker_screen.dart';
import 'interview_prep_screen.dart';

class CareerGuidanceScreen extends StatefulWidget {
  const CareerGuidanceScreen({super.key});

  @override
  State<CareerGuidanceScreen> createState() => _CareerGuidanceScreenState();
}

class _CareerGuidanceScreenState extends State<CareerGuidanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CareerGuidanceService _careerService = CareerGuidanceService();
  Map<String, dynamic> _dashboardData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
      final data = await _careerService.getDashboardData();
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
              'Career Guidance',
              style: GoogleFonts.orbitron(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.assessment, color: Colors.teal),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CareerAssessmentScreen(),
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
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
                Tab(icon: Icon(Icons.assessment), text: 'Assessment'),
                Tab(icon: Icon(Icons.trending_up), text: 'Industry'),
                Tab(icon: Icon(Icons.psychology), text: 'Skills'),
                Tab(icon: Icon(Icons.work), text: 'Interview'),
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
                  Colors.teal.shade900.withOpacity(0.3),
                  Colors.black,
                ],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                const CareerAssessmentScreen(),
                const IndustryInsightsScreen(),
                const SkillTrackerScreen(),
                const InterviewPrepScreen(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showCareerActions,
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Start Journey'),
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
        child: CircularProgressIndicator(color: Colors.teal),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: Colors.teal,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Career Progress
            _buildCareerProgress(),
            const SizedBox(height: 24),
            
            // Recommended Paths
            _buildRecommendedPaths(),
            const SizedBox(height: 24),
            
            // Skill Assessment
            _buildSkillAssessment(),
            const SizedBox(height: 24),
            
            // Industry Trends
            _buildIndustryTrends(),
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final careerLevel = _dashboardData['career_level'] ?? 'Beginner';
    final completedAssessments = _dashboardData['completed_assessments'] ?? 0;
    final skillsTracked = _dashboardData['skills_tracked'] ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.teal.withOpacity(0.3),
            Colors.blue.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.teal.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.rocket_launch, color: Colors.teal, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Career Journey',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Discover your potential and plan your future',
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
              _buildStatChip(careerLevel, 'Level', Colors.teal),
              const SizedBox(width: 12),
              _buildStatChip('$completedAssessments', 'Assessments', Colors.blue),
              const SizedBox(width: 12),
              _buildStatChip('$skillsTracked', 'Skills', Colors.green),
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

  Widget _buildCareerProgress() {
    final progressData = _dashboardData['career_progress'] as Map<String, dynamic>? ?? {};
    final overallProgress = progressData['overall'] ?? 0.0;
    
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Career Development Progress',
              style: GoogleFonts.orbitron(
                color: Colors.teal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Overall Progress
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Progress',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: overallProgress,
                        backgroundColor: Colors.grey.shade700,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${(overallProgress * 100).toInt()}%',
                  style: GoogleFonts.orbitron(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Progress Categories
            ..._getProgressCategories().map((category) => _buildProgressCategory(category)),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: 200.ms, duration: 600.ms)
    .slideX(begin: -0.3, end: 0);
  }

  Widget _buildProgressCategory(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(category['icon'], color: category['color'], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category['name'],
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: category['progress'],
                  backgroundColor: Colors.grey.shade700,
                  valueColor: AlwaysStoppedAnimation<Color>(category['color']),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${(category['progress'] * 100).toInt()}%',
            style: GoogleFonts.montserrat(
              color: category['color'],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedPaths() {
    final recommendedPaths = _dashboardData['recommended_paths'] as List<dynamic>? ?? [];
    
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended Career Paths',
                  style: GoogleFonts.orbitron(
                    color: Colors.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(2),
                  child: const Text('View All', style: TextStyle(color: Colors.teal)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recommendedPaths.isEmpty)
              Text(
                'Complete assessments to get personalized recommendations!',
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              )
            else
              ...recommendedPaths.take(3).map((path) => _buildCareerPathItem(path)),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: 400.ms, duration: 600.ms)
    .slideX(begin: 0.3, end: 0);
  }

  Widget _buildCareerPathItem(dynamic path) {
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
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.work, color: Colors.teal, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  path['title'] ?? 'Career Path',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${path['match']}% match • ${path['growth']} growth',
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
              '${path['match']}%',
              style: GoogleFonts.montserrat(
                color: Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillAssessment() {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skill Assessment Status',
              style: GoogleFonts.orbitron(
                color: Colors.teal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ..._getSkillCategories().map((skill) => _buildSkillItem(skill)),
            
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _tabController.animateTo(1),
                icon: const Icon(Icons.assessment),
                label: const Text('Take Assessment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(Map<String, dynamic> skill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(skill['icon'], color: skill['color'], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              skill['name'],
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: skill['assessed'] ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              skill['assessed'] ? 'Assessed' : 'Pending',
              style: GoogleFonts.montserrat(
                color: skill['assessed'] ? Colors.green : Colors.orange,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndustryTrends() {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Industry Trends',
                  style: GoogleFonts.orbitron(
                    color: Colors.teal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(2),
                  child: const Text('View More', style: TextStyle(color: Colors.teal)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            ..._getTrendingIndustries().map((trend) => _buildTrendItem(trend)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendItem(Map<String, dynamic> trend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: trend['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: trend['color'].withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(trend['icon'], color: trend['color'], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trend['title'],
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  trend['description'],
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
              color: trend['color'].withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              trend['growth'],
              style: GoogleFonts.montserrat(
                color: trend['color'],
                fontSize: 10,
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
                color: Colors.teal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Assessment',
                    Icons.assessment,
                    Colors.blue,
                    () => _tabController.animateTo(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Skills',
                    Icons.psychology,
                    Colors.purple,
                    () => _tabController.animateTo(3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Interview',
                    Icons.work,
                    Colors.orange,
                    () => _tabController.animateTo(4),
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

  List<Map<String, dynamic>> _getProgressCategories() {
    return [
      {'name': 'Self Assessment', 'progress': 0.6, 'icon': Icons.psychology, 'color': Colors.blue},
      {'name': 'Skill Development', 'progress': 0.4, 'icon': Icons.trending_up, 'color': Colors.green},
      {'name': 'Industry Knowledge', 'progress': 0.3, 'icon': Icons.business, 'color': Colors.orange},
      {'name': 'Interview Prep', 'progress': 0.2, 'icon': Icons.work, 'color': Colors.purple},
    ];
  }

  List<Map<String, dynamic>> _getSkillCategories() {
    return [
      {'name': 'Technical Skills', 'assessed': true, 'icon': Icons.code, 'color': Colors.blue},
      {'name': 'Communication', 'assessed': false, 'icon': Icons.chat, 'color': Colors.green},
      {'name': 'Leadership', 'assessed': false, 'icon': Icons.group, 'color': Colors.orange},
      {'name': 'Problem Solving', 'assessed': true, 'icon': Icons.psychology, 'color': Colors.purple},
    ];
  }

  List<Map<String, dynamic>> _getTrendingIndustries() {
    return [
      {
        'title': 'Artificial Intelligence',
        'description': 'AI/ML roles growing rapidly',
        'growth': '+25%',
        'icon': Icons.smart_toy,
        'color': Colors.blue,
      },
      {
        'title': 'Cybersecurity',
        'description': 'High demand for security experts',
        'growth': '+18%',
        'icon': Icons.security,
        'color': Colors.red,
      },
      {
        'title': 'Cloud Computing',
        'description': 'Cloud infrastructure specialists needed',
        'growth': '+22%',
        'icon': Icons.cloud,
        'color': Colors.teal,
      },
    ];
  }

  void _showCareerActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Start Your Career Journey',
              style: GoogleFonts.orbitron(
                color: Colors.teal,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.assessment, color: Colors.blue),
              title: const Text('Take Career Assessment', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Discover your strengths and interests', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.green),
              title: const Text('Explore Industries', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Learn about growing career fields', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.psychology, color: Colors.purple),
              title: const Text('Track Skills', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Monitor your skill development', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.work, color: Colors.orange),
              title: const Text('Interview Preparation', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Practice and improve interview skills', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _tabController.animateTo(4);
              },
            ),
          ],
        ),
      ),
    );
  }
}