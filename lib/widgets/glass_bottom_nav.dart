import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'glass_container.dart';

class GlassBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<GlassBottomNav> createState() => _GlassBottomNavState();
}

class _GlassBottomNavState extends State<GlassBottomNav>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _pulseController;
  late List<AnimationController> _itemControllers;

  @override
  void initState() {
    super.initState();
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    // Create individual controllers for each nav item
    _itemControllers = List.generate(4, (index) {
      return AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _pulseController.dispose();
    for (var controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(GlassBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      // Animate the selected item
      _itemControllers[widget.currentIndex].forward();
      if (oldWidget.currentIndex < _itemControllers.length) {
        _itemControllers[oldWidget.currentIndex].reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
      child: Stack(
        children: [
          // Animated Background Glow
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.cyanAccent.withOpacity(0.1 + sin(_backgroundController.value * 2 * pi) * 0.05),
                      Colors.purple.withOpacity(0.1 + cos(_backgroundController.value * 2 * pi) * 0.05),
                      Colors.pink.withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              );
            },
          ),
          
          // Main Glass Container
          GlassContainer(
            width: double.infinity,
            height: 70,
            borderRadius: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: [
                // Animated Selection Indicator
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      left: (MediaQuery.of(context).size.width - 40) / 4 * widget.currentIndex + 8,
                      top: 8,
                      child: Container(
                        width: (MediaQuery.of(context).size.width - 40) / 4 - 16,
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: RadialGradient(
                            colors: [
                              Colors.cyanAccent.withOpacity(0.3 * _pulseController.value),
                              Colors.purple.withOpacity(0.2 * _pulseController.value),
                              Colors.transparent,
                            ],
                          ),
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // Navigation Items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavItem(0, Icons.calendar_today_outlined, Icons.calendar_today, "Timetable", Colors.cyanAccent),
                    _buildNavItem(1, Icons.alarm_outlined, Icons.alarm, "Alarm", Colors.orange),
                    _buildNavItem(2, Icons.event_outlined, Icons.event, "Calendar", Colors.green),
                    _buildNavItem(3, Icons.chat_bubble_outline, Icons.chat_bubble, "ChatHub", Colors.pink),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
      .animate()
      .slideY(begin: 1, end: 0, duration: 800.ms, curve: Curves.elasticOut)
      .fadeIn(duration: 600.ms);
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label, Color color) {
    final bool isSelected = widget.currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: AnimatedBuilder(
          animation: _itemControllers[index],
          builder: (context, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Icon Container
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.all(isSelected ? 8 : 6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isSelected
                          ? RadialGradient(
                              colors: [
                                color.withOpacity(0.3),
                                color.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulsing Background for Selected Item
                        if (isSelected)
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 30 + _pulseController.value * 10,
                                height: 30 + _pulseController.value * 10,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      color.withOpacity(0.2 * _pulseController.value),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        
                        // Main Icon
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: RotationTransition(
                                turns: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            isSelected ? activeIcon : icon,
                            key: ValueKey(isSelected),
                            color: isSelected ? color : Colors.white70,
                            size: isSelected ? 26 : 22,
                            shadows: isSelected
                                ? [
                                    Shadow(
                                      color: color.withOpacity(0.8),
                                      blurRadius: 10,
                                      offset: const Offset(0, 0),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Animated Label
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: isSelected ? 16 : 0,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isSelected ? 1.0 : 0.0,
                      child: Text(
                        label,
                        style: GoogleFonts.poppins(
                          color: color,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                          shadows: [
                            Shadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    )
      .animate()
      .fadeIn(delay: Duration(milliseconds: index * 100), duration: 600.ms)
      .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
      .then()
      .shimmer(
        delay: Duration(milliseconds: 1000 + index * 200),
        duration: 2.seconds,
        color: color.withOpacity(0.3),
      );
  }
}
