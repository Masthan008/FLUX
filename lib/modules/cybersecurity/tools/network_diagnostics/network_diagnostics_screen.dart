import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'network_diagnostics_service.dart';

class NetworkDiagnosticsScreen extends StatefulWidget {
  const NetworkDiagnosticsScreen({super.key});

  @override
  State<NetworkDiagnosticsScreen> createState() => _NetworkDiagnosticsScreenState();
}

class _NetworkDiagnosticsScreenState extends State<NetworkDiagnosticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _service = NetworkDiagnosticsService();
  
  // Ping state
  final _pingController = TextEditingController(text: '8.8.8.8');
  final List<PingResult> _pingResults = [];
  bool _isPinging = false;
  
  // Whois state
  final _whoisController = TextEditingController(text: 'google.com');
  WhoisResult? _whoisResult;
  bool _isLookingUp = false;
  
  // Traceroute state
  final _traceController = TextEditingController(text: 'google.com');
  final List<TracerouteHop> _traceHops = [];
  bool _isTracing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pingController.dispose();
    _whoisController.dispose();
    _traceController.dispose();
    super.dispose();
  }

  Future<void> _startPing() async {
    final host = _pingController.text.trim();
    if (!_service.isValidHost(host)) {
      _showError('Invalid hostname or IP');
      return;
    }

    setState(() {
      _isPinging = true;
      _pingResults.clear();
    });

    await for (final result in _service.ping(host, count: 10)) {
      if (!_isPinging) break;
      setState(() {
        _pingResults.add(result);
      });
    }

    setState(() => _isPinging = false);
  }

  void _stopPing() {
    setState(() => _isPinging = false);
  }

  Future<void> _startWhois() async {
    final domain = _whoisController.text.trim();
    if (domain.isEmpty) {
      _showError('Please enter a domain name');
      return;
    }

    setState(() => _isLookingUp = true);

    final result = await _service.whoisLookup(domain);
    
    setState(() {
      _whoisResult = result;
      _isLookingUp = false;
    });
  }

  Future<void> _startTraceroute() async {
    final host = _traceController.text.trim();
    if (!_service.isValidHost(host)) {
      _showError('Invalid hostname or IP');
      return;
    }

    setState(() {
      _isTracing = true;
      _traceHops.clear();
    });

    await for (final hop in _service.traceroute(host)) {
      if (!_isTracing) break;
      setState(() {
        _traceHops.add(hop);
      });
    }

    setState(() => _isTracing = false);
  }

  void _stopTraceroute() {
    setState(() => _isTracing = false);
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
            const Icon(Icons.network_check, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              'Network Diagnostics',
              style: GoogleFonts.orbitron(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        iconTheme: const IconThemeData(color: Colors.cyan),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyan,
          labelColor: Colors.cyan,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(icon: Icon(Icons.speed), text: 'Ping'),
            Tab(icon: Icon(Icons.info_outline), text: 'Whois'),
            Tab(icon: Icon(Icons.route), text: 'Traceroute'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPingTab(),
          _buildWhoisTab(),
          _buildTracerouteTab(),
        ],
      ),
    );
  }

  Widget _buildPingTab() {
    return Column(
      children: [
        // Input section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.withOpacity(0.1),
                Colors.purple.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              TextField(
                controller: _pingController,
                style: GoogleFonts.robotoMono(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Host or IP',
                  labelStyle: GoogleFonts.montserrat(color: Colors.grey),
                  prefixIcon: const Icon(Icons.computer, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.blue.withOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isPinging ? _stopPing : _startPing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPinging ? Colors.red : Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isPinging ? Icons.stop : Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(
                        _isPinging ? 'STOP PING' : 'START PING',
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

        // Results
        Expanded(
          child: _pingResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.speed,
                        size: 80,
                        color: Colors.blue.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No ping results yet',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Graph
                    Container(
                      height: 200,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true, drawVerticalLine: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: _pingResults
                                  .asMap()
                                  .entries
                                  .map((e) => FlSpot(
                                        e.key.toDouble(),
                                        e.value.time,
                                      ))
                                  .toList(),
                              isCurved: true,
                              color: Colors.cyan,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.cyan.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Stats
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat('Min', '${_pingResults.map((e) => e.time).reduce((a, b) => a < b ? a : b).toStringAsFixed(1)}ms', Colors.green),
                          _buildStat('Avg', '${(_pingResults.map((e) => e.time).reduce((a, b) => a + b) / _pingResults.length).toStringAsFixed(1)}ms', Colors.blue),
                          _buildStat('Max', '${_pingResults.map((e) => e.time).reduce((a, b) => a > b ? a : b).toStringAsFixed(1)}ms', Colors.orange),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Results list
                    Expanded(
                      child: ListView.builder(
                        itemCount: _pingResults.length,
                        itemBuilder: (context, index) {
                          final result = _pingResults[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Seq ${result.sequence}',
                                  style: GoogleFonts.robotoMono(color: Colors.grey),
                                ),
                                Text(
                                  '${result.time.toStringAsFixed(1)} ms',
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildWhoisTab() {
    return Column(
      children: [
        // Input section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacity(0.1),
                Colors.pink.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.purple.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              TextField(
                controller: _whoisController,
                style: GoogleFonts.robotoMono(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Domain Name',
                  labelStyle: GoogleFonts.montserrat(color: Colors.grey),
                  prefixIcon: const Icon(Icons.language, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.purple.withOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLookingUp ? null : _startWhois,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLookingUp
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

        // Results
        Expanded(
          child: _whoisResult == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 80,
                        color: Colors.purple.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No whois results yet',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildWhoisCard('Domain', _whoisResult!.domain, Icons.language),
                    _buildWhoisCard('Registrar', _whoisResult!.registrar, Icons.business),
                    _buildWhoisCard('Created', _whoisResult!.createdDate, Icons.calendar_today),
                    _buildWhoisCard('Expires', _whoisResult!.expiresDate, Icons.event),
                    _buildWhoisCard('Registrant', _whoisResult!.registrantName, Icons.person),
                    _buildWhoisCard('Organization', _whoisResult!.registrantOrg, Icons.corporate_fare),
                    if (_whoisResult!.nameServers.isNotEmpty)
                      _buildWhoisCard('Name Servers', _whoisResult!.nameServers.join('\n'), Icons.dns),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTracerouteTab() {
    return Column(
      children: [
        // Input section
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orange.withOpacity(0.1),
                Colors.red.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              TextField(
                controller: _traceController,
                style: GoogleFonts.robotoMono(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Host or IP',
                  labelStyle: GoogleFonts.montserrat(color: Colors.grey),
                  prefixIcon: const Icon(Icons.route, color: Colors.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.orange.withOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isTracing ? _stopTraceroute : _startTraceroute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isTracing ? Colors.red : Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_isTracing ? Icons.stop : Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(
                        _isTracing ? 'STOP TRACE' : 'START TRACE',
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

        // Results
        Expanded(
          child: _traceHops.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.route,
                        size: 80,
                        color: Colors.orange.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No traceroute results yet',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _traceHops.length,
                  itemBuilder: (context, index) {
                    final hop = _traceHops[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            hop.isDestination
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.1),
                            Colors.black.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: hop.isDestination ? Colors.green : Colors.orange,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hop.isDestination ? Colors.green : Colors.orange,
                            ),
                            child: Center(
                              child: Text(
                                '${hop.hopNumber}',
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
                                  hop.host,
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${hop.latency.toStringAsFixed(1)} ms',
                                  style: GoogleFonts.robotoMono(
                                    color: Colors.cyan,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (hop.isDestination)
                            const Icon(Icons.flag, color: Colors.green),
                        ],
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: index * 100))
                      .slideX(begin: -0.2, delay: Duration(milliseconds: index * 100));
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
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
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildWhoisCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.purple, size: 24),
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
                    fontSize: 14,
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
