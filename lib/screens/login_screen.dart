import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/student_auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isLogin = true;
  bool _isLoading = false;
  
  // Controllers
  final _nameController = TextEditingController();
  final _regdController = TextEditingController();
  final _groupController = TextEditingController();
  final _sectionController = TextEditingController();
  final _yearController = TextEditingController();
  
  // Avatar Selection
  String? _selectedAvatar;
  final List<String> _avatars = [
    'https://api.dicebear.com/7.x/avataaars/png?seed=Felix',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Aneka',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Bob',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Mila',
  ];
  
  // Dropdown options
  final List<String> _groups = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'IT', 'AIDS', 'AIML', 'Cyber Security', 'Other'];
  final List<String> _sections = ['A', 'B', 'C', 'D', 'E'];
  final List<String> _years = ['1', '2', '3', '4'];
  
  String? _selectedGroup;
  String? _selectedSection;
  String? _selectedYear;
  
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regdController.dispose();
    _groupController.dispose();
    _sectionController.dispose();
    _yearController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
    _animController.reset();
    _animController.forward();
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final regdNo = _regdController.text.trim();
    
    if (name.isEmpty || regdNo.isEmpty) {
      _showError('Please fill all required fields');
      return;
    }
    
    setState(() => _isLoading = true);
    
    if (_isLogin) {
      // Login
      final result = await StudentAuthService.login(name, regdNo);
      
      if (result.student != null && mounted) {
        HapticFeedback.mediumImpact();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (mounted) {
        _showError(result.error ?? 'Login failed');
      }
    } else {
      // Register
      if (_selectedGroup == null || _selectedSection == null || _selectedYear == null) {
        _showError('Please fill all required fields');
        setState(() => _isLoading = false);
        return;
      }
      
      final result = await StudentAuthService.register(
        name: name,
        regdNo: regdNo,
        group: _selectedGroup!,
        section: _selectedSection!,
        year: _selectedYear!,
        imageUrl: _selectedAvatar,
      );
      
      if (result.success && mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );
        _toggleMode(); // Switch to login
      } else if (mounted) {
        _showError(result.error ?? 'Registration failed');
      }
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0A0A0F),
                    Colors.purple.withOpacity(0.1),
                    const Color(0xFF0A0A0F),
                  ],
                ),
              ),
            ),
            
            // Floating particles
            ...List.generate(10, (index) {
              return Positioned(
                left: (index * 50.0) % MediaQuery.of(context).size.width,
                top: (index * 80.0) % MediaQuery.of(context).size.height,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .fadeIn(duration: Duration(seconds: 2 + index % 3))
                    .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5)),
              );
            }),
            
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.cyanAccent.withOpacity(0.2), Colors.purple.withOpacity(0.2)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.cyanAccent,
                    ),
                  ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                  
                  const SizedBox(height: 24),
                  
                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.cyanAccent, Colors.purple],
                    ).createShader(bounds),
                    child: Text(
                      'FluxFlow',
                      style: GoogleFonts.orbitron(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3),
                  
                  Text(
                    'Student OS',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey,
                      letterSpacing: 4,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: 40),
                  
                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        // Toggle buttons
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _isLogin ? null : _toggleMode(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: _isLogin ? Colors.cyanAccent : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Login',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: _isLogin ? Colors.black : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _isLogin ? _toggleMode() : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: !_isLogin ? Colors.purple : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Register',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: !_isLogin ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Name field
                        _buildTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          icon: Icons.person,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Regd No field
                        _buildTextField(
                          controller: _regdController,
                          label: 'Registration Number',
                          icon: Icons.badge,
                          hint: 'e.g., 22B01A0501',
                        ),
                        
                        // Registration-only fields
                        if (!_isLogin) ...[
                          const SizedBox(height: 16),

                          // Avatar Selector (Optional)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Select Avatar (Optional)',
                              style: TextStyle(
                                color: Colors.cyanAccent.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 60,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _avatars.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final avatar = _avatars[index];
                                final isSelected = _selectedAvatar == avatar;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedAvatar = avatar),
                                  child: Container(
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? Colors.cyanAccent : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(avatar),
                                      backgroundColor: Colors.grey.shade800,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Group dropdown
                          _buildDropdown(
                            value: _selectedGroup,
                            items: _groups,
                            label: 'Branch/Group',
                            icon: Icons.school,
                            onChanged: (val) => setState(() => _selectedGroup = val),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              // Section dropdown
                              Expanded(
                                child: _buildDropdown(
                                  value: _selectedSection,
                                  items: _sections,
                                  label: 'Section',
                                  icon: Icons.class_,
                                  onChanged: (val) => setState(() => _selectedSection = val),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Year dropdown
                              Expanded(
                                child: _buildDropdown(
                                  value: _selectedYear,
                                  items: _years,
                                  label: 'Year',
                                  icon: Icons.calendar_today,
                                  onChanged: (val) => setState(() => _selectedYear = val),
                                ),
                              ),
                            ],
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isLogin ? Colors.cyanAccent : Colors.purple,
                              foregroundColor: _isLogin ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(
                                    _isLogin ? 'Login' : 'Create Account',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                  
                  const SizedBox(height: 24),
                  
                  // Info text
                  Text(
                    _isLogin
                        ? "Don't have an account? Tap Register above"
                        : "Already have an account? Tap Login above",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        hintStyle: TextStyle(color: Colors.grey.shade700),
        prefixIcon: Icon(icon, color: Colors.cyanAccent),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.cyanAccent),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String label,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      )).toList(),
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      dropdownColor: Colors.grey.shade900,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, color: Colors.purple),
        filled: true,
        fillColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
