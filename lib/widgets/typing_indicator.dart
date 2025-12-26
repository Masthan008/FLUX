import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/chat_enhanced_service.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: ChatEnhancedService.streamTypingUsers(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final typingUsers = snapshot.data!;
        String text;

        if (typingUsers.length == 1) {
          text = '${typingUsers[0]} is typing...';
        } else if (typingUsers.length == 2) {
          text = '${typingUsers[0]} and ${typingUsers[1]} are typing...';
        } else {
          text = '${typingUsers[0]} and ${typingUsers.length - 1} others are typing...';
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildTypingAnimation(),
              const SizedBox(width: 8),
              Text(
                text,
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypingAnimation() {
    return Row(
      children: [
        _buildDot(0),
        const SizedBox(width: 4),
        _buildDot(1),
        const SizedBox(width: 4),
        _buildDot(2),
      ],
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = (value + delay) % 1.0;
        final opacity = (animValue < 0.5) ? animValue * 2 : (1 - animValue) * 2;
        
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.cyanAccent.withOpacity(opacity),
          ),
        );
      },
      onEnd: () {
        // Restart animation
      },
    );
  }
}
