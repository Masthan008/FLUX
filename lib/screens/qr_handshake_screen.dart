import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/auth_service.dart';

class QrHandshakeScreen extends StatefulWidget {
  final bool isTeacher;
  const QrHandshakeScreen({super.key, required this.isTeacher});

  @override
  State<QrHandshakeScreen> createState() => _QrHandshakeScreenState();
}

class _QrHandshakeScreenState extends State<QrHandshakeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MobileScannerController _scannerController;
  String? _generatedQrData;
  bool _approvalGranted = false;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Initialize scanner controller with specific settings
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
    );
    
    if (!widget.isTeacher) {
      _generateStudentQr();
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _generateStudentQr() {
    final data = {
      'id': AuthService.userId,
      'name': AuthService.userName,
      'time': DateTime.now().toIso8601String(),
      'type': 'LATE_REQUEST',
    };
    setState(() {
      _generatedQrData = jsonEncode(data);
    });
  }

  void _generateTeacherApprovalQr() {
    final data = {
      'auth_token': 'GRANTED',
      'teacher_id': AuthService.userId,
      'timestamp': DateTime.now().toIso8601String(),
    };
    setState(() {
      _generatedQrData = jsonEncode(data);
    });
  }

  void _handleScannedCode(String code) {
    if (_isProcessing) return; // Prevent duplicate processing
    
    setState(() => _isProcessing = true);
    
    try {
      final data = jsonDecode(code);
      
      if (widget.isTeacher) {
        // Teacher scanning Student
        if (data['type'] == 'LATE_REQUEST') {
          _showApprovalDialog(data['name'], data['id']);
        }
      } else {
        // Student scanning Teacher
        if (data['auth_token'] == 'GRANTED') {
          // Authentication granted - you can add other functionality here
        }
      }
    } catch (e) {
      // Not our QR code, ignore
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _showApprovalDialog(String? name, String? id) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Approve Late Request?"),
        content: Text("Student: $name\nRoll No: $id"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isProcessing = false);
            },
            child: const Text("Deny"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generateTeacherApprovalQr();
              _tabController.animateTo(0);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Approval Generated! Show QR to student.")),
              );
              setState(() => _isProcessing = false);
            },
            child: const Text("Approve"),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isTeacher ? "Teacher Scanner" : "Late Request"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Show QR"),
            Tab(text: "Scan QR"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Show QR
          Center(
            child: _generatedQrData != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QrImageView(
                        data: _generatedQrData!,
                        version: QrVersions.auto,
                        size: 250.0,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.isTeacher 
                          ? "Show this to Student" 
                          : "Show this to Teacher",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                : const Text("No QR Generated yet"),
          ),
          
          // Tab 2: Scan QR with Overlay
          Stack(
            children: [
              MobileScanner(
                controller: _scannerController,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      _handleScannedCode(barcode.rawValue!);
                      break; // Stop after first valid code
                    }
                  }
                },
              ),
              // QR Scanner Overlay
              const QrScannerOverlay(),
            ],
          ),
        ],
      ),
    );
  }
}

// QR Scanner Overlay Widget
class QrScannerOverlay extends StatelessWidget {
  const QrScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Corner indicators
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.green, width: 5),
                    left: BorderSide(color: Colors.green, width: 5),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.green, width: 5),
                    right: BorderSide(color: Colors.green, width: 5),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.green, width: 5),
                    left: BorderSide(color: Colors.green, width: 5),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.green, width: 5),
                    right: BorderSide(color: Colors.green, width: 5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
