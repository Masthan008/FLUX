import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeadlinesWidget extends StatelessWidget {
  const DeadlinesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_note, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'Deadlines',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Column(
              children: [
                _buildDeadlineItem('Math Assignment', '2 days', Colors.red),
                _buildDeadlineItem('Physics Lab', '5 days', Colors.orange),
                _buildDeadlineItem('English Essay', '1 week', Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(String title, String timeLeft, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                Text(
                  timeLeft,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 8,
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