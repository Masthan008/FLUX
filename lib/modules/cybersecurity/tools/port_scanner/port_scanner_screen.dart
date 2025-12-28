import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import 'package:fluxflow/modules/cybersecurity/models/scan_result.dart';
import 'port_scanner_service.dart';
import 'widgets/radar_widget.dart';
import 'widgets/scan_result_card.dart';

class PortScannerScreen extends StatefulWidget {
  const PortScannerScreen({super.key});

  @override
  State<PortScannerScreen> createState() => _PortScannerScreenState();
}

class _PortScannerScreenState extends State<PortScannerScreen> {
  final _service = PortScannerService();
  final _ipController = TextEditingController(text: '192.168.1.1');
  final _startPortController = TextEditingController(text: '1');
  final _endPortController = TextEditingController(text: '1000');
  
  final List<ScanResult> _results = [];
  final List<RadarPoint> _radarPoints = [];
  bool _isScanning = false;
  int _scannedPorts = 0;
  int _totalPorts = 0;
  int _openPorts = 0;

  @override
  void dispose() {
    _ipController.dispose();
    _startPortController.dispose();
    _endPortController.dispose();
    super.dispose();
  }

  Future<void> _startScan({List<int>? customPorts}) async {
    if (_isScanning) return;

    final ip = _ipController.text.trim();
    if (!_service.isValidIP(ip)) {
      _showError('Invalid IP address');
      return;
    }

    setState(() {
      _isScanning = true;
      _results.clear();
      _radarPoints.clear();
      _scannedPorts = 0;
      _openPorts = 0;
    });

    try {
      Stream<ScanResult> scanStream;
      
      if (customPorts != null) {
        _totalPorts = customPorts.length;
        scanStream = _service.scanPorts(ip, customPorts);
      } else {
        final startPort = int.tryParse(_startPortController.text) ?? 1;
        final endPort = int.tryParse(_endPortController.text) ?? 1000;
        
        if (!_service.isValidPort(startPort) || !_service.isValidPort(endPort)) {
          _showError('Invalid port range');
          setState(() => _isScanning = false);
          return;
        }
        
        _totalPorts = endPort - startPort + 1;
        scanStream = _service.scanPortRange(ip, startPort, endPort);
      }

      await for (final result in scanStream) {
        if (!_isScanning) break;
        
        setState(() {
          _results.add(result);
          _scannedPorts++;
          
          if (result.isOpen) {
            _openPorts++;
            // Add to radar
            final angle = (result.port % 360).toDouble();
            final distance = 0.5 + (math.Random().nextDouble() * 0.4);
            _radarPoints.add(RadarPoint(
              angle: angle,
              distance: distance,
              color: Colors.green,
              label: result.port.toString(),
            ));
          }
        });
      }
    } catch (e) {
      _showError('Scan error: $e');
    } finally {
      setState(() => _isScanning = false);
    }
  }

  void _stopScan() {
    setState(() => _isScanning = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.montserrat()),
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
            const Icon(Icons.radar, color: Colors.cyan),
            const SizedBox(width: 12),
            Text(
              'FluxScan',
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
          if (_results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _exportResults,
              tooltip: 'Export Results',
            ),
        ],
      ),
      body: Column(
        children: [
          // Input Section
          _buildInputSection(),
          
          // Radar Section
          if (_isScanning || _radarPoints.isNotEmpty)
            _buildRadarSection(),
          
          // Results Section
          Expanded(
            child: _buildResultsSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyan.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Configuration',
            style: GoogleFonts.orbitron(
              color: Colors.cyan,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // IP Address
          TextField(
            controller: _ipController,
            style: GoogleFonts.robotoMono(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'IP Address',
              labelStyle: GoogleFonts.montserrat(color: Colors.grey),
              prefixIcon: const Icon(Icons.computer, color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.cyan.withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.cyan.withOpacity(0.5)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.cyan, width: 2),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Port Range
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _startPortController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.robotoMono(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Start Port',
                    labelStyle: GoogleFonts.montserrat(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.cyan.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _endPortController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.robotoMono(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'End Port',
                    labelStyle: GoogleFonts.montserrat(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.cyan.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Quick Scan Buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickScanButton('Web', PortScannerService.webServerPorts, Icons.web),
              _buildQuickScanButton('Database', PortScannerService.databasePorts, Icons.storage),
              _buildQuickScanButton('Remote', PortScannerService.remotePorts, Icons.terminal),
              _buildQuickScanButton('Mail', PortScannerService.mailPorts, Icons.email),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Scan Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isScanning ? _stopScan : () => _startScan(),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isScanning ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_isScanning ? Icons.stop : Icons.play_arrow),
                  const SizedBox(width: 8),
                  Text(
                    _isScanning ? 'STOP SCAN' : 'START SCAN',
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
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildQuickScanButton(String label, List<int> ports, IconData icon) {
    return ElevatedButton.icon(
      onPressed: _isScanning ? null : () => _startScan(customPorts: ports),
      icon: Icon(icon, size: 16),
      label: Text(label, style: GoogleFonts.montserrat(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.cyan.withOpacity(0.2),
        foregroundColor: Colors.cyan,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.cyan),
        ),
      ),
    );
  }

  Widget _buildRadarSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.5),
            const Color(0xFF1A1F3A).withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'RADAR SCAN',
            style: GoogleFonts.orbitron(
              color: Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          RadarWidget(
            isScanning: _isScanning,
            points: _radarPoints,
            size: 250,
          ),
          const SizedBox(height: 8),
          Text(
            '$_scannedPorts / $_totalPorts ports scanned',
            style: GoogleFonts.robotoMono(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          if (_openPorts > 0)
            Text(
              '$_openPorts open ports found',
              style: GoogleFonts.robotoMono(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).scale(delay: 200.ms);
  }

  Widget _buildResultsSection() {
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.radar,
              size: 80,
              color: Colors.cyan.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No scan results yet',
              style: GoogleFonts.montserrat(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter an IP and start scanning',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Scan Results',
                style: GoogleFonts.orbitron(
                  color: Colors.cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_results.length} ports',
                style: GoogleFonts.robotoMono(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _results.length,
            itemBuilder: (context, index) {
              return ScanResultCard(
                result: _results[index],
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }

  void _exportResults() {
    final json = _service.exportToJson(_results);
    // TODO: Implement file export
    _showError('Export feature coming soon!');
  }
}
