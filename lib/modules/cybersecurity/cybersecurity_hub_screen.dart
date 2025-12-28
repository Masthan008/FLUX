import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'tools/port_scanner/port_scanner_screen.dart';
import 'tools/network_diagnostics/network_diagnostics_screen.dart';
import 'tools/wifi_analyzer/wifi_analyzer_screen.dart';
import 'tools/hash_generator/hash_generator_screen.dart';
import 'tools/ssh_terminal/ssh_terminal_screen.dart';
import 'tools/learning/tool_library_screen.dart';
import 'tools/dns_lookup/dns_lookup_screen.dart';
import 'tools/http_headers/http_header_screen.dart';
import 'tools/subnet_calculator/subnet_calculator_screen.dart';
import 'tools/ip_geolocation/ip_geolocation_screen.dart';

class CybersecurityHubScreen extends StatelessWidget {
  const CybersecurityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.red),
            const SizedBox(width: 12),
            Text(
              'Cybersecurity Tools',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0E27),
              const Color(0xFF1A1F3A).withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),
            
            // Category: Reconnaissance Tools
            _buildCategoryHeader('Reconnaissance Tools', Icons.search),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              title: 'FluxScan',
              subtitle: 'Port Scanner with Radar UI',
              icon: Icons.radar,
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PortScannerScreen(),
                ),
              ),
              delay: 0,
            ),
            _buildToolCard(
              context,
              title: 'Network Diagnostics',
              subtitle: 'Ping, Traceroute, Whois',
              icon: Icons.network_check,
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NetworkDiagnosticsScreen(),
                ),
              ),
              delay: 100,
            ),
            _buildToolCard(
              context,
              title: 'WiFi Analyzer',
              subtitle: 'Network Information & Analysis',
              icon: Icons.wifi,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WiFiAnalyzerScreen(),
                ),
              ),
              delay: 200,
              badge: 'REAL-TIME',
            ),
            _buildToolCard(
              context,
              title: 'DNS Lookup',
              subtitle: 'Resolve Domains to IPs',
              icon: Icons.dns,
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DNSLookupScreen(),
                ),
              ),
              delay: 250,
              badge: 'REAL-TIME',
            ),
            _buildToolCard(
              context,
              title: 'HTTP Headers',
              subtitle: 'Analyze Website Headers',
              icon: Icons.http,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HTTPHeaderScreen(),
                ),
              ),
              delay: 300,
              badge: 'REAL-TIME',
            ),
            _buildToolCard(
              context,
              title: 'IP Geolocation',
              subtitle: 'Track IP Location & ISP',
              icon: Icons.location_on,
              color: Colors.red,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IPGeolocationScreen(),
                ),
              ),
              delay: 350,
              badge: 'REAL-TIME',
            ),
            
            const SizedBox(height: 24),
            
            // Category: Cryptography Tools
            _buildCategoryHeader('Cryptography Tools', Icons.lock),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              title: 'Hash Generator',
              subtitle: 'MD5, SHA-256, Base64',
              icon: Icons.tag,
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HashGeneratorScreen(),
                ),
              ),
              delay: 350,
              badge: 'REAL-TIME',
            ),
            _buildToolCard(
              context,
              title: 'Subnet Calculator',
              subtitle: 'Network Planning Tool',
              icon: Icons.calculate,
              color: Colors.purple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubnetCalculatorScreen(),
                ),
              ),
              delay: 400,
            ),
            
            const SizedBox(height: 24),
            
            // Category: Remote Access
            _buildCategoryHeader('Remote Access', Icons.terminal),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              title: 'SSH Terminal',
              subtitle: 'Connect to Kali Linux',
              icon: Icons.computer,
              color: Colors.cyan,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SSHTerminalScreen(),
                ),
              ),
              delay: 400,
              badge: 'PRO',
            ),
            
            const SizedBox(height: 24),
            
            // Category: Learning
            _buildCategoryHeader('Learning & Simulation', Icons.school),
            const SizedBox(height: 12),
            _buildToolCard(
              context,
              title: 'Tool Encyclopedia',
              subtitle: 'Learn How Tools Work',
              icon: Icons.menu_book,
              color: Colors.pink,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ToolLibraryScreen(),
                ),
              ),
              delay: 500,
            ),
            
            const SizedBox(height: 32),
            
            // Disclaimer
            _buildDisclaimer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.2),
            Colors.purple.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.red, Colors.purple],
                  ),
                ),
                child: const Icon(
                  Icons.security,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pocket Cyberdeck',
                      style: GoogleFonts.orbitron(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Professional Security Tools',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Access powerful cybersecurity tools for network reconnaissance, cryptography, and remote system control.',
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade300,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildCategoryHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.cyan, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.orbitron(
            color: Colors.cyan,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required int delay,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.5)],
                    ),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.pink],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge,
                                style: GoogleFonts.robotoMono(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.montserrat(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay))
      .slideX(begin: -0.2, delay: Duration(milliseconds: delay));
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EDUCATIONAL USE ONLY',
                  style: GoogleFonts.orbitron(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'These tools are for authorized security testing and education only. Unauthorized access to computer systems is illegal. Users are responsible for complying with all applicable laws.',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade300,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  void _showComingSoon(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.cyan, width: 2),
        ),
        title: Row(
          children: [
            const Icon(Icons.construction, color: Colors.orange),
            const SizedBox(width: 12),
            Text(
              'Coming Soon',
              style: GoogleFonts.orbitron(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          'This tool is under development and will be available in the next update!',
          style: GoogleFonts.montserrat(color: Colors.grey.shade300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.montserrat(color: Colors.cyan),
            ),
          ),
        ],
      ),
    );
  }
}
