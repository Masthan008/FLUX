import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _logoController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );
    
    _backgroundController.repeat();
    _logoController.repeat();
    _particleController.repeat();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Colors.cyanAccent, Colors.white, Colors.cyanAccent],
          ).createShader(bounds),
          child: Text(
            'About FluxFlow OS',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 1,
            ),
          ),
        )
          .animate()
          .fadeIn(duration: 800.ms)
          .slideX(begin: -0.3, end: 0)
          .then()
          .shimmer(duration: 2.seconds, color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.cyanAccent),
          ),
          onPressed: () => Navigator.pop(context),
        )
          .animate()
          .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
          .then()
          .shimmer(duration: 2.seconds, color: Colors.cyanAccent),
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5 + sin(_backgroundController.value * 2 * pi) * 0.3,
                    colors: [
                      const Color(0xFF0A0A0A),
                      const Color(0xFF1A1A2E),
                      const Color(0xFF16213E),
                      Colors.black,
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: AboutBackgroundPainter(_backgroundController.value),
                  size: Size.infinite,
                ),
              );
            },
          ),

          // Floating Particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Stack(
                children: List.generate(15, (index) {
                  double phase = (_particleController.value + (index * 0.067)) % 1.0;
                  double x = MediaQuery.of(context).size.width * (0.1 + (index * 0.06));
                  double y = MediaQuery.of(context).size.height * (0.1 + sin(phase * 2 * pi) * 0.4);
                  
                  return Positioned(
                    left: x,
                    top: y,
                    child: Container(
                      width: 15 + sin(phase * 4 * pi) * 3,
                      height: 15 + sin(phase * 4 * pi) * 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.cyanAccent.withOpacity(0.4 * sin(phase * pi)),
                            Colors.purple.withOpacity(0.3 * cos(phase * pi)),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // --- ANIMATED HEADER ---
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.cyanAccent.withOpacity(0.4 + sin(_logoController.value * 2 * pi) * 0.2),
                              Colors.purple.withOpacity(0.3 + cos(_logoController.value * 2 * pi) * 0.2),
                              Colors.pink.withOpacity(0.2),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.5),
                              blurRadius: 40 + sin(_logoController.value * 4 * pi) * 10,
                              spreadRadius: 8 + cos(_logoController.value * 3 * pi) * 3,
                            ),
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Transform.rotate(
                          angle: _logoController.value * 2 * pi * 0.1,
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  )
                    .animate()
                    .scale(delay: 300.ms, duration: 1200.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 3.seconds, color: Colors.white),
                  
                  const SizedBox(height: 30),
                  
                  // App Title with Holographic Effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.cyanAccent,
                        Colors.white,
                        Colors.purple,
                        Colors.pink,
                        Colors.cyanAccent,
                      ],
                      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      'FluxFlow OS',
                      style: GoogleFonts.orbitron(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 3,
                        shadows: [
                          Shadow(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                          Shadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 1000.ms)
                    .slideY(begin: 0.3, end: 0)
                    .then()
                    .shimmer(duration: 4.seconds, color: Colors.white),
                  
                  const SizedBox(height: 15),
                  
                  // Version Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyanAccent.withOpacity(0.2),
                          Colors.purple.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'v2.0.0 • Next-Gen Release',
                      style: GoogleFonts.firaCode(
                        fontSize: 14,
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 800.ms)
                    .scale(duration: 800.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 2.seconds, color: Colors.cyanAccent),
                  
                  const SizedBox(height: 15),
                  
                  // Subtitle with Glow Effect
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.white.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Revolutionary AI-Powered Learning Ecosystem',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.cyanAccent.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 800.ms)
                    .slideY(begin: 0.2, end: 0)
                    .then()
                    .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.3)),

                  const SizedBox(height: 50),

                  // --- ENHANCED FEATURES SECTION ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade900.withOpacity(0.8),
                          Colors.black.withOpacity(0.9),
                          Colors.grey.shade900.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.cyanAccent.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome_outlined,
                                color: Colors.cyanAccent,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [Colors.cyanAccent, Colors.white, Colors.cyanAccent],
                                ).createShader(bounds),
                                child: Text(
                                  'ADVANCED SYSTEM MODULES',
                                  style: GoogleFonts.orbitron(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                          .animate()
                          .fadeIn(delay: 1200.ms, duration: 800.ms)
                          .slideX(begin: -0.3, end: 0),
                        
                        const SizedBox(height: 25),

                        _buildEnhancedFeature(
                          'Academic Syllabus',
                          'Comprehensive Subject-Wise Study Materials with Flowcharts',
                          Icons.auto_stories_outlined,
                          Colors.amber,
                          1300,
                        ),
                        _buildEnhancedFeature(
                          'C-Coding Lab',
                          'Interactive Code Editor with Syntax Highlighting',
                          Icons.terminal_outlined,
                          Colors.green,
                          1350,
                        ),
                        _buildEnhancedFeature(
                          'LeetCode Problems',
                          'Curated DSA Practice Problems with Solutions',
                          Icons.code_outlined,
                          Colors.orange,
                          1400,
                        ),
                        _buildEnhancedFeature(
                          'Flux AI Chat',
                          'Multi-Provider AI Assistant for Pro & Ultra Users',
                          Icons.auto_awesome,
                          Colors.purple,
                          1425,
                        ),
                        _buildEnhancedFeature(
                          'Tech Roadmaps',
                          'Career-Focused Learning Paths for Multiple Domains',
                          Icons.route_outlined,
                          Colors.blue,
                          1450,
                        ),
                        _buildEnhancedFeature(
                          'Cyber Library',
                          'Ethical Hacking & Security Resource Collection',
                          Icons.shield_outlined,
                          Colors.red,
                          1500,
                        ),
                        _buildEnhancedFeature(
                          'Focus Forest',
                          'Gamified Pomodoro Timer for Deep Work Sessions',
                          Icons.forest_outlined,
                          Colors.green,
                          1550,
                        ),
                        _buildEnhancedFeature(
                          'Sleep Architect',
                          'Smart Sleep Cycle Calculator with Bedtime Alerts',
                          Icons.nightlight_round,
                          Colors.indigo,
                          1600,
                        ),
                        _buildEnhancedFeature(
                          'Campus News',
                          'Real-Time Announcements with Push Notifications',
                          Icons.notifications_active_outlined,
                          Colors.purple,
                          1650,
                        ),
                        _buildEnhancedFeature(
                          'Smart Calculator',
                          'Scientific Calculator with History & Memory',
                          Icons.calculate_outlined,
                          Colors.cyanAccent,
                          1700,
                        ),
                        _buildEnhancedFeature(
                          'Games Arcade',
                          '2048 & Tic-Tac-Toe for Study Breaks',
                          Icons.sports_esports_outlined,
                          Colors.deepPurple,
                          1750,
                        ),
                        _buildEnhancedFeature(
                          'Online Compilers',
                          'Quick Access to Cloud-Based IDEs',
                          Icons.developer_mode_outlined,
                          Colors.teal,
                          1800,
                        ),
                        _buildEnhancedFeature(
                          'Smart Alarms',
                          'Label-Based Alarms with Custom Ringtones',
                          Icons.alarm_outlined,
                          Colors.pink,
                          1850,
                        ),
                      ],
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 1200.ms, duration: 1000.ms)
                    .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 40),

                  // --- ENHANCED TEAM CREDITS ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.shade900.withOpacity(0.5),
                          Colors.orange.shade800.withOpacity(0.5),
                          Colors.deepOrange.shade900.withOpacity(0.4),
                          Colors.purple.shade900.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        width: 3,
                        color: Colors.amber.withOpacity(0.8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 25,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.amber.withOpacity(0.6),
                                Colors.orange.withOpacity(0.4),
                                Colors.purple.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.8),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.6),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.groups_outlined,
                            color: Colors.amber,
                            size: 60,
                          ),
                        )
                          .animate()
                          .scale(delay: 1900.ms, duration: 1000.ms, curve: Curves.elasticOut)
                          .then()
                          .shimmer(duration: 3.seconds, color: Colors.white)
                          .then()
                          .rotate(duration: 20.seconds, begin: 0, end: 1),
                        
                        const SizedBox(height: 20),
                        
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.amber,
                              Colors.white,
                              Colors.orange,
                              Colors.white,
                              Colors.amber,
                            ],
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ).createShader(bounds),
                          child: Text(
                            'DEVELOPMENT TEAM',
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                              shadows: [
                                Shadow(
                                  color: Colors.amber.withOpacity(0.8),
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
                                ),
                                Shadow(
                                  color: Colors.orange.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        )
                          .animate()
                          .fadeIn(delay: 2000.ms, duration: 1000.ms)
                          .slideY(begin: 0.3, end: 0)
                          .then()
                          .shimmer(duration: 4.seconds, color: Colors.white),
                        
                        const SizedBox(height: 20),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.05),
                                Colors.transparent,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Exceptional minds behind FluxFlow OS, Flux AI system, and next-generation student productivity experience:',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.95),
                              fontSize: 15,
                              height: 1.7,
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(
                                  color: Colors.amber.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        )
                          .animate()
                          .fadeIn(delay: 2100.ms, duration: 1000.ms)
                          .slideY(begin: 0.2, end: 0),
                        
                        const SizedBox(height: 30),
                        
                        // Team Members in Horizontal Scrollable Layout
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            children: [
                              _buildEnhancedTeamMember(
                                'MASTHAN', 
                                Icons.code_outlined, 
                                'Lead Developer', 
                                'Full-Stack & AI', 
                                Colors.cyan, 
                                2150,
                              ),
                              const SizedBox(width: 20),
                              _buildEnhancedTeamMember(
                                'AKHIL', 
                                Icons.psychology_outlined, 
                                'AI Developer', 
                                'Neural Networks', 
                                Colors.purple, 
                                2200,
                              ),
                              const SizedBox(width: 20),
                              _buildEnhancedTeamMember(
                                'NADIR', 
                                Icons.security_outlined, 
                                'Security Lead', 
                                'Cybersecurity', 
                                Colors.red, 
                                2250,
                              ),
                              const SizedBox(width: 20),
                              _buildEnhancedTeamMember(
                                'MOUNIKA', 
                                Icons.design_services_outlined, 
                                'UX/UI Lead', 
                                'Visual Design', 
                                Colors.pink, 
                                2300,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 25),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.amber.withOpacity(0.4),
                                Colors.orange.withOpacity(0.3),
                                Colors.amber.withOpacity(0.4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.amber.withOpacity(0.8),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.amber.withOpacity(0.6),
                                      Colors.transparent,
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.rocket_launch_outlined,
                                  color: Colors.amber,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.amber,
                                    Colors.white,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Core Innovation Team',
                                  style: GoogleFonts.orbitron(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                          .animate()
                          .fadeIn(delay: 2400.ms, duration: 1000.ms)
                          .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut)
                          .then()
                          .shimmer(duration: 3.seconds, color: Colors.white)
                          .then()
                          .shake(duration: 500.ms, hz: 2),
                      ],
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 1900.ms, duration: 1000.ms)
                    .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 50),

                  // --- ENHANCED INSTITUTION ---
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.grey.shade900.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.3),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.school_outlined,
                            color: Colors.cyanAccent,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.cyanAccent, Colors.white, Colors.cyanAccent],
                          ).createShader(bounds),
                          child: Text(
                            'RGMCET',
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rajiv Gandhi Memorial College of Engineering & Technology',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w300,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nurturing Innovation • Empowering Future',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            color: Colors.cyanAccent.withOpacity(0.7),
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 2500.ms, duration: 800.ms)
                    .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 50),

                  // --- ENHANCED SIGNATURE ---
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.cyanAccent.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Architected & Engineered by',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.cyanAccent,
                              Colors.white,
                              Colors.purple,
                              Colors.cyanAccent,
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Masthan Valli',
                            style: GoogleFonts.greatVibes(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.cyanAccent.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.2),
                                Colors.purple.withOpacity(0.2),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Chief Technology Officer & Lead Architect',
                            style: GoogleFonts.orbitron(
                              color: Colors.cyanAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 2700.ms, duration: 1000.ms)
                    .slideY(begin: 0.3, end: 0)
                    .then()
                    .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.3)),

                  const SizedBox(height: 40),

                  // --- ENHANCED FOOTER ---
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.05),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '© 2024 FluxFlow OS • Next-Generation Learning Platform',
                          style: GoogleFonts.poppins(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: Colors.red, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Crafted with Passion for Students Worldwide',
                            style: GoogleFonts.poppins(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                    .animate()
                    .fadeIn(delay: 2900.ms, duration: 800.ms),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedFeature(String title, String subtitle, IconData icon, Color color, int delay) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            Colors.transparent,
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(0.3),
                  color.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 12,
            ),
          ),
        ],
      ),
    )
      .animate()
      .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
      .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
      .then()
      .shimmer(
        delay: Duration(milliseconds: delay + 500),
        duration: 2.seconds,
        color: color.withOpacity(0.3),
      );
  }

  Widget _buildEnhancedTeamMember(String name, IconData icon, String role, String expertise, Color accentColor, int delay) {
    return Container(
      width: 280, // Wider card for horizontal list
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accentColor.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
            Colors.black.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 1.5,
          color: accentColor.withOpacity(0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar with glowing ring
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                  border: Border.all(
                    color: accentColor.withOpacity(0.8),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 32,
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.5)),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.orbitron(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: accentColor.withOpacity(0.6),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Expertise / Features
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: accentColor,
                  size: 16,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    expertise,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Social / Action Icons (Placeholder)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSocialIcon(Icons.link, accentColor),
              const SizedBox(width: 8),
              _buildSocialIcon(Icons.code, accentColor),
            ],
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(delay: Duration(milliseconds: delay), duration: 800.ms)
    .slideX(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Icon(
        icon,
        size: 14,
        color: color.withOpacity(0.8),
      ),
    );
  }

  // Keep the old function for reference if needed
  Widget _buildOldEnhancedTeamMember(String name, IconData icon, String role, String expertise, Color accentColor, int delay) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Floating particles around the card
        Positioned(
          top: -10,
          right: 20,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accentColor.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          )
            .animate(onPlay: (controller) => controller.repeat())
            .moveY(begin: 0, end: -15, duration: 2.seconds, curve: Curves.easeInOut)
            .then()
            .moveY(begin: -15, end: 0, duration: 2.seconds, curve: Curves.easeInOut),
        ),
        Positioned(
          bottom: -8,
          left: 30,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.amber.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          )
            .animate(onPlay: (controller) => controller.repeat())
            .moveY(begin: 0, end: 12, duration: 2.5.seconds, curve: Curves.easeInOut)
            .then()
            .moveY(begin: 12, end: 0, duration: 2.5.seconds, curve: Curves.easeInOut),
        ),
        
        // Main Card
        Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withOpacity(0.2),
                Colors.black.withOpacity(0.7),
                accentColor.withOpacity(0.15),
                Colors.black.withOpacity(0.8),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              width: 2.5,
              color: accentColor.withOpacity(0.8),
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 3,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.amber.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  // Enhanced Avatar with Animated Glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulsing ring
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              accentColor.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                        .animate(onPlay: (controller) => controller.repeat())
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds)
                        .then()
                        .scale(begin: const Offset(1.1, 1.1), end: const Offset(0.9, 0.9), duration: 2.seconds),
                      
                      // Main avatar
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              accentColor.withOpacity(0.5),
                              accentColor.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: accentColor.withOpacity(0.8),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: accentColor,
                          size: 36,
                        ),
                      )
                        .animate(onPlay: (controller) => controller.repeat())
                        .rotate(begin: 0, end: 0.02, duration: 3.seconds)
                        .then()
                        .rotate(begin: 0.02, end: -0.02, duration: 3.seconds)
                        .then()
                        .rotate(begin: -0.02, end: 0, duration: 3.seconds),
                    ],
                  ),
                  const SizedBox(width: 22),
                  
                  // Name and Role
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              accentColor,
                              Colors.amber,
                              accentColor,
                              Colors.white,
                            ],
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ).createShader(bounds),
                          child: Text(
                            name,
                            style: GoogleFonts.orbitron(
                              fontSize: 26,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.5,
                              shadows: [
                                Shadow(
                                  color: accentColor.withOpacity(0.7),
                                  blurRadius: 15,
                                  offset: const Offset(0, 0),
                                ),
                                Shadow(
                                  color: Colors.amber.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.5)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                accentColor.withOpacity(0.4),
                                Colors.amber.withOpacity(0.3),
                                accentColor.withOpacity(0.4),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: accentColor.withOpacity(0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Text(
                            role,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        )
                          .animate(onPlay: (controller) => controller.repeat())
                          .shimmer(delay: 500.ms, duration: 2.5.seconds, color: accentColor.withOpacity(0.4)),
                      ],
                    ),
                  ),
                  
                  // Animated Star Badge
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating outer glow
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              Colors.amber.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      )
                        .animate(onPlay: (controller) => controller.repeat())
                        .rotate(duration: 4.seconds),
                      
                      // Star badge
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.amber.withOpacity(0.6),
                              Colors.amber.withOpacity(0.3),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber.withOpacity(0.8),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.6),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 22,
                        ),
                      )
                        .animate(onPlay: (controller) => controller.repeat())
                        .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.15, 1.15), duration: 1.5.seconds)
                        .then()
                        .scale(begin: const Offset(1.15, 1.15), end: const Offset(1.0, 1.0), duration: 1.5.seconds),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Enhanced Expertise Section with Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.04),
                      Colors.white.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            accentColor.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified_outlined,
                        color: accentColor,
                        size: 20,
                      ),
                    )
                      .animate(onPlay: (controller) => controller.repeat())
                      .rotate(duration: 5.seconds),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        expertise,
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(delay: 1.seconds, duration: 3.seconds, color: Colors.white.withOpacity(0.1)),
              
              const SizedBox(height: 16),
              
              // Achievement Badges Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAchievementBadge(Icons.emoji_events_outlined, 'Excellence', accentColor),
                  _buildAchievementBadge(Icons.workspace_premium_outlined, 'Innovation', Colors.amber),
                  _buildAchievementBadge(Icons.military_tech_outlined, 'Leadership', Colors.orange),
                ],
              ),
            ],
          ),
        )
          .animate()
          .fadeIn(delay: Duration(milliseconds: delay), duration: 1200.ms)
          .slideX(begin: -0.6, end: 0, curve: Curves.easeOutCubic)
          .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOut)
          .then()
          .shimmer(
            delay: Duration(milliseconds: delay + 500),
            duration: 3.seconds,
            color: accentColor.withOpacity(0.5),
          ),
        
        // Top-right corner accent
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withOpacity(0.4),
                  Colors.amber.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: accentColor.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: accentColor,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  'CORE',
                  style: GoogleFonts.orbitron(
                    fontSize: 9,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.5)),
        ),
      ],
    );
  }
  
  Widget _buildAchievementBadge(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                color.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        )
          .animate(onPlay: (controller) => controller.repeat())
          .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.1, 1.1), duration: 2.seconds)
          .then()
          .scale(begin: const Offset(1.1, 1.1), end: const Offset(1.0, 1.0), duration: 2.seconds),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 9,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// Custom Painter for About Screen Background
class AboutBackgroundPainter extends CustomPainter {
  final double animationValue;

  AboutBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.03)
      ..strokeWidth = 1;

    // Draw animated neural network pattern
    for (int i = 0; i < 25; i++) {
      for (int j = 0; j < 20; j++) {
        double x = (i * 30.0) + (j % 2) * 15 + (animationValue * 8) % 30;
        double y = (j * 25.0) + (animationValue * 3) % 25;
        
        if (x < size.width + 30 && y < size.height + 30) {
          _drawNeuralNode(canvas, Offset(x, y), 8, paint);
        }
      }
    }

    // Draw flowing data streams
    final streamPaint = Paint()
      ..color = Colors.purple.withOpacity(0.08)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 8; i++) {
      final path = Path();
      double startY = size.height * (0.1 + i * 0.12);
      path.moveTo(0, startY);
      
      for (double x = 0; x <= size.width; x += 8) {
        double y = startY + sin((x / 80) + (animationValue * 3 * pi) + (i * pi / 4)) * 15;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, streamPaint);
    }

    // Draw quantum particles
    final particlePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      double phase = (animationValue + (i * 0.083)) % 1.0;
      double x = size.width * (0.1 + (i * 0.075));
      double y = size.height * (0.2 + sin(phase * 2 * pi) * 0.3);
      
      canvas.drawCircle(
        Offset(x, y),
        3 + sin(phase * 6 * pi) * 1.5,
        particlePaint,
      );
    }
  }

  void _drawNeuralNode(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
    
    // Draw connections
    for (int i = 0; i < 6; i++) {
      double angle = (i * pi) / 3;
      double x = center.dx + radius * 2 * cos(angle);
      double y = center.dy + radius * 2 * sin(angle);
      
      canvas.drawLine(
        center,
        Offset(x, y),
        Paint()
          ..color = Colors.cyanAccent.withOpacity(0.02)
          ..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}