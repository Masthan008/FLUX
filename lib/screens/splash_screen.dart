import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/particle_background.dart';
import '../services/auth_service.dart';
import '../animations/slide_up_route.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import '../services/student_auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _logoController;
  late AnimationController _particleController;
  late AnimationController _textController;
  late AnimationController _glowController;
  late AnimationController _waveController;
  
  late Animation<double> _loadingAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _waveAnimation;
  
  double _loadingProgress = 0.0;
  String _loadingText = '🚀 Initializing FluxFlow...';
  String _subText = 'Preparing your learning experience';
  bool _isLoading = true;
  
  final List<String> _loadingMessages = [
    '🔧 Initializing core systems...',
    '🎯 Loading smart features...',
    '🔐 Securing your data...',
    '🌟 Optimizing performance...',
    '🎨 Preparing beautiful UI...',
    '✨ Almost ready...',
    '🎉 Welcome to FluxFlow!'
  ];
  
  final List<String> _subMessages = [
    'Setting up your personalized dashboard',
    'Loading AI-powered study tools',
    'Encrypting your personal information',
    'Calibrating adaptive algorithms',
    'Rendering stunning animations',
    'Final touches in progress',
    'Your learning journey begins now!'
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );

    // Initialize animations
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOutCubic,
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));
    
    _logoRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    ));

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
    _startLoadingSequence();
  }
  
  void _startAnimations() {
    _logoController.forward();
    _particleController.repeat();
    _textController.forward();
    _glowController.repeat(reverse: true);
    _waveController.repeat();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _logoController.dispose();
    _particleController.dispose();
    _textController.dispose();
    _glowController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _startLoadingSequence() async {
    // Enhanced loading sequence with dynamic messages
    for (int i = 0; i < _loadingMessages.length; i++) {
      double progress = (i + 1) / _loadingMessages.length;
      await _updateProgress(progress, _loadingMessages[i], _subMessages[i]);
      
      if (i == 1) {
        await _checkPermissions();
      }
      
      // Variable delays for realistic loading feel
      int delay = i == 0 ? 800 : (i == _loadingMessages.length - 1 ? 1200 : 600);
      await Future.delayed(Duration(milliseconds: delay));
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      // Dramatic pause before navigation
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        await _checkBiometricAndNavigate();
      }
    }
  }

  Future<void> _updateProgress(double progress, String text, String subText) async {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
        _loadingText = text;
        _subText = subText;
      });
      
      // Animate the progress bar with easing
      _loadingController.animateTo(progress, 
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
      
      // Reset and restart text animation for each update
      _textController.reset();
      _textController.forward();
      
      await Future.delayed(const Duration(milliseconds: 300));
    }
  }

  Future<void> _checkPermissions() async {
    // Request necessary permissions (removed location to save memory)
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.notification,
      Permission.scheduleExactAlarm,
      Permission.ignoreBatteryOptimizations, // Critical for alarms
    ].request();

    // Log status for debugging
    debugPrint("Permissions: $statuses");

    if (mounted) {
      await _checkBiometricAndNavigate();
    }
  }

  Future<void> _checkBiometricAndNavigate() async {
    // Simply navigate to the next screen - authentication will be handled in _navigateNext()
    if (mounted) {
      _navigateNext();
    }
  }

  Future<bool> _authenticateUser() async {
    try {
      // Use AuthService for actual biometric authentication
      final result = await AuthService.authenticate();
      debugPrint('Authentication result: $result');
      return result;
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      // Return true for certain errors that shouldn't block access
      if (e.toString().contains('UserCancel') || 
          e.toString().contains('SystemCancel') ||
          e.toString().contains('NotAvailable')) {
        return false; // User cancelled or biometric not available
      }
      return false;
    }
  }

  void _showAuthFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.redAccent, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Authentication Required',
              style: TextStyle(color: Colors.redAccent, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Biometric authentication is required to access the app.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please try again or disable biometric lock in settings.',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Disable biometric and continue
              final userBox = Hive.box('user_prefs');
              await userBox.put('biometric_enabled', false);
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  SlideUpRoute(page: const HomeScreen()),
                );
              }
            },
            child: const Text(
              'Skip Authentication', 
              style: TextStyle(color: Colors.orange),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Retry authentication
              _navigateNext();
            },
            child: const Text(
              'Try Again', 
              style: TextStyle(color: Colors.cyanAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateNext() async {
    try {
      // 1. Wait a moment for visual smoothness
      await Future.delayed(const Duration(seconds: 2));

      // 2. Ask the Service to initialize
      // (This automatically checks SharedPreferences and loads Supabase data)
      final student = await StudentAuthService.init();
      
      if (!mounted) return;

      if (student != null) {
        // ✅ Logged In -> Home
        Navigator.pushReplacement(
          context, 
          SlideUpRoute(page: const HomeScreen())
        );
      } else {
        // ❌ Not Logged In -> Login
        Navigator.pushReplacement(
          context, 
          SlideUpRoute(page: const LoginScreen())
        );
      }
    } catch (e) {
      debugPrint("Splash Error: $e");
      // Safety Net: Go to login if anything explodes
      if (mounted) {
        Navigator.pushReplacement(
          context, 
          SlideUpRoute(page: const LoginScreen())
        );
      }
    }
  }

  void _showOfflineModeDialog(String localUserName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.orange.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            const Icon(Icons.cloud_off, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Offline Mode Detected',
              style: TextStyle(color: Colors.orange, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Found local data for: $localUserName',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'You can continue in offline mode or clear data to login fresh.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            const Text(
              'Offline mode may have limited functionality.',
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Clear all data and go to login
              await StudentAuthService.clearAllData();
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  SlideUpRoute(page: const LoginScreen()),
                );
              }
            },
            child: const Text(
              'Clear & Login Fresh',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Continue in offline mode
              Navigator.pushReplacement(
                context,
                SlideUpRoute(page: const HomeScreen()),
              );
            },
            child: const Text(
              'Continue Offline',
              style: TextStyle(color: Colors.cyanAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              const Color(0xFF0A0A0A),
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              Colors.black,
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Animated Background Waves
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: WavePainter(_waveAnimation.value),
                  size: Size.infinite,
                );
              },
            ),

            // Particle Background
            ParticleBackground(
              child: Container(),
            ),

            // Dynamic Gradient Overlay
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 2.0 * _glowAnimation.value,
                      colors: [
                        Colors.cyanAccent.withOpacity(0.1 * _glowAnimation.value),
                        Colors.purple.withOpacity(0.05 * _glowAnimation.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated App Title with Holographic Effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.cyanAccent,
                        Colors.purple,
                        Colors.pink,
                        Colors.cyanAccent,
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      'FluxFlow',
                      style: GoogleFonts.orbitron(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 1200.ms)
                    .slideY(begin: -0.5, end: 0, curve: Curves.elasticOut)
                    .then()
                    .shimmer(
                      duration: 3.seconds,
                      color: Colors.white,
                      colors: [
                        Colors.cyanAccent,
                        Colors.purple,
                        Colors.pink,
                        Colors.cyanAccent,
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Subtitle with Typewriter Effect
                  Text(
                    'Next-Gen Learning Platform',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 1200.ms, duration: 800.ms)
                    .slideX(begin: -0.3, end: 0)
                    .then()
                    .shimmer(duration: 2.seconds, color: Colors.cyanAccent),

                  const SizedBox(height: 60),

                  // Revolutionary Logo with Multiple Animation Layers
                  AnimatedBuilder(
                    animation: Listenable.merge([_logoScaleAnimation, _logoRotationAnimation, _glowAnimation]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Transform.rotate(
                          angle: _logoRotationAnimation.value * 0.1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer Glow Ring
                              Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.cyanAccent.withOpacity(0.1 * _glowAnimation.value),
                                      Colors.purple.withOpacity(0.2 * _glowAnimation.value),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Middle Ring with Rotation
                              Transform.rotate(
                                angle: _logoRotationAnimation.value * 2,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.cyanAccent.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyanAccent.withOpacity(0.5),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              // Inner Logo Container
                              Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.cyanAccent.withOpacity(0.2),
                                      Colors.purple.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.4),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.asset(
                                    'assets/images/logo.png', 
                                    fit: BoxFit.contain,
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .scale(
                      begin: const Offset(0.98, 0.98),
                      end: const Offset(1.02, 1.02),
                      duration: 4000.ms,
                      curve: Curves.easeInOut,
                    ),

                  const SizedBox(height: 80),

                  // Enhanced Loading Section
                  if (_isLoading) ...[
                    // Main Loading Text with Glow Effect
                    AnimatedBuilder(
                      animation: _textFadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFadeAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - _textFadeAnimation.value)),
                            child: Text(
                              _loadingText,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Colors.cyanAccent.withOpacity(0.8),
                                    blurRadius: 15,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Subtitle Text
                    AnimatedBuilder(
                      animation: _textFadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFadeAnimation.value * 0.8,
                          child: Text(
                            _subText,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white60,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Revolutionary Progress Bar
                    Container(
                      width: 300,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AnimatedBuilder(
                        animation: _loadingAnimation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              // Progress Fill
                              Container(
                                width: 300 * _loadingAnimation.value,
                                height: 6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.cyanAccent,
                                      Colors.purple,
                                      Colors.pink,
                                      Colors.cyanAccent,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.6),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              // Animated Glow Effect
                              if (_loadingAnimation.value > 0)
                                Positioned(
                                  left: (300 * _loadingAnimation.value) - 20,
                                  child: Container(
                                    width: 40,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    )
                      .animate()
                      .fadeIn(delay: 1500.ms, duration: 800.ms)
                      .slideX(begin: -0.3, end: 0),

                    const SizedBox(height: 20),

                    // Animated Progress Percentage
                    AnimatedBuilder(
                      animation: _loadingAnimation,
                      builder: (context, child) {
                        return Text(
                          '${(_loadingProgress * 100).toInt()}%',
                          style: GoogleFonts.orbitron(
                            fontSize: 16,
                            color: Colors.cyanAccent,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.cyanAccent.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                      .animate()
                      .fadeIn(delay: 1800.ms, duration: 600.ms),
                  ] else ...[
                    // Epic Ready State
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyanAccent,
                            Colors.purple,
                            Colors.pink,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        '🚀 Ready to Launch!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    )
                      .animate()
                      .fadeIn(duration: 1000.ms)
                      .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0), curve: Curves.elasticOut)
                      .then()
                      .shimmer(duration: 2.seconds, color: Colors.white)
                      .then(delay: 500.ms)
                      .shake(hz: 2, curve: Curves.easeInOut),
                  ],
                ],
              ),
            ),

            // Enhanced Signature with Holographic Effect
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      Colors.cyanAccent,
                      Colors.purple,
                      Colors.pink,
                      Colors.orange,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    "✨ Crafted with ❤️ by MASTHAN VALLI ✨",
                    style: GoogleFonts.greatVibes(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
                .animate()
                .fadeIn(delay: 3000.ms, duration: 1500.ms)
                .slideY(begin: 0.8, end: 0, curve: Curves.elasticOut)
                .then()
                .shimmer(
                  duration: 4.seconds,
                  colors: [
                    Colors.cyanAccent,
                    Colors.purple,
                    Colors.pink,
                    Colors.orange,
                    Colors.cyanAccent,
                  ],
                ),
            ),

            // Advanced Floating Particles
            ...List.generate(12, (index) {
              return AnimatedBuilder(
                animation: _particleAnimation,
                builder: (context, child) {
                  double offset = (_particleAnimation.value + (index * 0.1)) % 1.0;
                  return Positioned(
                    left: 50 + (index * 30.0) + (20 * sin(offset * 6.28)),
                    top: 150 + (index * 40.0) + (30 * cos(offset * 6.28)),
                    child: Transform.scale(
                      scale: 0.5 + (0.5 * sin(offset * 6.28)),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.cyanAccent.withOpacity(0.8),
                              Colors.purple.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.4),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Custom Wave Painter for Background Animation
class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.cyanAccent.withOpacity(0.1),
          Colors.purple.withOpacity(0.05),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final waveHeight = 30.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height * 0.7);

    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height * 0.7 + 
          waveHeight * sin((x / waveLength * 2 * pi) + (animationValue * 2 * pi));
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
