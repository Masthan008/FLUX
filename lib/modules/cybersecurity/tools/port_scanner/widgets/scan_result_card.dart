import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluxflow/modules/cybersecurity/models/scan_result.dart';

class ScanResultCard extends StatelessWidget {
  final ScanResult result;
  final int index;

  const ScanResultCard({
    super.key,
    required this.result,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            result.isOpen 
                ? Colors.green.withOpacity(0.1)
                : Colors.red.withOpacity(0.1),
            Colors.black.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: result.statusColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showDetails(context),
          onLongPress: () => _copyToClipboard(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Status Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        result.statusColor,
                        result.statusColor.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Icon(
                    result.statusIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ).animate().scale(delay: Duration(milliseconds: index * 50)),

                const SizedBox(width: 12),

                // Port Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Port ${result.port}',
                            style: GoogleFonts.robotoMono(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: result.statusColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: result.statusColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              result.status,
                              style: GoogleFonts.robotoMono(
                                color: result.statusColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.service,
                        style: GoogleFonts.montserrat(
                          color: Colors.cyan,
                          fontSize: 14,
                        ),
                      ),
                      if (result.isOpen) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${result.responseTime}ms',
                          style: GoogleFonts.robotoMono(
                            color: Colors.grey.shade400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.grey.shade500,
                      size: 14,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.formattedTime,
                      style: GoogleFonts.robotoMono(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 50))
      .slideX(begin: -0.2, delay: Duration(milliseconds: index * 50));
  }

  void _showDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: result.statusColor, width: 2),
        ),
        title: Row(
          children: [
            Icon(result.statusIcon, color: result.statusColor),
            const SizedBox(width: 12),
            Text(
              'Port ${result.port}',
              style: GoogleFonts.orbitron(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('IP Address', result.ip),
            _buildDetailRow('Port', result.port.toString()),
            _buildDetailRow('Status', result.status),
            _buildDetailRow('Service', result.service),
            if (result.isOpen)
              _buildDetailRow('Response Time', '${result.responseTime}ms'),
            _buildDetailRow('Scanned At', result.formattedTime),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.montserrat(color: Colors.cyan),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _copyToClipboard(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: result.statusColor,
            ),
            child: Text(
              'Copy',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: result.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied to clipboard',
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
