import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                'Recent Activity',
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
                _buildActivityItem('Calculator used', '2h ago', Icons.calculate),
                _buildActivityItem('Message sent', '3h ago', Icons.chat),
                _buildActivityItem('Focus session', '5h ago', Icons.timer),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
                Text(
                  time,
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