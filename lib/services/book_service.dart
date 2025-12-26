import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for managing books stored in Supabase with Google Drive links
class BookService {
  static final _supabase = Supabase.instance.client;
  
  /// Get all books from Supabase
  static Future<List<Book>> getAllBooks() async {
    try {
      final response = await _supabase
          .from('books')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List).map((item) => Book.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching books: $e');
      return [];
    }
  }
  
  /// Get books by category
  static Future<List<Book>> getBooksByCategory(String category) async {
    try {
      final response = await _supabase
          .from('books')
          .select()
          .eq('category', category)
          .order('title');
      
      return (response as List).map((item) => Book.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching books by category: $e');
      return [];
    }
  }
  
  /// Get all categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from('books')
          .select('category');
      
      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();
      categories.sort();
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }
  
  /// Stream books for real-time updates
  static Stream<List<Book>> streamBooks() {
    return _supabase
        .from('books')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => Book.fromJson(item)).toList());
  }
  
  /// Open book PDF in browser (Google Drive, Mega, or any URL)
  /// Converts Google Drive view links to force-download links
  static Future<bool> openBook(Book book) async {
    try {
      String url = book.pdfDriveLink.trim();
      
      if (url.isEmpty) {
        print('Error: Book URL is empty');
        return false;
      }
      
      // Convert Google Drive "view" link to "download" link
      // FROM: https://drive.google.com/file/d/XYZ123/view
      // TO:   https://drive.google.com/uc?export=download&id=XYZ123
      if (url.contains('drive.google.com') && url.contains('/d/')) {
        try {
          final fileId = url.split('/d/')[1].split('/')[0];
          url = 'https://drive.google.com/uc?export=download&id=$fileId';
          print('Converted to download link: $url');
        } catch (e) {
          print('Could not convert Drive link, using original: $e');
        }
      }
      
      print('Opening book URL: $url');
      
      final uri = Uri.parse(url);
      
      // Always try to launch - don't use canLaunchUrl (fails on Android 11+)
      await launchUrl(
        uri, 
        mode: LaunchMode.externalApplication,
      );
      return true;
    } catch (e) {
      print('Error opening book: $e');
      
      // Fallback: Try with platformDefault mode
      try {
        final uri = Uri.parse(book.pdfDriveLink.trim());
        await launchUrl(uri, mode: LaunchMode.platformDefault);
        return true;
      } catch (e2) {
        print('Fallback also failed: $e2');
      }
      
      return false;
    }
  }
  
  /// Search books by title
  static Future<List<Book>> searchBooks(String query) async {
    try {
      final response = await _supabase
          .from('books')
          .select()
          .ilike('title', '%$query%')
          .order('title');
      
      return (response as List).map((item) => Book.fromJson(item)).toList();
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }
}

/// Book model with tier-based access control
class Book {
  final String id;
  final String title;
  final String category;
  final String? description;
  final String? coverUrl;
  final String pdfDriveLink;
  final String minTierRequired; // 'free', 'pro', 'ultra'
  final DateTime createdAt;
  
  Book({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.coverUrl,
    required this.pdfDriveLink,
    this.minTierRequired = 'free',
    required this.createdAt,
  });
  
  /// Backward compatibility: returns true if tier is 'pro' or 'ultra'
  bool get isPremium => minTierRequired != 'free';
  
  /// Check if tier is 'ultra'
  bool get isUltra => minTierRequired == 'ultra';
  
  /// Get tier level for comparison
  int get tierLevel {
    switch (minTierRequired.toLowerCase()) {
      case 'ultra':
        return 3;
      case 'pro':
        return 2;
      default:
        return 1;
    }
  }
  
  factory Book.fromJson(Map<String, dynamic> json) {
    // Support both old 'is_premium' boolean and new 'min_tier_required' string
    String tier = 'free';
    if (json['min_tier_required'] != null) {
      tier = json['min_tier_required'] as String;
    } else if (json['is_premium'] == true) {
      tier = 'pro'; // Backward compatibility: premium = pro
    }
    
    return Book(
      id: (json['id'] ?? '').toString(),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      description: json['description'],
      coverUrl: json['cover_url'],
      pdfDriveLink: json['pdf_drive_link'] ?? '',
      minTierRequired: tier,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'cover_url': coverUrl,
      'pdf_drive_link': pdfDriveLink,
      'min_tier_required': minTierRequired,
    };
  }
}
