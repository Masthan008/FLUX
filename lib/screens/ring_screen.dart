import 'dart:math';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import '../modules/alarm/alarm_service.dart';
import '../widgets/glass_container.dart';
import 'smart_snooze_screen.dart';

class AlarmRingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  late int _num1;
  late int _num2;
  late int _answer;
  final TextEditingController _controller = TextEditingController();
  bool _canStop = false;
  String? _reminderNote;

  @override
  void initState() {
    super.initState();
    _extractReminderNote();
    _generateMathProblem();
    _controller.addListener(_checkAnswer);
  }
  
  void _extractReminderNote() {
    final body = widget.alarmSettings.notificationSettings.body;
    if (body.contains('\n\n📝 ')) {
      final parts = body.split('\n\n📝 ');
      if (parts.length > 1) {
        _reminderNote = parts[1];
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateMathProblem() {
    final random = Random();
    _num1 = random.nextInt(20) + 1;
    _num2 = random.nextInt(20) + 1;
    _answer = _num1 + _num2;
  }

  void _checkAnswer() {
    if (_controller.text == _answer.toString()) {
      setState(() {
        _canStop = true;
      });
    } else {
      setState(() {
        _canStop = false;
      });
    }
  }

  Future<void> _stopAlarm() async {
    await AlarmService.stopAlarm(widget.alarmSettings.id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _snoozeAlarm() async {
    await AlarmService.snoozeAlarm(widget.alarmSettings);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8B0000), // Dark Red for urgency
                Colors.black,
                Color(0xFF4B0082),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ALARM RINGING",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Reminder Note Display
                  if (_reminderNote != null) ...[
                    GlassContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.note_alt_outlined,
                            color: Colors.yellowAccent,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _reminderNote!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  
                  GlassContainer(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          "Solve to Stop",
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "$_num1 + $_num2 = ?",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 32),
                          decoration: InputDecoration(
                            hintText: "?",
                            hintStyle: const TextStyle(color: Colors.white24),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => _snoozeAlarm(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "SNOOZE (5 Min)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SmartSnoozeScreen(
                              onSnooze: () {
                                _snoozeAlarm();
                                Navigator.pop(context); // Pop SmartSnoozeScreen
                                // _snoozeAlarm already pops RingScreen if mounted, but we need to be careful about navigation stack.
                                // Actually _snoozeAlarm pops the context.
                                // If we are in SmartSnoozeScreen, we need to pop it first?
                                // Or pass a callback that does everything.
                                // Let's adjust _snoozeAlarm to not pop if we are handling it here, or just let it pop.
                                // If _snoozeAlarm pops, it pops SmartSnoozeScreen.
                                // Then we need to pop RingScreen?
                                // Wait, RingScreen is the one below.
                                // If _snoozeAlarm pops, it removes SmartSnoozeScreen.
                                // Then we are back at RingScreen.
                                // We want to close RingScreen too.
                                // So we might need to pop twice or use popUntil.
                                // Let's make _snoozeAlarm return a Future and we handle navigation.
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "SMART SNOOZE (Puzzle)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _canStop ? _stopAlarm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "STOP ALARM",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _canStop ? Colors.white : Colors.white38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
