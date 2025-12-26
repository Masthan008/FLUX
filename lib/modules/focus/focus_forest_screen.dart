import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/focus_provider.dart';
import 'forest_history_screen.dart';

class FocusForestScreen extends StatefulWidget {
  const FocusForestScreen({super.key});

  @override
  State<FocusForestScreen> createState() => _FocusForestScreenState();
}

class _FocusForestScreenState extends State<FocusForestScreen> 
    with TickerProviderStateMixin {
  int _selectedDuration = 25; 
  late AnimationController _breathingController;
  late AnimationController _particleController;
  late Animation<double> _breathingAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FocusProvider>(context, listen: false);
      if (provider.treeStatus == TreeStatus.dead) {
        _showDeadDialog();
        provider.resetTree();
      }
    });
  }

  void _initializeAnimations() {
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _breathingAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _showDeadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            const Icon(Icons.dangerous, color: Colors.redAccent, size: 28),
            const SizedBox(width: 10),
            Text('Tree Withered', style: GoogleFonts.orbitron(color: Colors.redAccent)),
          ],
        ),
        content: Text(
          'You left the app! The digital ecosystem couldn\'t sustain your tree.',
          style: GoogleFonts.montserrat(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('TRY AGAIN', style: GoogleFonts.orbitron(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(int forestCount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.park, color: Colors.greenAccent, size: 28),
            const SizedBox(width: 10),
            Text('Focus Complete!', style: GoogleFonts.orbitron(color: Colors.greenAccent)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You stayed focused for $_selectedDuration minutes.',
              style: GoogleFonts.montserrat(color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              'Total Trees: $forestCount 🌲',
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('AWESOME', style: GoogleFonts.orbitron(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusProvider>(
      builder: (context, focusProvider, child) {
        if (focusProvider.timeLeft == 0 && 
            !focusProvider.isFocusing && 
            focusProvider.treeStatus == TreeStatus.tree) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog(focusProvider.forestCount);
            focusProvider.resetTree();
          });
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0F0F0F),
          body: Stack(
            children: [
              // Background Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.2),
                      radius: 1.5,
                      colors: [
                        Colors.green.withOpacity(0.15),
                        const Color(0xFF0F0F0F),
                      ],
                    ),
                  ),
                ),
              ),

              // Animated Particles
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _particleAnimation,
                  builder: (context, child) => CustomPaint(
                    painter: ParticlePainter(_particleAnimation.value),
                  ),
                ),
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(focusProvider),
                      
                      const Spacer(),

                      // Middle Section (Tree & Timer)
                      _buildFocusCenter(focusProvider),

                      const Spacer(),

                      // Bottom Controls
                      if (!focusProvider.isFocusing)
                        _buildControls(focusProvider)
                      else
                        _buildFocusingState(focusProvider),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(FocusProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FOCUS FOREST',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Streak: ${provider.currentStreak} days',
                  style: GoogleFonts.montserrat(color: Colors.orangeAccent, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForestHistoryScreen()),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.park, color: Colors.greenAccent, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${provider.forestCount}',
                  style: GoogleFonts.orbitron(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFocusCenter(FocusProvider provider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular Timer Background
        SizedBox(
          width: 300,
          height: 300,
          child: CircularProgressIndicator(
            value: provider.isFocusing 
              ? 1 - (provider.timeLeft / provider.sessionDuration) 
              : 0,
            strokeWidth: 2,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(
              provider.isFocusing ? Colors.greenAccent.withOpacity(0.5) : Colors.transparent
            ),
          ),
        ),
        
        // Tree Container
        AnimatedBuilder(
          animation: _breathingAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: provider.isFocusing ? _breathingAnimation.value : 1.0,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      provider.getTreeColor().withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: provider.isFocusing ? [
                    BoxShadow(
                      color: provider.getTreeColor().withOpacity(0.3),
                      blurRadius: 50,
                      spreadRadius: 10,
                    )
                  ] : null,
                ),
                child: Icon(
                  provider.getTreeIcon(),
                  size: 120,
                  color: provider.getTreeColor(),
                ),
              ),
            );
          },
        ),

        // Timer Text (Only when focusing)
        if (provider.isFocusing)
          Positioned(
            bottom: 40,
            child: Text(
              provider.formatTime(),
              style: GoogleFonts.orbitron(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildControls(FocusProvider provider) {
    return Column(
      children: [
        // Duration Selector
        Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [10, 15, 25, 30, 45, 60].map((min) {
              final isSelected = _selectedDuration == min;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDuration = min);
                  provider.setSessionDuration(min);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.greenAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? Colors.greenAccent : Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$min m',
                      style: GoogleFonts.orbitron(
                        color: isSelected ? Colors.greenAccent : Colors.white54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Sound Selector
        GestureDetector(
          onTap: () => _showSoundPicker(provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.music_note, color: Colors.cyanAccent.withOpacity(0.7)),
                const SizedBox(width: 10),
                Text(
                  provider.ambientSound,
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_drop_down, color: Colors.white54),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),

        // Start Button
        GestureDetector(
          onTap: () => provider.startFocus(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent.withOpacity(0.8), Colors.green],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'PLANT SEED',
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFocusingState(FocusProvider provider) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Leaving the app will kill your tree!',
                  style: GoogleFonts.montserrat(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Stay Focused...',
          style: GoogleFonts.orbitron(
            color: Colors.white54,
            fontSize: 16,
            letterSpacing: 2,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
         .shimmer(duration: 2.seconds, color: Colors.white),
      ],
    );
  }

  void _showSoundPicker(FocusProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Ambience', style: GoogleFonts.orbitron(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 20),
            ...['Silence', 'Rain', 'Fire', 'Night', 'Library'].map(
              (sound) => ListTile(
                leading: Icon(
                  sound == 'Silence' ? Icons.volume_off : Icons.music_note,
                  color: provider.ambientSound == sound ? Colors.cyanAccent : Colors.grey,
                ),
                title: Text(
                  sound,
                  style: GoogleFonts.montserrat(
                    color: provider.ambientSound == sound ? Colors.cyanAccent : Colors.white,
                  ),
                ),
                onTap: () {
                  provider.setAmbientSound(sound);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42); 

    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height + animationValue * 100) % size.height;
      final opacity = (math.sin(animationValue * 2 * math.pi + i) + 1) / 2 * 0.5;
      
      paint.color = Colors.greenAccent.withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}