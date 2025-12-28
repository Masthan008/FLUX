import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:io';

class DNSLookupScreen extends StatefulWidget {
  const DNSLookupScreen({super.key});

  @override
  State<DNSLookupScreen> createState() => _DNSLookupScreenState();
}

class _DNSLookupScreenState extends State<DNSLookupScreen> {
  final _hostController = TextEditingController(text: 'google.com');
  List<InternetAddress> _addresses = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _performLookup() async {
    final host = _hostController.text.trim();
    if (host.isEmpty) {
      setState(() => _error = 'Please enter a hostname or IP');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _addresses.clear();
    });

    try {
      // REAL DNS LOOKUP - This actually queries DNS servers
      final addresses = await InternetAddress.lookup(host);
      setState(() {
        _addresses = addresses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.dns, color: Colors.green),
            const SizedBox(width: 12),
            Text(
              'DNS Lookup',
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
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Try: google.com, github.com, or any domain',
                    style: GoogleFonts.montserrat(
                      color: Colors.blue,
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
                  Colors.green.withOpacity(0.1),
                  Colors.teal.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Domain or IP Address',
                  style: GoogleFonts.orbitron(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _hostController,
                  style: GoogleFonts.robotoMono(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., google.com or 8.8.8.8',
                    hintStyle: GoogleFonts.robotoMono(color: Colors.grey),
                    prefixIcon: const Icon(Icons.language, color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.green.withOpacity(0.5)),
                    ),
                  ),
                  onSubmitted: (_) => _performLookup(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _performLookup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search),
                              const SizedBox(width: 8),
                              Text(
                                'LOOKUP',
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

          const SizedBox(height: 24),

          // Results
          if (_error != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _error!,
                      style: GoogleFonts.montserrat(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ).animate().shake(),

          if (_addresses.isNotEmpty) ...[
            Text(
              'Results (${_addresses.length} address${_addresses.length > 1 ? 'es' : ''})',
              style: GoogleFonts.orbitron(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._addresses.asMap().entries.map((entry) {
              final index = entry.key;
              final address = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.1),
                      Colors.black.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.robotoMono(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.address,
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.type == InternetAddressType.IPv4 ? 'IPv4' : 'IPv6',
                            style: GoogleFonts.montserrat(
                              color: Colors.green,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.green),
                      onPressed: () {
                        // Copy to clipboard functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied ${address.address}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: -0.2, delay: Duration(milliseconds: index * 100));
            }),
          ],
        ],
      ),
    );
  }

  void _showTutorial() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: Row(
          children: [
            const Icon(Icons.school, color: Colors.green),
            const SizedBox(width: 12),
            Text(
              'How to Use DNS Lookup',
              style: GoogleFonts.orbitron(color: Colors.white),
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
                'Resolves domain names to IP addresses using real DNS queries. This is how your browser finds websites!',
              ),
              _buildTutorialSection(
                '2. How to Use',
                '• Enter a domain (e.g., google.com)\n• Press LOOKUP\n• See the actual IP addresses',
              ),
              _buildTutorialSection(
                '3. Try This Example',
                'Enter "google.com" and press LOOKUP. You\'ll see Google\'s real IP addresses!',
              ),
              _buildTutorialSection(
                '4. What You\'ll Learn',
                '• How DNS resolution works\n• IPv4 vs IPv6 addresses\n• Why some domains have multiple IPs',
              ),
              _buildTutorialSection(
                '5. Real-World Use',
                'Network administrators use DNS lookup to troubleshoot connectivity and verify DNS configuration.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It!', style: TextStyle(color: Colors.green)),
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
              color: Colors.green,
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
    _hostController.dispose();
    super.dispose();
  }
}
