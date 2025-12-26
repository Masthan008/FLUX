import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/accessibility_provider.dart';
import '../widgets/glass_bottom_nav.dart';
import '../widgets/accessibility_wrapper.dart';
import '../modules/calculator/calculator_screen.dart';
import '../modules/alarm/alarm_screen.dart';
import '../modules/games/enhanced_2048_screen.dart';
import '../modules/games/enhanced_tictactoe_screen.dart';
import '../modules/focus/focus_forest_screen.dart';
import '../modules/sleep/sleep_screen.dart';
import '../modules/cyber/cyber_vault_screen.dart';
import '../modules/coding/coding_lab_screen.dart';
import '../modules/coding/compiler_screen.dart';
import '../modules/coding/jdoodle_compiler_screen.dart';
import '../modules/coding/leetcode_screen.dart';
import '../modules/news/news_screen.dart';
import '../modules/academic/syllabus_screen.dart';
import '../modules/academic/books_notes_screen.dart';
import '../modules/roadmaps/roadmaps_screen.dart';
import '../modules/programming_hub/programming_hub_screen.dart';
import '../modules/ai/nova_chat_screen.dart';
import '../modules/community/community_books_screen.dart';
import '../modules/study_companion/study_companion_screen.dart';
import '../modules/social_learning/social_learning_screen.dart';
import 'timetable_screen.dart';
import 'calendar_screen.dart';
import 'library_screen.dart';
import 'video_library_screen.dart';
import 'coding_contest_screen.dart';
import 'leaderboard_screen.dart';
import 'subscription_screen.dart';
import 'projects_screen.dart';
import 'student_profile_screen.dart';
import 'login_screen.dart';

import 'settings_screen.dart';
import 'about_screen.dart';
import 'chat_screen.dart';

import '../services/auth_service.dart';
import '../services/student_auth_service.dart';
import '../services/notification_service.dart';
import '../widgets/user_badge.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _drawerAnimationController;
  late AnimationController _appBarAnimationController;
  late AnimationController _backgroundController;
  
  final List<Widget> _screens = [
    const TimetableScreen(),  // Index 0 - Timetable
    const AlarmScreen(),      // Index 1 - Alarm
    const CalendarScreen(),   // Index 2 - Calendar
    const ChatScreen(),       // Index 3 - Chat
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _drawerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _appBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    // Start animations
    _appBarAnimationController.forward();
    _backgroundController.repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkFirstRun();
      if (mounted && StudentAuthService.isLoggedIn) {
        await syncUserProfile();
      }
    });
  }

  // Sync user profile from Supabase (Source of Truth)
  Future<void> syncUserProfile() async {
    try {
      // Use the centralized Auth Service to refresh data from 'students' table
      final updatedStudent = await StudentAuthService.refreshCurrentStudent();
      
      if (updatedStudent != null) {
        // Also update Hive for fallback (though UI uses StudentAuthService mostly)
        var box = Hive.box('user_prefs');
        await box.put('user_name', updatedStudent.name);
        if (updatedStudent.imageUrl != null) {
           await box.put('user_photo', updatedStudent.imageUrl);
        }

        if (mounted) {
          setState(() {}); // Force UI rebuild with new data
          
          // Debug feedback for user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("✅ Profile Synced: ${updatedStudent.name}"),
              backgroundColor: Colors.green.withOpacity(0.8),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        print("✅ Profile synced via StudentAuthService!");
      }
    } catch (e) {
      print("⚠️ Sync error: $e");
    }
  }

  @override
  void dispose() {
    _drawerAnimationController.dispose();
    _appBarAnimationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  Future<void> _checkFirstRun() async {
    // Check if user is logged in using the new service
    final student = await StudentAuthService.init();
    
    if (student == null) {
      // If not logged in, redirect to login
      if (mounted) {
         Navigator.pushReplacementNamed(context, '/auth');
      }
      return; // Exit if not logged in
    } else {
      // Check if biometric is enabled
      final box = Hive.box('user_prefs');
      final isBiometricEnabled = box.get('biometric_enabled', defaultValue: false);
      
      if (isBiometricEnabled) {
        // Biometric Auth on startup
        final authenticated = await AuthService.authenticate();
        if (!authenticated) {
          // Show authentication failed dialog
          _showAuthFailedDialog();
          return;
        }
      }
    }
  }

  void _showAuthFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Authentication Required',
          style: TextStyle(color: Colors.redAccent),
        ),
        content: const Text(
          'Please authenticate to access FluxFlow',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authenticated = await AuthService.authenticate();
              if (!authenticated) {
                // Navigate back to auth screen
                Navigator.pushReplacementNamed(context, '/auth');
              }
            },
            child: const Text('Retry', style: TextStyle(color: Colors.cyanAccent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auth');
            },
            child: const Text('Login Again', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final box = Hive.box('user_prefs');
    final userName = box.get('user_name', defaultValue: 'Student');
    final userPhoto = box.get('user_photo');
    
    return Consumer2<ThemeProvider, AccessibilityProvider>(
      builder: (context, themeProvider, accessibilityProvider, child) {
        return Scaffold(
          extendBody: true, // Important for floating nav bar
          drawer: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.98),
              Colors.grey.shade900.withOpacity(0.95),
              Colors.black.withOpacity(0.98),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.2),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Drawer(
          backgroundColor: Colors.transparent,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Revolutionary Drawer Header with Advanced Animations
              Container(
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.cyanAccent.withOpacity(0.9),
                      Colors.purple.withOpacity(0.8),
                      Colors.pink.withOpacity(0.7),
                      Colors.deepPurple.withOpacity(0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Enhanced Animated Background Pattern
                    AnimatedBuilder(
                      animation: _backgroundController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: DrawerPatternPainter(_backgroundController.value),
                          size: Size.infinite,
                        );
                      },
                    ),
                    
                    // Floating Orbs Animation
                    AnimatedBuilder(
                      animation: _backgroundController,
                      builder: (context, child) {
                        return Stack(
                          children: List.generate(8, (index) {
                            double phase = (_backgroundController.value + (index * 0.125)) % 1.0;
                            double x = 50 + (index * 25.0) + (15 * sin(phase * 2 * pi));
                            double y = 30 + (index * 20.0) + (20 * cos(phase * 2 * pi));
                            
                            return Positioned(
                              left: x,
                              top: y,
                              child: Container(
                                width: 12 + sin(phase * 4 * pi) * 4,
                                height: 12 + sin(phase * 4 * pi) * 4,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.6 * sin(phase * pi)),
                                      Colors.cyanAccent.withOpacity(0.4 * cos(phase * pi)),
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
                    
                    // Header Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Student Profile Row
                          Row(
                            children: [
                              // Profile Avatar
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: StudentAuthService.currentStudent?.imageUrl == null
                                      ? RadialGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.9),
                                            Colors.cyanAccent.withOpacity(0.7),
                                          ],
                                        )
                                      : null,
                                  image: StudentAuthService.currentStudent?.imageUrl != null
                                      ? DecorationImage(
                                          image: NetworkImage(StudentAuthService.currentStudent!.imageUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: 3,
                                    ),
                                  ],
                                ),
                                child: StudentAuthService.currentStudent?.imageUrl == null
                                    ? Icon(
                                        Icons.person,
                                        color: Colors.black,
                                        size: 30,
                                      )
                                    : null,
                              )
                                .animate()
                                .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
                                .then()
                                .shimmer(duration: 2.seconds, color: Colors.white),
                              
                              const SizedBox(width: 12),
                              
                              // Student Name & Tier Badge
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      StudentAuthService.currentStudent?.name ?? 'Student',
                                      style: GoogleFonts.sourceCodePro(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    if (StudentAuthService.currentStudent != null)
                                      UserBadge(
                                        tier: StudentAuthService.currentStudent!.subscriptionTier,
                                        compact: false,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          )
                            .animate()
                            .fadeIn(delay: 300.ms)
                            .slideX(begin: -0.2),
                          
                          const SizedBox(height: 16),
                          
                          // App Title
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.white, Colors.cyanAccent, Colors.white],
                            ).createShader(bounds),
                            child: Text(
                              'FluxFlow OS',
                              style: GoogleFonts.orbitron(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 800.ms)
                            .slideX(begin: -0.3, end: 0)
                            .then()
                            .shimmer(duration: 3.seconds, color: Colors.white),
                          
                          // Subtitle
                          Text(
                            'Next-Gen Learning Platform',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1,
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 600.ms)
                            .slideX(begin: -0.2, end: 0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            _buildAnimatedDrawerItem(
              icon: Icons.calculate_outlined,
              title: 'Smart Calculator',
              color: Colors.cyanAccent,
              delay: 100,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculatorScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.nightlight_round,
              title: 'Sleep Architect',
              color: Colors.purpleAccent,
              delay: 200,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SleepScreen(),
                  ),
                );
              },
            ),
            // Games Arcade - Premium Gaming Experience
            _buildAnimatedExpansionTile(
              icon: Icons.sports_esports_outlined,
              title: 'Games Arcade',
              color: Colors.cyanAccent,
              delay: 300,
              children: [
                // 2048 Game with Enhanced Design & Animations
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.amber.withOpacity(0.3),
                          Colors.orange.withOpacity(0.2),
                          Colors.deepOrange.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const Enhanced2048Screen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                                      .chain(CurveTween(curve: Curves.easeInOutCubic)),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.view_module_outlined,
                                  color: Colors.amber,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '2048 Puzzle',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Strategic number puzzle with smooth animations',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.amber.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.amber.withOpacity(0.6),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.3),
                ),
                // Tic-Tac-Toe with Enhanced Design & Animations
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.cyanAccent.withOpacity(0.3),
                          Colors.blue.withOpacity(0.2),
                          Colors.indigo.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const EnhancedTicTacToeScreen(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return SlideTransition(
                                  position: animation.drive(
                                    Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                                      .chain(CurveTween(curve: Curves.easeInOutCubic)),
                                  ),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.grid_3x3_outlined,
                                  color: Colors.cyanAccent,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tic-Tac-Toe',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Classic strategy game with AI opponent',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.cyanAccent.withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.cyanAccent.withOpacity(0.6),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.3),
                ),
              ],
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.forest_outlined,
              title: 'Focus Forest',
              color: Colors.green,
              delay: 650,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FocusForestScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.shield_outlined,
              title: 'Cyber Library',
              color: Colors.amber,
              delay: 700,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CyberVaultScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.terminal_outlined,
              title: 'C-Coding Lab',
              color: Colors.green,
              delay: 750,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CodingLabScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.code_outlined,
              title: 'LeetCode Problems',
              color: Colors.orange,
              delay: 800,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeetCodeScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.developer_mode_outlined,
              title: 'Online Compilers',
              color: Colors.cyanAccent,
              delay: 850,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompilerScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.play_circle_outline,
              title: 'Practice Code',
              color: Colors.greenAccent,
              delay: 860,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JDoodleCompilerScreen(),
                  ),
                );
              },
            ),

            _buildAnimatedDrawerItem(
              icon: Icons.auto_stories_outlined,
              title: 'Academic Syllabus',
              color: Colors.amber,
              delay: 900,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SyllabusScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.route_outlined,
              title: 'Tech Roadmaps',
              color: Colors.blue,
              delay: 950,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoadmapsScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.developer_board,
              title: 'Programming Hub',
              color: Colors.purpleAccent,
              delay: 1000,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProgrammingHubScreen(),
                  ),
                );
              },
            ),
            // Flux AI Chat
            _buildAnimatedDrawerItem(
              icon: Icons.auto_awesome,
              title: 'Flux AI Chat',
              subtitle: 'Multi-provider AI assistant',
              color: Colors.purple,
              delay: 1025,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NovaChatScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.menu_book_outlined,
              title: 'Student Library',
              color: Colors.green,
              delay: 1050,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LibraryScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.play_circle_outlined,
              title: 'Video Library',
              color: Colors.blue,
              delay: 1075,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VideoLibraryScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.folder_special,
              title: 'Projects Store',
              subtitle: 'Download ready-made projects',
              color: Colors.purple,
              delay: 1090,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectsScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.person_outline,
              title: 'Student Profile',
              subtitle: 'Manage your profile',
              color: Colors.teal,
              delay: 1095,
              onTap: () async {
                Navigator.pop(context);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentProfileScreen(),
                  ),
                );
                // Refresh home screen data when returning from profile
                if (mounted) {
                  setState(() {});
                }
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.emoji_events_outlined,
              title: 'Coding Contests',
              color: Colors.orange,
              delay: 1100,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CodingContestScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.leaderboard_outlined,
              title: 'Leaderboard',
              color: Colors.amber,
              delay: 1125,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardScreen(),
                  ),
                );
              },
            ),

            _buildAnimatedDrawerItem(
              icon: Icons.info_outline,
              title: 'About FluxFlow',
              color: Colors.cyanAccent,
              delay: 1250,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
            _buildAnimatedDrawerItem(
              icon: Icons.settings_outlined,
              title: 'System Settings',
              color: Colors.grey,
              delay: 1300,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            
            // Subscription Plans - NEW
            _buildAnimatedDrawerItem(
              icon: Icons.star,
              title: 'Subscription Plans',
              subtitle: 'Upgrade to Pro/Ultra',
              color: Colors.green,
              delay: 1350,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubscriptionScreen(),
                  ),
                );
              },
            ),
            


            // Logout Button
            _buildAnimatedDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              subtitle: 'Sign out of account',
              color: Colors.redAccent,
              delay: 1450,
              onTap: () async {
                Navigator.pop(context);
                
                // Show confirmation dialog
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.grey.shade900,
                    title: const Text('Logout', style: TextStyle(color: Colors.white)),
                    content: const Text('Are you sure you want to logout?', style: TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await StudentAuthService.logout();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AnimatedBuilder(
          animation: _appBarAnimationController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.grey.shade900.withOpacity(0.8),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                    child: const Icon(
                      Icons.menu,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
                  .animate()
                  .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
                  .then()
                  .shimmer(duration: 2.seconds, color: Colors.cyanAccent),
                
                title: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.cyanAccent,
                      Colors.white,
                      Colors.cyanAccent,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    userName,
                    style: GoogleFonts.orbitron(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 800.ms)
                  .slideX(begin: -0.3, end: 0)
                  .then()
                  .shimmer(duration: 3.seconds, color: Colors.white),
                actions: [
                  // Animated News Bell Icon with Badge
                  FutureBuilder<int>(
                    future: NotificationService.getUnreadCount(),
                    builder: (context, snapshot) {
                      final unreadCount = snapshot.data ?? 0;
                      
                      // Listen for badge updates
                      NotificationService.setOnUnreadCountChanged((count) {
                        if (mounted) setState(() {});
                      });
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: Badge(
                          label: Text('$unreadCount'),
                          isLabelVisible: unreadCount > 0,
                          backgroundColor: Colors.red,
                          child: Container(
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
                            child: IconButton(
                              icon: const Icon(Icons.notifications_outlined, color: Colors.cyanAccent),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NewsScreen(),
                                  ),
                                ).then((_) {
                                  // Refresh badge when returning from news screen
                                  if (mounted) setState(() {});
                                });
                              },
                            ),
                          ),
                        ),
                      )
                        .animate()
                        .scale(delay: 600.ms, duration: 600.ms, curve: Curves.elasticOut)
                        .then()
                        .shake(hz: 2, curve: Curves.easeInOut);
                    },
                  ),
                  
                  // Enhanced User Photo
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyanAccent,
                          Colors.purple,
                          Colors.cyanAccent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: userPhoto != null
                        ? ClipOval(
                            child: Image.file(
                              File(userPhoto),
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const CircleAvatar(
                                  backgroundColor: Colors.cyanAccent,
                                  child: Icon(Icons.person, color: Colors.black),
                                );
                              },
                            ),
                          )
                        : const CircleAvatar(
                            backgroundColor: Colors.cyanAccent,
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                  )
                    .animate()
                    .scale(delay: 800.ms, duration: 600.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 2.seconds, color: Colors.white),
                  

                ],
              ),
            );
          },
        ),
      ),
          body: Stack(
            children: [
              // Revolutionary Animated Background
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
                      painter: BackgroundPatternPainter(_backgroundController.value),
                      size: Size.infinite,
                    ),
                  );
                },
              ),

              // Floating Orbs Background
              AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, child) {
                  return Stack(
                    children: List.generate(8, (index) {
                      double phase = (_backgroundController.value + (index * 0.125)) % 1.0;
                      double x = MediaQuery.of(context).size.width * (0.1 + (index * 0.1));
                      double y = MediaQuery.of(context).size.height * (0.2 + sin(phase * 2 * pi) * 0.3);
                      
                      return Positioned(
                        left: x,
                        top: y,
                        child: Container(
                          width: 20 + sin(phase * 4 * pi) * 5,
                          height: 20 + sin(phase * 4 * pi) * 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.3 * sin(phase * pi)),
                                Colors.purple.withOpacity(0.2 * cos(phase * pi)),
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

              // Content with Page Transition Animation
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.3, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        )),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey(_currentIndex),
                      child: _screens[_currentIndex],
                    ),
                  ),
                ),
              ),

              // Enhanced Glass Bottom Nav
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: GlassBottomNav(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      accessibilityProvider.provideFeedback(
                        text: 'Switched to ${_getScreenName(index)}',
                      );
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getScreenName(int index) {
    switch (index) {
      case 0: return 'Timetable';
      case 1: return 'Alarm';
      case 2: return 'Calendar';
      case 3: return 'Chat';
      default: return 'Screen';
    }
  }

  Widget _buildAnimatedDrawerItem({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    int delay = 0,
    String? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color.withOpacity(0.12),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Add haptic feedback
            onTap();
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.4),
                    color.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 24),
            )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.05, 1.05),
                duration: 2.seconds,
              ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 14,
              ),
            )
              .animate()
              .slideX(begin: -0.2, end: 0, duration: 800.ms, curve: Curves.elasticOut),
          ),
        ),
      ),
    )
      .animate()
      .fadeIn(delay: Duration(milliseconds: delay), duration: 700.ms)
      .slideX(begin: -0.4, end: 0, curve: Curves.easeOutCubic)
      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
      .then()
      .shimmer(
        delay: Duration(milliseconds: delay + 1200),
        duration: 2.5.seconds,
        color: color.withOpacity(0.4),
      );
  }

  Widget _buildAnimatedExpansionTile({
    required IconData icon,
    required String title,
    required Color color,
    required List<Widget> children,
    int delay = 0,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color.withOpacity(0.12),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  color.withOpacity(0.4),
                  color.withOpacity(0.15),
                  Colors.transparent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.05, 1.05),
              duration: 2.5.seconds,
            ),
          title: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          iconColor: color,
          collapsedIconColor: color.withOpacity(0.7),
          children: children.map((child) => 
            child.animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: -0.2, end: 0, curve: Curves.easeOut)
          ).toList(),
        ),
      ),
    )
      .animate()
      .fadeIn(delay: Duration(milliseconds: delay), duration: 700.ms)
      .slideX(begin: -0.4, end: 0, curve: Curves.easeOutCubic)
      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
      .then()
      .shimmer(
        delay: Duration(milliseconds: delay + 1200),
        duration: 2.5.seconds,
        color: color.withOpacity(0.4),
      );
  }
}

// Custom Painter for Drawer Background Pattern
class DrawerPatternPainter extends CustomPainter {
  final double animationValue;

  DrawerPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw animated grid pattern
    for (int i = 0; i < 10; i++) {
      double offset = (animationValue * 50) % 50;
      double x = (i * 20.0) + offset;
      
      if (x < size.width) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );
      }
    }

    // Draw floating circles
    for (int i = 0; i < 5; i++) {
      double phase = (animationValue + (i * 0.2)) % 1.0;
      double x = size.width * 0.2 + (i * size.width * 0.15);
      double y = size.height * 0.3 + sin(phase * 2 * pi) * 30;
      
      canvas.drawCircle(
        Offset(x, y),
        5 + sin(phase * 4 * pi) * 2,
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Background Pattern Painter for Main Screen
class BackgroundPatternPainter extends CustomPainter {
  final double animationValue;

  BackgroundPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.05)
      ..strokeWidth = 1;

    // Draw animated hexagonal pattern
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 15; j++) {
        double x = (i * 40.0) + (j % 2) * 20 + (animationValue * 10) % 40;
        double y = (j * 35.0) + (animationValue * 5) % 35;
        
        if (x < size.width + 40 && y < size.height + 40) {
          _drawHexagon(canvas, Offset(x, y), 15, paint);
        }
      }
    }

    // Draw flowing lines
    final linePaint = Paint()
      ..color = Colors.purple.withOpacity(0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      double startY = size.height * (0.2 + i * 0.15);
      path.moveTo(0, startY);
      
      for (double x = 0; x <= size.width; x += 10) {
        double y = startY + sin((x / 100) + (animationValue * 2 * pi) + (i * pi / 3)) * 20;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, linePaint);
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      double angle = (i * pi) / 3;
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
