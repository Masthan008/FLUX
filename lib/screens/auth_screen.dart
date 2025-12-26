import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String? _selectedBranch;
  String? _selectedSection;
  String? _selectedYear;
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();
  
  late AnimationController _backgroundController;
  late AnimationController _glowController;

  final List<String> _branches = ['CSE', 'ECE', 'EEE', 'MECH', 'CIVIL', 'AIDS', 'Cyber Security'];
  final List<String> _sections = ['A', 'B', 'C', 'D'];
  final List<String> _years = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  
  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    _glowController.dispose();
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final box = Hive.box('user_prefs');
      
      await box.put('user_role', 'student');
      await box.put('user_name', _nameController.text);
      await box.put('user_id', _idController.text);
      await box.put('user_branch', _selectedBranch);
      await box.put('user_section', _selectedSection);
      await box.put('user_year', _selectedYear);
      await box.put('is_logged_in', true);
      if (_profileImagePath != null) {
        await box.put('user_photo', _profileImagePath);
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2 + sin(_backgroundController.value * 2 * pi) * 0.2,
                    colors: [
                      const Color(0xFF0A0A0A),
                      const Color(0xFF1A1A2E),
                      const Color(0xFF16213E),
                      Colors.black,
                    ],
                  ),
                ),
                child: CustomPaint(
                  painter: RegistrationBackgroundPainter(_backgroundController.value),
                  size: Size.infinite,
                ),
              );
            },
          ),
          
          // Floating Particles
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Stack(
                children: List.generate(12, (index) {
                  double phase = (_backgroundController.value + (index * 0.083)) % 1.0;
                  double x = MediaQuery.of(context).size.width * (0.1 + (index * 0.08));
                  double y = MediaQuery.of(context).size.height * (0.1 + sin(phase * 2 * pi) * 0.4);
                  
                  return Positioned(
                    left: x,
                    top: y,
                    child: Container(
                      width: 12 + sin(phase * 4 * pi) * 3,
                      height: 12 + sin(phase * 4 * pi) * 3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.cyanAccent.withOpacity(0.4 * sin(phase * pi)),
                            Colors.purple.withOpacity(0.3 * cos(phase * pi)),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          
          // Main Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo/Icon
                  AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.cyanAccent.withOpacity(0.3 + _glowController.value * 0.2),
                              Colors.purple.withOpacity(0.2 + _glowController.value * 0.1),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.4 + _glowController.value * 0.2),
                              blurRadius: 30 + _glowController.value * 10,
                              spreadRadius: 5 + _glowController.value * 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          size: 60,
                          color: Colors.cyanAccent,
                        ),
                      );
                    },
                  )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(delay: 200.ms, duration: 1000.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 2.seconds, color: Colors.white.withOpacity(0.3)),
                  
                  const SizedBox(height: 25),
                  
                  // Title with Gradient
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.cyanAccent,
                        Colors.white,
                        Colors.purple,
                        Colors.cyanAccent,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      "STUDENT REGISTRATION",
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.5,
                        shadows: [
                          Shadow(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideY(begin: -0.3, end: 0)
                    .then()
                    .shimmer(duration: 3.seconds, color: Colors.white.withOpacity(0.4)),
                  
                  const SizedBox(height: 12),
                  
                  // Subtitle with Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.withOpacity(0.2),
                          Colors.orange.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.5),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, color: Colors.amber, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "All Years Welcome • 1st to 4th Year",
                          style: GoogleFonts.montserrat(
                            color: Colors.amber,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 800.ms)
                    .scale(delay: 600.ms, duration: 800.ms, curve: Curves.elasticOut)
                    .then()
                    .shimmer(duration: 2.5.seconds, color: Colors.white.withOpacity(0.3)),
                  
                  const SizedBox(height: 35),
              
                  // Enhanced Digital ID Card Container
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1E1E1E).withOpacity(0.95),
                          const Color(0xFF2A2A2A).withOpacity(0.9),
                          const Color(0xFF1E1E1E).withOpacity(0.95),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 3,
                        ),
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Enhanced Profile Photo Picker
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer pulsing ring
                                AnimatedBuilder(
                                  animation: _glowController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: RadialGradient(
                                          colors: [
                                            Colors.transparent,
                                            Colors.cyanAccent.withOpacity(0.2 + _glowController.value * 0.1),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                
                                // Main photo container
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.grey[800]!,
                                          Colors.grey[900]!,
                                        ],
                                      ),
                                      border: Border.all(
                                        color: Colors.cyanAccent,
                                        width: 3.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyanAccent.withOpacity(0.5),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: _profileImagePath != null
                                        ? ClipOval(
                                            child: Image.file(
                                              File(_profileImagePath!),
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.add_a_photo,
                                            color: Colors.cyanAccent,
                                            size: 45,
                                          ),
                                  ),
                                ),
                                
                                // Camera badge
                                if (_profileImagePath == null)
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.cyanAccent,
                                            Colors.blueAccent,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.cyanAccent.withOpacity(0.5),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.black,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 800.ms, duration: 800.ms)
                            .scale(delay: 800.ms, duration: 1000.ms, curve: Curves.elasticOut),
                          
                          const SizedBox(height: 12),
                          
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.05),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                "Tap to add photo (optional)",
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 1000.ms, duration: 600.ms),
                          
                          const SizedBox(height: 25),
                          
                          // Animated Divider
                          Container(
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.cyanAccent.withOpacity(0.5),
                                  Colors.purple.withOpacity(0.3),
                                  Colors.cyanAccent.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 1100.ms, duration: 600.ms)
                            .slideX(begin: -1, end: 0),
                          
                          const SizedBox(height: 25),

                          // Enhanced Fields with Animations
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("FULL NAME", Icons.person_outline),
                              _buildTextField(_nameController, "Enter your full name", Icons.badge),
                            ],
                          )
                            .animate()
                            .fadeIn(delay: 1200.ms, duration: 600.ms)
                            .slideX(begin: -0.3, end: 0),
                          
                          const SizedBox(height: 18),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("REGISTRATION ID", Icons.fingerprint),
                              _buildTextField(_idController, "e.g., 21091A0501", Icons.numbers),
                            ],
                          )
                            .animate()
                            .fadeIn(delay: 1300.ms, duration: 600.ms)
                            .slideX(begin: -0.3, end: 0),
                          
                          const SizedBox(height: 18),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("ACADEMIC YEAR", Icons.calendar_today),
                              _buildDropdown(
                                value: _selectedYear,
                                items: _years,
                                onChanged: (val) => setState(() => _selectedYear = val),
                                icon: Icons.school,
                              ),
                            ],
                          )
                            .animate()
                            .fadeIn(delay: 1400.ms, duration: 600.ms)
                            .slideX(begin: -0.3, end: 0),
                          
                          const SizedBox(height: 18),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("BRANCH", Icons.account_tree),
                                    _buildDropdown(
                                      value: _selectedBranch,
                                      items: _branches,
                                      onChanged: (val) => setState(() => _selectedBranch = val),
                                      icon: Icons.engineering,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel("SECTION", Icons.group),
                                    _buildDropdown(
                                      value: _selectedSection,
                                      items: _sections,
                                      onChanged: (val) => setState(() => _selectedSection = val),
                                      icon: Icons.class_,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                            .animate()
                            .fadeIn(delay: 1500.ms, duration: 600.ms)
                            .slideX(begin: -0.3, end: 0),
                          
                          const SizedBox(height: 35),

                          // Enhanced Save Button
                          Center(
                            child: GestureDetector(
                              onTap: _saveProfile,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.cyanAccent,
                                      Colors.blueAccent,
                                      Colors.purpleAccent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(35),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.6),
                                      blurRadius: 25,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 8),
                                    ),
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.3),
                                      blurRadius: 15,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.rocket_launch,
                                      color: Colors.black,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "ENTER APP",
                                      style: GoogleFonts.orbitron(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 1600.ms, duration: 800.ms)
                            .slideY(begin: 0.3, end: 0)
                            .scale(delay: 1600.ms, duration: 800.ms, curve: Curves.elasticOut)
                            .then()
                            .shimmer(duration: 2.5.seconds, color: Colors.white.withOpacity(0.5)),
                          
                          const SizedBox(height: 20),
                          
                          // Info Footer
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.03),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.security,
                                    color: Colors.green.shade300,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Your data is stored securely",
                                    style: GoogleFonts.montserrat(
                                      color: Colors.grey.shade400,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                            .animate()
                            .fadeIn(delay: 1800.ms, duration: 600.ms),
                        ],
                      ),
                    ),
                  )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 1000.ms)
                    .slideY(begin: 0.3, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.cyanAccent,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String hint, IconData icon) {
    return TextFormField(
      controller: ctrl,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.cyanAccent.withOpacity(0.7),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey[800]!.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.cyanAccent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) => value!.isEmpty ? "This field is required" : null,
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF2C2C2C),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      icon: Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.cyanAccent.withOpacity(0.7),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.cyanAccent.withOpacity(0.7),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey[800]!.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.cyanAccent,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Please select an option" : null,
    );
  }
}

// Custom Painter for Registration Background
class RegistrationBackgroundPainter extends CustomPainter {
  final double animationValue;

  RegistrationBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.03)
      ..strokeWidth = 1;

    // Draw animated grid pattern
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 15; j++) {
        double x = (i * 40.0) + (j % 2) * 20 + (animationValue * 10) % 40;
        double y = (j * 35.0) + (animationValue * 5) % 35;
        
        if (x < size.width + 40 && y < size.height + 35) {
          _drawNode(canvas, Offset(x, y), 6, paint);
        }
      }
    }

    // Draw flowing lines
    final linePaint = Paint()
      ..color = Colors.purple.withOpacity(0.06)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final path = Path();
      double startY = size.height * (0.15 + i * 0.15);
      path.moveTo(0, startY);
      
      for (double x = 0; x <= size.width; x += 10) {
        double y = startY + sin((x / 60) + (animationValue * 2 * pi) + (i * pi / 3)) * 20;
        path.lineTo(x, y);
      }
      
      canvas.drawPath(path, linePaint);
    }

    // Draw floating particles
    final particlePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 10; i++) {
      double phase = (animationValue + (i * 0.1)) % 1.0;
      double x = size.width * (0.1 + (i * 0.09));
      double y = size.height * (0.2 + sin(phase * 2 * pi) * 0.3);
      
      canvas.drawCircle(
        Offset(x, y),
        4 + sin(phase * 4 * pi) * 2,
        particlePaint,
      );
    }
  }

  void _drawNode(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawCircle(center, radius, paint);
    
    // Draw connections
    for (int i = 0; i < 4; i++) {
      double angle = (i * pi) / 2;
      double x = center.dx + radius * 3 * cos(angle);
      double y = center.dy + radius * 3 * sin(angle);
      
      canvas.drawLine(
        center,
        Offset(x, y),
        Paint()
          ..color = Colors.cyanAccent.withOpacity(0.02)
          ..strokeWidth = 0.5,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
