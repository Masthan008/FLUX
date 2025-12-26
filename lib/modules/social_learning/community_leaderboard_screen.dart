import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CommunityLeaderboardScreen extends StatefulWidget {
  const CommunityLeaderboardScreen({super.key});

  @override
  State<CommunityLeaderboardScreen> createState() => _CommunityLeaderboardScreenState();
}

class _CommunityLeaderboardScreenState extends State<CommunityLeaderboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'All Time';
  String _selectedCategory = 'Overall';

  final List<String> _periods = ['All Time', 'This Month', 'This Week', 'Today'];
  final List<String> _categories = ['Overall', 'Questions', 'Answers', 'Resources', 'Tutoring'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Community Leaderboard',
          style: GoogleFonts.orbitron(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(Icons.leaderboard), text: 'Rankings'),
            Tab(icon: Icon(Icons.trending_up), text: 'Achievements'),
            Tab(icon: Icon(Icons.person), text: 'My Stats'),
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
              Colors.amber.shade900.withOpacity(0.3),
              Colors.black,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildRankingsTab(),
            _buildAchievementsTab(),
            _buildMyStatsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingsTab() {
    return Column(
      children: [
        // Filters
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade900.withOpacity(0.5),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPeriod,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Period',
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _periods.map((period) => DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedPeriod = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: _categories.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                ),
              ),
            ],
          ),
        ),
        
        // Top 3 Podium
        Container(
          padding: const EdgeInsets.all(20),
          child: _buildPodium(),
        ),
        
        // Rankings List
        Expanded(
          child: _buildRankingsList(),
        ),
      ],
    );
  }

  Widget _buildPodium() {
    final topUsers = _getTopUsers();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 2nd Place
        if (topUsers.length > 1) _buildPodiumPlace(topUsers[1], 2, 120),
        // 1st Place
        if (topUsers.isNotEmpty) _buildPodiumPlace(topUsers[0], 1, 140),
        // 3rd Place
        if (topUsers.length > 2) _buildPodiumPlace(topUsers[2], 3, 100),
      ],
    );
  }

  Widget _buildPodiumPlace(Map<String, dynamic> user, int place, double height) {
    final Color color = place == 1 ? Colors.amber : place == 2 ? Colors.grey.shade400 : Colors.orange.shade700;
    final IconData crown = place == 1 ? Icons.emoji_events : place == 2 ? Icons.military_tech : Icons.workspace_premium;
    
    return Column(
      children: [
        // Crown/Medal
        Icon(crown, color: color, size: 32),
        const SizedBox(height: 8),
        
        // Avatar
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Text(
            user['name'].substring(0, 1).toUpperCase(),
            style: GoogleFonts.orbitron(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        
        // Name
        Text(
          user['name'],
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        // Score
        Text(
          '${user['score']} pts',
          style: GoogleFonts.montserrat(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Podium
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.8),
                color.withOpacity(0.4),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color),
          ),
          child: Center(
            child: Text(
              '$place',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    )
    .animate()
    .fadeIn(delay: (place * 200).ms, duration: 600.ms)
    .slideY(begin: 0.5, end: 0);
  }

  Widget _buildRankingsList() {
    final users = _getAllUsers();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final rank = index + 1;
        return _buildRankingItem(user, rank, index);
      },
    );
  }

  Widget _buildRankingItem(Map<String, dynamic> user, int rank, int index) {
    final bool isTopThree = rank <= 3;
    final Color rankColor = isTopThree ? 
        (rank == 1 ? Colors.amber : rank == 2 ? Colors.grey.shade400 : Colors.orange.shade700) : 
        Colors.grey;

    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: rankColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: rankColor),
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: GoogleFonts.orbitron(
                    color: rankColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.purple.withOpacity(0.2),
              child: Text(
                user['name'].substring(0, 1).toUpperCase(),
                style: GoogleFonts.orbitron(
                  color: Colors.purple,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['name'],
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${user['reputation']} reputation • ${user['level']}',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${user['score']}',
                  style: GoogleFonts.orbitron(
                    color: Colors.amber,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'points',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: (index * 50).ms, duration: 400.ms)
    .slideX(begin: 0.3, end: 0);
  }

  Widget _buildAchievementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Community Achievements',
            style: GoogleFonts.orbitron(
              color: Colors.amber,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Achievement Categories
          ..._getAchievementCategories().map((category) => _buildAchievementCategory(category)),
        ],
      ),
    );
  }

  Widget _buildAchievementCategory(Map<String, dynamic> category) {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(category['icon'], color: category['color'], size: 24),
                const SizedBox(width: 12),
                Text(
                  category['title'],
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Achievements Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: (category['achievements'] as List).length,
              itemBuilder: (context, index) {
                final achievement = category['achievements'][index];
                return _buildAchievementBadge(achievement);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementBadge(Map<String, dynamic> achievement) {
    final bool isUnlocked = achievement['unlocked'] ?? false;
    
    return Container(
      decoration: BoxDecoration(
        color: isUnlocked ? achievement['color'].withOpacity(0.2) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked ? achievement['color'] : Colors.grey,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            achievement['icon'],
            color: isUnlocked ? achievement['color'] : Colors.grey,
            size: 32,
          ),
          const SizedBox(height: 4),
          Text(
            achievement['name'],
            style: GoogleFonts.montserrat(
              color: isUnlocked ? Colors.white : Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMyStatsTab() {
    final myStats = _getMyStats();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Card
          Card(
            color: Colors.grey.shade900.withOpacity(0.8),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.purple.withOpacity(0.2),
                    child: Text(
                      'S',
                      style: GoogleFonts.orbitron(
                        color: Colors.purple,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Student',
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rank #${myStats['rank']} • ${myStats['level']}',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Points', '${myStats['points']}', Colors.amber),
                      _buildStatItem('Reputation', '${myStats['reputation']}', Colors.blue),
                      _buildStatItem('Streak', '${myStats['streak']}d', Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Activity Stats
          Text(
            'Activity Statistics',
            style: GoogleFonts.orbitron(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._getActivityStats().map((stat) => _buildActivityStatCard(stat)),
          
          const SizedBox(height: 20),
          
          // Recent Achievements
          Text(
            'Recent Achievements',
            style: GoogleFonts.orbitron(
              color: Colors.amber,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          ..._getRecentAchievements().map((achievement) => _buildRecentAchievementCard(achievement)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityStatCard(Map<String, dynamic> stat) {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(stat['icon'], color: stat['color'], size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                stat['label'],
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              '${stat['value']}',
              style: GoogleFonts.orbitron(
                color: stat['color'],
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAchievementCard(Map<String, dynamic> achievement) {
    return Card(
      color: Colors.grey.shade900.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: achievement['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(achievement['icon'], color: achievement['color'], size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement['name'],
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    achievement['description'],
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              achievement['date'],
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getTopUsers() {
    return [
      {'name': 'Sarah Johnson', 'score': 2450, 'reputation': 850, 'level': 'Expert'},
      {'name': 'Mike Chen', 'score': 2180, 'reputation': 720, 'level': 'Advanced'},
      {'name': 'Emma Davis', 'score': 1950, 'reputation': 650, 'level': 'Intermediate'},
    ];
  }

  List<Map<String, dynamic>> _getAllUsers() {
    return [
      {'name': 'Sarah Johnson', 'score': 2450, 'reputation': 850, 'level': 'Expert'},
      {'name': 'Mike Chen', 'score': 2180, 'reputation': 720, 'level': 'Advanced'},
      {'name': 'Emma Davis', 'score': 1950, 'reputation': 650, 'level': 'Intermediate'},
      {'name': 'Alex Wilson', 'score': 1720, 'reputation': 580, 'level': 'Intermediate'},
      {'name': 'Lisa Brown', 'score': 1540, 'reputation': 520, 'level': 'Beginner'},
      {'name': 'John Smith', 'score': 1320, 'reputation': 450, 'level': 'Beginner'},
      {'name': 'Maria Garcia', 'score': 1180, 'reputation': 390, 'level': 'Beginner'},
      {'name': 'David Lee', 'score': 980, 'reputation': 320, 'level': 'Novice'},
    ];
  }

  List<Map<String, dynamic>> _getAchievementCategories() {
    return [
      {
        'title': 'Learning Milestones',
        'icon': Icons.school,
        'color': Colors.blue,
        'achievements': [
          {'name': 'First Steps', 'icon': Icons.baby_changing_station, 'color': Colors.green, 'unlocked': true},
          {'name': 'Quick Learner', 'icon': Icons.flash_on, 'color': Colors.yellow, 'unlocked': true},
          {'name': 'Dedicated', 'icon': Icons.favorite, 'color': Colors.red, 'unlocked': false},
          {'name': 'Expert', 'icon': Icons.star, 'color': Colors.purple, 'unlocked': false},
        ],
      },
      {
        'title': 'Community Participation',
        'icon': Icons.people,
        'color': Colors.orange,
        'achievements': [
          {'name': 'Helper', 'icon': Icons.help, 'color': Colors.blue, 'unlocked': true},
          {'name': 'Mentor', 'icon': Icons.school, 'color': Colors.green, 'unlocked': false},
          {'name': 'Popular', 'icon': Icons.thumb_up, 'color': Colors.pink, 'unlocked': false},
          {'name': 'Influencer', 'icon': Icons.trending_up, 'color': Colors.orange, 'unlocked': false},
        ],
      },
    ];
  }

  Map<String, dynamic> _getMyStats() {
    return {
      'rank': 15,
      'level': 'Beginner',
      'points': 450,
      'reputation': 120,
      'streak': 7,
    };
  }

  List<Map<String, dynamic>> _getActivityStats() {
    return [
      {'label': 'Questions Asked', 'value': 5, 'icon': Icons.help, 'color': Colors.blue},
      {'label': 'Answers Given', 'value': 12, 'icon': Icons.lightbulb, 'color': Colors.yellow},
      {'label': 'Resources Shared', 'value': 3, 'icon': Icons.share, 'color': Colors.green},
      {'label': 'Study Groups Joined', 'value': 2, 'icon': Icons.group, 'color': Colors.purple},
      {'label': 'Tutoring Sessions', 'value': 1, 'icon': Icons.school, 'color': Colors.orange},
    ];
  }

  List<Map<String, dynamic>> _getRecentAchievements() {
    return [
      {
        'name': 'First Steps',
        'description': 'Joined your first study group',
        'icon': Icons.group,
        'color': Colors.green,
        'date': '2 days ago',
      },
      {
        'name': 'Helper',
        'description': 'Answered your first question',
        'icon': Icons.help,
        'color': Colors.blue,
        'date': '1 week ago',
      },
    ];
  }
}