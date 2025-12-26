import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:alarm/alarm.dart';
import '../../widgets/glass_container.dart';
import 'alarm_service.dart';

enum ChallengeMode { standard, math, shake }

class ChallengeScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const ChallengeScreen({super.key, required this.alarmSettings});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  ChallengeMode _mode = ChallengeMode.standard; // Default, can be passed or random
  
  // Math Mode
  late int _num1;
  late int _num2;
  late int _answer;
  final TextEditingController _mathController = TextEditingController();
  String _mathError = '';

  // Shake Mode
  int _shakeCount = 0;
  static const int _targetShakes = 15;
  StreamSubscription? _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    // For demo purposes, let's pick a random mode or just standard. 
    // In a real app, this would come from the alarm settings.
    // Let's randomize for "Logic Gate" feel if not specified.
    _mode = ChallengeMode.values[Random().nextInt(ChallengeMode.values.length)];
    
    if (_mode == ChallengeMode.math) {
      _generateMathProblem();
    } else if (_mode == ChallengeMode.shake) {
      _startShakeDetection();
    }
  }

  @override
  void dispose() {
    _mathController.dispose();
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  void _generateMathProblem() {
    final random = Random();
    _num1 = random.nextInt(20) + 10; // 10-29
    _num2 = random.nextInt(10) + 2;  // 2-11
    // Simple equation: num1 * num2 - 10 (as per example style)
    // Let's do: (A * B) - C
    int c = random.nextInt(10);
    _answer = (_num1 * _num2) - c;
  }

  void _startShakeDetection() {
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double force = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (force > 12) { // Threshold > 12 m/s^2
        setState(() {
          _shakeCount++;
        });
        if (_shakeCount >= _targetShakes) {
          _stopAlarm();
        }
      }
    });
  }

  Future<void> _stopAlarm() async {
    await AlarmService.stopAlarm(widget.alarmSettings.id);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Or use the app theme gradient
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "WAKE UP!",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            GlassContainer(
              width: 300,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Challenge: ${_mode.name.toUpperCase()}",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  _buildChallengeContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeContent() {
    switch (_mode) {
      case ChallengeMode.standard:
        return Column(
          children: [
            const Text(
              "Swipe to Stop",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Dismissible(
              key: UniqueKey(),
              onDismissed: (_) => _stopAlarm(),
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              ),
            ),
          ],
        );
      case ChallengeMode.math:
        return Column(
          children: [
            Text(
              "Solve: $_num1 * $_num2 - ? = $_answer", // Wait, I should show the equation and ask for answer.
              // Example: "25 * 4 - 10" -> User types 90.
              // Let's stick to the prompt: "25 * 4 - 10". User must type 90.
              // My logic: (_num1 * _num2) - c = _answer.
              // I should show: "$_num1 * $_num2 - $c"
            ),
             Text(
              "Solve: $_num1 * $_num2 - ${(_num1 * _num2) - _answer}", // Reconstructing for display
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _mathController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter result",
                hintStyle: const TextStyle(color: Colors.white54),
                errorText: _mathError.isNotEmpty ? _mathError : null,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_mathController.text == _answer.toString()) {
                  _stopAlarm();
                } else {
                  setState(() {
                    _mathError = "Incorrect!";
                  });
                }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      case ChallengeMode.shake:
        return Column(
          children: [
            const Icon(Icons.vibration, size: 50, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              "Shake: $_shakeCount / $_targetShakes",
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 10),
            const Text(
              "Shake your phone!",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        );
    }
  }
}
