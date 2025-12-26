import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../services/community_resources_service.dart';

class CommunityResourcesScreen extends StatefulWidget {
  const CommunityResourcesScreen({super.key});

  @override
  State<CommunityResourcesScreen> createState() => _CommunityResourcesScreenState();
}

class _CommunityResourcesScreenState extends State<CommunityResourcesScreen> with SingleTickerProviderStateMixin {
  final CommunityResourcesService _service = CommunityResourcesService();
  late TabController _tabController;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Computer Science',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Engineering',
    'Web Development',
    'Mobile Development',
    'Data Science',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Community Resources',
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.cyanAccent,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Browse', icon: Icon(Icons.library_books)),
            Tab(text: 'Upload', icon: Icon(Icons.upload_file)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseTab(),
          _buildUploadTab(),
        ],
      ),
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade900,
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search resources...',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),

        // Category Filter
        Container(
          height: 50,
          color: Colors.grey.shade900,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  backgroundColor: Colors.grey.shade800,
                  selectedColor: Colors.cyanAccent,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),

        // Resources List
        Expanded(
          child: StreamBuilder<List<CommunityResource>>(
            stream: _service.getRealtimeResources(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
              
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading resources',
                        style: GoogleFonts.montserrat(color: Colors.red.shade400, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please check your internet connection',
                        style: GoogleFonts.montserrat(color: Colors.grey.shade600, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final resources = snapshot.data ?? [];
              
              // Filter resources
              final filteredResources = resources.where((resource) {
                final matchesCategory = _selectedCategory == 'All' || resource.category == _selectedCategory;
                final matchesSearch = _searchQuery.isEmpty ||
                    resource.bookName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    resource.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    resource.uploaderName.toLowerCase().contains(_searchQuery.toLowerCase());
                return matchesCategory && matchesSearch;
              }).toList();

              if (filteredResources.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.library_books_outlined, size: 64, color: Colors.grey.shade700),
                      const SizedBox(height: 16),
                      Text(
                        'No resources found',
                        style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Be the first to share a resource!',
                        style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 12),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredResources.length,
                itemBuilder: (context, index) {
                  final resource = filteredResources[index];
                  return _buildResourceCard(resource);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResourceCard(CommunityResource resource) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getFileIcon(resource.fileType),
                    color: Colors.cyanAccent,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.bookName,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'by ${resource.uploaderName}',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.download, color: Colors.green),
                  onPressed: () => _downloadResource(resource),
                ),
              ],
            ),
            if (resource.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resource.description,
                style: GoogleFonts.montserrat(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.orange.withOpacity(0.5)),
                  ),
                  child: Text(
                    resource.category,
                    style: GoogleFonts.montserrat(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.download, color: Colors.blue, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.downloadCount}',
                        style: GoogleFonts.montserrat(
                          color: Colors.blue,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(resource.createdAt),
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyanAccent.withOpacity(0.3),
                  Colors.cyanAccent.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent),
            ),
            child: Column(
              children: [
                const Icon(Icons.cloud_upload, size: 48, color: Colors.cyanAccent),
                const SizedBox(height: 12),
                Text(
                  'Share Knowledge',
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload your educational resources to help the community learn together.',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showUploadDialog,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Resource'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload Guidelines:',
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildGuideline('📚', 'Educational content only'),
          _buildGuideline('📄', 'Supported formats: PDF, DOC, DOCX, TXT, PPT, PPTX'),
          _buildGuideline('📏', 'Maximum file size: 50MB'),
          _buildGuideline('✅', 'Ensure you have rights to share the content'),
          _buildGuideline('🏷️', 'Use clear, descriptive titles'),
        ],
      ),
    );
  }

  Widget _buildGuideline(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadDialog() {
    // Implementation similar to community_books_screen.dart
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Upload feature coming soon!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _downloadResource(CommunityResource resource) async {
    try {
      if (resource.fileUrl.isNotEmpty) {
        final uri = Uri.parse(resource.fileUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening download link...'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw Exception('Cannot open download link');
        }
      } else {
        throw Exception('No download link available');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}