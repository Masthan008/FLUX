import 'package:flutter/material.dart';

/// Coding challenge model for contest system
class CodingChallenge {
  final String id;
  final String title;
  final String description;
  final String? starterCode;
  final String? expectedOutput;
  final String? testInput;
  final int points;
  final String difficulty; // 'easy', 'medium', 'hard'
  final String language; // 'python', 'java', 'javascript'
  final String minTierRequired;
  final int weekNumber;
  final DateTime createdAt;

  CodingChallenge({
    required this.id,
    required this.title,
    required this.description,
    this.starterCode,
    this.expectedOutput,
    this.testInput,
    this.points = 50,
    this.difficulty = 'easy',
    this.language = 'python',
    this.minTierRequired = 'free',
    this.weekNumber = 1,
    required this.createdAt,
  });

  /// Get difficulty color
  Color get difficultyColor {
    switch (difficulty.toLowerCase()) {
      case 'hard':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  /// Get language icon
  IconData get languageIcon {
    switch (language.toLowerCase()) {
      case 'java':
        return Icons.code;
      case 'javascript':
        return Icons.javascript;
      default:
        return Icons.code; // Python
    }
  }

  /// Check if challenge is locked
  bool get isPremium => minTierRequired != 'free';

  factory CodingChallenge.fromJson(Map<String, dynamic> json) {
    return CodingChallenge(
      id: (json['id'] ?? '').toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      starterCode: json['starter_code'],
      expectedOutput: json['expected_output'],
      testInput: json['test_input'],
      points: json['points'] ?? 50,
      difficulty: json['difficulty'] ?? 'easy',
      language: json['language'] ?? 'python',
      minTierRequired: json['min_tier_required'] ?? 'free',
      weekNumber: json['week_number'] ?? 1,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'starter_code': starterCode,
      'expected_output': expectedOutput,
      'test_input': testInput,
      'points': points,
      'difficulty': difficulty,
      'language': language,
      'min_tier_required': minTierRequired,
      'week_number': weekNumber,
    };
  }
}

/// Student submission model
class ChallengeSubmission {
  final String id;
  final String studentId;
  final String challengeId;
  final String submittedCode;
  final String? output;
  final bool isCorrect;
  final int pointsEarned;
  final DateTime submittedAt;

  ChallengeSubmission({
    required this.id,
    required this.studentId,
    required this.challengeId,
    required this.submittedCode,
    this.output,
    this.isCorrect = false,
    this.pointsEarned = 0,
    required this.submittedAt,
  });

  factory ChallengeSubmission.fromJson(Map<String, dynamic> json) {
    return ChallengeSubmission(
      id: (json['id'] ?? '').toString(),
      studentId: (json['student_id'] ?? '').toString(),
      challengeId: (json['challenge_id'] ?? '').toString(),
      submittedCode: json['submitted_code'] ?? '',
      output: json['output'],
      isCorrect: json['is_correct'] ?? false,
      pointsEarned: json['points_earned'] ?? 0,
      submittedAt: DateTime.tryParse(json['submitted_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'challenge_id': challengeId,
      'submitted_code': submittedCode,
      'output': output,
      'is_correct': isCorrect,
      'points_earned': pointsEarned,
    };
  }
}
