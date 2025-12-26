import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/focus_provider.dart';

class ForestHistoryScreen extends StatefulWidget {
  const ForestHistoryScreen({super.key});

  @override
  State<ForestHistoryScreen> createState() => _ForestHistoryScreenState();
}

class _ForestHistoryScreenState extends State<ForestHistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final provider = Provider.of<FocusProvider>(context, listen: false);
    final history = await provider.getHistory();
    
    setState(() {
      _history = history.reversed.toList(); // Most recent first
      _isLoading = false;
    });
  }

  int _getTotalMinutes() {
    return _history.fold(0, (sum, tree) {
      if (tree['status'] == 'alive') {
        return sum + (tree['minutes'] as int);
      }
      return sum;
    });
  }

  int _getAliveCount() {
    return _history.where((tree) => tree['status'] == 'alive').length;
  }

  int _getDeadCount() {
    return _history.where((tree) => tree['status'] == 'dead').length;
  }

  @override
  Widget build(BuildContext context) {
    final totalMinutes = _getTotalMinutes();
    final totalHours = (totalMinutes / 60).toStringAsFixed(1);
    final aliveCount = _getAliveCount();
    final deadCount = _getDeadCount();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'My Forest',
          style: GoogleFonts.orbitron(
            color: Colors.greenAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade900,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            )
          : Column(
              children: [
                // Stats Header
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade900.withOpacity(0.5),
                        Colors.green.shade700.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            Icons.access_time,
                            '$totalHours hrs',
                            'Total Focus',
                            Colors.cyanAccent,
                          ),
                          _buildStatItem(
                            Icons.park,
                            '$aliveCount',
                            'Trees Planted',
                            Colors.green,
                          ),
                          _buildStatItem(
                            Icons.dangerous,
                            '$deadCount',
                            'Trees Lost',
                            Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Forest Grid
                Expanded(
                  child: _history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.eco_outlined,
                                size: 80,
                                color: Colors.grey.shade700,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No trees yet',
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start focusing to grow your forest!',
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: _history.length,
                          itemBuilder: (context, index) {
                            final tree = _history[index];
                            final minutes = tree['minutes'] as int;
                            final status = tree['status'] as String;
                            final date = DateTime.parse(tree['date'] as String);
                            final isAlive = status == 'alive';

                            return _buildTreeCard(
                              minutes: minutes,
                              isAlive: isAlive,
                              date: date,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTreeCard({
    required int minutes,
    required bool isAlive,
    required DateTime date,
  }) {
    final icon = isAlive
        ? FocusProvider.getTreeIconByMinutes(minutes)
        : Icons.nature; // Withered tree
    
    final color = isAlive
        ? FocusProvider.getTreeColorByMinutes(minutes)
        : Colors.brown.shade700;

    final dateStr = DateFormat('MMM d').format(date);
    final timeStr = DateFormat('h:mm a').format(date);

    return GestureDetector(
      onTap: () {
        _showTreeDetails(minutes, isAlive, date);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isAlive
              ? Colors.green.shade900.withOpacity(0.3)
              : Colors.grey.shade900.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isAlive ? color.withOpacity(0.5) : Colors.grey.shade800,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Tree Icon
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: color,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$minutes min',
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dateStr,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            
            // Dead Badge
            if (!isAlive)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showTreeDetails(int minutes, bool isAlive, DateTime date) {
    final dateStr = DateFormat('MMMM d, yyyy').format(date);
    final timeStr = DateFormat('h:mm a').format(date);
    
    String treeType;
    if (minutes < 15) {
      treeType = '🌱 Grass';
    } else if (minutes < 30) {
      treeType = '🌸 Flower';
    } else if (minutes < 60) {
      treeType = '🌲 Pine Tree';
    } else {
      treeType = '🌳 Oak Forest';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Icon(
              isAlive ? Icons.park : Icons.dangerous,
              color: isAlive ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            Text(
              isAlive ? 'Tree Details' : 'Lost Tree',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type:', treeType),
            _buildDetailRow('Duration:', '$minutes minutes'),
            _buildDetailRow('Date:', dateStr),
            _buildDetailRow('Time:', timeStr),
            _buildDetailRow('Status:', isAlive ? '✅ Completed' : '❌ Failed'),
            if (!isAlive)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  '💡 Tip: Stay in the app to keep your tree alive!',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
