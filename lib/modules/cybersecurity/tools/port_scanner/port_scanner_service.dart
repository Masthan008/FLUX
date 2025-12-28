import 'dart:io';
import 'dart:async';
import 'package:fluxflow/modules/cybersecurity/models/scan_result.dart';

class PortScannerService {
  // Common ports and their services
  static const Map<int, String> commonPorts = {
    20: 'FTP Data',
    21: 'FTP Control',
    22: 'SSH',
    23: 'Telnet',
    25: 'SMTP',
    53: 'DNS',
    80: 'HTTP',
    110: 'POP3',
    143: 'IMAP',
    443: 'HTTPS',
    445: 'SMB',
    3306: 'MySQL',
    3389: 'RDP',
    5432: 'PostgreSQL',
    5900: 'VNC',
    8080: 'HTTP-Alt',
    8443: 'HTTPS-Alt',
    27017: 'MongoDB',
  };

  // Preset scan profiles
  static const List<int> webServerPorts = [80, 443, 8080, 8443];
  static const List<int> databasePorts = [3306, 5432, 27017, 1433, 1521];
  static const List<int> remotePorts = [22, 23, 3389, 5900];
  static const List<int> mailPorts = [25, 110, 143, 587, 993, 995];

  /// Scan a single port
  Future<ScanResult> scanPort(String ip, int port, {Duration timeout = const Duration(seconds: 2)}) async {
    final stopwatch = Stopwatch()..start();
    
    try {
      final socket = await Socket.connect(ip, port, timeout: timeout);
      socket.destroy();
      stopwatch.stop();
      
      return ScanResult(
        ip: ip,
        port: port,
        isOpen: true,
        service: _detectService(port),
        timestamp: DateTime.now(),
        responseTime: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      
      return ScanResult(
        ip: ip,
        port: port,
        isOpen: false,
        service: _detectService(port),
        timestamp: DateTime.now(),
        responseTime: stopwatch.elapsedMilliseconds,
      );
    }
  }

  /// Scan multiple ports
  Stream<ScanResult> scanPorts(String ip, List<int> ports, {Duration timeout = const Duration(seconds: 2)}) async* {
    for (final port in ports) {
      yield await scanPort(ip, port, timeout: timeout);
    }
  }

  /// Scan a range of ports
  Stream<ScanResult> scanPortRange(String ip, int startPort, int endPort, {Duration timeout = const Duration(seconds: 2)}) async* {
    for (int port = startPort; port <= endPort; port++) {
      yield await scanPort(ip, port, timeout: timeout);
    }
  }

  /// Quick scan of common ports
  Stream<ScanResult> quickScan(String ip) async* {
    final commonPortsList = commonPorts.keys.toList();
    yield* scanPorts(ip, commonPortsList);
  }

  /// Detect service name from port number
  String _detectService(int port) {
    return commonPorts[port] ?? 'Unknown';
  }

  /// Validate IP address
  bool isValidIP(String ip) {
    final ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    );
    return ipRegex.hasMatch(ip);
  }

  /// Validate port number
  bool isValidPort(int port) {
    return port >= 1 && port <= 65535;
  }

  /// Get preset scan profile
  List<int> getPresetPorts(String preset) {
    switch (preset.toLowerCase()) {
      case 'web':
        return webServerPorts;
      case 'database':
        return databasePorts;
      case 'remote':
        return remotePorts;
      case 'mail':
        return mailPorts;
      case 'common':
        return commonPorts.keys.toList();
      default:
        return [];
    }
  }

  /// Export scan results to JSON
  String exportToJson(List<ScanResult> results) {
    final jsonList = results.map((r) => r.toJson()).toList();
    return jsonList.toString();
  }
}
