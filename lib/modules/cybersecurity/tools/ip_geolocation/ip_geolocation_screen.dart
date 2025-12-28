import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IPGeolocationScreen extends StatefulWidget {
  const IPGeolocationScreen({super.key});

  @override
  State<IPGeolocationScreen> createState() => _IPGeolocationScreenState();
}

class _IPGeolocationScreenState extends State<IPGeolocationScreen> {
  final _ipController = TextEditingController(text: '8.8.8.8');
  bool _isLoading = false;
  String? _error;
  
  // Geolocation data
  String? _ip;
  String? _country;
  String? _countryCode;
  String? _region;
  String? _city;
  String? _isp;
  String? _org;
  double? _lat;
  double? _lon;
  String? _timezone;

  Future<void> _lookupIP() async {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) {
      setState(() => _error = 'Please enter an IP address');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _clearData();
    });

    try {
      // REAL GEO-IP API - Using ip-api.com (free, no key required)
      final url = Uri.parse('http://ip-api.com/json/$ip?fields=status,message,country,countryCode,region,regionName,city,lat,lon,timezone,isp,org,query');
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          setState(() {
            _ip = data['query'];
            _country = data['country'];
            _countryCode = data['countryCode'];
            _region = data['regionName'];
            _city = data['city'];
            _isp = data['isp'];
            _org = data['org'];
            _lat = data['lat']?.toDouble();
            _lon = data['lon']?.toDouble();
            _timezone = data['timezone'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = data['message'] ?? 'Lookup failed';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'HTTP ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _clearData() {
    _ip = null;
    _country = null;
    _countryCode = null;
    _region = null;
    _city = null;
    _isp = null;
    _org = null;
    _lat = null;
    _lon = null;
    _timezone = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red),
            const SizedBox(width: 12),
            Text(
              'IP Geolocation',
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
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.red, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Try: 8.8.8.8 (Google) or 1.1.1.1 (Cloudflare)',
                    style: GoogleFonts.montserrat(
                      color: Colors.red,
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
                  Colors.red.withOpacity(0.1),
                  Colors.orange.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target IP Address',
                  style: GoogleFonts.orbitron(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ipController,
                  style: GoogleFonts.robotoMono(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., 8.8.8.8',
                    hintStyle: GoogleFonts.robotoMono(color: Colors.grey),
                    prefixIcon: const Icon(Icons.my_location, color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.red.withOpacity(0.5)),
                    ),
                  ),
                  onSubmitted: (_) => _lookupIP(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _lookupIP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.track_changes),
                              const SizedBox(width: 8),
                              Text(
                                'TRACK LOCATION',
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

          // Error
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

          // Results
          if (_country != null) ...[
            // Target Acquired Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.orange],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.gps_fixed, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🎯 TARGET ACQUIRED',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _ip ?? '',
                          style: GoogleFonts.robotoMono(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 600.ms).then().shimmer(duration: 2.seconds),

            const SizedBox(height: 16),

            // Location Info
            _buildInfoCard('Country', '$_country ($_countryCode)', Icons.flag, Colors.red),
            _buildInfoCard('Region', _region ?? 'Unknown', Icons.map, Colors.orange),
            _buildInfoCard('City', _city ?? 'Unknown', Icons.location_city, Colors.deepOrange),
            _buildInfoCard('Coordinates', '${_lat?.toStringAsFixed(4)}, ${_lon?.toStringAsFixed(4)}', Icons.pin_drop, Colors.red),
            _buildInfoCard('Timezone', _timezone ?? 'Unknown', Icons.access_time, Colors.orange),
            _buildInfoCard('ISP', _isp ?? 'Unknown', Icons.business, Colors.deepOrange),
            _buildInfoCard('Organization', _org ?? 'Unknown', Icons.corporate_fare, Colors.red),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
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
            const Icon(Icons.school, color: Colors.red),
            const SizedBox(width: 12),
            Text(
              'How to Use IP Geolocation',
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
                'Queries a real-time Geo-IP database to find the physical location and ISP information for any IP address.',
              ),
              _buildTutorialSection(
                '2. How to Use',
                '• Enter an IP address (e.g., 8.8.8.8)\n• Press TRACK LOCATION\n• View country, city, ISP, and coordinates',
              ),
              _buildTutorialSection(
                '3. Try This Example',
                'IP: 8.8.8.8 (Google DNS)\nYou\'ll see it\'s located in the United States.',
              ),
              _buildTutorialSection(
                '4. What You\'ll Learn',
                '• How IP geolocation works\n• ISP and organization mapping\n• Geographic coordinates\n• Timezone detection',
              ),
              _buildTutorialSection(
                '5. Real-World Use',
                'Security analysts use IP geolocation to track attack sources, verify VPN locations, and investigate suspicious activity.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got It!', style: TextStyle(color: Colors.red)),
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
              color: Colors.red,
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
    super.dispose();
  }
}
