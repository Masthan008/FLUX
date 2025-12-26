import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/dashboard_service.dart';

class ScheduleWidget extends StatefulWidget {
  const ScheduleWidget({super.key});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  final DashboardService _dashboardService = DashboardService();
  Map<String, dynamic> _data = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _dashboardService.getWidgetData(DashboardWidgetType.schedule);
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.cyanAccent,
          strokeWidth: 2,
        ),
      );
    }

    final classes = _data['classes'] as List<dynamic>? ?? [];
    final totalClasses = _data['total_classes_today'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: Colors.cyanAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Today\'s Schedule',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Schedule Content
          Expanded(
            child: totalClasses == 0
                ? _buildEmptySchedule()
                : _buildScheduleList(classes),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySchedule() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            color: Colors.grey.shade600,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No classes today',
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
          Text(
            'Enjoy your free day!',
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade500,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList(List<dynamic> classes) {
    return ListView.builder(
      itemCount: classes.length > 3 ? 3 : classes.length, // Show max 3 classes
      itemBuilder: (context, index) {
        final classData = classes[index] as Map<String, dynamic>;
        return _buildClassItem(classData, index);
      },
    );
  }

  Widget _buildClassItem(Map<String, dynamic> classData, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              classData['time'] ?? '',
              style: GoogleFonts.montserrat(
                color: Colors.cyanAccent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Class Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classData['subject'] ?? '',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (classData['location'] != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    classData['location'],
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(delay: (index * 100).ms, duration: 400.ms)
    .slideX(begin: -0.3, end: 0);
  }
}