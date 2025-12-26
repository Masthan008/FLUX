import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/social_learning_service.dart';
import 'simple_study_groups_screen.dart';
import 'simple_peer_tutoring_screen.dart';
import 'simple_knowledge_marketplace_screen.dart';
import 'simple_qa_platform_screen.dart';
import 'community_leaderboard_screen.dart';

class SocialLearningScreen extends StatefulWidget {
  const SocialLearningScreen({super.key});

  @override
  State<SocialLearningScreen> createState() => _SocialLearningScreenState();
}

class _SocialLearningScreenState extends State<SocialLearningScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SocialLearningService _socialService = SocialLearningService();
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
      final data = await _socialService.getDashboardData();
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
              'Social Learning',
              style: GoogleFonts.orbitron(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.leaderboard, color: Colors.amber),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityLeaderboardScreen(),
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
              indicatorColor: Colors.purple,
              labelColor: Colors.purple,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              tabs: const [
                Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
                Tab(icon: Icon(Icons.group), text: 'Groups'),
                Tab(icon: Icon(Icons.school), text: 'Tutoring'),
                Tab(icon: Icon(Icons.store), text: 'Marketplace'),
                Tab(icon: Icon(Icons.help), text: 'Q&A'),
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
                  Colors.purple.shade900.withOpacity(0.3),
                  Colors.black,
                ],
              ),
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                const SimpleStudyGroupsScreen(),
                const SimplePeerTutoringScreen(),
                const SimpleKnowledgeMarketplaceScreen(),
                const SimpleQAPlatformScreen(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showCreateOptions,
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add),
            label: const Text('Create'),
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
        child: CircularProgressIndicator(color: Colors.purple),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      color: Colors.purple,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            
            // Community Stats
            _buildCommunityStats(),
            const SizedBox(height: 24),
            
            // Active Groups
            _buildActiveGroups(),
            const SizedBox(height: 24),
            
            // Recent Activity
            _buildRecentActivity(),
            const SizedBox(height: 24),
            
            // Featured Content
            _buildFeaturedContent(),
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final userReputation = _dashboardData['user_reputation'] ?? 0;
    final studyGroups = _dashboardData['joined_groups'] ?? 0;
    final helpedStudents = _dashboardData['helped_students'] ?? 0;
    
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
              const Icon(Icons.people, color: Colors.purple, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learning Together',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Connect, collaborate, and grow with peers',
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
              _buildStatChip('${userReputation}', 'Reputation', Colors.amber),
              const SizedBox(width: 12),
              _buildStatChip('${studyGroups}', 'Groups', Colors.blue),
              const SizedBox(width: 12),
              _buildStatChip('${helpedStudents}', 'Helped', Colors.green),
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

  Widget _buildCommunityStats() {
    final totalUsers = _dashboardData['total_users'] ?? 0;
    final activeGroups = _dashboardData['active_groups'] ?? 0;
    final questionsAnswered = _dashboardData['questions_answered'] ?? 0;
    final resourcesShared = _dashboardData['resources_shared'] ?? 0;

    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Community Overview',
              style: GoogleFonts.orbitron(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCommunityStatItem(
                    'Active Users',
                    '${totalUsers}',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildCommunityStatItem(
                    'Study Groups',
                    '${activeGroups}',
                    Icons.group,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildCommunityStatItem(
                    'Q&A Answered',
                    '${questionsAnswered}',
                    Icons.help,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildCommunityStatItem(
                    'Resources',
                    '${resourcesShared}',
                    Icons.share,
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

  Widget _buildCommunityStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
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
      ),
    );
  }

  Widget _buildActiveGroups() {
    final activeGroups = _dashboardData['user_active_groups'] as List<dynamic>? ?? [];
    
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
                  'Your Study Groups',
                  style: GoogleFonts.orbitron(
                    color: Colors.purple,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('View All', style: TextStyle(color: Colors.purple)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (activeGroups.isEmpty)
              Text(
                'Join study groups to collaborate with peers!',
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              )
            else
              ...activeGroups.take(3).map((group) => _buildGroupItem(group)),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: 400.ms, duration: 600.ms)
    .slideX(begin: 0.3, end: 0);
  }

  Widget _buildGroupItem(dynamic group) {
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
              color: Colors.purple.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.group, color: Colors.purple, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group['name'] ?? 'Study Group',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${group['members'] ?? 0} members • ${group['subject'] ?? 'General'}',
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
              'Active',
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

  Widget _buildRecentActivity() {
    final recentActivity = _dashboardData['recent_activity'] as List<dynamic>? ?? [];
    
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Community Activity',
              style: GoogleFonts.orbitron(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (recentActivity.isEmpty)
              Text(
                'No recent activity. Start participating!',
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              )
            else
              ...recentActivity.take(4).map((activity) => _buildActivityItem(activity)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(dynamic activity) {
    final IconData icon;
    final Color color;
    
    switch (activity['type']) {
      case 'question':
        icon = Icons.help;
        color = Colors.orange;
        break;
      case 'answer':
        icon = Icons.lightbulb;
        color = Colors.yellow;
        break;
      case 'group_join':
        icon = Icons.group_add;
        color = Colors.blue;
        break;
      case 'resource_share':
        icon = Icons.share;
        color = Colors.green;
        break;
      default:
        icon = Icons.local_activity;
        color = Colors.purple;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              activity['description'] ?? 'Community activity',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            activity['time'] ?? 'now',
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured This Week',
              style: GoogleFonts.orbitron(
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeaturedItem(
              'Top Contributor',
              'Sarah M. - Helped 15 students this week',
              Icons.star,
              Colors.amber,
            ),
            _buildFeaturedItem(
              'Popular Question',
              'How to solve calculus derivatives?',
              Icons.trending_up,
              Colors.orange,
            ),
            _buildFeaturedItem(
              'New Study Group',
              'Advanced Physics - Join now!',
              Icons.new_releases,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedItem(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
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
                color: Colors.purple,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Ask Question',
                    Icons.help,
                    Colors.orange,
                    () => _tabController.animateTo(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Find Tutor',
                    Icons.school,
                    Colors.blue,
                    () => _tabController.animateTo(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'Join Group',
                    Icons.group,
                    Colors.green,
                    () => _tabController.animateTo(1),
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

  void _showCreateOptions() {
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
              'Create New',
              style: GoogleFonts.orbitron(
                color: Colors.purple,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.blue),
              title: const Text('Study Group', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Start a new study group', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _createStudyGroup();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.orange),
              title: const Text('Ask Question', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Get help from the community', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _askQuestion();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: Colors.green),
              title: const Text('Share Resource', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Share knowledge with others', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _shareResource();
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.purple),
              title: const Text('Offer Tutoring', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Help other students learn', style: TextStyle(color: Colors.grey)),
              onTap: () {
                Navigator.pop(context);
                _offerTutoring();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _createStudyGroup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Study group creation coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _askQuestion() {
    _tabController.animateTo(4); // Switch to Q&A tab
  }

  void _shareResource() {
    _tabController.animateTo(3); // Switch to marketplace tab
  }

  void _offerTutoring() {
    _tabController.animateTo(2); // Switch to tutoring tab
  }
}