import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/dashboard_service.dart';

class ProgressChartWidget extends StatefulWidget {
  const ProgressChartWidget({super.key});

  @override
  State<ProgressChartWidget> createState() => _ProgressChartWidgetState();
}

class _ProgressChartWidgetState extends State<ProgressChartWidget> {
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
      final data = await _dashboardService.getWidgetData(DashboardWidgetType.progressChart);
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

    final weeklyProgress = _data['weekly_progress'] as List<dynamic>? ?? [];
    final totalStudyTime = _data['total_study_time'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.trending_up,
                color: Colors.cyanAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Progress',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Chart Area
          Expanded(
            child: Column(
              children: [
                // Simple Bar Chart
                Expanded(
                  child: weeklyProgress.isEmpty
                      ? _buildEmptyChart()
                      : _buildSimpleChart(weeklyProgress),
                ),
                const SizedBox(height: 8),
                
                // Summary
                Text(
                  '${(totalStudyTime / 60).toStringAsFixed(1)}h this week',
                  style: GoogleFonts.montserrat(
                    color: Colors.cyanAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            color: Colors.grey.shade600,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'No data yet',
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade400,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleChart(List<dynamic> data) {
    final maxValue = data.fold<int>(0, (max, item) {
      final studyTime = item['study_time'] as int;
      return studyTime > max ? studyTime : max;
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value as Map<String, dynamic>;
        final studyTime = item['study_time'] as int;
        final date = item['date'] as String;
        
        final height = maxValue > 0 ? (studyTime / maxValue * 60).clamp(4.0, 60.0) : 4.0;
        
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 16,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.cyanAccent,
                    Colors.cyanAccent.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            )
            .animate()
            .scaleY(
              delay: (index * 100).ms,
              duration: 600.ms,
              begin: 0,
              end: 1,
              curve: Curves.elasticOut,
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade400,
                fontSize: 8,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}