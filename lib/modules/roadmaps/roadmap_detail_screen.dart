import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'roadmap_data.dart';

class RoadmapDetailScreen extends StatefulWidget {
  final TechRoadmap roadmap;

  const RoadmapDetailScreen({super.key, required this.roadmap});

  @override
  State<RoadmapDetailScreen> createState() => _RoadmapDetailScreenState();
}

class _RoadmapDetailScreenState extends State<RoadmapDetailScreen> 
    with TickerProviderStateMixin {
  late Box _progressBox;
  Set<int> _completedSteps = {};
  late AnimationController _headerAnimationController;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadProgress();
  }

  void _initializeAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadProgress() async {
    _progressBox = await Hive.openBox('roadmap_progress');
    final progress = _progressBox.get(widget.roadmap.title, defaultValue: <int>[]);
    setState(() {
      _completedSteps = Set<int>.from(progress);
    });
    _progressAnimationController.forward();
  }

  Future<void> _toggleStep(int index) async {
    setState(() {
      if (_completedSteps.contains(index)) {
        _completedSteps.remove(index);
      } else {
        _completedSteps.add(index);
      }
    });
    await _progressBox.put(widget.roadmap.title, _completedSteps.toList());
  }

  @override
  Widget build(BuildContext context) {
    final progress = _completedSteps.length / widget.roadmap.steps.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              const Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.cyanAccent,
                        size: 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.3),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.roadmap.title,
                        style: GoogleFonts.orbitron(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Enhanced Header Card
                      Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.roadmap.color.withOpacity(0.3),
                              widget.roadmap.color.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: widget.roadmap.color.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.roadmap.color.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: widget.roadmap.color.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: widget.roadmap.color.withOpacity(0.4),
                                ),
                              ),
                              child: Icon(
                                widget.roadmap.icon,
                                size: 48,
                                color: widget.roadmap.color,
                              ),
                            ).animate().scale(begin: const Offset(0.8, 0.8)).fadeIn(delay: 300.ms),
                            const SizedBox(height: 16),
                            Text(
                              widget.roadmap.description,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildEnhancedInfoChip(Icons.schedule_rounded, widget.roadmap.duration, 0),
                                _buildEnhancedInfoChip(Icons.list_alt_rounded, '${widget.roadmap.steps.length} steps', 1),
                                _buildEnhancedInfoChip(
                                  Icons.check_circle_rounded,
                                  '${(progress * 100).toInt()}%',
                                  2,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            AnimatedBuilder(
                              animation: _progressAnimation,
                              builder: (context, child) {
                                return Container(
                                  height: 12,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: progress * _progressAnimation.value,
                                      backgroundColor: Colors.transparent,
                                      valueColor: AlwaysStoppedAnimation<Color>(widget.roadmap.color),
                                      minHeight: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Progress: ${(progress * 100).toInt()}% Complete',
                              style: GoogleFonts.poppins(
                                color: widget.roadmap.color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ).animate().fadeIn(delay: 600.ms),
                          ],
                        ),
                      ).animate().fadeIn(delay: 300.ms).slideY(begin: -0.3),
                      
                      // Enhanced Steps List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: widget.roadmap.steps.length,
                        itemBuilder: (context, index) {
                          final step = widget.roadmap.steps[index];
                          final isCompleted = _completedSteps.contains(index);
                          
                          return _buildEnhancedStepCard(step, index, isCompleted);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoChip(IconData icon, String label, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.roadmap.color.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: widget.roadmap.color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (500 + index * 100).ms).scale(begin: const Offset(0.8, 0.8));
  }

  Widget _buildEnhancedStepCard(RoadmapStep step, int index, bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: isCompleted 
              ? widget.roadmap.color.withOpacity(0.8) 
              : Colors.white.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isCompleted 
                ? widget.roadmap.color.withOpacity(0.3) 
                : Colors.black.withOpacity(0.2),
            blurRadius: isCompleted ? 15 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: () => _toggleStep(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isCompleted
                    ? LinearGradient(
                        colors: [
                          widget.roadmap.color,
                          widget.roadmap.color.withOpacity(0.8),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.grey.shade700,
                          Colors.grey.shade800,
                        ],
                      ),
                border: Border.all(
                  color: isCompleted 
                      ? widget.roadmap.color.withOpacity(0.5) 
                      : Colors.white.withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isCompleted 
                        ? widget.roadmap.color.withOpacity(0.4) 
                        : Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isCompleted
                      ? Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 24,
                          key: ValueKey('check_$index'),
                        )
                      : Text(
                          '${index + 1}',
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          key: ValueKey('number_$index'),
                        ),
                ),
              ),
            ),
          ),
          title: Text(
            step.title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                step.description,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: widget.roadmap.color),
                  const SizedBox(width: 4),
                  Text(
                    step.duration,
                    style: GoogleFonts.poppins(
                      color: widget.roadmap.color,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Topics
                  Text(
                    'Topics to Learn:',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...step.topics.map((topic) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: widget.roadmap.color.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_right,
                                  color: widget.roadmap.color,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    topic.title,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (topic.content.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Padding(
                                padding: const EdgeInsets.only(left: 28),
                                child: Text(
                                  topic.content,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade400,
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  
                  // Resources
                  Text(
                    'Recommended Resources:',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...step.resources.map((resource) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.link,
                              color: Colors.blue,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              resource,
                              style: GoogleFonts.montserrat(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 16),
                  
                  // Mark Complete Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _toggleStep(index),
                      icon: Icon(
                        isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      ),
                      label: Text(
                        isCompleted ? 'Completed' : 'Mark as Complete',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isCompleted
                            ? widget.roadmap.color
                            : Colors.grey.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (700 + index * 150).ms).slideX(begin: index.isEven ? -0.3 : 0.3);
  }
}
