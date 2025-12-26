import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/challenge_service.dart';
import '../services/student_auth_service.dart';
import '../widgets/user_badge.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _leaderboard = [];
  int _currentUserRank = -1;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() => _isLoading = true);
    
    final leaderboard = await ChallengeService.getLeaderboard(limit: 20);
    final rank = await ChallengeService.getStudentRank();
    
    if (mounted) {
      setState(() {
        _leaderboard = leaderboard;
        _currentUserRank = rank;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStudent = StudentAuthService.currentStudent;
    
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.amber, Colors.orange],
          ).createShader(bounds),
          child: Text(
            'Leaderboard',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.withOpacity(0.2),
                Colors.purple.withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.construction_outlined,
                size: 80,
                color: Colors.orange,
              ).animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2.seconds),
              
              const SizedBox(height: 24),
              
              Text(
                'Under Maintenance',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'The leaderboard feature is temporarily unavailable as we\'ve removed the coding contest system.',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'We\'re working on exciting new features! Stay tuned for updates.',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Coming Soon',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 1.5.seconds),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms).scale(),
      ),
    );
  }

  Widget _buildPodium() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place
          _buildPodiumPlace(2, _leaderboard[1], Colors.grey, 120),
          const SizedBox(width: 8),
          // 1st Place
          _buildPodiumPlace(1, _leaderboard[0], Colors.amber, 150),
          const SizedBox(width: 8),
          // 3rd Place
          _buildPodiumPlace(3, _leaderboard[2], Colors.brown, 100),
        ],
      ),
    );
  }

  Widget _buildPodiumPlace(int rank, Map<String, dynamic> student, Color color, double height) {
    final weeklyPoints = student['weekly_points'] ?? 0;
    final name = student['name'] ?? 'Unknown';
    final imageUrl = student['image_url'];
    final tier = student['subscription_tier'] ?? 'free';
    
    return Column(
      children: [
        // Crown for 1st place
        if (rank == 1)
          const Icon(Icons.emoji_events, color: Colors.amber, size: 40)
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 2.seconds),
        
        // Profile Image
        Container(
          width: rank == 1 ? 80 : 60,
          height: rank == 1 ? 80 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.5)],
            ),
            border: Border.all(color: color, width: 3),
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? Center(
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: rank == 1 ? 32 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : null,
        ),
        
        const SizedBox(height: 8),
        
        // Name
        SizedBox(
          width: 100,
          child: Text(
            name,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Points
        Text(
          '$weeklyPoints pts',
          style: TextStyle(
            color: color,
            fontSize: 14,
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
              colors: [color, color.withOpacity(0.3)],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              UserBadge(tier: tier, compact: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardTile({
    required int rank,
    required Map<String, dynamic> student,
    required bool isCurrentUser,
    required int index,
  }) {
    final weeklyPoints = student['weekly_points'] ?? 0;
    final name = student['name'] ?? 'Unknown';
    final imageUrl = student['image_url'];
    final tier = student['subscription_tier'] ?? 'free';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCurrentUser
              ? [Colors.purple.withOpacity(0.3), Colors.blue.withOpacity(0.2)]
              : [Colors.grey.shade900, Colors.grey.shade900.withOpacity(0.5)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentUser ? Colors.purple : Colors.grey.shade800,
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade800,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Profile Image
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.blue],
              ),
              image: imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? Center(
                    child: Text(
                      name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
          
          const SizedBox(width: 12),
          
          // Name
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Badge
          UserBadge(tier: tier, compact: true),
          
          const SizedBox(width: 12),
          
          // Points
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange),
            ),
            child: Text(
              '$weeklyPoints pts',
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.1);
  }
}
