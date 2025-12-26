import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/challenge_model.dart';
import '../services/student_auth_service.dart';

/// Service for managing coding challenges and submissions
class ChallengeService {
  static final _supabase = Supabase.instance.client;
  
  /// Get all challenges
  static Future<List<CodingChallenge>> getChallenges() async {
    try {
      final response = await _supabase
          .from('coding_challenges')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List).map((item) => CodingChallenge.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching challenges: $e');
      return [];
    }
  }
  
  /// Get challenges by difficulty
  static Future<List<CodingChallenge>> getChallengesByDifficulty(String difficulty) async {
    try {
      final response = await _supabase
          .from('coding_challenges')
          .select()
          .eq('difficulty', difficulty)
          .order('title');
      
      return (response as List).map((item) => CodingChallenge.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching challenges by difficulty: $e');
      return [];
    }
  }
  
  /// Get challenges by week
  static Future<List<CodingChallenge>> getChallengesByWeek(int weekNumber) async {
    try {
      final response = await _supabase
          .from('coding_challenges')
          .select()
          .eq('week_number', weekNumber)
          .order('points', ascending: false);
      
      return (response as List).map((item) => CodingChallenge.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching challenges by week: $e');
      return [];
    }
  }
  
  /// Submit a challenge solution
  static Future<bool> submitChallenge({
    required String challengeId,
    required String submittedCode,
    required String output,
    required bool isCorrect,
    required int pointsEarned,
  }) async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null || student.id == null) {
        print('Error: No student logged in');
        return false;
      }
      
      // Insert or update submission
      await _supabase.from('student_submissions').upsert({
        'student_id': student.id,
        'challenge_id': challengeId,
        'submitted_code': submittedCode,
        'output': output,
        'is_correct': isCorrect,
        'points_earned': isCorrect ? pointsEarned : 0,
      });
      
      // If correct, add points to student
      if (isCorrect) {
        await addPointsToStudent(pointsEarned);
      }
      
      print('✅ Challenge submitted successfully');
      return true;
    } catch (e) {
      print('❌ Error submitting challenge: $e');
      return false;
    }
  }
  
  /// Add points to current student
  static Future<bool> addPointsToStudent(int points) async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null || student.id == null) {
        print('Error: No student logged in');
        return false;
      }
      
      // Get current points
      final response = await _supabase
          .from('students')
          .select('weekly_points, total_points')
          .eq('id', student.id!)
          .single();
      
      final currentWeekly = response['weekly_points'] ?? 0;
      final currentTotal = response['total_points'] ?? 0;
      
      // Update points
      await _supabase.from('students').update({
        'weekly_points': currentWeekly + points,
        'total_points': currentTotal + points,
      }).eq('id', student.id!);
      
      print('✅ Added $points points to student');
      return true;
    } catch (e) {
      print('❌ Error adding points: $e');
      return false;
    }
  }
  
  /// Get leaderboard (top students by weekly points)
  static Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('students')
          .select('id, name, regd_no, image_url, weekly_points, total_points, subscription_tier')
          .order('weekly_points', ascending: false)
          .limit(limit);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }
  
  /// Get student's rank by weekly points
  static Future<int> getStudentRank() async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null || student.id == null) return -1;
      
      // Get all students sorted by weekly points
      final response = await _supabase
          .from('students')
          .select('id, weekly_points')
          .order('weekly_points', ascending: false);
      
      final students = List<Map<String, dynamic>>.from(response);
      
      // Find student's position
      for (int i = 0; i < students.length; i++) {
        if (students[i]['id'] == student.id) {
          return i + 1; // 1-indexed rank
        }
      }
      
      return -1;
    } catch (e) {
      print('Error getting student rank: $e');
      return -1;
    }
  }
  
  /// Check if student has solved a challenge
  static Future<bool> hasSolved(String challengeId) async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null || student.id == null) return false;
      
      final response = await _supabase
          .from('student_submissions')
          .select('is_correct')
          .eq('student_id', student.id!)
          .eq('challenge_id', challengeId)
          .maybeSingle();
      
      if (response == null) return false;
      return response['is_correct'] == true;
    } catch (e) {
      print('Error checking if solved: $e');
      return false;
    }
  }
  
  /// Get student's points
  static Future<Map<String, int>> getStudentPoints() async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null || student.id == null) {
        return {'weekly': 0, 'total': 0};
      }
      
      final response = await _supabase
          .from('students')
          .select('weekly_points, total_points')
          .eq('id', student.id!)
          .single();
      
      return {
        'weekly': response['weekly_points'] ?? 0,
        'total': response['total_points'] ?? 0,
      };
    } catch (e) {
      print('Error getting student points: $e');
      return {'weekly': 0, 'total': 0};
    }
  }
}
