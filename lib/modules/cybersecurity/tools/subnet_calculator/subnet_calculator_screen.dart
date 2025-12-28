import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SubnetCalculatorScreen extends StatefulWidget {
  const SubnetCalculatorScreen({super.key});

  @override
  State<SubnetCalculatorScreen> createState() => _SubnetCalculatorScreenState();
}

class _SubnetCalculatorScreenState extends State<SubnetCalculatorScreen> {
  final _ipController = TextEditingController(text: '192.168.1.100');
  final _cidrController = TextEditingController(text: '24');
  
  String? _networkAddress;
  String? _broadcastAddress;
  String? _subnetMask;
  String? _wildcardMask;
  String? _firstHost;
  String? _lastHost;
  int? _totalHosts;

  void _calculate() {
    final ip = _ipController.text.trim();
    final cidr = int.tryParse(_cidrController.text.trim()) ?? 0;

    if (cidr < 0 || cidr > 32) {
      _showError('CIDR must be between 0 and 32');
      return;
    }

    try {
      final ipParts = ip.split('.').map(int.parse).toList();
      if (ipParts.length != 4 || ipParts.any((p) => p < 0 || p > 255)) {
        _showError('Invalid IP address');
        return;
      }

      // Calculate subnet mask
      final mask = (0xFFFFFFFF << (32 - cidr)) & 0xFFFFFFFF;
      final maskParts = [
        (mask >> 24) & 0xFF,
        (mask >> 16) & 0xFF,
        (mask >> 8) & 0xFF,
        mask & 0xFF,
      ];

      // Calculate wildcard mask
      final wildcard = ~mask & 0xFFFFFFFF;
      final wildcardParts = [
        (wildcard >> 24) & 0xFF,
        (wildcard >> 16) & 0xFF,
        (wildcard >> 8) & 0xFF,
        wildcard & 0xFF,
      ];

      // Calculate network address
      final ipInt = (ipParts[0] << 24) | (ipParts[1] << 16) | (ipParts[2] << 8) | ipParts[3];
      final networkInt = ipInt & mask;
      final networkParts = [
        (networkInt >> 24) & 0xFF,
        (networkInt >> 16) & 0xFF,
        (networkInt >> 8) & 0xFF,
        networkInt & 0xFF,
      ];

      // Calculate broadcast address
      final broadcastInt = networkInt | wildcard;
      final broadcastParts = [
        (broadcastInt >> 24) & 0xFF,
        (broadcastInt >> 16) & 0xFF,
        (broadcastInt >> 8) & 0xFF,
        broadcastInt & 0xFF,
      ];

      // Calculate first and last host
      final firstHostInt = networkInt + 1;
      final lastHostInt = broadcastInt - 1;
      final firstHostParts = [
        (firstHostInt >> 24) & 0xFF,
        (firstHostInt >> 16) & 0xFF,
        (firstHostInt >> 8) & 0xFF,
        firstHostInt & 0xFF,
      ];
      final lastHostParts = [
        (lastHostInt >> 24) & 0xFF,
        (lastHostInt >> 16) & 0xFF,
        (lastHostInt >> 8) & 0xFF,
        lastHostInt & 0xFF,
      ];

      setState(() {
        _networkAddress = networkParts.join('.');
        _broadcastAddress = broadcastParts.join('.');
        _subnetMask = maskParts.join('.');
        _wildcardMask = wildcardParts.join('.');
        _firstHost = firstHostParts.join('.');
        _lastHost = lastHostParts.join('.');
        _totalHosts = (1 << (32 - cidr)) - 2;
      });
    } catch (e) {
      _showError('Invalid input');
    }
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
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.calculate, color: Colors.purple),
            const SizedBox(width: 12),
            Text(
              'Subnet Calculator',
              style: GoogleFonts.orbitron(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        iconTheme: const IconThemeData(color: Colors.cyan),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showTutorial(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tutorial hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.purple, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Try: 192.168.1.100 with CIDR /24',
                    style: GoogleFonts.montserrat(
                      color: Colors.purple,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          const SizedBox(height: 16),

          // Input section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withOpacity(0.1),
                  Colors.deepPurple.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IP Address & CIDR',
                  style: GoogleFonts.orbitron(
                    color: Colors.purple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _ipController,
                        style: GoogleFonts.robotoMono(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'IP Address',
                          hintText: '192.168.1.100',
                          labelStyle: GoogleFonts.montserrat(color: Colors.grey),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.purple.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _cidrController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.robotoMono(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'CIDR',
                          hintText: '24',
                          labelStyle: GoogleFonts.montserrat(color: Colors.grey),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.purple.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _calculate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calculate),
                        const SizedBox(width: 8),
                        Text(
                          'CALCULATE',
                          style: GoogleFonts.orbitron(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: -0.2),

          if (_networkAddress != null) ...[
            const SizedBox(height: 24),
            _buildResultCard('Network Address', _networkAddress!, Icons.router),
            _buildResultCard('Broadcast Address', _broadcastAddress!, Icons.broadcast_on_home),
            _buildResultCard('Subnet Mask', _subnetMask!, Icons.filter_alt),
            _buildResultCard('Wildcard Mask', _wildcardMask!, Icons.filter_alt_off),
            _buildResultCard('First Host', _firstHost!, Icons.computer),
            _buildResultCard('Last Host', _lastHost!, Icons.devices),
            _buildResultCard('Total Hosts', _totalHosts.toString(), Icons.group),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.1),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.robotoMono(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.2);
  }

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.purple),
            const SizedBox(width: 12),
            Text(
              'How to Use Subnet Calculator',
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTutorialSection(
                '1. What This Tool Does',
                'Calculates network information from an IP address and CIDR notation. Essential for network planning and configuration.',
              ),
              _buildTutorialSection(
                '2. How to Use',
                '• Enter an IP address (e.g., 192.168.1.100)\n• Enter CIDR notation (e.g., 24 for /24)\n• Press CALCULATE\n• View network details',
              ),
              _buildTutorialSection(
                '3. Try This Example',
                'IP: 192.168.1.100, CIDR: 24\nThis calculates a typical home network range.',
              ),
              _buildTutorialSection(
                '4. What You\'ll Learn',
                '• IP addressing and subnetting\n• Network vs broadcast addresses\n• Subnet masks and wildcards\n• Host range calculations',
              ),
              _buildTutorialSection(
                '5. Real-World Use',
                'Network engineers use this to plan IP address allocation and configure routers and firewalls.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It!', style: TextStyle(color: Colors.purple)),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.orbitron(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade300,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    _cidrController.dispose();
    super.dispose();
  }
}
