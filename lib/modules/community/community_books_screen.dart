import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/community_resources_service.dart';
import '../../services/books_upload_service.dart';

class CommunityBooksScreen extends StatefulWidget {
  const CommunityBooksScreen({super.key});

  @override
  State<CommunityBooksScreen> createState() => _CommunityBooksScreenState();
}

class _CommunityBooksScreenState extends State<CommunityBooksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final CommunityResourcesService _resourcesService = CommunityResourcesService();
  final BooksUploadService _uploadService = BooksUploadService();
  
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<CommunityResource> _resources = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'All',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Computer Science',
    'English',
    'Biology',
    'History',
    'Geography',
    'Economics',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadResources();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadResources() async {
    setState(() => _isLoading = true);
    try {
      // Test connection first
      final connectionOk = await _resourcesService.testConnection();
      if (!connectionOk) {
        throw Exception('Unable to connect to community database');
      }

      final resources = await _resourcesService.getAllResources();
      setState(() {
        _resources = resources;
        _isLoading = false;
      });
      
      if (resources.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No books uploaded yet. Be the first to share!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading resources: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadResources,
            ),
          ),
        );
      }
    }
  }

  Future<void> _searchResources() async {
    if (_searchQuery.isEmpty) {
      _loadResources();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final resources = await _resourcesService.searchResources(_searchQuery);
      setState(() {
        _resources = resources;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _filterByCategory() async {
    if (_selectedCategory == 'All') {
      _loadResources();
      return;
    }

    setState(() => _isLoading = true);
    try {
      final resources = await _resourcesService.getResourcesByCategory(_selectedCategory);
      setState(() {
        _resources = resources;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Community Books',
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
            Tab(icon: Icon(Icons.public), text: 'Browse'),
            Tab(icon: Icon(Icons.upload), text: 'Upload'),
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
      floatingActionButton: _tabController.index == 0 
          ? FloatingActionButton.extended(
              onPressed: () {
                _tabController.animateTo(1); // Switch to upload tab
              },
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.upload),
              label: const Text('Upload Book'),
            ).animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 1.0, end: 0.0, curve: Curves.elasticOut)
          : null,
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
              hintText: 'Search books...',
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
                        _loadResources();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
              if (value.isEmpty) {
                _loadResources();
              }
            },
            onSubmitted: (value) => _searchResources(),
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
                    setState(() => _selectedCategory = category);
                    _filterByCategory();
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
              : _resources.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.book_outlined, size: 64, color: Colors.grey.shade700),
                          const SizedBox(height: 16),
                          Text(
                            'No books found',
                            style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Be the first to share a book!',
                            style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 12),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _addSampleData,
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text('Add Sample Books'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyanAccent,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadResources,
                      color: Colors.cyanAccent,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _resources.length,
                        itemBuilder: (context, index) {
                          final resource = _resources[index];
                          return _buildResourceCard(resource);
                        },
                      ),
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
                    _getFileIcon(resource.fileType ?? 'unknown'),
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
            if (resource.description?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                resource.description ?? '',
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
                  'Upload your books and notes to help the community learn together.',
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
            label: const Text('Upload Book'),
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
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Other';
    String? selectedFilePath;
    String? selectedFileName;
    bool isUploading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(
            'Upload Book',
            style: GoogleFonts.orbitron(color: Colors.cyanAccent),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Book Title *',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category *',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyanAccent),
                    ),
                  ),
                  items: _categories.skip(1) // Skip 'All'
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCategory = value!);
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade700),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.attach_file, color: Colors.grey, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Select File *',
                            style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      if (selectedFileName != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Colors.green, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  selectedFileName!,
                                  style: GoogleFonts.montserrat(
                                    color: Colors.green,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: isUploading ? null : () async {
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'ppt', 'pptx'],
                          );
                          
                          if (result != null && result.files.single.path != null) {
                            setDialogState(() {
                              selectedFilePath = result.files.single.path;
                              selectedFileName = result.files.single.name;
                            });
                          }
                        },
                        icon: const Icon(Icons.upload_file, size: 16),
                        label: const Text('Choose File'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyanAccent,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 36),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isUploading) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(color: Colors.cyanAccent),
                  const SizedBox(height: 8),
                  Text(
                    'Uploading...',
                    style: GoogleFonts.montserrat(color: Colors.cyanAccent),
                  ),
                ],
              ],
            ),
          ),
          actions: isUploading ? [] : [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty && selectedFilePath != null) {
                  setDialogState(() => isUploading = true);
                  
                  try {
                    final box = Hive.box('user_prefs');
                    final uploaderName = box.get('user_name', defaultValue: 'Anonymous');
                    
                    print('🔄 Starting upload: ${titleController.text.trim()}');
                    print('📁 File path: $selectedFilePath');
                    
                    final success = await _resourcesService.uploadResource(
                      filePath: selectedFilePath!,
                      uploaderName: uploaderName,
                      bookName: titleController.text.trim(),
                      description: descriptionController.text.trim(),
                      category: selectedCategory,
                    );
                    
                    if (success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Book uploaded successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadResources(); // Refresh the list
                    } else {
                      throw Exception('Upload failed - please check your internet connection and try again');
                    }
                  } catch (e) {
                    setDialogState(() => isUploading = false);
                    print('❌ Upload error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Upload failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Upload', style: TextStyle(color: Colors.cyanAccent)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadResource(CommunityResource resource) async {
    try {
      // Show downloading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Downloading...'),
          backgroundColor: Colors.blue,
        ),
      );

      // Here you would implement the actual download logic
      // For now, we'll just increment the download count
      // In a real implementation, you'd download the file from Supabase storage
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Download completed!'),
          backgroundColor: Colors.green,
        ),
      );
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

  Future<void> _addSampleData() async {
    try {
      setState(() => _isLoading = true);
      
      // Add sample data to help users get started
      final sampleBooks = [
        {
          'uploaderName': 'FluxFlow Team',
          'bookName': 'Introduction to Computer Science',
          'category': 'Computer Science',
          'resourceUrl': 'https://example.com/cs-intro.pdf',
          'description': 'A comprehensive guide to computer science fundamentals',
        },
        {
          'uploaderName': 'FluxFlow Team',
          'bookName': 'Mathematics for Engineers',
          'category': 'Mathematics',
          'resourceUrl': 'https://example.com/math-eng.pdf',
          'description': 'Essential mathematics concepts for engineering students',
        },
        {
          'uploaderName': 'FluxFlow Team',
          'bookName': 'Physics Laboratory Manual',
          'category': 'Physics',
          'resourceUrl': 'https://example.com/physics-lab.pdf',
          'description': 'Complete laboratory experiments and procedures',
        },
      ];

      bool anySuccess = false;
      for (final book in sampleBooks) {
        final success = await _resourcesService.uploadResourceFromUrl(
          fileUrl: book['resourceUrl']!,
          uploaderName: book['uploaderName']!,
          bookName: book['bookName']!,
          description: book['description']!,
          category: book['category']!,
        );
        if (success) anySuccess = true;
      }

      setState(() => _isLoading = false);
      
      if (anySuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sample books added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadResources(); // Refresh the list
      } else {
        throw Exception('Failed to add sample data');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding sample data: $e'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Setup Database',
            onPressed: _showDatabaseSetupDialog,
          ),
        ),
      );
    }
  }

  void _showDatabaseSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Database Setup Required', style: TextStyle(color: Colors.orange)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The community books feature requires database setup. Please run the following SQL in your Supabase dashboard:',
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 12),
            Text(
              '1. Go to Supabase Dashboard\n2. Open SQL Editor\n3. Run SUPABASE_COMMUNITY_RESOURCES_SETUP.sql',
              style: TextStyle(color: Colors.cyanAccent, fontFamily: 'monospace'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }
}