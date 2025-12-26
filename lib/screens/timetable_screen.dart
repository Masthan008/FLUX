import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/class_session.dart';
import '../widgets/glass_container.dart';
import '../services/timetable_service.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> 
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _headerAnimationController;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    scheduleDailyNotifications();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animationController.forward();
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  Future<void> scheduleDailyNotifications() async {
    final box = Hive.box<ClassSession>('class_sessions');
    final sessions = box.values.toList();
    final now = DateTime.now();
    final today = now.weekday;

    // Get today's classes
    final todayClasses = sessions.where((s) => s.dayOfWeek == today).toList();

    for (var session in todayClasses) {
      // Calculate notification time (5 minutes before class)
      final classTime = session.startTime;
      final notificationTime = classTime.subtract(const Duration(minutes: 5));

      // Only schedule if the notification time is in the future
      if (notificationTime.isAfter(now)) {
        final alarmId = session.hashCode % 100000 + 50000; // Unique ID for timetable alarms
        
        try {
          await Alarm.set(
            alarmSettings: AlarmSettings(
              id: alarmId,
              dateTime: notificationTime,
              assetAudioPath: 'assets/sounds/alarm_1.mp3',
              loopAudio: false,
              vibrate: true,
              androidFullScreenIntent: false,
              volumeSettings: VolumeSettings.fade(
                volume: 0.5,
                fadeDuration: const Duration(seconds: 3),
                volumeEnforced: false,
              ),
              notificationSettings: NotificationSettings(
                title: 'Class Starting Soon',
                body: '${session.subjectName} starts in 5 minutes',
                stopButton: 'OK',
              ),
            ),
          );
        } catch (e) {
          debugPrint('Error scheduling notification for ${session.subjectName}: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              const Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.cyanAccent,
                        size: 24,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.3),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Class Timetable',
                            style: GoogleFonts.orbitron(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent,
                            ),
                          ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3),
                          Text(
                            'Your academic schedule',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.3),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.cyanAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.cyanAccent.withOpacity(0.3),
                        ),
                      ),
                      child: Icon(
                        Icons.schedule_rounded,
                        color: Colors.cyanAccent,
                        size: 24,
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.8, 0.8)),
                  ],
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<ClassSession>('class_sessions').listenable(),
                  builder: (context, Box<ClassSession> box, _) {
                    final sessions = box.values.toList();

                    if (sessions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: Icon(
                                Icons.schedule_outlined,
                                size: 64,
                                color: Colors.grey.shade600,
                              ),
                            ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(),
                            const SizedBox(height: 24),
                            Text(
                              'No classes scheduled',
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade400,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ).animate().fadeIn(delay: 200.ms),
                            const SizedBox(height: 8),
                            Text(
                              'Your timetable will appear here',
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ).animate().fadeIn(delay: 300.ms),
                          ],
                        ),
                      );
                    }

                    // Group sessions by day
                    final sessionsByDay = <int, List<ClassSession>>{};
                    for (var session in sessions) {
                      sessionsByDay.putIfAbsent(session.dayOfWeek, () => []);
                      sessionsByDay[session.dayOfWeek]!.add(session);
                    }

                    // Sort sessions within each day by start time
                    for (var daySessions in sessionsByDay.values) {
                      daySessions.sort(
                          (a, b) => a.startTime.compareTo(b.startTime));
                    }

                    final dayNames = [
                      '',
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday'
                    ];

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: sessionsByDay.length,
                      itemBuilder: (context, index) {
                        final dayOfWeek =
                            sessionsByDay.keys.toList()..sort();
                        final day = dayOfWeek[index];
                        final daySessions = sessionsByDay[day]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyanAccent.withOpacity(0.2),
                                    Colors.cyanAccent.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.cyanAccent.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.cyanAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    dayNames[day],
                                    style: GoogleFonts.orbitron(
                                      color: Colors.cyanAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${daySessions.length} classes',
                                      style: GoogleFonts.poppins(
                                        color: Colors.cyanAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(delay: (500 + index * 100).ms).slideX(begin: -0.3),
                            ...daySessions.asMap().entries.map((entry) {
                              final sessionIndex = entry.key;
                              final session = entry.value;
                              return _buildEnhancedClassCard(context, session, index, sessionIndex);
                            }),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedClassCard(BuildContext context, ClassSession session, int dayIndex, int sessionIndex) {
    // Read time format preference from Hive
    final userPrefs = Hive.box('user_prefs');
    final use24h = userPrefs.get('use24h', defaultValue: false);
    
    // Format time based on preference
    final timeFormat = use24h ? DateFormat('HH:mm') : DateFormat('h:mm a');
    final startTime = timeFormat.format(session.startTime);
    final endTime = timeFormat.format(session.endTime);
    
    // Get full subject name from TimetableService
    final fullName = TimetableService.subjectNames[session.subjectName] ?? session.subjectName;
    final subjectColor = _getSubjectColor(session.subjectName);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: subjectColor.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: subjectColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Enhanced Subject Indicator
            Container(
              width: 6,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    subjectColor,
                    subjectColor.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: subjectColor.withOpacity(0.5),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            
            // Enhanced Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          session.subjectName,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: subjectColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: subjectColor.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          'Room TBA',
                          style: GoogleFonts.poppins(
                            color: subjectColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    fullName,
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade300,
                      fontSize: 13,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: subjectColor,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$startTime - $endTime',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      // Duration indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${session.endTime.difference(session.startTime).inMinutes}min',
                          style: GoogleFonts.poppins(
                            color: Colors.white60,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
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
    ).animate().fadeIn(delay: (600 + dayIndex * 200 + sessionIndex * 100).ms).slideX(begin: sessionIndex.isEven ? -0.3 : 0.3);
  }

  Color _getSubjectColor(String subjectName) {
    final colors = {
      'BCE': Colors.cyanAccent,
      'CE': Colors.greenAccent,
      'LAAC': Colors.yellowAccent,
      'CHE': Colors.orangeAccent,
      'EWS': Colors.purpleAccent,
      'IP LAB': Colors.pinkAccent,
      'SS': Colors.blueAccent,
      'EC LAB': Colors.tealAccent,
      'BME': Colors.limeAccent,
      'IP': Colors.indigoAccent,
      'CE LAB': Colors.lightGreenAccent,
      'EAA': Colors.amberAccent,
    };
    return colors[subjectName] ?? Colors.white;
  }
}
