import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/books_upload_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityBooksScreen extends StatefulWidget {
  const CommunityBooksScreen({super.key});

  @override
  State<CommunityBooksScreen> createState() => _CommunityBooksScreenState();
}

class _CommunityBooksScreenState extends State<CommunityBooksScreen> {
  final _booksService = BooksUploadService();
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _currentUser = 'Student';

  @override
  void initState() {
    super.initState();
    final box = Hive.box('user_prefs');
    _currentUser = box.get('user_name', defaultValue: 'Student');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _uploadBook() async {
    try {
      // Pick file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        
        // Show upload dialog
        if (!mounted) return;
        final bookData = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => _UploadDialog(fileName: file.name),
        );

        if (bookData != null) {
          // Show loading
          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );

          // Upload file
          final fileUrl = await _booksService.uploadBookFile(
            File(file.path!),
            file.name,
          );

          // Add to database
          await _booksService.addBook(
            title: bookData['title']!,
            description: bookData['description']!,
            subject: bookData['subject']!,
            semester: bookData['semester']!,
            fileUrl: fileUrl,
            fileName: file.name,
            fileSize: file.size,
            fileType: file.extension ?? 'unknown',
            uploadedBy: _currentUser,
          );

          if (!mounted) return;
          Navigator.pop(context); // Close loading
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book uploaded successfully!')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Close loading if open
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
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
      ),
      body: Column(
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
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Books List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _booksService.getBooksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final books = snapshot.data ?? [];
                final filteredBooks = _searchQuery.isEmpty
                    ? books
                    : books.where((book) {
                        final title = book['title']?.toString().toLowerCase() ?? '';
                        final subject = book['subject']?.toString().toLowerCase() ?? '';
                        return title.contains(_searchQuery.toLowerCase()) ||
                            subject.contains(_searchQuery.toLowerCase());
                      }).toList();

                if (filteredBooks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.book_outlined, size: 64, color: Colors.grey.shade700),
                        const SizedBox(height: 16),
                        Text(
                          'No books found',
                          style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    return _buildBookCard(book);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _uploadBook,
        backgroundColor: Colors.cyanAccent,
        icon: const Icon(Icons.upload_file, color: Colors.black),
        label: Text(
          'Upload',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final title = book['title'] ?? 'Untitled';
    final description = book['description'] ?? '';
    final subject = book['subject'] ?? '';
    final uploadedBy = book['uploaded_by'] ?? 'Unknown';
    final downloads = book['downloads'] ?? 0;
    final likes = book['likes'] ?? 0;
    final fileUrl = book['file_url'] ?? '';

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
                    color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.book, color: Colors.purple, size: 32),
                ),
                const SizedBox(width: 12),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subject.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subject,
                          style: GoogleFonts.montserrat(
                            color: Colors.cyanAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                description,
                style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  uploadedBy,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Icon(Icons.download, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '$downloads',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(Icons.favorite, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '$likes',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                if (fileUrl.isNotEmpty) {
                  final uri = Uri.parse(fileUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                    await _booksService.trackDownload(book['id'], _currentUser);
                  }
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Download'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadDialog extends StatefulWidget {
  final String fileName;

  const _UploadDialog({required this.fileName});

  @override
  State<_UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<_UploadDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _subject = 'Computer Science';
  String _semester = 'Semester 1';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _subject,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Subject',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: ['Computer Science', 'Mathematics', 'Physics', 'Chemistry', 'Other']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) => setState(() => _subject = value!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _semester,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Semester',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: List.generate(8, (i) => 'Semester ${i + 1}')
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) => setState(() => _semester = value!),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'description': _descController.text,
                'subject': _subject,
                'semester': _semester,
              });
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
          child: const Text('Upload', style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
