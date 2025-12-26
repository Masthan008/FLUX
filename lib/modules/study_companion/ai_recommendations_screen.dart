import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIRecommendationsScreen extends StatelessWidget {
  const AIRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'AI Recommendations',
          style: GoogleFonts.orbitron(
            color: Colors.purple,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: Colors.grey.shade900.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text(
                          'Personalized Insights',
                          style: GoogleFonts.orbitron(
                            color: Colors.purple,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRecommendation(
                      'Optimal Study Time',
                      'Based on your patterns, you focus best between 9-11 AM',
                      Icons.schedule,
                      Colors.blue,
                    ),
                    _buildRecommendation(
                      'Session Length',
                      'Try 45-minute sessions with 15-minute breaks for better retention',
                      Icons.timer,
                      Colors.green,
                    ),
                    _buildRecommendation(
                      'Subject Balance',
                      'Consider spending more time on Mathematics this week',
                      Icons.balance,
                      Colors.orange,
                    ),
                    _buildRecommendation(
                      'Focus Improvement',
                      'Remove phone from study area to increase focus score',
                      Icons.psychology_alt,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 12,
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