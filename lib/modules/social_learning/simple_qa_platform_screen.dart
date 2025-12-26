import 'package:flutter/material.dart';

class SimpleQAPlatformScreen extends StatelessWidget {
  const SimpleQAPlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.question_answer,
              size: 64,
              color: Colors.green,
            ),
            SizedBox(height: 16),
            Text(
              'Q&A Platform',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Coming Soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}