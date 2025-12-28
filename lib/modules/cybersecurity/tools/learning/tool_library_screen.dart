import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'tool_database.dart';

class ToolLibraryScreen extends StatelessWidget {
  const ToolLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = cyberTools.map((t) => t.category).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.menu_book, color: Colors.pink),
            const SizedBox(width: 12),
            Text(
              'Tool Encyclopedia',
              style: GoogleFonts.orbitron(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        iconTheme: const IconThemeData(color: Colors.cyan),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cyberTools.length,
        itemBuilder: (context, index) {
          final tool = cyberTools[index];
          return _buildToolCard(context, tool, index);
        },
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, CyberTool tool, int index) {
    final color = _getColor(tool.color);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ToolDetailScreen(tool: tool),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.5)],
                    ),
                  ),
                  child: Icon(_getIcon(tool.icon), color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.name,
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tool.category,
                          style: GoogleFonts.montserrat(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tool.description,
                        style: GoogleFonts.montserrat(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 100))
      .slideX(begin: -0.2, delay: Duration(milliseconds: index * 100));
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'green': return Colors.green;
      case 'red': return Colors.red;
      case 'orange': return Colors.orange;
      case 'blue': return Colors.blue;
      case 'purple': return Colors.purple;
      case 'cyan': return Colors.cyan;
      case 'pink': return Colors.pink;
      case 'yellow': return Colors.yellow;
      default: return Colors.grey;
    }
  }

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'radar': return Icons.radar;
      case 'bug_report': return Icons.bug_report;
      case 'lock_open': return Icons.lock_open;
      case 'analytics': return Icons.analytics;
      case 'web': return Icons.web;
      case 'wifi': return Icons.wifi;
      case 'storage': return Icons.storage;
      case 'vpn_key': return Icons.vpn_key;
      default: return Icons.help;
    }
  }
}

class ToolDetailScreen extends StatelessWidget {
  final CyberTool tool;

  const ToolDetailScreen({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    final color = _getColor(tool.color);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: Text(
          tool.name,
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1A1F3A),
        iconTheme: const IconThemeData(color: Colors.cyan),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Description
          _buildSection(
            'Description',
            tool.description,
            Icons.info_outline,
            color,
          ),

          // Usage
          _buildSection(
            'Usage',
            tool.usage,
            Icons.lightbulb_outline,
            color,
          ),

          // Commands
          _buildCommandsSection(color),

          // How It Works
          _buildSection(
            'How It Works',
            tool.howItWorks,
            Icons.settings,
            color,
          ),

          // Defenses
          _buildDefensesSection(color),

          // Warning
          _buildWarning(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.orbitron(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade300,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildCommandsSection(Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.terminal, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                'Example Commands',
                style: GoogleFonts.orbitron(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tool.commands.map((cmd) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Text(
                  '\$ ',
                  style: GoogleFonts.robotoMono(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Text(
                    cmd,
                    style: GoogleFonts.robotoMono(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildDefensesSection(Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, color: Colors.blue, size: 24),
              const SizedBox(width: 12),
              Text(
                'Defense Strategies',
                style: GoogleFonts.orbitron(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tool.defenses.map((defense) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    defense,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2);
  }

  Widget _buildWarning() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EDUCATIONAL USE ONLY',
                  style: GoogleFonts.orbitron(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Unauthorized use of these tools against systems you don\'t own is illegal. Always get written permission before testing.',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade300,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Color _getColor(String colorName) {
    switch (colorName) {
      case 'green': return Colors.green;
      case 'red': return Colors.red;
      case 'orange': return Colors.orange;
      case 'blue': return Colors.blue;
      case 'purple': return Colors.purple;
      case 'cyan': return Colors.cyan;
      case 'pink': return Colors.pink;
      case 'yellow': return Colors.yellow;
      default: return Colors.grey;
    }
  }
}
