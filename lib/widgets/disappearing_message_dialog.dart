import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisappearingMessageDialog extends StatefulWidget {
  const DisappearingMessageDialog({super.key});

  @override
  State<DisappearingMessageDialog> createState() => _DisappearingMessageDialogState();
}

class _DisappearingMessageDialogState extends State<DisappearingMessageDialog> {
  Duration? _selectedDuration;

  final List<Map<String, dynamic>> _durations = [
    {'label': '1 Minute', 'duration': const Duration(minutes: 1), 'icon': Icons.timer},
    {'label': '5 Minutes', 'duration': const Duration(minutes: 5), 'icon': Icons.timer},
    {'label': '1 Hour', 'duration': const Duration(hours: 1), 'icon': Icons.schedule},
    {'label': '6 Hours', 'duration': const Duration(hours: 6), 'icon': Icons.schedule},
    {'label': '1 Day', 'duration': const Duration(days: 1), 'icon': Icons.today},
    {'label': '1 Week', 'duration': const Duration(days: 7), 'icon': Icons.calendar_today},
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Row(
              children: [
                const Icon(Icons.timer, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Disappearing Message',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              'Message will be automatically deleted after the selected time',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 24),
            
            // Duration options
            ..._durations.map((item) {
              final isSelected = _selectedDuration == item['duration'];
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDuration = item['duration'] as Duration;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange.withOpacity(0.2) : Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.orange : Colors.grey.shade700,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: isSelected ? Colors.orange : Colors.grey,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item['label'] as String,
                          style: GoogleFonts.montserrat(
                            color: isSelected ? Colors.orange : Colors.white,
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.orange,
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            
            const SizedBox(height: 24),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.montserrat(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedDuration == null
                        ? null
                        : () => Navigator.pop(context, _selectedDuration),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Set Timer',
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
