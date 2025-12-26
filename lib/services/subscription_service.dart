import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student_model.dart';
import 'student_auth_service.dart';

/// Subscription tier enum
enum SubscriptionTier { free, pro, ultra }

/// Extension for tier comparisons
extension SubscriptionTierExtension on SubscriptionTier {
  int get level {
    switch (this) {
      case SubscriptionTier.ultra:
        return 3;
      case SubscriptionTier.pro:
        return 2;
      case SubscriptionTier.free:
        return 1;
    }
  }

  String get displayName {
    switch (this) {
      case SubscriptionTier.ultra:
        return 'Ultra';
      case SubscriptionTier.pro:
        return 'Pro';
      case SubscriptionTier.free:
        return 'Free';
    }
  }

  String get price {
    switch (this) {
      case SubscriptionTier.ultra:
        return '₹99';
      case SubscriptionTier.pro:
        return '₹49';
      case SubscriptionTier.free:
        return 'Free';
    }
  }

  Color get color {
    switch (this) {
      case SubscriptionTier.ultra:
        return Colors.purple;
      case SubscriptionTier.pro:
        return Colors.amber;
      case SubscriptionTier.free:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case SubscriptionTier.ultra:
        return Icons.diamond;
      case SubscriptionTier.pro:
        return Icons.star;
      case SubscriptionTier.free:
        return Icons.person;
    }
  }
}

/// Service for handling subscriptions and payments
class SubscriptionService {
  static final _supabase = Supabase.instance.client;

  /// Convert string to tier enum
  static SubscriptionTier stringToTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'ultra':
        return SubscriptionTier.ultra;
      case 'pro':
        return SubscriptionTier.pro;
      default:
        return SubscriptionTier.free;
    }
  }

  /// Get tier level from string
  static int getTierLevel(String tier) {
    return stringToTier(tier).level;
  }

  /// Check if user can access content with required tier
  static bool canAccess(String userTier, String requiredTier) {
    return getTierLevel(userTier) >= getTierLevel(requiredTier);
  }

  /// Get current user's tier
  static SubscriptionTier get currentTier {
    final student = StudentAuthService.currentStudent;
    if (student == null) return SubscriptionTier.free;
    return stringToTier(student.subscriptionTier);
  }

  /// Submit payment request (UTR verification)
  static Future<({bool success, String? error})> submitPaymentRequest({
    required String utrNumber,
    required SubscriptionTier plan,
  }) async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null) {
        return (success: false, error: 'Not logged in');
      }
      
      if (utrNumber.trim().length < 10) {
        return (success: false, error: 'Invalid UTR number (min 10 characters)');
      }
      
      // Check if there's already a pending request
      final existing = await _supabase
          .from('payment_requests')
          .select()
          .eq('student_id', student.id!)
          .eq('status', 'pending')
          .maybeSingle();
      
      if (existing != null) {
        return (success: false, error: 'You already have a pending request. Please wait for approval.');
      }
      
      // Insert payment request
      await _supabase.from('payment_requests').insert({
        'student_id': student.id,
        'utr_number': utrNumber.trim(),
        'requested_plan': plan == SubscriptionTier.ultra ? 'ultra' : 'pro',
        'amount': plan == SubscriptionTier.ultra ? '99' : '49',
        'status': 'pending',
      });
      
      debugPrint('✅ Payment request submitted: $utrNumber for ${plan.displayName}');
      return (success: true, error: null);
    } catch (e) {
      debugPrint('⚠️ Payment request error: $e');
      return (success: false, error: 'Failed to submit request. Please try again.');
    }
  }

  /// Get pending payment requests for current user
  static Future<List<Map<String, dynamic>>> getPendingRequests() async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null) return [];
      
      final data = await _supabase
          .from('payment_requests')
          .select()
          .eq('student_id', student.id!)
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('⚠️ Get requests error: $e');
      return [];
    }
  }

  /// Check if there's a pending payment request
  static Future<bool> hasPendingRequest() async {
    try {
      final student = StudentAuthService.currentStudent;
      if (student == null) return false;
      
      final data = await _supabase
          .from('payment_requests')
          .select()
          .eq('student_id', student.id!)
          .eq('status', 'pending')
          .maybeSingle();
      
      return data != null;
    } catch (e) {
      return false;
    }
  }

  /// Stream subscription changes (for real-time updates)
  static Stream<Student?> subscribeToTierChanges() {
    final student = StudentAuthService.currentStudent;
    if (student == null) return Stream.value(null);
    
    return _supabase
        .from('students')
        .stream(primaryKey: ['id'])
        .eq('id', student.id!)
        .map((data) {
          if (data.isNotEmpty) {
            return Student.fromMap(data.first);
          }
          return null;
        });
  }
}
