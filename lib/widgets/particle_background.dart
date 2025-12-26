import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ParticleBackground extends StatefulWidget {
  final Widget child;

  const ParticleBackground({super.key, required this.child});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();
  bool _powerSaverMode = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate 50 particles
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: 0.001 + _random.nextDouble() * 0.002,
        size: 2 + _random.nextDouble() * 3,
      ));
    }

    _controller.addListener(() {
      if (!_powerSaverMode) {
        setState(() {
          for (var particle in _particles) {
            particle.y -= particle.speed;
            if (particle.y < 0) {
              particle.y = 1.0;
              particle.x = _random.nextDouble();
            }
          }
        });
      }
    });
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox('app_settings');
    final powerSaver = box.get('power_saver_mode', defaultValue: false);
    if (mounted) {
      setState(() => _powerSaverMode = powerSaver);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If power saver mode is enabled, skip the CustomPaint to save CPU
    if (_powerSaverMode) {
      return widget.child;
    }
    
    return Stack(
      children: [
        CustomPaint(
          painter: ParticlePainter(_particles),
          size: Size.infinite,
        ),
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double speed;
  double size;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      final dx = particle.x * size.width;
      final dy = particle.y * size.height;
      canvas.drawCircle(Offset(dx, dy), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
