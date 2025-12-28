import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SSHTerminalScreen extends StatelessWidget {
  const SSHTerminalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.computer, color: Colors.cyan),
            const SizedBox(width: 12),
            Text(
              'SSH Terminal',
              style: GoogleFonts.orbitron(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        iconTheme: const IconThemeData(color: Colors.cyan),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan.withOpacity(0.3),
                      Colors.blue.withOpacity(0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.construction,
                  size: 60,
                  color: Colors.cyan,
                ),
              )
                  .animate()
                  .shimmer(duration: 2.seconds, color: Colors.cyan)
                  .shake(duration: 500.ms, hz: 2, delay: 2.seconds),

              const SizedBox(height: 32),

              // Coming Soon Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.deepOrange],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  '🚧 COMING SOON',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(delay: 300.ms)
                  .shimmer(duration: 2.seconds, color: Colors.white, delay: 1.seconds),

              const SizedBox(height: 24),

              // Title
              Text(
                'SSH Terminal',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: -0.3),

              const SizedBox(height: 16),

              // Description
              Text(
                'Remote Linux Server Access',
                style: GoogleFonts.montserrat(
                  color: Colors.cyan,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms),

              const SizedBox(height: 32),

              // Feature Cards
              _buildFeatureCard(
                icon: Icons.terminal,
                title: 'Full Terminal Emulation',
                description: 'Execute commands on remote servers',
                delay: 800,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                icon: Icons.security,
                title: 'Secure SSH Connection',
                description: 'Encrypted communication with servers',
                delay: 1000,
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                icon: Icons.cloud,
                title: 'Kali Linux Support',
                description: 'Connect to your Kali VM or cloud instances',
                delay: 1200,
              ),

              const SizedBox(height: 32),

              // Status Message
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.2),
                      Colors.purple.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.blue, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'Under Development',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This feature requires platform-specific SSH library integration. We\'re working on bringing you a fully functional terminal experience.',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey.shade300,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.schedule, color: Colors.cyan, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Expected: Next Update',
                          style: GoogleFonts.montserrat(
                            color: Colors.cyan,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 1400.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.cyan, Colors.cyan.withOpacity(0.5)],
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 4),
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
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: -0.2);
  }
}
