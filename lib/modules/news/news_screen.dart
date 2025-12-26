import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/news_service.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> with TickerProviderStateMixin {
  late AnimationController _headerAnimationController;
  late AnimationController _refreshAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    
    // Clear unread news count when entering news screen
    NotificationService.clearUnreadCount();
    
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _refreshAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();
    
    _refreshAnimationController.forward();
    
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));
    
    _refreshAnimationController.reverse();
    setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
        ),
        title: AnimatedBuilder(
          animation: _headerFadeAnimation,
          builder: (context, child) {
            return FadeTransition(
              opacity: _headerFadeAnimation,
              child: SlideTransition(
                position: _headerSlideAnimation,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.cyanAccent, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.newspaper, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'News Feed',
                      style: GoogleFonts.orbitron(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        actions: [
          AnimatedBuilder(
            animation: _refreshAnimationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _refreshAnimationController.value * 2 * 3.14159,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.8),
                          Colors.greenAccent.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: _isRefreshing ? Colors.white70 : Colors.white,
                    ),
                  ),
                  onPressed: _isRefreshing ? null : _handleRefresh,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Enhanced Animated Background
          Container(
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
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(
                duration: 8.seconds, 
                color: Colors.cyanAccent.withOpacity(0.1),
              )
              .saturate(duration: 8.seconds, begin: 0.9, end: 1.1),

          // Floating Particles Background
          ...List.generate(20, (index) {
            return Positioned(
              left: (index * 50.0) % MediaQuery.of(context).size.width,
              top: (index * 80.0) % MediaQuery.of(context).size.height,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat(reverse: true))
                  .fadeIn(duration: (2 + index % 3).seconds)
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5)),
            );
          }),

          // Content
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: Colors.cyanAccent,
              backgroundColor: Colors.grey.shade900,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: NewsService.getNewsStream(),
                builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.2),
                                Colors.blue.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.cyanAccent,
                            strokeWidth: 3,
                          ),
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .scale(
                              duration: 1.seconds,
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.2, 1.2),
                            ),
                        const SizedBox(height: 20),
                        Text(
                          'Loading latest news...',
                          style: GoogleFonts.montserrat(
                            color: Colors.cyanAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .slideY(begin: 0.3, end: 0),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final newsList = snapshot.data ?? [];

                if (newsList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.withOpacity(0.2),
                                Colors.grey.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                            ),
                          ),
                          child: const Icon(
                            Icons.newspaper_outlined,
                            color: Colors.white38,
                            size: 60,
                          ),
                        )
                            .animate()
                            .scale(delay: 200.ms, duration: 600.ms)
                            .fadeIn(),
                        const SizedBox(height: 24),
                        Text(
                          'No Updates Yet',
                          style: GoogleFonts.montserrat(
                            color: Colors.white70,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 12),
                        Text(
                          'Pull down to refresh or check back later',
                          style: GoogleFonts.montserrat(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .slideY(begin: 0.3, end: 0),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.cyanAccent, Colors.blue],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.refresh, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Pull to Refresh',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 800.ms)
                            .scale(begin: const Offset(0.8, 0.8)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    final news = newsList[index];
                    return _NewsCard(news: news, index: index);
                  },
                );
                },
              ),
            ),
          ),

          // Floating Action Button for Quick Actions
          Positioned(
            bottom: 30,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _handleRefresh();
              },
              backgroundColor: Colors.cyanAccent,
              child: const Icon(Icons.add, color: Colors.black),
            )
                .animate()
                .scale(delay: 1.seconds, duration: 400.ms)
                .fadeIn(),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatefulWidget {
  final Map<String, dynamic> news;
  final int index;

  const _NewsCard({
    required this.news,
    required this.index,
  });

  @override
  State<_NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<_NewsCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.news['title'] ?? 'Untitled';
    final description = widget.news['description'] ?? '';
    final imageUrl = widget.news['image_url'];
    final hasImage = imageUrl != null && imageUrl.toString().isNotEmpty;
    final createdAt = widget.news['created_at'];
    
    String formattedDate = 'Unknown date';
    if (createdAt != null) {
      try {
        final date = DateTime.parse(createdAt).toLocal();
        formattedDate = DateFormat('dd MMM, h:mm a').format(date);
      } catch (e) {
        formattedDate = createdAt.toString();
      }
    }

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
        HapticFeedback.lightImpact();
      },
      onTapUp: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      onTapCancel: () {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_hoverController.value * 0.02),
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.shade900.withOpacity(0.9),
                    Colors.grey.shade800.withOpacity(0.7),
                  ],
                ),
                border: Border.all(
                  color: _isHovered 
                    ? Colors.cyanAccent.withOpacity(0.6)
                    : Colors.cyanAccent.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(_isHovered ? 0.2 : 0.1),
                    blurRadius: _isHovered ? 20 : 12,
                    spreadRadius: _isHovered ? 4 : 2,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (if exists)
                  if (hasImage)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white38,
                        size: 48,
                      ),
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey.shade800,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          
                  // Enhanced Text Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Enhanced Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.redAccent, Colors.red],
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.campaign,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Text(
                              description,
                              style: GoogleFonts.montserrat(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                        
                        const SizedBox(height: 16),
                        // Enhanced Footer
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyanAccent.withOpacity(0.2),
                                    Colors.blue.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.cyanAccent,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    formattedDate,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.cyanAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.trending_up,
                                color: Colors.greenAccent,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    )
        .animate(delay: Duration(milliseconds: widget.index * 150))
        .fadeIn(duration: 600.ms, curve: Curves.easeOutCubic)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, curve: Curves.easeOutCubic)
        .scale(begin: const Offset(0.9, 0.9), duration: 600.ms, curve: Curves.easeOutCubic);
  }
}
