import 'dart:math';
import 'package:flutter/material.dart';

class AdvancedParticleSystem extends StatefulWidget {
  final int particleCount;
  final List<Color> colors;
  final double maxSize;
  final double minSize;
  final Duration animationDuration;

  const AdvancedParticleSystem({
    super.key,
    this.particleCount = 50,
    this.colors = const [
      Colors.cyanAccent,
      Colors.purple,
      Colors.pink,
      Colors.orange,
    ],
    this.maxSize = 8.0,
    this.minSize = 2.0,
    this.animationDuration = const Duration(seconds: 10),
  });

  @override
  State<AdvancedParticleSystem> createState() => _AdvancedParticleSystemState();
}

class _AdvancedParticleSystemState extends State<AdvancedParticleSystem>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    particles = List.generate(widget.particleCount, (index) => _createParticle());
  }

  Particle _createParticle() {
    return Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: widget.minSize + random.nextDouble() * (widget.maxSize - widget.minSize),
      color: widget.colors[random.nextInt(widget.colors.length)],
      speedX: (random.nextDouble() - 0.5) * 0.02,
      speedY: (random.nextDouble() - 0.5) * 0.02,
      opacity: 0.3 + random.nextDouble() * 0.7,
      phase: random.nextDouble() * 2 * pi,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final Color color;
  final double speedX;
  final double speedY;
  final double opacity;
  final double phase;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.phase,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      // Update particle position
      particle.x += particle.speedX;
      particle.y += particle.speedY;

      // Wrap around screen
      if (particle.x > 1.0) particle.x = 0.0;
      if (particle.x < 0.0) particle.x = 1.0;
      if (particle.y > 1.0) particle.y = 0.0;
      if (particle.y < 0.0) particle.y = 1.0;

      // Calculate pulsing effect
      double pulse = sin(animationValue * 2 * pi + particle.phase) * 0.3 + 0.7;
      
      // Create gradient paint
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            particle.color.withOpacity(particle.opacity * pulse),
            particle.color.withOpacity(particle.opacity * pulse * 0.5),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(
            particle.x * size.width,
            particle.y * size.height,
          ),
          radius: particle.size * pulse,
        ));

      // Draw particle
      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size * pulse,
        paint,
      );

      // Draw connecting lines between nearby particles
      for (var other in particles) {
        if (other != particle) {
          double distance = sqrt(
            pow((particle.x - other.x) * size.width, 2) +
            pow((particle.y - other.y) * size.height, 2),
          );

          if (distance < 100) {
            final linePaint = Paint()
              ..color = particle.color.withOpacity(
                (particle.opacity * (1 - distance / 100) * 0.3),
              )
              ..strokeWidth = 1;

            canvas.drawLine(
              Offset(particle.x * size.width, particle.y * size.height),
              Offset(other.x * size.width, other.y * size.height),
              linePaint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FloatingOrbs extends StatefulWidget {
  final int orbCount;
  final List<Color> colors;

  const FloatingOrbs({
    super.key,
    this.orbCount = 8,
    this.colors = const [
      Colors.cyanAccent,
      Colors.purple,
      Colors.pink,
    ],
  });

  @override
  State<FloatingOrbs> createState() => _FloatingOrbsState();
}

class _FloatingOrbsState extends State<FloatingOrbs>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<OrbData> orbs;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    orbs = List.generate(widget.orbCount, (index) => _createOrb(index));
  }

  OrbData _createOrb(int index) {
    return OrbData(
      initialX: random.nextDouble(),
      initialY: random.nextDouble(),
      radius: 20 + random.nextDouble() * 40,
      color: widget.colors[random.nextInt(widget.colors.length)],
      speed: 0.1 + random.nextDouble() * 0.3,
      phase: index * (2 * pi / widget.orbCount),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: OrbPainter(orbs, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class OrbData {
  final double initialX;
  final double initialY;
  final double radius;
  final Color color;
  final double speed;
  final double phase;

  OrbData({
    required this.initialX,
    required this.initialY,
    required this.radius,
    required this.color,
    required this.speed,
    required this.phase,
  });
}

class OrbPainter extends CustomPainter {
  final List<OrbData> orbs;
  final double animationValue;

  OrbPainter(this.orbs, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var orb in orbs) {
      // Calculate floating motion
      double x = orb.initialX * size.width + 
          sin(animationValue * 2 * pi * orb.speed + orb.phase) * 50;
      double y = orb.initialY * size.height + 
          cos(animationValue * 2 * pi * orb.speed + orb.phase) * 30;

      // Pulsing effect
      double pulse = sin(animationValue * 4 * pi + orb.phase) * 0.2 + 0.8;
      double currentRadius = orb.radius * pulse;

      // Create gradient paint
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            orb.color.withOpacity(0.6 * pulse),
            orb.color.withOpacity(0.3 * pulse),
            orb.color.withOpacity(0.1 * pulse),
            Colors.transparent,
          ],
          stops: const [0.0, 0.4, 0.7, 1.0],
        ).createShader(Rect.fromCircle(
          center: Offset(x, y),
          radius: currentRadius,
        ));

      // Draw orb
      canvas.drawCircle(
        Offset(x, y),
        currentRadius,
        paint,
      );

      // Draw inner glow
      final innerPaint = Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withOpacity(0.8 * pulse),
            orb.color.withOpacity(0.4 * pulse),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(x, y),
          radius: currentRadius * 0.3,
        ));

      canvas.drawCircle(
        Offset(x, y),
        currentRadius * 0.3,
        innerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}