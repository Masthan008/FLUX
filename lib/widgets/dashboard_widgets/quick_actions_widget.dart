import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../modules/calculator/calculator_screen.dart';
import '../../modules/focus/focus_forest_screen.dart';
import '../../modules/academic/books_notes_screen.dart';
import '../../screens/chat_screen.dart';

class QuickActionsWidget extends StatefulWidget {
  const QuickActionsWidget({super.key});

  @override
  State<QuickActionsWidget> createState() => _QuickActionsWidgetState();
}

class _QuickActionsWidgetState extends State<QuickActionsWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5 + sin(_glowController.value * 2 * pi) * 0.2,
              colors: [
                Colors.orange.withOpacity(0.05),
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
                          Colors.orange.withOpacity(0.3),
                          Colors.orange.withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.flash_on,
                      color: Colors.orange,
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
                          Colors.orange,
                          Colors.white,
                          Colors.orange,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        'Quick Actions',
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
              
              // Enhanced Actions Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _buildEnhancedActionButton(
                      context,
                      'Calculator',
                      Icons.calculate,
                      Colors.green,
                      0,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalculatorScreen(),
                        ),
                      ),
                    ),
                    _buildEnhancedActionButton(
                      context,
                      'Focus Timer',
                      Icons.timer,
                      Colors.orange,
                      1,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FocusForestScreen(),
                        ),
                      ),
                    ),
                    _buildEnhancedActionButton(
                      context,
                      'Notes',
                      Icons.note_add,
                      Colors.blue,
                      2,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BooksNotesScreen(),
                        ),
                      ),
                    ),
                    _buildEnhancedActionButton(
                      context,
                      'ChatHub',
                      Icons.chat_bubble,
                      Colors.purple,
                      3,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreen(),
                        ),
                      ),
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

  Widget _buildEnhancedActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    int index,
    VoidCallback onTap,
  ) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        double floatOffset = sin((_floatController.value * 2 * pi) + (index * pi / 2)) * 3;
        
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.2),
                    color.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(
                  color: color.withOpacity(0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background Pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ActionButtonPatternPainter(color, _glowController.value),
                    ),
                  ),
                  
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated Icon Container
                        Container(
                          padding: const EdgeInsets.all(12),
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
                                color: color.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 28,
                            shadows: [
                              Shadow(
                                color: color.withOpacity(0.8),
                                blurRadius: 10,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                        )
                          .animate(onPlay: (controller) => controller.repeat(reverse: true))
                          .scale(
                            begin: const Offset(0.9, 0.9),
                            end: const Offset(1.1, 1.1),
                            duration: Duration(milliseconds: 1500 + index * 200),
                          ),
                        
                        const SizedBox(height: 8),
                        
                        // Enhanced Label
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [color, Colors.white, color],
                          ).createShader(bounds),
                          child: Text(
                            label,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    )
      .animate()
      .fadeIn(delay: Duration(milliseconds: 600 + index * 150), duration: 800.ms)
      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), curve: Curves.elasticOut)
      .then()
      .shimmer(
        delay: Duration(milliseconds: 1500 + index * 300),
        duration: 2.seconds,
        color: color.withOpacity(0.3),
      );
  }
}

// Custom Painter for Action Button Background Pattern
class ActionButtonPatternPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  ActionButtonPatternPainter(this.color, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw animated diagonal lines
    for (int i = 0; i < 8; i++) {
      double offset = (animationValue * 20) % 20;
      double x = (i * 10.0) + offset - 20;
      
      if (x < size.width + 20) {
        canvas.drawLine(
          Offset(x, 0),
          Offset(x + size.height, size.height),
          paint,
        );
      }
    }

    // Draw corner accent
    final accentPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width - 10, 10),
      5 + sin(animationValue * 2 * pi) * 2,
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}