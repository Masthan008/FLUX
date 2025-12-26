import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/dashboard_service.dart';

class QuickStatsWidget extends StatefulWidget {
  const QuickStatsWidget({super.key});

  @override
  State<QuickStatsWidget> createState() => _QuickStatsWidgetState();
}

class _QuickStatsWidgetState extends State<QuickStatsWidget> 
    with TickerProviderStateMixin {
  final DashboardService _dashboardService = DashboardService();
  Map<String, dynamic> _data = {};
  bool _isLoading = true;
  
  late AnimationController _pulseController;
  late AnimationController _counterController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _counterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _counterController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final data = await _dashboardService.getWidgetData(DashboardWidgetType.quickStats);
      setState(() {
        _data = data;
        _isLoading = false;
      });
      // Start counter animation after data loads
      _counterController.forward();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: const CircularProgressIndicator(
                color: Colors.cyanAccent,
                strokeWidth: 3,
              ),
            )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 2.seconds)
              .then()
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2))
              .then()
              .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8)),
            
            const SizedBox(height: 12),
            
            Text(
              'Loading Stats...',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 12,
              ),
            )
              .animate(onPlay: (controller) => controller.repeat())
              .fadeIn(duration: 800.ms)
              .then()
              .fadeOut(duration: 800.ms),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5 + sin(_glowController.value * 2 * pi) * 0.2,
              colors: [
                Colors.cyanAccent.withOpacity(0.05),
                Colors.purple.withOpacity(0.03),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enhanced Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.cyanAccent.withOpacity(0.3),
                          Colors.cyanAccent.withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.analytics,
                      color: Colors.cyanAccent,
                      size: 20,
                    ),
                  )
                    .animate()
                    .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 2.seconds, color: Colors.white),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.cyanAccent,
                          Colors.white,
                          Colors.cyanAccent,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Quick Stats',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 800.ms)
                      .slideX(begin: -0.3, end: 0)
                      .then()
                      .shimmer(duration: 3.seconds, color: Colors.white),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Enhanced Stats Grid
              Expanded(
                child: Column(
                  children: [
                    _buildEnhancedStatRow(
                      'Attendance',
                      _data['attendance_rate']?.toString() ?? '0.0',
                      '%',
                      Icons.school,
                      Colors.green,
                      0,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildEnhancedStatRow(
                      'Sessions',
                      _data['study_sessions']?.toString() ?? '0',
                      '',
                      Icons.timer,
                      Colors.blue,
                      1,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    _buildEnhancedStatRow(
                      'Streak',
                      _data['current_streak']?.toString() ?? '0',
                      ' days',
                      Icons.local_fire_department,
                      Colors.orange,
                      2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEnhancedStatRow(
    String label, 
    String value, 
    String suffix, 
    IconData icon, 
    Color color, 
    int index
  ) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              // Animated Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(0.3),
                      color.withOpacity(0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: Duration(milliseconds: 2000 + index * 200),
                ),
              
              const SizedBox(width: 16),
              
              // Stats Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Animated Counter
                    AnimatedBuilder(
                      animation: _counterController,
                      builder: (context, child) {
                        double animatedValue = double.tryParse(value) ?? 0.0;
                        double displayValue = animatedValue * _counterController.value;
                        
                        return ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [color, Colors.white, color],
                          ).createShader(bounds),
                          child: Text(
                            '${displayValue.toStringAsFixed(suffix == '%' ? 1 : 0)}$suffix',
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  color: color.withOpacity(0.8),
                                  blurRadius: 10,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Label with Glow Effect
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Progress Indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color,
                      color.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  duration: Duration(milliseconds: 1500 + index * 300),
                  color: Colors.white,
                ),
            ],
          ),
        );
      },
    )
      .animate()
      .fadeIn(delay: Duration(milliseconds: 600 + index * 200), duration: 800.ms)
      .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
      .then()
      .shimmer(
        delay: Duration(milliseconds: 1500 + index * 300),
        duration: 2.seconds,
        color: color.withOpacity(0.3),
      );
  }
}