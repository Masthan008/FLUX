import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/social_learning_service.dart';

class PeerTutoringScreen extends StatefulWidget {
  const PeerTutoringScreen({super.key});

  @override
  State<PeerTutoringScreen> createState() => _PeerTutoringScreenState();
}

class _PeerTutoringScreenState extends State<PeerTutoringScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SocialLearningService _socialService = SocialLearningService();
  List<UserProfile> _tutors = [];
  List<TutoringSession> _sessions = [];
  bool _isLoading = true;
  String _selectedSubject = 'All';

  final List<String> _subjects = [
    'All', 'Mathematics', 'Physics', 'Chemistry', 'Computer Science', 'Biology', 'English'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final tutors = await _socialService.getAvailableTutors();
      setState(() {
        _tutors = tutors;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          color: Colors.grey.shade900.withOpacity(0.5),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.orange,
            labelColor: Colors.orange,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.search), text: 'Find Tutors'),
              Tab(icon: Icon(Icons.schedule), text: 'My Sessions'),
              Tab(icon: Icon(Icons.school), text: 'Become Tutor'),
            ],
          ),
        ),
        
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildFindTutorsTab(),
              _buildMySessionsTab(),
              _buildBecomeTutorTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFindTutorsTab() {
    return Column(
      children: [
        // Subject Filter
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade900.withOpacity(0.3),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                final isSelected = subject == _selectedSubject;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(subject),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedSubject = subject);
                    },
                    backgroundColor: Colors.grey.shade800,
                    selectedColor: Colors.orange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade300,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Tutors List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.orange))
              : _buildTutorsList(),
        ),
      ],
    );
  }

  Widget _buildTutorsList() {
    final filteredTutors = _tutors.where((tutor) {
      if (_selectedSubject == 'All') return true;
      return tutor.subjects.contains(_selectedSubject);
    }).toList();

    if (filteredTutors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 80, color: Colors.grey.shade700),
            const SizedBox(height: 24),
            Text(
              'No Tutors Available',
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Check back later or try a different subject',
              style: GoogleFonts.montserrat(color: Colors.grey.shade400, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredTutors.length,
      itemBuilder: (context, index) {
        final tutor = filteredTutors[index];
        return _buildTutorCard(tutor, index);
      },
    );
  }

  Widget _buildTutorCard(UserProfile tutor, int index) {
    final rating = tutor.stats['rating'] ?? 4.5;
    final sessionsCompleted = tutor.stats['sessions_completed'] ?? 0;

    return Card(
      color: Colors.grey.shade900.withOpacity(0.8),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  child: Text(
                    tutor.name.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.orbitron(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tutor.name,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (i) => Icon(
                            i < rating.floor() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          )),
                          const SizedBox(width: 8),
                          Text(
                            '${rating.toStringAsFixed(1)} (${sessionsCompleted} sessions)',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Available',
                    style: GoogleFonts.montserrat(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Bio
            if (tutor.bio != null)
              Text(
                tutor.bio!,
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 12),
            
            // Subjects
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: tutor.subjects.map((subject) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  subject,
                  style: GoogleFonts.montserrat(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewTutorProfile(tutor),
                    icon: const Icon(Icons.person, size: 16),
                    label: const Text('View Profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      side: const BorderSide(color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _bookSession(tutor),
                    icon: const Icon(Icons.schedule, size: 16),
                    label: const Text('Book Session'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: (index * 100).ms, duration: 600.ms)
    .slideY(begin: 0.3, end: 0);
  }

  Widget _buildMySessionsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule_outlined, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 24),
          Text(
            'No Sessions Scheduled',
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Book a session with a tutor to get started',
            style: GoogleFonts.montserrat(color: Colors.grey.shade400, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _tabController.animateTo(0),
            icon: const Icon(Icons.search),
            label: const Text('Find Tutors'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBecomeTutorTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.withOpacity(0.3), Colors.purple.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.school, color: Colors.orange, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become a Tutor',
                            style: GoogleFonts.orbitron(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Share your knowledge and help others learn',
                            style: GoogleFonts.montserrat(
                              color: Colors.grey.shade300,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Benefits
          Text(
            'Why Become a Tutor?',
            style: GoogleFonts.orbitron(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...[
            {'icon': Icons.monetization_on, 'title': 'Earn Reputation Points', 'desc': 'Build your profile and gain recognition'},
            {'icon': Icons.people, 'title': 'Help Fellow Students', 'desc': 'Make a positive impact on others\' learning'},
            {'icon': Icons.schedule, 'title': 'Flexible Schedule', 'desc': 'Tutor when it\'s convenient for you'},
            {'icon': Icons.trending_up, 'title': 'Improve Your Skills', 'desc': 'Teaching helps reinforce your own knowledge'},
          ].map((benefit) => _buildBenefitItem(
            benefit['icon'] as IconData,
            benefit['title'] as String,
            benefit['desc'] as String,
          )),
          
          const SizedBox(height: 24),
          
          // Requirements
          Text(
            'Requirements',
            style: GoogleFonts.orbitron(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...[
            'Strong knowledge in at least one subject',
            'Good communication skills',
            'Patience and willingness to help others',
            'Reliable internet connection for online sessions',
          ].map((req) => _buildRequirementItem(req)),
          
          const SizedBox(height: 32),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _applyToBecomeTutor,
              icon: const Icon(Icons.send),
              label: const Text('Apply to Become a Tutor'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String requirement) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              requirement,
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade300,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewTutorProfile(UserProfile tutor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          tutor.name,
          style: GoogleFonts.orbitron(color: Colors.orange),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${tutor.email}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Reputation: ${tutor.reputation}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Subjects: ${tutor.subjects.join(', ')}', style: const TextStyle(color: Colors.white)),
            if (tutor.bio != null) ...[
              const SizedBox(height: 8),
              Text('Bio: ${tutor.bio}', style: const TextStyle(color: Colors.white)),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _bookSession(tutor);
            },
            child: const Text('Book Session', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _bookSession(UserProfile tutor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Book Session with ${tutor.name}',
          style: GoogleFonts.orbitron(color: Colors.orange),
        ),
        content: const Text(
          'Session booking functionality will be available soon!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _applyToBecomeTutor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Tutor Application',
          style: GoogleFonts.orbitron(color: Colors.orange),
        ),
        content: const Text(
          'Tutor application process will be available soon! We\'ll review your profile and get back to you.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}