import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/glass_button.dart';
import '../alarm/alarm_provider.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> with TickerProviderStateMixin {
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);
  late AnimationController _moonController;
  late AnimationController _starsController;
  late Animation<double> _moonAnimation;
  late Animation<double> _starsAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _moonController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    
    _starsController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );
    
    _moonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _moonController,
      curve: Curves.easeInOut,
    ));
    
    _starsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _starsController,
      curve: Curves.linear,
    ));
    
    _moonController.repeat(reverse: true);
    _starsController.repeat();
  }

  @override
  void dispose() {
    _moonController.dispose();
    _starsController.dispose();
    super.dispose();
  }

  // Helper function to calculate bedtime based on cycles
  String _calculateBedtime(int cycles) {
    final now = DateTime.now();
    DateTime wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    // If wake time is earlier than now, assume it's for tomorrow
    if (wakeDateTime.isBefore(now)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    final sleepTime = wakeDateTime.subtract(Duration(minutes: cycles * 90));
    return DateFormat.jm().format(sleepTime);
  }

  // Helper to get actual DateTime for alarm setting
  DateTime _getSleepDateTime(int cycles) {
    final now = DateTime.now();
    DateTime wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    if (wakeDateTime.isBefore(now)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    return wakeDateTime.subtract(Duration(minutes: cycles * 90));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null && picked != _wakeTime) {
      setState(() {
        _wakeTime = picked;
      });
    }
  }

  void _setAlarm(int cycles) {
    final sleepTime = _getSleepDateTime(cycles);
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    
    // Create a unique ID based on time
    int id = sleepTime.millisecondsSinceEpoch ~/ 1000;
    
    if (sleepTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This time has already passed!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    alarmProvider.scheduleAlarmWithNote(
      sleepTime,
      'assets/sounds/alarm_1.mp3', // Default sound
      'Bedtime! Time to sleep for optimal rest.',
      loopAudio: false,
      alarmId: id,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Bedtime Alarm set for ${DateFormat.jm().format(sleepTime)}",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyanAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cyclesList = [6, 5, 4]; // 9h, 7.5h, 6h
    final hoursList = ["9 Hours", "7.5 Hours", "6 Hours"];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Sleep Architect", style: TextStyle(color: Colors.cyanAccent)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Animated background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Color(0xFF1A1A2E), Color(0xFF16213e)],
              ),
            ),
          ),
          // Animated stars
          AnimatedBuilder(
            animation: _starsAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: StarsPainter(_starsAnimation.value),
              );
            },
          ),
          // Floating moon
          AnimatedBuilder(
            animation: _moonAnimation,
            builder: (context, child) {
              return Positioned(
                top: 50 + 20 * _moonAnimation.value,
                right: 30 + 10 * _moonAnimation.value,
                child: Transform.rotate(
                  angle: _moonAnimation.value * 0.2,
                  child: Icon(
                    Icons.nightlight_round,
                    size: 60,
                    color: Colors.yellow.withOpacity(0.8),
                  ),
                ),
              );
            },
          ),
          // Main content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "I want to wake up at",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Text(
                      _wakeTime.format(context),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.8, 0.8)),
                const SizedBox(height: 40),
                const Text(
                  "You should fall asleep at:",
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: cyclesList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final cycles = cyclesList[index];
                      final bedtime = _calculateBedtime(cycles);
                      final isBest = index == 1; // 7.5 hours is usually recommended as balanced

                      return GlassContainer(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bedtime,
                                  style: TextStyle(
                                    color: isBest ? Colors.cyanAccent : Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "$cycles Cycles (${hoursList[index]})",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                if (isBest)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'Recommended',
                                      style: TextStyle(
                                        color: Colors.cyanAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isBest ? Colors.cyanAccent.withOpacity(0.2) : Colors.white.withOpacity(0.1),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.add_circle_outline,
                                  size: 32,
                                  color: isBest ? Colors.cyanAccent : Colors.white54,
                                ),
                                onPressed: () => _setAlarm(cycles),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: (900 + index * 200).ms).slideX(begin: 0.3);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for animated stars
class StarsPainter extends CustomPainter {
  final double animationValue;
  
  StarsPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    // Draw twinkling stars
    for (int i = 0; i < 50; i++) {
      final x = (i * 37.0) % size.width;
      final y = (i * 73.0) % size.height;
      
      final twinkle = (animationValue + i * 0.1) % 1.0;
      final opacity = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(twinkle * 2 * math.pi));
      final starSize = 1.0 + 1.5 * (0.5 + 0.5 * math.sin(twinkle * 4 * math.pi));
      
      canvas.drawCircle(
        Offset(x, y),
        starSize,
        paint..color = Colors.white.withOpacity(opacity),
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
