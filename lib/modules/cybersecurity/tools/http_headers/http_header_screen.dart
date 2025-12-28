import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;

class HTTPHeaderScreen extends StatefulWidget {
  const HTTPHeaderScreen({super.key});

  @override
  State<HTTPHeaderScreen> createState() => _HTTPHeaderScreenState();
}

class _HTTPHeaderScreenState extends State<HTTPHeaderScreen> {
  final _urlController = TextEditingController(text: 'https://google.com');
  Map<String, String> _headers = {};
  bool _isLoading = false;
  String? _error;
  int? _statusCode;

  Future<void> _fetchHeaders() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      setState(() => _error = 'Please enter a URL');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _headers.clear();
      _statusCode = null;
    });

    try {
      // REAL HTTP REQUEST - Actually fetches headers from the server
      final response = await http.head(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );
      
      setState(() {
        _headers = response.headers;
        _statusCode = response.statusCode;
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
            const Icon(Icons.http, color: Colors.orange),
            const SizedBox(width: 12),
            Text(
              'HTTP Headers',
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
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Try: https://google.com or any website',
                    style: GoogleFonts.montserrat(
                      color: Colors.orange,
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
                  Colors.orange.withOpacity(0.1),
                  Colors.deepOrange.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Website URL',
                  style: GoogleFonts.orbitron(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _urlController,
                  style: GoogleFonts.robotoMono(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'https://example.com',
                    hintStyle: GoogleFonts.robotoMono(color: Colors.grey),
                    prefixIcon: const Icon(Icons.link, color: Colors.orange),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.orange.withOpacity(0.5)),
                    ),
                  ),
                  onSubmitted: (_) => _fetchHeaders(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _fetchHeaders,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
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
                                'FETCH HEADERS',
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

          // Status Code
          if (_statusCode != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _statusCode! < 400 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _statusCode! < 400 ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _statusCode! < 400 ? Icons.check_circle : Icons.error,
                    color: _statusCode! < 400 ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Status Code: $_statusCode',
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

          if (_error != null)
            Container(
              margin: const EdgeInsets.only(top: 16),
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

          if (_headers.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Headers (${_headers.length})',
              style: GoogleFonts.orbitron(
                color: Colors.orange,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._headers.entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: GoogleFonts.robotoMono(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.value,
                      style: GoogleFonts.robotoMono(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideX(begin: -0.1);
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
            const Icon(Icons.school, color: Colors.orange),
            const SizedBox(width: 12),
            Text(
              'How to Use HTTP Headers',
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
                'Fetches and displays HTTP headers from websites. Headers contain important metadata about the server and security settings.',
              ),
              _buildTutorialSection(
                '2. How to Use',
                '• Enter a website URL (must start with https://)\n• Press FETCH HEADERS\n• View the response headers',
              ),
              _buildTutorialSection(
                '3. Try This Example',
                'Enter "https://google.com" and see Google\'s actual HTTP headers including security headers like X-Frame-Options.',
              ),
              _buildTutorialSection(
                '4. What You\'ll Learn',
                '• HTTP protocol basics\n• Security headers (CSP, HSTS, etc.)\n• Server information\n• Content types',
              ),
              _buildTutorialSection(
                '5. Real-World Use',
                'Security professionals analyze headers to identify vulnerabilities and verify security configurations.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It!', style: TextStyle(color: Colors.orange)),
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
              color: Colors.orange,
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
    _urlController.dispose();
    super.dispose();
  }
}
