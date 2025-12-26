import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/video_service.dart';
import '../services/subscription_service.dart';
import '../models/video_model.dart';
import '../widgets/payment_dialog.dart';
import '../widgets/user_badge.dart';
import '../services/link_launcher.dart';
import '../main.dart'; // For getPlanScore

class VideoLibraryScreen extends StatefulWidget {
  const VideoLibraryScreen({super.key});

  @override
  State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = [
    'Java', 
    'AWS', 
    'CyberSecurity', 
    'Flutter', 
    'Python',
    'React',
    'Node.js',
    'DevOps',
    'Data Science',
    'System Design'
  ];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.purple, Colors.blue],
          ).createShader(bounds),
          child: Text(
            'Tech Video Library',
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.purple,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
          tabs: _categories.map((category) {
            return Tab(
              text: category,
              icon: Icon(_getCategoryIcon(category), size: 20),
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withOpacity(0.1),
                    Colors.blue.withOpacity(0.1),
                  ],
                ),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search videos...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  prefixIcon: const Icon(Icons.search, color: Colors.purple),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ).animate().fadeIn().slideY(begin: -0.2),

          // Video Lists
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _VideoList(
                  category: category,
                  searchQuery: _searchQuery,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Java':
        return Icons.coffee;
      case 'AWS':
        return Icons.cloud;
      case 'CyberSecurity':
        return Icons.security;
      case 'Flutter':
        return Icons.phone_android;
      case 'Python':
        return Icons.code;
      case 'React':
        return Icons.web;
      case 'Node.js':
        return Icons.javascript;
      case 'DevOps':
        return Icons.settings_system_daydream;
      case 'Data Science':
        return Icons.analytics;
      case 'System Design':
        return Icons.architecture;
      default:
        return Icons.play_circle;
    }
  }}

class _VideoList extends StatelessWidget {
  final String category;
  final String searchQuery;

  const _VideoList({
    required this.category,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Video>>(
      stream: VideoService.streamVideosByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.purple),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 80,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(height: 16),
                Text(
                  'No videos for $category yet',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back soon!',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        }

        var videos = snapshot.data!;

        // Filter by search
        if (searchQuery.isNotEmpty) {
          videos = videos
              .where((v) => v.title.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return _VideoCard(video: videos[index], index: index);
          },
        );
      },
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Video video;
  final int index;

  const _VideoCard({
    required this.video,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Check tier access
    final userTier = SubscriptionService.currentTier;
    final videoTier = SubscriptionService.stringToTier(video.minTierRequired);
    final isLocked = userTier.level < videoTier.level;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            isLocked ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade900,
            isLocked ? Colors.grey.shade900.withOpacity(0.3) : Colors.grey.shade900.withOpacity(0.5),
          ],
        ),
        border: Border.all(
          color: isLocked
              ? Colors.grey.withOpacity(0.3)
              : video.isPremium
                  ? Colors.amber.withOpacity(0.5)
                  : Colors.purple.withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => isLocked ? _showUpgradeDialog(context, videoTier) : _openVideo(context, video),
          child: Column(
            children: [
              // Thumbnail Section
              if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    video.thumbnailUrl!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey.shade900,
                      child: Icon(Icons.play_circle_fill, size: 50, color: Colors.grey.shade800),
                    ),
                  ),
                ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Play/Lock Icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLocked 
                                ? Colors.grey.withOpacity(0.2) 
                                : Colors.purple.withOpacity(0.2),
                          ),
                          child: Icon(
                            isLocked ? Icons.lock : Icons.play_arrow_rounded,
                            color: isLocked ? Colors.grey : Colors.purpleAccent,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        
                        // Title & Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: GoogleFonts.sourceCodePro(
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.grey : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              if (video.description != null && video.description!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  video.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Footer: Tags & Tier
                    Row(
                      children: [
                        // Category Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            video.category,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 8),

                        // Duration Tag
                        if (video.durationMinutes != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time, size: 10, color: Colors.white70),
                                const SizedBox(width: 4),
                                Text(
                                  video.formattedDuration,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                        const Spacer(),
                        
                        // Premium Badge
                        if (video.isPremium)
                          UserBadge(tier: video.minTierRequired, compact: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.1);
  }

  Future<void> _openVideo(BuildContext context, Video video) async {
    await LinkLauncher.openLink(context, video.youtubeLink);
  }

  Future<void> _showUpgradeDialog(BuildContext context, SubscriptionTier requiredTier) async {
    HapticFeedback.mediumImpact();
    await PaymentDialog.show(context, requiredTier);
  }
}
