# Books Screen - Supabase Integration Guide

## Quick Setup

### Step 1: Run SQL
Run `SUPABASE_BOOKS_SIMPLE.sql` in Supabase SQL Editor

### Step 2: Create Storage Bucket
1. Go to Supabase Dashboard > Storage
2. Click "New Bucket"
3. Name: `community-books`
4. Public: YES
5. Create bucket

### Step 3: Set Storage Policies
In the `community-books` bucket policies:

**Policy 1:**
```
Name: Anyone can upload
Operation: INSERT
Policy: true
```

**Policy 2:**
```
Name: Anyone can download  
Operation: SELECT
Policy: true
```

### Step 4: Update Books Screen

Add this import at the top of `books_notes_screen.dart`:
```dart
import 'package:supabase_flutter/supabase_flutter.dart';
```

Change TabController length from 2 to 3:
```dart
_tabController = TabController(length: 3, vsync: this);
```

Add third tab:
```dart
Tab(icon: Icon(Icons.public), text: 'Community')
```

Add third tab view:
```dart
_CommunityTab(searchQuery: _searchQuery, currentUserId: _currentUserId),
```

### Step 5: Add Community Tab Widget

Add this class at the end of `books_notes_screen.dart`:

```dart
// ============================================
// Community Tab (Supabase)
// ============================================
class _CommunityTab extends StatefulWidget {
  final String searchQuery;
  final String currentUserId;

  const _CommunityTab({required this.searchQuery, required this.currentUserId});

  @override
  State<_CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends State<_CommunityTab> {
  final _supabase = Supabase.instance.client;
  
  Future<List<Map<String, dynamic>>> _getBooks() async {
    try {
      var query = _supabase
          .from('community_books')
          .select()
          .order('created_at', ascending: false);
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error loading books: $e');
      return [];
    }
  }
  
  Future<void> _deleteBook(int bookId) async {
    try {
      await _supabase
          .from('community_books')
          .delete()
          .eq('id', bookId);
      
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text('Error loading books', style: GoogleFonts.montserrat(color: Colors.white)),
                const SizedBox(height: 8),
                Text('${snapshot.error}', style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        }
        
        final books = snapshot.data ?? [];
        
        // Filter by search query
        final filteredBooks = widget.searchQuery.isEmpty
            ? books
            : books.where((book) {
                final title = book['title'].toString().toLowerCase();
                final author = (book['author'] ?? '').toString().toLowerCase();
                final subject = (book['subject'] ?? '').toString().toLowerCase();
                return title.contains(widget.searchQuery) ||
                    author.contains(widget.searchQuery) ||
                    subject.contains(widget.searchQuery);
              }).toList();
        
        if (filteredBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.public_off, size: 64, color: Colors.grey.shade700),
                const SizedBox(height: 16),
                Text(
                  widget.searchQuery.isEmpty ? 'No books shared yet' : 'No books found',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.searchQuery.isEmpty ? 'Be the first to share!' : 'Try a different search',
                  style: GoogleFonts.montserrat(color: Colors.grey.shade700, fontSize: 12),
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
            return _buildCommunityBookCard(book);
          },
        );
      },
    );
  }
  
  Widget _buildCommunityBookCard(Map<String, dynamic> book) {
    final hasLink = book['link'] != null && book['link'].toString().isNotEmpty;
    final hasFile = book['file_url'] != null && book['file_url'].toString().isNotEmpty;
    final isMyBook = book['uploaded_by_id'] == widget.currentUserId;
    
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
                  child: const Icon(Icons.book, color: Colors.cyanAccent, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'],
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (book['author'] != null && book['author'].toString().isNotEmpty)
                        Text(
                          'by ${book['author']}',
                          style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
                        ),
                    ],
                  ),
                ),
                if (isMyBook)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteBook(book['id']),
                  ),
              ],
            ),
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
                    book['subject'] ?? 'General',
                    style: GoogleFonts.montserrat(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.person, color: Colors.grey, size: 14),
                const SizedBox(width: 4),
                Text(
                  book['uploaded_by_name'],
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
            if (hasLink || hasFile) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (hasLink)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openLink(book['link']),
                        icon: const Icon(Icons.link, size: 16),
                        label: const Text('Open Link'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (hasLink && hasFile) const SizedBox(width: 8),
                  if (hasFile)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _openFile(book['file_url']),
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Download'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _openLink(String link) async {
    // Use url_launcher package
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  
  void _openFile(String fileUrl) async {
    // Use url_launcher package
    final uri = Uri.parse(fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
```

### Step 6: Update Add Book Dialog

In `_showAddBookDialog`, after saving locally, also save to Supabase:

```dart
// After local save
try {
  await Supabase.instance.client.from('community_books').insert({
    'title': titleController.text,
    'author': authorController.text,
    'link': linkController.text,
    'file_url': fileUrl, // if uploaded
    'file_name': fileName, // if uploaded
    'subject': selectedSubject,
    'uploaded_by_name': box.get('user_name', defaultValue: 'Student'),
    'uploaded_by_id': box.get('user_id', defaultValue: 'unknown'),
  });
} catch (e) {
  debugPrint('Error saving to Supabase: $e');
}
```

### Step 7: Update Add Note Dialog

Similarly for notes:

```dart
// After local save
try {
  await Supabase.instance.client.from('community_notes').insert({
    'title': titleController.text,
    'content': contentController.text,
    'subject': selectedSubject,
    'uploaded_by_name': box.get('user_name', defaultValue: 'Student'),
    'uploaded_by_id': box.get('user_id', defaultValue: 'unknown'),
  });
} catch (e) {
  debugPrint('Error saving to Supabase: $e');
}
```

## Done!

Now all users will see books and notes in the Community tab!

## Testing

1. Add a book in "Books" tab
2. Switch to "Community" tab
3. You should see your book
4. Login with different user
5. They should also see the book

## Troubleshooting

**Books not showing:**
- Check Supabase SQL ran successfully
- Check storage bucket exists
- Check RLS policies are enabled

**Can't upload:**
- Check storage bucket is public
- Check upload policy exists

**Can't delete:**
- Check delete policy exists
