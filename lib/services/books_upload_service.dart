import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class BooksUploadService {
  final _supabase = Supabase.instance.client;

  // Upload book file to Supabase Storage
  Future<String> uploadBookFile(File file, String fileName) async {
    try {
      final bytes = await file.readAsBytes();
      final filePath = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      
      await _supabase.storage
          .from('community-books')
          .uploadBinary(filePath, bytes);
      
      final url = _supabase.storage
          .from('community-books')
          .getPublicUrl(filePath);
      
      return url;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Add book to database
  Future<void> addBook({
    required String title,
    required String description,
    required String subject,
    required String semester,
    required String fileUrl,
    required String fileName,
    required int fileSize,
    required String fileType,
    required String uploadedBy,
    List<String>? tags,
  }) async {
    try {
      await _supabase.from('community_books').insert({
        'title': title,
        'description': description,
        'subject': subject,
        'semester': semester,
        'file_url': fileUrl,
        'file_name': fileName,
        'file_size': fileSize,
        'file_type': fileType,
        'uploaded_by': uploadedBy,
        'tags': tags ?? [],
      });
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  // Get all books
  Stream<List<Map<String, dynamic>>> getBooksStream() {
    return _supabase
        .from('community_books')
        .stream(primaryKey: ['id'])
        .order('upload_date', ascending: false)
        .map((data) => data);
  }

  // Search books
  Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    try {
      final response = await _supabase
          .from('community_books')
          .select()
          .or('title.ilike.%$query%,description.ilike.%$query%,subject.ilike.%$query%')
          .order('upload_date', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to search books: $e');
    }
  }

  // Filter books by subject
  Future<List<Map<String, dynamic>>> getBooksBySubject(String subject) async {
    try {
      final response = await _supabase
          .from('community_books')
          .select()
          .eq('subject', subject)
          .order('upload_date', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get books: $e');
    }
  }

  // Filter books by semester
  Future<List<Map<String, dynamic>>> getBooksBySemester(String semester) async {
    try {
      final response = await _supabase
          .from('community_books')
          .select()
          .eq('semester', semester)
          .order('upload_date', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get books: $e');
    }
  }

  // Like a book
  Future<void> likeBook(int bookId, String userName) async {
    try {
      await _supabase.from('book_likes').insert({
        'book_id': bookId,
        'user_name': userName,
      });
      
      // Increment likes count
      await _supabase.rpc('increment_book_likes', params: {'book_id_param': bookId});
    } catch (e) {
      throw Exception('Failed to like book: $e');
    }
  }

  // Unlike a book
  Future<void> unlikeBook(int bookId, String userName) async {
    try {
      await _supabase
          .from('book_likes')
          .delete()
          .eq('book_id', bookId)
          .eq('user_name', userName);
      
      // Decrement likes count
      await _supabase.rpc('decrement_book_likes', params: {'book_id_param': bookId});
    } catch (e) {
      throw Exception('Failed to unlike book: $e');
    }
  }

  // Check if user liked a book
  Future<bool> hasUserLiked(int bookId, String userName) async {
    try {
      final response = await _supabase
          .from('book_likes')
          .select()
          .eq('book_id', bookId)
          .eq('user_name', userName)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Track download
  Future<void> trackDownload(int bookId, String userName) async {
    try {
      await _supabase.from('book_downloads').insert({
        'book_id': bookId,
        'user_name': userName,
      });
      
      // Increment downloads count
      await _supabase.rpc('increment_book_downloads', params: {'book_id_param': bookId});
    } catch (e) {
      // Silently fail for download tracking
      print('Failed to track download: $e');
    }
  }

  // Report a book
  Future<void> reportBook(int bookId, String reportedBy, String reason) async {
    try {
      await _supabase.from('book_reports').insert({
        'book_id': bookId,
        'reported_by': reportedBy,
        'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to report book: $e');
    }
  }

  // Delete book (only by uploader)
  Future<void> deleteBook(int bookId, String userName) async {
    try {
      await _supabase
          .from('community_books')
          .delete()
          .eq('id', bookId)
          .eq('uploaded_by', userName);
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  // Get user's uploaded books
  Future<List<Map<String, dynamic>>> getUserBooks(String userName) async {
    try {
      final response = await _supabase
          .from('community_books')
          .select()
          .eq('uploaded_by', userName)
          .order('upload_date', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get user books: $e');
    }
  }

  // Get book statistics
  Future<Map<String, dynamic>> getBookStats(int bookId) async {
    try {
      final response = await _supabase
          .rpc('get_book_stats', params: {'book_id_param': bookId})
          .single();
      
      return response;
    } catch (e) {
      return {'total_downloads': 0, 'total_likes': 0, 'unique_downloaders': 0};
    }
  }
}
