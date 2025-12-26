import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'programming_languages_data.dart';

class LanguageDetailScreen extends StatefulWidget {
  final ProgrammingLanguage language;

  const LanguageDetailScreen({super.key, required this.language});

  @override
  State<LanguageDetailScreen> createState() => _LanguageDetailScreenState();
}

class _LanguageDetailScreenState extends State<LanguageDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _waveController;
  int? _expandedTopicIndex;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = widget.language;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0A0A0F),
              lang.primaryColor.withOpacity(0.1),
              lang.secondaryColor.withOpacity(0.05),
              const Color(0xFF0A0A0F),
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverHeader(lang),
              _buildLanguageInfo(lang),
              _buildUseCases(lang),
              _buildTopicsSection(lang),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverHeader(ProgrammingLanguage lang) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: AnimatedBuilder(
        animation: _glowController,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: lang.primaryColor.withOpacity(0.3 + _glowController.value * 0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.5),
                foregroundColor: lang.primaryColor,
              ),
            ),
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Animated background pattern
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _WavePainter(
                    lang.primaryColor,
                    _waveController.value,
                  ),
                  size: Size.infinite,
                );
              },
            ),
            // Language icon with glow
            Center(
              child: AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          lang.primaryColor.withOpacity(0.3),
                          lang.secondaryColor.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: lang.primaryColor.withOpacity(0.4 + _glowController.value * 0.3),
                          blurRadius: 30 + _glowController.value * 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      lang.icon,
                      size: 60,
                      color: lang.primaryColor,
                    ),
                  );
                },
              ),
            ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          ],
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [lang.primaryColor, lang.secondaryColor],
          ).createShader(bounds),
          child: Text(
            lang.name,
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }

  Widget _buildLanguageInfo(ProgrammingLanguage lang) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              lang.primaryColor.withOpacity(0.1),
              Colors.black.withOpacity(0.3),
            ],
          ),
          border: Border.all(
            color: lang.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tagline with neon effect
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [lang.primaryColor, Colors.white],
              ).createShader(bounds),
              child: Text(
                lang.tagline,
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              lang.description,
              style: GoogleFonts.sourceCodePro(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            // Stats row
            Row(
              children: [
                _buildStatChip(
                  Icons.calendar_today,
                  'Created ${lang.yearCreated}',
                  lang.primaryColor,
                ),
                const SizedBox(width: 10),
                _buildStatChip(
                  Icons.person,
                  lang.creator.isNotEmpty ? lang.creator : 'Unknown',
                  lang.secondaryColor,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatChip(
                  Icons.topic,
                  '${lang.topics.length} Topics',
                  Colors.cyan,
                ),
                const SizedBox(width: 10),
                _buildStatChip(
                  Icons.signal_cellular_alt,
                  lang.difficulty,
                  _getDifficultyColor(lang.difficulty),
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(0.15),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.sourceCodePro(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUseCases(ProgrammingLanguage lang) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '⚡ USE CASES',
              style: GoogleFonts.orbitron(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: lang.primaryColor,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: lang.useCases.asMap().entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        lang.primaryColor.withOpacity(0.2),
                        lang.secondaryColor.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: lang.primaryColor.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    entry.value,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ).animate(delay: Duration(milliseconds: 100 * entry.key))
                    .fadeIn()
                    .scale(begin: const Offset(0.8, 0.8));
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ).animate().fadeIn(delay: 300.ms),
    );
  }

  Widget _buildTopicsSection(ProgrammingLanguage lang) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'TOPICS',
                  style: GoogleFonts.orbitron(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: lang.primaryColor.withOpacity(0.2),
                  ),
                  child: Text(
                    '${lang.topics.length}',
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: lang.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...lang.topics.asMap().entries.map((entry) {
              return _buildTopicCard(entry.value, entry.key, lang);
            }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard(LanguageTopic topic, int index, ProgrammingLanguage lang) {
    final isExpanded = _expandedTopicIndex == index;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            lang.primaryColor.withOpacity(isExpanded ? 0.15 : 0.08),
            Colors.black.withOpacity(0.4),
          ],
        ),
        border: Border.all(
          color: lang.primaryColor.withOpacity(isExpanded ? 0.5 : 0.2),
          width: isExpanded ? 2 : 1,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: lang.primaryColor.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            HapticFeedback.lightImpact();
            setState(() {
              _expandedTopicIndex = expanded ? index : null;
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [lang.primaryColor, lang.secondaryColor],
                  ),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: GoogleFonts.orbitron(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  topic.title,
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lang.primaryColor.withOpacity(0.2),
            ),
            child: Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: lang.primaryColor,
              size: 20,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Content
                  Text(
                    topic.content,
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.6,
                    ),
                  ),
                  
                  // Code example
                  if (topic.codeExample != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.cyan.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Code header
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.cyan.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(11),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.code,
                                  size: 14,
                                  color: Colors.cyan,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Code Example',
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.cyan,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(
                                      ClipboardData(text: topic.codeExample!),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Code copied!'),
                                        backgroundColor: lang.primaryColor,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    size: 14,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Code content
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(11),
                            ),
                            child: HighlightView(
                              topic.codeExample!,
                              language: _getLanguageCode(lang.name),
                              theme: atomOneDarkTheme,
                              padding: const EdgeInsets.all(12),
                              textStyle: GoogleFonts.sourceCodePro(
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // Key points
                  if (topic.keyPoints.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      '💡 KEY POINTS',
                      style: GoogleFonts.orbitron(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...topic.keyPoints.map((point) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              point,
                              style: GoogleFonts.sourceCodePro(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: 50 * index))
        .fadeIn()
        .slideX(begin: 0.1);
  }

  String _getLanguageCode(String langName) {
    final Map<String, String> langCodes = {
      'Python': 'python',
      'JavaScript': 'javascript',
      'C': 'c',
      'C++': 'cpp',
      'Java': 'java',
      'Kotlin': 'kotlin',
      'Go': 'go',
      'Rust': 'rust',
      'Dart': 'dart',
      'TypeScript': 'typescript',
      'SQL': 'sql',
      'Swift': 'swift',
    };
    return langCodes[langName] ?? 'plaintext';
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.cyan;
    }
  }
}

class _WavePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  _WavePainter(this.color, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 5; i++) {
      final path = Path();
      final waveHeight = 20.0 + i * 10;
      final shift = animationValue * 2 * 3.14159 + i * 0.5;
      
      path.moveTo(0, size.height / 2);
      for (double x = 0; x <= size.width; x += 5) {
        final y = size.height / 2 + 
            waveHeight * (0.5 + 0.5 * (i / 5)) * 
            (1 + 0.5 * (x / size.width)) *
            (0.5 + 0.5 * animationValue) *
            (x / size.width) * 
            (1 - x / size.width) * 4 *
            ((x / size.width - 0.5).abs() < 0.3 ? 1 : 0.3);
        path.lineTo(x, y + waveHeight * 0.3 * (i % 2 == 0 ? 1 : -1) * 
            (0.5 + 0.5 * animationValue));
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
