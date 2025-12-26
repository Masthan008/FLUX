import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/social_learning_service.dart';

class StudyGroupsScreen extends StatefulWidget {
  const StudyGroupsScreen({super.key});

  @override
  State<StudyGroupsScreen> createState() => _StudyGroupsScreenState();
}

class _StudyGroupsScreenState extends State<StudyGroupsScreen> {
  final SocialLearningService _socialService = SocialLearningService();
  final TextEditingController _searchController = TextEditingController();
  List<StudyGroup> _allGroups = [];
  List<StudyGroup> _filteredGroups = [];
  String _selectedSubject = 'All';
  bool _isLoading = true;

  final List<String> _subjects = [
    'All',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Computer Science',
    'Biology',
    'English',
    'History',
  ];

  @override
  void initState() {
    super.initState();
    _loadStudyGroups();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudyGroups() async {
    setState(() => _isLoading = true);
    try {
      final groups = await _socialService.getAllStudyGroups();
      setState(() {
        _allGroups = groups;
        _filteredGroups = groups;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading groups: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterGroups() {
    setState(() {
      _filteredGroups = _allGroups.where((group) {
        final matchesSubject = _selectedSubject == 'All' || 
            group.subject == _selectedSubject;
        final matchesSearch = _searchController.text.isEmpty ||
            group.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            group.description.toLowerCase().contains(_searchController.text.toLowerCase());
        return matchesSubject && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade900.withOpacity(0.5),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search study groups...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            _filterGroups();
                          },
                        )
                      : null,
                ),
                onChanged: (value) => _filterGroups(),
              ),
              const SizedBox(height: 12),
              
              // Subject Filter
              SizedBox(
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
                          _filterGroups();
                        },
                        backgroundColor: Colors.grey.shade800,
                        selectedColor: Colors.purple,
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
        
        // Groups List
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.purple),
                )
              : _filteredGroups.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadStudyGroups,
                      color: Colors.purple,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredGroups.length,
                        itemBuilder: (context, index) {
                          final group = _filteredGroups[index];
                          return _buildGroupCard(group, index);
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_outlined,
            size: 80,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 24),
          Text(
            'No Study Groups Found',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Be the first to create a study group!',
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showCreateGroupDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Study Group'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(StudyGroup group, int index) {
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
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.group,
                    color: Colors.purple,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        group.subject,
                        style: GoogleFonts.montserrat(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (group.isPrivate)
                  const Icon(Icons.lock, color: Colors.amber, size: 16),
              ],
            ),
            const SizedBox(height: 12),
            
            // Description
            Text(
              group.description,
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade300,
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Stats and Actions
            Row(
              children: [
                // Members Count
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people, color: Colors.blue, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${group.members.length}/${group.maxMembers}',
                        style: GoogleFonts.montserrat(
                          color: Colors.blue,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                
                // Created Date
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDate(group.createdAt),
                    style: GoogleFonts.montserrat(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                
                // Join Button
                ElevatedButton(
                  onPressed: group.isFull ? null : () => _joinGroup(group),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: group.isFull ? Colors.grey : Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    group.isFull ? 'Full' : 'Join',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
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

  void _showCreateGroupDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedSubject = 'Mathematics';
    int maxMembers = 10;
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: Text(
            'Create Study Group',
            style: GoogleFonts.orbitron(color: Colors.purple),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Group Name *',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description *',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedSubject,
                  dropdownColor: Colors.grey.shade800,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Subject *',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple),
                    ),
                  ),
                  items: _subjects.skip(1) // Skip 'All'
                      .map((subject) => DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedSubject = value!);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Max Members:', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Slider(
                        value: maxMembers.toDouble(),
                        min: 5,
                        max: 50,
                        divisions: 9,
                        activeColor: Colors.purple,
                        inactiveColor: Colors.grey,
                        label: maxMembers.toString(),
                        onChanged: (value) {
                          setDialogState(() => maxMembers = value.round());
                        },
                      ),
                    ),
                  ],
                ),
                CheckboxListTile(
                  title: const Text('Private Group', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Requires approval to join', style: TextStyle(color: Colors.grey)),
                  value: isPrivate,
                  activeColor: Colors.purple,
                  onChanged: (value) {
                    setDialogState(() => isPrivate = value ?? false);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  final group = await _socialService.createStudyGroup(
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                    subject: selectedSubject,
                    maxMembers: maxMembers,
                    isPrivate: isPrivate,
                  );
                  
                  Navigator.pop(context);
                  
                  if (group != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Study group created successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _loadStudyGroups();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to create study group'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Create', style: TextStyle(color: Colors.purple)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinGroup(StudyGroup group) async {
    try {
      final success = await _socialService.joinStudyGroup(group.id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined ${group.name} successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadStudyGroups();
      } else {
        throw Exception('Failed to join group');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error joining group: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference}d ago';
    return '${date.month}/${date.day}';
  }
}