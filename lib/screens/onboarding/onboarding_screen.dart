import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../theme/app_theme.dart';
import '../auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to FluxFlow',
      description: 'The Ultimate Student OS with 50+ features to boost your academic journey',
      icon: Icons.school,
      color: Colors.cyanAccent,
    ),
    OnboardingPage(
      title: 'Academic Excellence',
      description: 'Manage timetables, track attendance, upload notes, and stay organized',
      icon: Icons.book,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'Smart Productivity',
      description: 'Scientific calculator, alarms, focus timer, and productivity tools',
      icon: Icons.calculate,
      color: Colors.green,
    ),
    OnboardingPage(
      title: 'Learn & Code',
      description: 'C programming lab, LeetCode problems, and tech roadmaps',
      icon: Icons.code,
      color: Colors.orange,
    ),
    OnboardingPage(
      title: 'Connect & Chat',
      description: 'Enhanced ChatHub with reactions, polls, and real-time messaging',
      icon: Icons.chat,
      color: Colors.purple,
    ),
    OnboardingPage(
      title: 'Games & Fun',
      description: '6 engaging games with healthy time limits for balanced learning',
      icon: Icons.games,
      color: Colors.pink,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black,
                  _pages[_currentPage].color.withOpacity(0.1),
                  Colors.black,
                ],
              ),
            ),
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 3.seconds, color: _pages[_currentPage].color.withOpacity(0.3)),

          SafeArea(
            child: Column(
              children: [
                // Skip Button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextButton(
                      onPressed: _completeOnboarding,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page View
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),

                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[_currentPage].color
                            : Colors.white30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                    .animate()
                    .scale(duration: 300.ms)
                    .fadeIn(),
                  ),
                ),

                const SizedBox(height: 32),

                // Navigation Buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous Button
                      _currentPage > 0
                          ? TextButton(
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text(
                                'Previous',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : const SizedBox(width: 80),

                      // Next/Get Started Button
                      ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _completeOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _pages[_currentPage].color,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      .animate()
                      .scale(duration: 200.ms)
                      .shimmer(delay: 1.seconds, duration: 2.seconds),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: page.color.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          )
          .animate()
          .scale(duration: 600.ms, curve: Curves.elasticOut)
          .fadeIn(duration: 400.ms),

          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
          .animate()
          .fadeIn(delay: 200.ms, duration: 600.ms)
          .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 24),

          // Description
          Text(
            page.description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          )
          .animate()
          .fadeIn(delay: 400.ms, duration: 600.ms)
          .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  void _completeOnboarding() async {
    // Mark onboarding as completed
    final box = Hive.box('user_prefs');
    await box.put('onboarding_completed', true);

    // Navigate to auth screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
      );
    }
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}