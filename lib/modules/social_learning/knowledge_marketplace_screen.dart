import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class KnowledgeMarketplaceScreen extends StatefulWidget {
  const KnowledgeMarketplaceScreen({super.key});

  @override
  State<KnowledgeMarketplaceScreen> createState() => _KnowledgeMarketplaceScreenState();
}

class _KnowledgeMarketplaceScreenState extends State<KnowledgeMarketplaceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedType = 'All';

  final List<String> _categories = [
    'All', 'Mathematics', 'Physics', 'Chemistry', 'Computer Science', 'Biology', 'English', 'History'
  ];

  final List<String> _types = [
    'All', 'Notes', 'Assignments', 'Projects', 'Study Guides', 'Practice Tests', 'Videos', 'Books'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
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
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.explore), text: 'Browse'),
              Tab(icon: Icon(Icons.upload), text: 'My Resources'),
              Tab(icon: Icon(Icons.favorite), text: 'Saved'),
            ],
          ),
        ),
        
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildBrowseTab(),
              _buildMyResourcesTab(),
              _buildSavedTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        // Search and Filters
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade900.withOpacity(0.3),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search resources...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),
              
              // Category Filter
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedCategory = category);
                        },
                        backgroundColor: Colors.grey.shade800,
                        selectedColor: Colors.green,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade300,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              
              // Type Filter
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _types.length,
                  itemBuilder: (context, index) {
                    final type = _types[index];
                    final isSelected = type == _selectedType;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(type),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedType = type);
                        },
                        backgroundColor: Colors.grey.shade800,
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey.shade300,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Resources List
        Expanded(
          child: _buildResourcesList(),
        ),
      ],
    );
  }

  Widget _buildResourcesList() {
    final sampleResources = _getSampleResources();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sampleResources.length,
      itemBuilder: (context, index) {
        final resource = sampleResources[index];
        return _buildResourceCard(resource, index);
      },
    );
  }

  Widget _buildResourceCard(Map<String, dynamic> resource, int index) {
    final type = resource['type'] as String;
    final IconData typeIcon = _getTypeIcon(type);
    final Color typeColor = _getTypeColor(type);

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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(typeIcon, color: typeColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource['title'] as String,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'by ${resource['author']} • ${resource['category']}',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _toggleSave(resource),
                  icon: Icon(
                    resource['isSaved'] ? Icons.favorite : Icons.favorite_border,
                    color: resource['isSaved'] ? Colors.red : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              resource['description'] as String,
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade300,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Tags
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (resource['tags'] as List<String>).map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.montserrat(
                    color: Colors.purple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 16),
            
            // Stats and Actions
            Row(
              children: [
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${resource['rating']}',
                      style: GoogleFonts.montserrat(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Downloads
                Row(
                  children: [
                    const Icon(Icons.download, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${resource['downloads']}',
                      style: GoogleFonts.montserrat(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                
                // Actions
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _previewResource(resource),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text('Preview', style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _downloadResource(resource),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                      child: const Text('Download', style: TextStyle(fontSize: 12)),
                    ),
                  ],
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

  Widget _buildMyResourcesTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.upload_outlined, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 24),
          Text(
            'No Resources Uploaded',
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Share your knowledge with the community',
            style: GoogleFonts.montserrat(color: Colors.grey.shade400, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _uploadResource,
            icon: const Icon(Icons.upload),
            label: const Text('Upload Resource'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_outline, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 24),
          Text(
            'No Saved Resources',
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Save resources to access them later',
            style: GoogleFonts.montserrat(color: Colors.grey.shade400, fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _tabController.animateTo(0),
            icon: const Icon(Icons.explore),
            label: const Text('Browse Resources'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Notes': return Icons.note;
      case 'Assignments': return Icons.assignment;
      case 'Projects': return Icons.work;
      case 'Study Guides': return Icons.book;
      case 'Practice Tests': return Icons.quiz;
      case 'Videos': return Icons.video_library;
      case 'Books': return Icons.menu_book;
      default: return Icons.description;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Notes': return Colors.blue;
      case 'Assignments': return Colors.orange;
      case 'Projects': return Colors.purple;
      case 'Study Guides': return Colors.green;
      case 'Practice Tests': return Colors.red;
      case 'Videos': return Colors.pink;
      case 'Books': return Colors.teal;
      default: return Colors.grey;
    }
  }

  List<Map<String, dynamic>> _getSampleResources() {
    return [
      {
        'title': 'Calculus Derivatives Cheat Sheet',
        'author': 'Sarah Johnson',
        'category': 'Mathematics',
        'type': 'Study Guides',
        'description': 'Comprehensive guide covering all derivative rules with examples and practice problems.',
        'tags': ['calculus', 'derivatives', 'math'],
        'rating': 4.8,
        'downloads': 245,
        'isSaved': false,
      },
      {
        'title': 'Physics Lab Report Template',
        'author': 'Mike Chen',
        'category': 'Physics',
        'type': 'Assignments',
        'description': 'Professional template for physics lab reports with proper formatting and sections.',
        'tags': ['physics', 'lab', 'template'],
        'rating': 4.6,
        'downloads': 189,
        'isSaved': true,
      },
      {
        'title': 'Data Structures Implementation',
        'author': 'Emma Davis',
        'category': 'Computer Science',
        'type': 'Projects',
        'description': 'Complete implementation of common data structures in Python with explanations.',
        'tags': ['programming', 'data-structures', 'python'],
        'rating': 4.9,
        'downloads': 312,
        'isSaved': false,
      },
      {
        'title': 'Organic Chemistry Practice Test',
        'author': 'Alex Wilson',
        'category': 'Chemistry',
        'type': 'Practice Tests',
        'description': 'Comprehensive practice test covering organic chemistry reactions and mechanisms.',
        'tags': ['chemistry', 'organic', 'test'],
        'rating': 4.7,
        'downloads': 156,
        'isSaved': false,
      },
      {
        'title': 'Linear Algebra Video Series',
        'author': 'Dr. Martinez',
        'category': 'Mathematics',
        'type': 'Videos',
        'description': 'Complete video series explaining linear algebra concepts with visual examples.',
        'tags': ['linear-algebra', 'videos', 'math'],
        'rating': 4.9,
        'downloads': 428,
        'isSaved': true,
      },
    ];
  }

  void _toggleSave(Map<String, dynamic> resource) {
    setState(() {
      resource['isSaved'] = !resource['isSaved'];
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          resource['isSaved'] ? 'Resource saved!' : 'Resource removed from saved',
        ),
        backgroundColor: resource['isSaved'] ? Colors.green : Colors.orange,
      ),
    );
  }

  void _previewResource(Map<String, dynamic> resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          resource['title'],
          style: GoogleFonts.orbitron(color: Colors.green),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Author: ${resource['author']}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Category: ${resource['category']}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Type: ${resource['type']}', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text('Description: ${resource['description']}', style: const TextStyle(color: Colors.white)),
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
              _downloadResource(resource);
            },
            child: const Text('Download', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _downloadResource(Map<String, dynamic> resource) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${resource['title']}...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _uploadResource() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Upload Resource',
          style: GoogleFonts.orbitron(color: Colors.green),
        ),
        content: const Text(
          'Resource upload functionality will be available soon!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}