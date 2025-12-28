import 'package:dart_ping/dart_ping.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkDiagnosticsService {
  /// Ping a host and return latency results
  Stream<PingResult> ping(String host, {int count = 4}) async* {
    final ping = Ping(host, count: count);
    int sequence = 0;
    
    await for (final result in ping.stream) {
      sequence++;
      yield PingResult(
        host: host,
        sequence: sequence,
        time: result.summary?.time?.inMilliseconds.toDouble() ?? 0,
        isSuccess: result.summary?.time != null,
        timestamp: DateTime.now(),
      );
    }
  }

  /// Perform Whois lookup using API
  Future<WhoisResult> whoisLookup(String domain) async {
    try {
      // Using a free Whois API
      final url = Uri.parse('https://www.whoisxmlapi.com/whoisserver/WhoisService?apiKey=at_free&domainName=$domain&outputFormat=JSON');
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final whoisRecord = data['WhoisRecord'] ?? {};
        
        return WhoisResult(
          domain: domain,
          registrar: whoisRecord['registrarName'] ?? 'Unknown',
          createdDate: whoisRecord['createdDate'] ?? 'Unknown',
          expiresDate: whoisRecord['expiresDate'] ?? 'Unknown',
          nameServers: (whoisRecord['nameServers']?['hostNames'] as List?)
              ?.map((e) => e.toString())
              .toList() ?? [],
          registrantName: whoisRecord['registrant']?['name'] ?? 'Private',
          registrantOrg: whoisRecord['registrant']?['organization'] ?? 'Private',
          isSuccess: true,
        );
      } else {
        return WhoisResult(
          domain: domain,
          registrar: 'Error',
          createdDate: 'N/A',
          expiresDate: 'N/A',
          nameServers: [],
          registrantName: 'N/A',
          registrantOrg: 'N/A',
          isSuccess: false,
          error: 'HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      return WhoisResult(
        domain: domain,
        registrar: 'Error',
        createdDate: 'N/A',
        expiresDate: 'N/A',
        nameServers: [],
        registrantName: 'N/A',
        registrantOrg: 'N/A',
        isSuccess: false,
        error: e.toString(),
      );
    }
  }

  /// Traceroute - Educational demonstration
  /// Note: Real traceroute requires raw socket access (root) on Android
  Stream<TracerouteHop> traceroute(String host, {int maxHops = 30}) async* {
    // EDUCATIONAL NOTE: This demonstrates the CONCEPT of traceroute
    // Real implementation requires:
    // 1. Raw socket access (needs root on Android)
    // 2. ICMP packet manipulation with TTL control
    // 3. Platform-specific native code
    
    // For HOD demo: Explain that this shows how traceroute WORKS conceptually
    // but actual implementation is blocked by Android security model
    
    yield TracerouteHop(
      hopNumber: 0,
      host: 'EDUCATIONAL MODE',
      latency: 0,
      isDestination: false,
      timestamp: DateTime.now(),
    );
    
    // Show educational message instead of fake data
    yield TracerouteHop(
      hopNumber: 1,
      host: 'Real traceroute requires root access on Android',
      latency: 0,
      isDestination: false,
      timestamp: DateTime.now(),
    );
    
    yield TracerouteHop(
      hopNumber: 2,
      host: 'This would need native platform channels',
      latency: 0,
      isDestination: false,
      timestamp: DateTime.now(),
    );
    
    yield TracerouteHop(
      hopNumber: 3,
      host: 'See Tool Encyclopedia for how traceroute works',
      latency: 0,
      isDestination: true,
      timestamp: DateTime.now(),
    );
  }

  /// Validate hostname/IP
  bool isValidHost(String host) {
    // Simple validation
    if (host.isEmpty) return false;
    
    // Check if it's an IP
    final ipRegex = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    );
    if (ipRegex.hasMatch(host)) return true;
    
    // Check if it's a domain
    final domainRegex = RegExp(
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'
    );
    return domainRegex.hasMatch(host);
  }
}

class PingResult {
  final String host;
  final int sequence;
  final double time;
  final bool isSuccess;
  final DateTime timestamp;

  PingResult({
    required this.host,
    required this.sequence,
    required this.time,
    required this.isSuccess,
    required this.timestamp,
  });
}

class WhoisResult {
  final String domain;
  final String registrar;
  final String createdDate;
  final String expiresDate;
  final List<String> nameServers;
  final String registrantName;
  final String registrantOrg;
  final bool isSuccess;
  final String? error;

  WhoisResult({
    required this.domain,
    required this.registrar,
    required this.createdDate,
    required this.expiresDate,
    required this.nameServers,
    required this.registrantName,
    required this.registrantOrg,
    required this.isSuccess,
    this.error,
  });
}

class TracerouteHop {
  final int hopNumber;
  final String host;
  final double latency;
  final bool isDestination;
  final DateTime timestamp;

  TracerouteHop({
    required this.hopNumber,
    required this.host,
    required this.latency,
    required this.isDestination,
    required this.timestamp,
  });
}
