import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class HolographicText extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Duration animationDuration;
  final List<Color> colors;

  const HolographicText({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
    this.animationDuration = const Duration(seconds: 3),
    this.colors = const [
      Colors.cyanAccent,
      Colors.purple,
      Colors.pink,
      Colors.orange,
    ],
  });

  @override
  State<HolographicText> createState() => _HolographicTextState();
}

class _HolographicTextState extends State<HolographicText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.colors,
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                (_animation.value - 0.1).clamp(0.0, 1.0),
                (_animation.value + 0.1).clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: GoogleFonts.orbitron(
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: widget.colors.first.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  color: widget.colors.last.withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration glitchDuration;

  const GlitchText({
    super.key,
    required this.text,
    required this.style,
    this.glitchDuration = const Duration(milliseconds: 100),
  });

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isGlitching = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.glitchDuration,
      vsync: this,
    );

    // Random glitch effect
    _startRandomGlitch();
  }

  void _startRandomGlitch() {
    Future.delayed(Duration(seconds: 2 + (DateTime.now().millisecond % 3)), () {
      if (mounted) {
        setState(() => _isGlitching = true);
        _controller.forward().then((_) {
          if (mounted) {
            setState(() => _isGlitching = false);
            _controller.reset();
            _startRandomGlitch();
          }
        });
      }
    });
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
        if (!_isGlitching) {
          return Text(widget.text, style: widget.style);
        }

        return Stack(
          children: [
            // Original text
            Text(widget.text, style: widget.style),
            
            // Red glitch layer
            Transform.translate(
              offset: Offset(-2 * _controller.value, 0),
              child: Text(
                widget.text,
                style: widget.style.copyWith(
                  color: Colors.red.withOpacity(0.7),
                ),
              ),
            ),
            
            // Blue glitch layer
            Transform.translate(
              offset: Offset(2 * _controller.value, 0),
              child: Text(
                widget.text,
                style: widget.style.copyWith(
                  color: Colors.blue.withOpacity(0.7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class NeonText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Color neonColor;
  final double intensity;

  const NeonText({
    super.key,
    required this.text,
    required this.style,
    this.neonColor = Colors.cyanAccent,
    this.intensity = 1.0,
  });

  @override
  State<NeonText> createState() => _NeonTextState();
}

class _NeonTextState extends State<NeonText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.text,
          style: widget.style.copyWith(
            shadows: [
              Shadow(
                color: widget.neonColor.withOpacity(_animation.value * widget.intensity),
                blurRadius: 10 * _animation.value * widget.intensity,
                offset: const Offset(0, 0),
              ),
              Shadow(
                color: widget.neonColor.withOpacity(_animation.value * widget.intensity * 0.5),
                blurRadius: 20 * _animation.value * widget.intensity,
                offset: const Offset(0, 0),
              ),
              Shadow(
                color: widget.neonColor.withOpacity(_animation.value * widget.intensity * 0.3),
                blurRadius: 30 * _animation.value * widget.intensity,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        );
      },
    );
  }
}