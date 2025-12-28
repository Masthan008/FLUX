import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WiFiAnalyzerScreen extends StatefulWidget {
  const WiFiAnalyzerScreen({super.key});

  @override
  State<WiFiAnalyzerScreen> createState() => _WiFiAnalyzerScreenState();
}

class _WiFiAnalyzerScreenState extends State<WiFiAnalyzerScreen> {
  final _networkInfo = NetworkInfo();
  String? _ssid;
  String? _bssid;
  String? _ip;
  String? _subnet;
  String? _gateway;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNetworkInfo();
  }

  Future<void> _loadNetworkInfo() async {
    setState(() => _isLoading = true);

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      
      if (connectivityResult.contains(ConnectivityResult.wifi)) {
        _ssid = await _networkInfo.getWifiName();
        _bssid = await _networkInfo.getWifiBSSID();
        _ip = await _networkInfo.getWifiIP();
        _subnet = await _networkInfo.getWifiSubmask();
        _gateway = await _networkInfo.getWifiGatewayIP();
      }
    } catch (e) {
      // Handle error
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.wifi, color: Colors.purple),
            const SizedBox(width: 12),
            Text(
              'WiFi Analyzer',
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
            icon: const Icon(Icons.refresh),
            onPressed: _loadNetworkInfo,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard('SSID', _ssid ?? 'Not connected', Icons.wifi),
                _buildInfoCard('BSSID', _bssid ?? 'N/A', Icons.router),
                _buildInfoCard('IP Address', _ip ?? 'N/A', Icons.computer),
                _buildInfoCard('Subnet Mask', _subnet ?? 'N/A', Icons.network_check),
                _buildInfoCard('Gateway', _gateway ?? 'N/A', Icons.dns),
              ],
            ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
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
          Icon(icon, color: Colors.purple, size: 32),
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
    ).animate().fadeIn().slideY(begin: 0.2);
  }
}
