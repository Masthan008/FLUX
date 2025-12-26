import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/challenge_service.dart';
import '../models/challenge_model.dart';
import '../widgets/payment_dialog.dart';
import '../services/subscription_service.dart';
import 'leaderboard_screen.dart';
// TODO: Import your code editor screen
// import '../modules/code_editor/code_editor_screen.dart';

class CodingContestScreen extends StatefulWidget {
  const CodingContestScreen({super.key});

  @override
  State<CodingContestScreen> createState() => _CodingContestScreenState();
}

class _CodingContestScreenState extends State<CodingContestScreen> {
  String _selectedDifficulty = 'All';
  final List<String> _difficulties = ['All', 'easy', 'medium', 'hard'];
  Map<String, int> _studentPoints = {'weekly': 0, 'total': 0};

  @override
  void initState() {
    super.initState();
    _loadStudentPoints();
  }

  Future<void> _loadStudentPoints() async {
    final points = await ChallengeService.getStudentPoints();
    if (mounted) {
      setState(() => _studentPoints = points);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.orange, Colors.red],
              ).createShader(bounds),
              child: Text(
                'Coding Contests',
                style: GoogleFonts.orbitron(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'Weekly Points: ${_studentPoints['weekly']}',
              style: GoogleFonts.montserrat(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Leaderboard button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.emoji_events, color: Colors.white, size: 20),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              );
            },
            tooltip: 'Leaderboard',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Difficulty Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _difficulties.length,
              itemBuilder: (context, index) {
                final difficulty = _difficulties[index];
                final isSelected = _selectedDifficulty == difficulty;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(difficulty == 'All' ? 'All' : difficulty.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedDifficulty = difficulty);
                    },
                    backgroundColor: Colors.grey.shade900,
                    selectedColor: _getDifficultyColor(difficulty).withOpacity(0.3),
                    labelStyle: TextStyle(
                      color: isSelected ? _getDifficultyColor(difficulty) : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? _getDifficultyColor(difficulty) : Colors.grey.shade700,
                    ),
                  ),
                );
              },
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.2),

          const SizedBox(height: 8),

          // Challenge List
          Expanded(
            child: FutureBuilder<List<CodingChallenge>>(
              future: ChallengeService.getChallenges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.orange),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.code_off,
                          size: 80,
                          color: Colors.grey.shade700,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No challenges available',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var challenges = snapshot.data!;

                // Filter by difficulty
                if (_selectedDifficulty != 'All') {
                  challenges = challenges
                      .where((c) => c.difficulty == _selectedDifficulty)
                      .toList();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await _loadStudentPoints();
                    setState(() {});
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      return _ChallengeCard(
                        challenge: challenges[index],
                        index: index,
                        onPointsEarned: _loadStudentPoints,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'hard':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'easy':
        return Colors.green;
      default:
        return Colors.purple;
    }
  }
}

class _ChallengeCard extends StatefulWidget {
  final CodingChallenge challenge;
  final int index;
  final VoidCallback onPointsEarned;

  const _ChallengeCard({
    required this.challenge,
    required this.index,
    required this.onPointsEarned,
  });

  @override
  State<_ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<_ChallengeCard> {
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSolved();
  }

  Future<void> _checkIfSolved() async {
    final solved = await ChallengeService.hasSolved(widget.challenge.id);
    if (mounted) {
      setState(() => _isSolved = solved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    
    // Check tier access
    final userTier = SubscriptionService.currentTier;
    final challengeTier = SubscriptionService.stringToTier(challenge.minTierRequired);
    final isLocked = userTier.level < challengeTier.level;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            isLocked
                ? Colors.grey.shade900.withOpacity(0.5)
                : _isSolved
                    ? Colors.green.shade900.withOpacity(0.3)
                    : Colors.grey.shade900,
            isLocked
                ? Colors.grey.shade900.withOpacity(0.3)
                : Colors.grey.shade900.withOpacity(0.5),
          ],
        ),
        border: Border.all(
          color: isLocked
              ? Colors.grey.withOpacity(0.3)
              : _isSolved
                  ? Colors.green.withOpacity(0.5)
                  : challenge.difficultyColor.withOpacity(0.5),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                challenge.difficultyColor,
                challenge.difficultyColor.withOpacity(0.5),
              ],
            ),
          ),
          child: Icon(
            _isSolved ? Icons.check_circle : challenge.languageIcon,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                challenge.title,
                style: GoogleFonts.sourceCodePro(
                  fontWeight: FontWeight.bold,
                  color: isLocked ? Colors.grey : Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${challenge.points}',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                challenge.description,
                style: TextStyle(
                  color: isLocked ? Colors.grey.shade600 : Colors.grey.shade400,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: challenge.difficultyColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      challenge.difficulty.toUpperCase(),
                      style: TextStyle(
                        color: challenge.difficultyColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      challenge.language.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  if (_isSolved) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Solved',
                      style: TextStyle(color: Colors.green, fontSize: 10),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        trailing: isLocked
            ? Icon(Icons.lock, color: challengeTier.color, size: 24)
            : Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 20),
        onTap: () => isLocked
            ? _showUpgradeDialog(context, challengeTier)
            : _openChallenge(context, challenge),
      ),
    ).animate(delay: Duration(milliseconds: 50 * widget.index)).fadeIn().slideX(begin: 0.1);
  }

  Future<void> _openChallenge(BuildContext context, CodingChallenge challenge) async {
    HapticFeedback.lightImpact();
    
    // TODO: Navigate to code editor with pre-filled code
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => CodeEditorScreen(
    //       initialCode: challenge.starterCode ?? '',
    //       expectedOutput: challenge.expectedOutput,
    //       pointReward: challenge.points,
    //       challengeId: challenge.id,
    //     ),
    //   ),
    // );
    
    // Temporary: Show info dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          challenge.title,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          'Challenge: ${challenge.description}\n\nPoints: ${challenge.points}\n\nIntegrate with your CodeEditorScreen here!',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _showUpgradeDialog(BuildContext context, SubscriptionTier requiredTier) async {
    HapticFeedback.mediumImpact();
    await PaymentDialog.show(context, requiredTier);
  }
}
