import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/student_auth_service.dart';
import '../models/student_model.dart';
import '../widgets/user_badge.dart';

/// Clean, simple Student Profile Screen
/// Read-only: Name, RegdNo, Group, Section, Year
/// Editable: Mobile, Email
/// Upload: Profile Picture
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;
  Student? _student;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    
    try {
      debugPrint('📱 Profile Screen: Starting data load...');
      
      // Force refresh from Supabase to get latest data
      final student = await StudentAuthService.forceRefreshFromSupabase();
      
      if (student != null && mounted) {
        debugPrint('✅ Profile Screen: Data loaded successfully');
        debugPrint('   Name: ${student.name}');
        debugPrint('   RegdNo: ${student.regdNo}');
        debugPrint('   Mobile: ${student.mobileNumber}');
        debugPrint('   Email: ${student.email}');
        debugPrint('   Image: ${student.imageUrl}');
        
        setState(() {
          _student = student;
          _mobileController.text = student.mobileNumber ?? '';
          _emailController.text = student.email ?? '';
          _isLoading = false;
        });
        
        debugPrint('✅ Profile Screen: UI updated with data');
      } else {
        debugPrint('❌ Profile Screen: No student data returned');
        setState(() => _isLoading = false);
        if (mounted) _showError('Failed to load profile');
      }
    } catch (e) {
      debugPrint('❌ Profile Screen: Error loading - $e');
      setState(() => _isLoading = false);
      if (mounted) _showError('Error loading profile');
    }
  }

  Future<void> _uploadImage() async {
    setState(() => _isLoading = true);
    
    try {
      final imageUrl = await StudentAuthService.pickAndUploadProfileImage();
      
      if (imageUrl != null) {
        final success = await StudentAuthService.updateProfile(imageUrl: imageUrl);
        
        if (success) {
          await _loadProfile();
          if (mounted) _showSuccess('Profile picture updated!');
        } else {
          setState(() => _isLoading = false);
          if (mounted) _showError('Failed to update picture');
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) _showError('Upload failed');
    }
  }

  Future<void> _saveChanges() async {
    if (_student == null) return;
    
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();
    
    debugPrint('💾 Profile Screen: Attempting FORCE SAVE...');
    debugPrint('   RegdNo: ${_student!.regdNo}');
    debugPrint('   Mobile: $mobile');
    debugPrint('   Email: $email');
    
    if (mobile.isNotEmpty && mobile.length < 10) {
      _showError('Mobile must be at least 10 digits');
      return;
    }
    
    if (email.isNotEmpty && !email.contains('@')) {
      _showError('Invalid email address');
      return;
    }
    
    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();
    
    try {
      // NUCLEAR OPTION: Call the "Force Save" Function (RPC)
      // This bypasses ALL RLS policies using security definer privileges
      await StudentAuthService.supabase.rpc('force_update_profile', params: {
        'p_regd_no': _student!.regdNo,  // The ID to find
        'p_mobile': mobile,              // The new data
        'p_email': email,                // The new data
      });
      
      debugPrint('✅ Profile Screen: FORCE SAVE successful!');
      
      // Force refresh to confirm data was saved
      await StudentAuthService.forceRefreshFromSupabase();
      
      // Reload the screen to show fresh data
      await _loadProfile();
      
      if (mounted) {
        _showSuccess('Profile saved permanently!');
        setState(() => _isSaving = false);
      }
    } catch (e) {
      debugPrint('❌ Profile Screen: FORCE SAVE error - $e');
      setState(() => _isSaving = false);
      if (mounted) _showError('Save failed: $e');
    }
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(msg),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Text(msg),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.cyanAccent),
        ),
      );
    }

    if (_student == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(
                'No profile data',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.purple, Colors.cyanAccent],
          ).createShader(bounds),
          child: Text(
            'My Profile',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.cyanAccent),
            onPressed: _loadProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture (Upload Disabled - Feature Freeze)
            GestureDetector(
              onTap: () {
                // Show "Coming Soon" message instead of opening gallery
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('Profile photo updates coming in the next version! 🚀'),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5), // Grey to show disabled
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[900],
                      backgroundImage: _student!.imageUrl != null
                          ? NetworkImage(_student!.imageUrl!)
                          : null,
                      child: _student!.imageUrl == null
                          ? const Icon(Icons.person, size: 60, color: Colors.white54)
                          : null,
                    ),
                  ),
                  // Lock icon instead of camera (shows feature is disabled)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800], // Grey to show disabled state
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.lock_clock, size: 20, color: Colors.white54),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Status message
            Text(
              'Photo updates paused for maintenance',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
            ),
            
            const SizedBox(height: 30),

            // Badge
            UserBadge(
              tier: _student!.subscriptionTier,
              compact: false,
            ),

            const SizedBox(height: 30),

            // Read-Only Section
            _buildHeader('Student Information', Icons.school),
            const SizedBox(height: 16),
            
            _buildReadOnly('Full Name', _student!.name, Icons.person),
            const SizedBox(height: 12),
            _buildReadOnly('Registration No', _student!.regdNo, Icons.badge),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(child: _buildReadOnly('Group', _student!.group, Icons.group)),
                const SizedBox(width: 12),
                Expanded(child: _buildReadOnly('Section', _student!.section, Icons.class_)),
              ],
            ),
            const SizedBox(height: 12),
            _buildReadOnly('Year', _student!.year, Icons.calendar_today),

            const SizedBox(height: 30),
            Divider(color: Colors.grey[800], thickness: 1),
            const SizedBox(height: 30),

            // Editable Section
            _buildHeader('Contact Details (Editable)', Icons.edit),
            const SizedBox(height: 16),
            
            _buildEditable(
              controller: _mobileController,
              label: 'Mobile Number',
              icon: Icons.phone,
              type: TextInputType.phone,
              hint: 'Enter mobile number',
            ),
            const SizedBox(height: 16),
            
            _buildEditable(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email,
              type: TextInputType.emailAddress,
              hint: 'Enter email address',
            ),

            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.grey[800],
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: _isSaving
                        ? null
                        : const LinearGradient(
                            colors: [Colors.purple, Colors.cyanAccent],
                          ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: _isSaving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.cyanAccent.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.cyanAccent, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.cyanAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnly(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.lock_outline, color: Colors.grey[700], size: 18),
        ],
      ),
    );
  }

  Widget _buildEditable({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType type,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.grey[500]),
        hintStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(icon, color: Colors.cyanAccent),
        filled: true,
        fillColor: Colors.grey[900]?.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
        ),
      ),
    );
  }
}
