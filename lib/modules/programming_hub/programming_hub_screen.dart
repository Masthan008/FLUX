import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'programming_languages_data.dart';
import 'language_detail_screen.dart';

class ProgrammingHubScreen extends StatefulWidget {
  const ProgrammingHubScreen({super.key});

  @override
  State<ProgrammingHubScreen> createState() => _ProgrammingHubScreenState();
}

class _ProgrammingHubScreenState extends State<ProgrammingHubScreen>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _glowController;
  final List<_Particle> _particles = [];
  String _selectedDifficulty = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize particles
    for (int i = 0; i < 30; i++) {
      _particles.add(_Particle.random());
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ProgrammingLanguage> get _filteredLanguages {
    var languages = ProgrammingLanguagesRepository.allLanguages;
    
    if (_selectedDifficulty != 'All') {
      languages = languages
          .where((lang) => lang.difficulty == _selectedDifficulty)
          .toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      languages = languages.where((lang) {
        return lang.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            lang.tagline.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    return languages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0F),
              Color(0xFF1A0A2E),
              Color(0xFF0F1A2E),
              Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated particles background
            _buildParticles(),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  _buildMonsterHeader(),
                  _buildSearchAndFilter(),
                  Expanded(
                    child: _buildLanguagesGrid(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(_particles, _particleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildMonsterHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              // Back button with glow
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3 + _glowController.value * 0.3),
                          blurRadius: 15 + _glowController.value * 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.cyan),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Monster title with neon effect
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF00FFFF),
                          Color(0xFFFF00FF),
                          Color(0xFF00FF00),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'PROGRAMMING HUB',
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(duration: 2.seconds, color: Colors.white30),
                    const SizedBox(height: 4),
                    Text(
                      '${ProgrammingLanguagesRepository.allLanguages.length} Languages • 50+ Topics',
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 12,
                        color: Colors.cyan.withOpacity(0.7),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              // Monster mode indicator
              _buildMonsterModeIndicator(),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.3);
  }

  Widget _buildMonsterModeIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.red.withOpacity(0.3 + _pulseController.value * 0.2),
                Colors.orange.withOpacity(0.3 + _pulseController.value * 0.2),
              ],
            ),
            border: Border.all(
              color: Colors.redAccent.withOpacity(0.5 + _pulseController.value * 0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3 + _pulseController.value * 0.3),
                blurRadius: 10 + _pulseController.value * 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'MONSTER',
                style: GoogleFonts.orbitron(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Search bar with neon border
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.cyan.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: GoogleFonts.sourceCodePro(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search languages...',
                hintStyle: GoogleFonts.sourceCodePro(
                  color: Colors.white30,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
          
          const SizedBox(height: 16),
          
          // Filter chips with glow effect
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Beginner', 'Intermediate', 'Advanced']
                  .map((diff) => _buildFilterChip(diff))
                  .toList(),
            ),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String difficulty) {
    final isSelected = _selectedDifficulty == difficulty;
    final chipColor = _getDifficultyColor(difficulty);
    
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() => _selectedDifficulty = difficulty);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: isSelected
                ? LinearGradient(
                    colors: [chipColor.withOpacity(0.5), chipColor.withOpacity(0.3)],
                  )
                : null,
            color: isSelected ? null : Colors.black.withOpacity(0.3),
            border: Border.all(
              color: isSelected ? chipColor : Colors.white24,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: chipColor.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Text(
            difficulty,
            style: GoogleFonts.sourceCodePro(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }

  Widget _buildLanguagesGrid() {
    final languages = _filteredLanguages;
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: languages.length,
      itemBuilder: (context, index) {
        return _buildLanguageCard(languages[index], index);
      },
    );
  }

  Widget _buildLanguageCard(ProgrammingLanguage lang, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LanguageDetailScreen(language: lang),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
                  ),
                  child: child,
                ),
              );
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  lang.primaryColor.withOpacity(0.15),
                  lang.secondaryColor.withOpacity(0.1),
                  Colors.black.withOpacity(0.5),
                ],
              ),
              border: Border.all(
                color: lang.primaryColor.withOpacity(0.4 + _glowController.value * 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: lang.primaryColor.withOpacity(0.2 + _glowController.value * 0.1),
                  blurRadius: 15 + _glowController.value * 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    right: -20,
                    bottom: -20,
                    child: Icon(
                      lang.icon,
                      size: 100,
                      color: lang.primaryColor.withOpacity(0.1),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon with glow
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                lang.primaryColor.withOpacity(0.3),
                                lang.secondaryColor.withOpacity(0.2),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: lang.primaryColor.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            lang.icon,
                            color: lang.primaryColor,
                            size: 28,
                          ),
                        ),
                        const Spacer(),
                        // Dark gradient for text visibility
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Language name with shadow
                              Text(
                                lang.name,
                                style: GoogleFonts.orbitron(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 4,
                                      offset: const Offset(1, 1),
                                    ),
                                    Shadow(
                                      color: lang.primaryColor,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Tagline
                              Text(
                                lang.tagline,
                                style: GoogleFonts.sourceCodePro(
                                  fontSize: 10,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Topics count and difficulty
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${lang.topics.length} topics',
                                style: GoogleFonts.sourceCodePro(
                                  fontSize: 9,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(lang.difficulty)
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _getDifficultyColor(lang.difficulty)
                                      .withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                lang.difficulty,
                                style: GoogleFonts.sourceCodePro(
                                  fontSize: 9,
                                  color: _getDifficultyColor(lang.difficulty),
                                  fontWeight: FontWeight.bold,
                                ),
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
    ).animate(delay: Duration(milliseconds: 100 * index))
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.3)
        .scale(begin: const Offset(0.8, 0.8));
  }
}

// Particle class for background animation
class _Particle {
  double x;
  double y;
  double size;
  double speed;
  Color color;
  double angle;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.angle,
  });

  factory _Particle.random() {
    final random = Random();
    final colors = [
      Colors.cyan.withOpacity(0.3),
      Colors.purple.withOpacity(0.3),
      Colors.blue.withOpacity(0.3),
      const Color(0xFF00FF00).withOpacity(0.3),
    ];
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 3 + 1,
      speed: random.nextDouble() * 0.02 + 0.005,
      color: colors[random.nextInt(colors.length)],
      angle: random.nextDouble() * 2 * pi,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double animationValue;

  _ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final x = ((particle.x + animationValue * particle.speed * cos(particle.angle)) % 1) * size.width;
      final y = ((particle.y + animationValue * particle.speed * sin(particle.angle)) % 1) * size.height;
      
      final paint = Paint()
        ..color = particle.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size);
      
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
