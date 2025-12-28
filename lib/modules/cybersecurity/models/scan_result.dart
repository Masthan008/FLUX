import 'package:flutter/material.dart';

class ScanResult {
  final String ip;
  final int port;
  final bool isOpen;
  final String service;
  final DateTime timestamp;
  final int responseTime; // in milliseconds

  ScanResult({
    required this.ip,
    required this.port,
    required this.isOpen,
    required this.service,
    required this.timestamp,
    this.responseTime = 0,
  });

  String get status => isOpen ? 'OPEN' : 'CLOSED';
  
  Color get statusColor => isOpen ? Colors.green : Colors.red.shade700;
  
  IconData get statusIcon => isOpen ? Icons.check_circle : Icons.cancel;

  String get formattedTime {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  Map<String, dynamic> toJson() => {
    'ip': ip,
    'port': port,
    'isOpen': isOpen,
    'service': service,
    'timestamp': timestamp.toIso8601String(),
    'responseTime': responseTime,
  };

  @override
  String toString() => '$ip:$port - $status ($service)';
}
