import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/social_learning_service.dart';

class QAPlatformScreen extends StatefulWidget {
  const QAPlatformScreen({super.key});

  @override
  State<QAPlatformScreen> createState() => _QAPlatformScreenState();
}

class _QAPlatformScreenState extends State<QAPlatformScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SocialLearningService _socialService = SocialLearningService();
  final TextEditingController _searchController = TextEditingController();
  List<Question> _questions = [];
  bool _isLoading = true;
  String _selectedSubject = 'All';
  String _sortBy = 'Recent';

  final List<String> _subjects = [
    'All', 'Mathematics', 'Physics', 'Chemistry', 'Computer Science', 'Biology', 'English'
  ];

  final List<String> _sortOptions = ['Recent', 'Popular', 'Unanswered', 'Most Voted'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadQuestions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    try {
      final questions = await _socialService.getQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading questions: $e'), backgroundColor: Colors.red),
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
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.help), text: 'All Questions'),
              Tab(icon: Icon(Icons.add), text: 'Ask Question'),
              Tab(icon: Icon(Icons.person), text: 'My Q&A'),
            ],
          ),
        ),
        
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAllQuestionsTab(),
              _buildAskQuestionTab(),
              _buildMyQATab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAllQuestionsTab() {
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
                  hintText: 'Search questions...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                ),
                onChanged: (value) => _filterQuestions(),
              ),
              const SizedBox(height: 12),
              
              // Filters Row
              Row(
                children: [
                  // Subject Filter
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      dropdownColor: Colors.grey.shade800,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Subject',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: _subjects.map((subject) => DropdownMenuItem(
                        value: subject,
                        child: Text(subject),
                      )).toList(),
                      onChanged: (value) {
                        setState(() => _selectedSubject = value!);
                        _filterQuestions();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Sort Filter
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sortBy,
                      dropdownColor: Colors.grey.shade800,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Sort by',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: _sortOptions.map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      )).toList(),
                      onChanged: (value) {
                        setState(() => _sortBy = value!);
                        _filterQuestions();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Questions List
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.blue))
              : _buildQuestionsList(),
        ),
      ],
    );
  }

  Widget _buildQuestionsList() {
    if (_questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.help_outline, size: 80, color: Colors.grey.shade700),
            const SizedBox(height: 24),
            Text(
              'No Questions Found',
              style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Be the first to ask a question!',
              style: GoogleFonts.montserrat(color: Colors.grey.shade400, fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.add),
              label: const Text('Ask Question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadQuestions,
      color: Colors.blue,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final question = _questions[index];
          return _buildQuestionCard(question, index);
        },
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: question.hasAcceptedAnswer ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    question.hasAcceptedAnswer ? Icons.check_circle : Icons.help,
                    color: question.hasAcceptedAnswer ? Colors.green : Colors.blue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.title,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'by ${question.askedBy} • ${question.subject}',
                        style: GoogleFonts.montserrat(
                          color: Colors.grey.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Content Preview
            Text(
              question.content,
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade300,
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            
            // Tags
            if (question.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: question.tags.map((tag) => Container(
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
                // Upvotes
                Row(
                  children: [
                    const Icon(Icons.thumb_up, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${question.upvotes}',
                      style: GoogleFonts.montserrat(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Answers
                Row(
                  children: [
                    const Icon(Icons.comment, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${question.answers.length}',
                      style: GoogleFonts.montserrat(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                
                // Views
                Row(
                  children: [
                    const Icon(Icons.visibility, color: Colors.grey, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${question.views}',
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                
                // Time
                Text(
                  _formatTime(question.createdAt),
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewQuestion(question),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _answerQuestion(question),
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text('Answer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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

  Widget _buildAskQuestionTab() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    final tagsController = TextEditingController();
    String selectedSubject = 'Mathematics';

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
                colors: [Colors.blue.withOpacity(0.3), Colors.purple.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.help, color: Colors.blue, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ask a Question',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Get help from the community',
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
          ),
          const SizedBox(height: 24),
          
          // Form
          TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Question Title *',
              labelStyle: const TextStyle(color: Colors.grey),
              hintText: 'What is your question about?',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.grey.shade900.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
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
              filled: true,
              fillColor: Colors.grey.shade900.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
            items: _subjects.skip(1).map((subject) => DropdownMenuItem(
              value: subject,
              child: Text(subject),
            )).toList(),
            onChanged: (value) => selectedSubject = value!,
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: contentController,
            style: const TextStyle(color: Colors.white),
            maxLines: 6,
            decoration: InputDecoration(
              labelText: 'Question Details *',
              labelStyle: const TextStyle(color: Colors.grey),
              hintText: 'Provide more details about your question...',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.grey.shade900.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(
            controller: tagsController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Tags (optional)',
              labelStyle: const TextStyle(color: Colors.grey),
              hintText: 'e.g., calculus, derivatives, math',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: Colors.grey.shade900.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Tips
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips for a good question:',
                  style: GoogleFonts.montserrat(
                    color: Colors.blue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...const [
                  '• Be specific and clear in your title',
                  '• Provide context and what you\'ve tried',
                  '• Include relevant details and examples',
                  '• Use appropriate tags for better visibility',
                ].map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    tip,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade300,
                      fontSize: 12,
                    ),
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _submitQuestion(
                titleController.text,
                contentController.text,
                selectedSubject,
                tagsController.text,
              ),
              icon: const Icon(Icons.send),
              label: const Text('Ask Question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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

  Widget _buildMyQATab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 24),
          Text(
            'No Questions or Answers',
            style: GoogleFonts.orbitron(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Start participating in the community!',
            style: GoogleFonts.montserrat(color: Colors.grey.shade400, fontSize: 16),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _tabController.animateTo(1),
                icon: const Icon(Icons.add),
                label: const Text('Ask Question'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () => _tabController.animateTo(0),
                icon: const Icon(Icons.help),
                label: const Text('Answer Questions'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _filterQuestions() {
    // Implement filtering logic here
    // For now, just trigger a rebuild
    setState(() {});
  }

  void _viewQuestion(Question question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          question.title,
          style: GoogleFonts.orbitron(color: Colors.blue),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subject: ${question.subject}', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              Text('Asked by: ${question.askedBy}', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              Text('Content:', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(question.content, style: const TextStyle(color: Colors.white)),
              if (question.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Tags: ${question.tags.join(', ')}', style: const TextStyle(color: Colors.grey)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _answerQuestion(question);
            },
            child: const Text('Answer', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _answerQuestion(Question question) {
    final answerController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Answer Question',
          style: GoogleFonts.orbitron(color: Colors.blue),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              question.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: answerController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your answer...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: Colors.black.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (answerController.text.isNotEmpty) {
                await _socialService.answerQuestion(
                  questionId: question.id,
                  content: answerController.text,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Answer submitted successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Submit', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void _submitQuestion(String title, String content, String subject, String tagsText) async {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final tags = tagsText.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
    
    final question = await _socialService.askQuestion(
      title: title,
      content: content,
      subject: subject,
      tags: tags,
    );

    if (question != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Question submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      _tabController.animateTo(0);
      _loadQuestions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit question'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}