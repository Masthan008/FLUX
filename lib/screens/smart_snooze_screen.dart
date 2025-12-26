import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/glass_container.dart';

class SmartSnoozeScreen extends StatefulWidget {
  final VoidCallback onSnooze;

  const SmartSnoozeScreen({super.key, required this.onSnooze});

  @override
  State<SmartSnoozeScreen> createState() => _SmartSnoozeScreenState();
}

class _SmartSnoozeScreenState extends State<SmartSnoozeScreen> {
  final List<int> _bubbles = [1, 2, 3, 4, 5];
  final List<Offset> _positions = [];
  int _currentTarget = 1;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generatePositions();
    });
  }

  void _generatePositions() {
    final size = MediaQuery.of(context).size;
    final double bubbleSize = 80;
    final double padding = 20;
    
    _positions.clear();
    for (int i = 0; i < 5; i++) {
      double x = _random.nextDouble() * (size.width - bubbleSize - padding * 2) + padding;
      double y = _random.nextDouble() * (size.height - bubbleSize - padding * 2) + padding;
      _positions.add(Offset(x, y));
    }
    setState(() {});
  }

  void _handleTap(int number) {
    if (number == _currentTarget) {
      if (_currentTarget == 5) {
        // Success
        widget.onSnooze();
      } else {
        setState(() {
          _currentTarget++;
        });
      }
    } else {
      // Wrong tap, maybe shake or reset?
      // For now, just reset progress
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wrong order! Start again from 1."), duration: Duration(seconds: 1)),
      );
      setState(() {
        _currentTarget = 1;
        _generatePositions(); // Shuffle positions to make it harder
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_positions.isEmpty) return const Scaffold(backgroundColor: Colors.black);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: Stack(
        children: [
          const Center(
            child: Text(
              "Tap 1 to 5 in order",
              style: TextStyle(color: Colors.white54, fontSize: 24),
            ),
          ),
          ..._bubbles.map((number) {
            if (number < _currentTarget) return const SizedBox.shrink(); // Hide tapped bubbles

            return Positioned(
              left: _positions[number - 1].dx,
              top: _positions[number - 1].dy,
              child: GestureDetector(
                onTap: () => _handleTap(number),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.cyanAccent, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "$number",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1000.ms),
              ),
            );
          }).toList(),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel", style: TextStyle(color: Colors.white38)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
