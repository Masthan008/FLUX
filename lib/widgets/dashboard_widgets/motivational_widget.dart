import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MotivationalWidget extends StatelessWidget {
  const MotivationalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology, color: Colors.purple, size: 20),
              const SizedBox(width: 8),
              Text(
                'Motivation',
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
            child: Center(
              child: Text(
                '"Success is the sum of small efforts repeated daily."',
                style: GoogleFonts.montserrat(
                  color: Colors.purple.shade200,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}