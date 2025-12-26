import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/student_model.dart';

/// Service for student authentication with Supabase
class StudentAuthService {
  static final _supabase = Supabase.instance.client;
  static Student? _currentStudent;

  /// Get Supabase client for direct access (e.g., RPC calls)
  static SupabaseClient get supabase => _supabase;

  /// Get current logged in student
  static Student? get currentStudent => _currentStudent;

  /// Check if user is logged in
  static bool get isLoggedIn => _currentStudent != null;

  /// Initialize auth - check if user is already logged in
  static Future<Student?> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final regdNo = prefs.getString('currentUserRegd');
      
      if (regdNo != null && regdNo.isNotEmpty) {
        // Fetch fresh data from Supabase
        final data = await _supabase
            .from('students')
            .select()
            .eq('regd_no', regdNo)
            .maybeSingle();
        
        if (data != null) {
          _currentStudent = Student.fromMap(data);
          debugPrint('✅ Auto-login: ${_currentStudent!.name}');
          return _currentStudent;
        }
      }
    } catch (e) {
      debugPrint('⚠️ Auth init error: $e');
    }
    return null;
  }

  /// Login with Name and Registration Number
  static Future<({Student? student, String? error})> login(String name, String regdNo) async {
    try {
      name = name.trim();
      regdNo = regdNo.trim().toUpperCase();
      
      if (name.isEmpty || regdNo.isEmpty) {
        return (student: null, error: 'Please fill all fields');
      }
      
      // Search for student with matching Name AND RegdNo
      final data = await _supabase
          .from('students')
          .select()
          .eq('regd_no', regdNo)
          .eq('name', name)
          .maybeSingle();
      
      if (data == null) {
        return (student: null, error: 'Invalid Name or Registration Number');
      }
      
      _currentStudent = Student.fromMap(data);
      
      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserRegd', _currentStudent!.regdNo);
      await prefs.setString('currentUserName', _currentStudent!.name);
      
      debugPrint('✅ Login success: ${_currentStudent!.name}');
      return (student: _currentStudent, error: null);
    } catch (e) {
      debugPrint('⚠️ Login error: $e');
      return (student: null, error: 'Login failed. Please try again.');
    }
  }

  /// Register new student
  static Future<({bool success, String? error})> register({
    required String name,
    required String regdNo,
    required String group,
    required String section,
    required String year,
    String? imageUrl,
  }) async {
    try {
      name = name.trim();
      regdNo = regdNo.trim().toUpperCase();
      
      debugPrint('📝 Registering: $name, $regdNo, $group, $section, $year');
      
      if (name.isEmpty || regdNo.isEmpty || group.isEmpty || 
          section.isEmpty || year.isEmpty) {
        debugPrint('⚠️ Registration failed: Empty fields');
        return (success: false, error: 'Please fill all required fields');
      }
      
      // Check if RegdNo already exists
      debugPrint('🔍 Checking if regd_no exists...');
      final existing = await _supabase
          .from('students')
          .select()
          .eq('regd_no', regdNo)
          .maybeSingle();
      
      if (existing != null) {
        debugPrint('⚠️ Registration failed: RegdNo already exists');
        return (success: false, error: 'Registration number already exists! Try logging in.');
      }
      
      // Create new student
      final student = Student(
        name: name,
        regdNo: regdNo,
        group: group,
        section: section,
        year: year,
        imageUrl: imageUrl,
        subscriptionTier: 'free',
      );
      
      debugPrint('📤 Inserting to Supabase: ${student.toMap()}');
      
      // Insert into Supabase
      final response = await _supabase.from('students').insert(student.toMap()).select();
      
      debugPrint('✅ Registration response: $response');
      debugPrint('✅ Registration success: $name');
      return (success: true, error: null);
    } catch (e, stack) {
      debugPrint('❌ Registration error: $e');
      debugPrint('📋 Stack trace: $stack');
      return (success: false, error: 'Registration failed: $e');
    }
  }

  /// Logout current user
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUserRegd');
      await prefs.remove('currentUserName');
      _currentStudent = null;
      debugPrint('✅ Logout success');
    } catch (e) {
      debugPrint('⚠️ Logout error: $e');
    }
  }

  /// Clear all cached data and force fresh login
  static Future<void> clearAllData() async {
    try {
      debugPrint('🧹 Clearing all cached data...');
      
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUserRegd');
      await prefs.remove('currentUserName');
      
      // Clear Hive data
      if (Hive.isBoxOpen('user_prefs')) {
        final box = Hive.box('user_prefs');
        await box.clear();
      }
      
      // Clear memory cache
      _currentStudent = null;
      
      debugPrint('✅ All cached data cleared');
    } catch (e) {
      debugPrint('⚠️ Error clearing data: $e');
    }
  }

  /// Refresh current student data from Supabase
  static Future<Student?> refreshCurrentStudent() async {
    if (_currentStudent == null) return null;
    
    try {
      debugPrint('🔄 Refreshing student data for: ${_currentStudent!.regdNo}');
      
      final data = await _supabase
          .from('students')
          .select()
          .eq('regd_no', _currentStudent!.regdNo)
          .maybeSingle();
      
      if (data != null) {
        _currentStudent = Student.fromMap(data);
        debugPrint('✅ Student data refreshed: ${_currentStudent!.name}, Mobile: ${_currentStudent!.mobileNumber}');
        return _currentStudent;
      } else {
        debugPrint('⚠️ No data found for student: ${_currentStudent!.regdNo}');
      }
    } catch (e) {
      debugPrint('⚠️ Refresh error: $e');
    }
    return null;
  }

  /// Force refresh from Supabase (ignores cache)
  /// ROBUST VERSION: Checks disk (SharedPreferences) first, doesn't rely on _currentStudent variable
  static Future<Student?> forceRefreshFromSupabase() async {
    try {
      // 1. Don't trust the variable, trust the disk (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      final regdNo = prefs.getString('currentUserRegd');
      
      // 2. If no saved login, we can't refresh
      if (regdNo == null || regdNo.isEmpty) {
        debugPrint("AuthService: No saved registration number found.");
        return null;
      }
      
      debugPrint('🔄 Force refreshing from Supabase for: $regdNo');
      
      // 3. Fetch fresh data using the saved ID
      final data = await _supabase
          .from('students')
          .select()
          .eq('regd_no', regdNo)
          .maybeSingle();
      
      // 4. Update the global variable
      if (data != null) {
        _currentStudent = Student.fromMap(data);
        debugPrint("AuthService: Profile refreshed for ${_currentStudent!.name}");
        return _currentStudent;
      }
      
      return null;
    } catch (e) {
      debugPrint("AuthService Error: $e");
      return null;
    }
  }

  /// Update student profile
  static Future<bool> updateProfile({
    String? name,
    String? imageUrl,
    String? mobileNumber,
    String? email,
    String? group,
    String? section,
    String? year,
  }) async {
    if (_currentStudent == null) return false;
    
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      if (mobileNumber != null) updates['mobile_number'] = mobileNumber;
      if (email != null) updates['email'] = email;
      if (group != null) updates['group_name'] = group;
      if (section != null) updates['section'] = section;
      if (year != null) updates['year'] = year;
      
      if (updates.isEmpty) return true;
      
      debugPrint('📤 Updating profile with: $updates');
      
      await _supabase
          .from('students')
          .update(updates)
          .eq('id', _currentStudent!.id!);
      
      // Refresh local data
      await refreshCurrentStudent();
      debugPrint('✅ Profile updated successfully');
      return true;
    } catch (e) {
      debugPrint('⚠️ Update profile error: $e');
      return false;
    }
  }

  /// Upload profile image to Supabase Storage
  /// Returns the public URL of the uploaded image, or null on error
  static Future<String?> uploadProfileImage(File imageFile) async {
    if (_currentStudent == null) return null;
    
    try {
      final fileName = '${_currentStudent!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'profile-images/$fileName';
      
      debugPrint('📤 Uploading profile image: $filePath');
      
      // Upload to Supabase Storage
      await _supabase.storage
          .from('profile-images')
          .upload(filePath, imageFile,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: true,
              ));
      
      // Get public URL with cache busting
      final publicUrl = _supabase.storage
          .from('profile-images')
          .getPublicUrl(filePath);
      
      // Add cache-busting query parameter to force browser refresh
      final cacheBustedUrl = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
      
      debugPrint('✅ Image uploaded: $cacheBustedUrl');
      return cacheBustedUrl;
    } catch (e) {
      debugPrint('⚠️ Image upload error: $e');
      return null;
    }
  }

  /// Pick and upload profile image
  /// Returns the public URL or null
  static Future<String?> pickAndUploadProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (pickedFile == null) return null;
      
      final imageFile = File(pickedFile.path);
      return await uploadProfileImage(imageFile);
    } catch (e) {
      debugPrint('⚠️ Image picker error: $e');
      return null;
    }
  }
}
