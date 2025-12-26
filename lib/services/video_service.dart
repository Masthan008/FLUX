import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/video_model.dart';

/// Service for managing tech education videos
class VideoService {
  static final _supabase = Supabase.instance.client;
  
  /// Get all videos
  static Future<List<Video>> getAllVideos() async {
    try {
      final response = await _supabase
          .from('videos')
          .select()
          .order('created_at', ascending: false);
      
      return (response as List).map((item) => Video.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching videos: $e');
      return [];
    }
  }
  
  /// Get videos by category
  static Future<List<Video>> getVideosByCategory(String category) async {
    try {
      final response = await _supabase
          .from('videos')
          .select()
          .eq('category', category)
          .order('title');
      
      return (response as List).map((item) => Video.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching videos by category: $e');
      return [];
    }
  }
  
  /// Get all unique categories
  static Future<List<String>> getCategories() async {
    try {
      final response = await _supabase
          .from('videos')
          .select('category');
      
      final categories = (response as List)
          .map((item) => item['category'] as String)
          .toSet()
          .toList();
      categories.sort();
      return categories;
    } catch (e) {
      print('Error fetching categories: $e');
      return ['Java', 'AWS', 'CyberSecurity', 'Flutter', 'Python']; // Defaults
    }
  }
  
  /// Stream videos for real-time updates
  static Stream<List<Video>> streamVideos() {
    return _supabase
        .from('videos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((item) => Video.fromJson(item)).toList());
  }
  
  /// Stream videos by category
  static Stream<List<Video>> streamVideosByCategory(String category) {
    return _supabase
        .from('videos')
        .stream(primaryKey: ['id'])
        .eq('category', category)
        .order('title')
        .map((data) => data.map((item) => Video.fromJson(item)).toList());
  }
  
  /// Open video in YouTube app/browser
  static Future<bool> openVideo(Video video) async {
    try {
      String url = video.youtubeLink.trim();
      
      // 1. Clean the URL (Add https if missing)
      if (url.isEmpty) return false;
      
      if (!url.startsWith('http')) {
        url = 'https://$url';
      }
      
      print('Opening video: $url');
      final uri = Uri.parse(url);
      
      // 2. Force open in external app (YouTube App or Chrome)
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
      return true;
    } catch (e) {
      print('Error opening video: $e');
      // Fallback: Try with platform default
      try {
        String url = video.youtubeLink.trim();
        if (!url.startsWith('http')) url = 'https://$url';
        await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
        return true;
      } catch (e2) {
        print('Fallback failed: $e2');
        return false;
      }
    }
  }
  
  /// Search videos by title
  static Future<List<Video>> searchVideos(String query) async {
    try {
      final response = await _supabase
          .from('videos')
          .select()
          .ilike('title', '%$query%')
          .order('title');
      
      return (response as List).map((item) => Video.fromJson(item)).toList();
    } catch (e) {
      print('Error searching videos: $e');
      return [];
    }
  }
}
