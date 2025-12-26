import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/student_auth_service.dart';
import 'subscription_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _userTier = 'free';
  String _selectedCategory = 'All';
  bool _isLoading = true;

  final List<String> _categories = ['All', 'Python', 'Java', 'Web', 'Android', 'AI', 'C'];

  @override
  void initState() {
    super.initState();
    _fetchUserTier();
  }

  Future<void> _fetchUserTier() async {
    setState(() => _isLoading = true);
    
    final student = StudentAuthService.currentStudent;
    if (student != null) {
      setState(() {
        _userTier = student.subscriptionTier;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  int _getTierScore(String tier) {
    switch (tier.toLowerCase()) {
      case 'ultra': return 3;
      case 'pro': return 2;
      default: return 1;
    }
  }

  Future<void> _downloadProject(String link, String projectId) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      
      // Increment download count
      await Supabase.instance.client
          .from('projects')
          .update({'downloads': Supabase.instance.client.rpc('increment', params: {'row_id': projectId})})
          .eq('id', projectId);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open download link")),
        );
      }
    }
  }

  void _showUpgradeDialog(String requiredTier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.purple.withOpacity(0.3)),
        ),
        title: Row(
          children: [
            Icon(Icons.lock, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text('Upgrade Required', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This project requires ${requiredTier.toUpperCase()} tier access.',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              'Upgrade now to unlock premium projects!',
              style: TextStyle(color: Colors.amber.shade300, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Upgrade Now'),
          ),
        ],
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'ultra': return Colors.purple;
      case 'pro': return Colors.amber;
      default: return Colors.green;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'python': return Icons.code;
      case 'java': return Icons.coffee;
      case 'web': return Icons.web;
      case 'android': return Icons.android;
      case 'ai': return Icons.psychology;
      case 'c': return Icons.terminal;
      default: return Icons.folder_zip;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.cyanAccent, Colors.purple],
          ).createShader(bounds),
          child: Text(
            'Project Hub',
            style: GoogleFonts.orbitron(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.cyanAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.cyanAccent),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_getTierColor(_userTier), _getTierColor(_userTier).withOpacity(0.5)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _userTier.toUpperCase(),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(colors: [Colors.cyanAccent, Colors.purple])
                          : null,
                      color: isSelected ? null : Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.transparent : Colors.grey.shade700,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ).animate(delay: Duration(milliseconds: 50 * index)).fadeIn().slideX(begin: 0.2);
              },
            ),
          ),

          // Projects List
          Expanded(
            child: StreamBuilder(
              stream: Supabase.instance.client
                  .from('projects')
                  .stream(primaryKey: ['id']),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.cyanAccent),
                  );
                }

                var projects = snapshot.data as List<dynamic>;
                
                // Filter by category
                if (_selectedCategory != 'All') {
                  projects = projects.where((p) => p['category'] == _selectedCategory).toList();
                }

                if (projects.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open, size: 64, color: Colors.grey.shade700),
                        const SizedBox(height: 16),
                        Text(
                          'No projects in this category',
                          style: GoogleFonts.poppins(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    final String requiredTier = project['min_tier'] ?? 'free';
                    final bool isLocked = _getTierScore(_userTier) < _getTierScore(requiredTier);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade900.withOpacity(0.8),
                            Colors.black.withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isLocked 
                              ? Colors.grey.shade800 
                              : Colors.cyanAccent.withOpacity(0.3),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isLocked
                                  ? [Colors.grey.shade800, Colors.grey.shade900]
                                  : [Colors.cyanAccent.withOpacity(0.3), Colors.purple.withOpacity(0.3)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(project['category']),
                            color: isLocked ? Colors.grey : Colors.cyanAccent,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          project['title'],
                          style: GoogleFonts.poppins(
                            color: isLocked ? Colors.grey : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              project['description'],
                              style: TextStyle(
                                color: isLocked ? Colors.grey.shade700 : Colors.grey.shade400,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getTierColor(requiredTier),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    requiredTier.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.download, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  '${project['downloads'] ?? 0}',
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: isLocked
                            ? IconButton(
                                icon: const Icon(Icons.lock, color: Colors.grey),
                                onPressed: () => _showUpgradeDialog(requiredTier),
                              )
                            : IconButton(
                                icon: const Icon(Icons.download, color: Colors.greenAccent),
                                onPressed: () => _downloadProject(project['zip_link'], project['id']),
                              ),
                      ),
                    ).animate(delay: Duration(milliseconds: 100 * index)).fadeIn().slideY(begin: 0.2);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
