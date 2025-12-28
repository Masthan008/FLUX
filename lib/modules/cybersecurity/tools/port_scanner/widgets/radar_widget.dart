import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_animate/flutter_animate.dart';

class RadarWidget extends StatefulWidget {
  final bool isScanning;
  final List<RadarPoint> points;
  final double size;

  const RadarWidget({
    super.key,
    required this.isScanning,
    required this.points,
    this.size = 300,
  });

  @override
  State<RadarWidget> createState() => _RadarWidgetState();
}

class _RadarWidgetState extends State<RadarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    if (widget.isScanning) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RadarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isScanning && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: RadarPainter(
              sweepAngle: _controller.value * 2 * math.pi,
              points: widget.points,
              isScanning: widget.isScanning,
            ),
          );
        },
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double sweepAngle;
  final List<RadarPoint> points;
  final bool isScanning;

  RadarPainter({
    required this.sweepAngle,
    required this.points,
    required this.isScanning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw background circles
    _drawBackgroundCircles(canvas, center, radius);

    // Draw crosshairs
    _drawCrosshairs(canvas, center, radius);

    // Draw sweep line (radar beam)
    if (isScanning) {
      _drawSweepLine(canvas, center, radius);
    }

    // Draw points
    _drawPoints(canvas, center, radius);

    // Draw center dot
    _drawCenterDot(canvas, center);
  }

  void _drawBackgroundCircles(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw 4 concentric circles
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * i / 4, paint);
    }
  }

  void _drawCrosshairs(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Horizontal line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );

    // Vertical line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );
  }

  void _drawSweepLine(Canvas canvas, Offset center, double radius) {
    final sweepPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00FF00).withOpacity(0.8),
          const Color(0xFF00FF00).withOpacity(0.0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        sweepAngle - 0.5,
        0.5,
        false,
      )
      ..close();

    canvas.drawPath(path, sweepPaint);

    // Draw sweep line edge
    final linePaint = Paint()
      ..color = const Color(0xFF00FF00)
      ..strokeWidth = 2.0;

    final lineEnd = Offset(
      center.dx + radius * math.cos(sweepAngle),
      center.dy + radius * math.sin(sweepAngle),
    );

    canvas.drawLine(center, lineEnd, linePaint);
  }

  void _drawPoints(Canvas canvas, Offset center, double radius) {
    for (final point in points) {
      final angle = point.angle * math.pi / 180;
      final distance = point.distance * radius;
      
      final pointOffset = Offset(
        center.dx + distance * math.cos(angle),
        center.dy + distance * math.sin(angle),
      );

      // Draw glow effect
      final glowPaint = Paint()
        ..color = point.color.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

      canvas.drawCircle(pointOffset, 8, glowPaint);

      // Draw point
      final pointPaint = Paint()
        ..color = point.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(pointOffset, 4, pointPaint);

      // Draw pulsing ring
      final ringPaint = Paint()
        ..color = point.color.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(pointOffset, 6, ringPaint);
    }
  }

  void _drawCenterDot(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 4, paint);

    // Outer ring
    final ringPaint = Paint()
      ..color = const Color(0xFF00FFFF).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, 8, ringPaint);
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) {
    return oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.points.length != points.length ||
        oldDelegate.isScanning != isScanning;
  }
}

class RadarPoint {
  final double angle; // 0-360 degrees
  final double distance; // 0-1 (0 = center, 1 = edge)
  final Color color;
  final String label;

  RadarPoint({
    required this.angle,
    required this.distance,
    required this.color,
    this.label = '',
  });
}
