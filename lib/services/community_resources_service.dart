import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class CommunityResource {
  final String id;
  final String uploaderName;
  final String bookName;
  final String category;
  final String resourceType; // 'link' or 'file'
  final String? resourceUrl;
  final String? filePath;
  final String? fileName;
  final int? fileSize;
  final String? fileType;
  final String? description;
  final int downloadCount;
  final String? uploadedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  CommunityResource({
    required this.id,
    required this.uploaderName,
    required this.bookName,
    required this.category,
    required this.resourceType,
    this.resourceUrl,
    this.filePath,
    this.fileName,
    this.fileSize,
    this.fileType,
    this.description,
    required this.downloadCount,
    this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CommunityResource.fromJson(Map<String, dynamic> json) {
    return CommunityResource(
      id: json['id'] as String,
      uploaderName: json['uploader_name'] as String,
      bookName: json['book_name'] as String,
      category: json['category'] as String,
      resourceType: json['resource_type'] as String,
      resourceUrl: json['resource_url'] as String?,
      filePath: json['file_path'] as String?,
      fileName: json['file_name'] as String?,
      fileSize: json['file_size'] as int?,
      fileType: json['file_type'] as String?,
      description: json['description'] as String?,
      downloadCount: json['download_count'] as int? ?? 0,
      uploadedBy: json['uploaded_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Convenience getter for file URL
  String get fileUrl => resourceUrl ?? '';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uploader_name': uploaderName,
      'book_name': bookName,
      'category': category,
      'resource_type': resourceType,
      'resource_url': resourceUrl,
      'file_path': filePath,
      'file_name': fileName,
      'file_size': fileSize,
      'file_type': fileType,
      'description': description,
      'download_count': downloadCount,
      'uploaded_by': uploadedBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class CommunityResourcesService {
  final SupabaseClient _supabase = Supabase.instance.client;
  static const String bucketName = 'community-books';

  // Test connection
  Future<bool> testConnection() async {
    try {
      final response = await _supabase
          .from('community_resources')
          .select('count')
          .limit(1);
      print('✅ Supabase connection successful');
      return true;
    } catch (e) {
      print('❌ Supabase connection failed: $e');
      return false;
    }
  }

  // Get all resources
  Future<List<CommunityResource>> getAllResources() async {
    try {
      print('🔍 Fetching all resources...');
      final response = await _supabase
          .from('community_resources')
          .select()
          .order('created_at', ascending: false);

      print('📚 Found ${(response as List).length} resources');
      return (response as List)
          .map((json) => CommunityResource.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching resources: $e');
      return [];
    }
  }

  // Get resources by category
  Future<List<CommunityResource>> getResourcesByCategory(String category) async {
    try {
      final response = await _supabase
          .from('community_resources')
          .select()
          .eq('category', category)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CommunityResource.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching resources by category: $e');
      return [];
    }
  }

  // Search resources
  Future<List<CommunityResource>> searchResources(String query) async {
    try {
      final response = await _supabase
          .from('community_resources')
          .select()
          .or('book_name.ilike.%$query%,uploader_name.ilike.%$query%,description.ilike.%$query%')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => CommunityResource.fromJson(json))
          .toList();
    } catch (e) {
      print('Error searching resources: $e');
      return [];
    }
  }

  // Upload file resource
  Future<String?> uploadFile(File file, String fileName) async {
    try {
      final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$userId/$timestamp-$fileName';

      await _supabase.storage.from(bucketName).upload(
            filePath,
            file,
            fileOptions: const FileOptions(upsert: true),
          );

      final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  // Add resource (link type)
  Future<bool> addLinkResource({
    required String uploaderName,
    required String bookName,
    required String category,
    required String resourceUrl,
    String? description,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      await _supabase.from('community_resources').insert({
        'uploader_name': uploaderName,
        'book_name': bookName,
        'category': category,
        'resource_type': 'link',
        'resource_url': resourceUrl,
        'description': description,
        'uploaded_by': userId,
      });

      return true;
    } catch (e) {
      print('Error adding link resource: $e');
      return false;
    }
  }

  // Add resource (file type)
  Future<bool> addFileResource({
    required String uploaderName,
    required String bookName,
    required String category,
    required File file,
    required String fileName,
    required String fileType,
    int? fileSize,
    String? description,
  }) async {
    try {
      // Upload file first
      final fileUrl = await uploadFile(file, fileName);
      if (fileUrl == null) return false;

      final userId = _supabase.auth.currentUser?.id;
      final filePath = fileUrl.split('/').last;

      await _supabase.from('community_resources').insert({
        'uploader_name': uploaderName,
        'book_name': bookName,
        'category': category,
        'resource_type': 'file',
        'resource_url': fileUrl,
        'file_path': filePath,
        'file_name': fileName,
        'file_size': fileSize,
        'file_type': fileType,
        'description': description,
        'uploaded_by': userId,
      });

      return true;
    } catch (e) {
      print('Error adding file resource: $e');
      return false;
    }
  }

  // Increment download count
  Future<void> incrementDownloadCount(String resourceId) async {
    try {
      await _supabase.rpc('increment_download_count', params: {
        'resource_id': resourceId,
      });
    } catch (e) {
      print('Error incrementing download count: $e');
    }
  }

  // Delete resource
  Future<bool> deleteResource(String resourceId, String? filePath) async {
    try {
      // Delete file from storage if it exists
      if (filePath != null && filePath.isNotEmpty) {
        await _supabase.storage.from(bucketName).remove([filePath]);
      }

      // Delete from database
      await _supabase.from('community_resources').delete().eq('id', resourceId);

      return true;
    } catch (e) {
      print('Error deleting resource: $e');
      return false;
    }
  }

  // Get realtime updates
  Stream<List<CommunityResource>> getRealtimeResources() {
    return _supabase
        .from('community_resources')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => CommunityResource.fromJson(json)).toList());
  }

  // Get most downloaded resources
  Future<List<CommunityResource>> getMostDownloaded({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('community_resources')
          .select()
          .order('download_count', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => CommunityResource.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching most downloaded: $e');
      return [];
    }
  }

  // Get recent uploads
  Future<List<CommunityResource>> getRecentUploads({int limit = 10}) async {
    try {
      final response = await _supabase
          .from('community_resources')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => CommunityResource.fromJson(json))
          .toList();
    } catch (e) {
      print('Error fetching recent uploads: $e');
      return [];
    }
  }

  // Upload resource (wrapper method for file upload)
  Future<bool> uploadResource({
    required String filePath,
    required String uploaderName,
    required String bookName,
    required String description,
    required String category,
  }) async {
    try {
      final file = File(filePath);
      final fileName = file.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();
      final fileSize = await file.length();

      return await addFileResource(
        uploaderName: uploaderName,
        bookName: bookName,
        category: category,
        file: file,
        fileName: fileName,
        fileType: fileExtension,
        fileSize: fileSize,
        description: description,
      );
    } catch (e) {
      print('Error in uploadResource: $e');
      return false;
    }
  }

  // Upload resource from URL (for sample data)
  Future<bool> uploadResourceFromUrl({
    required String fileUrl,
    required String uploaderName,
    required String bookName,
    required String description,
    required String category,
  }) async {
    try {
      return await addLinkResource(
        uploaderName: uploaderName,
        bookName: bookName,
        category: category,
        resourceUrl: fileUrl,
        description: description,
      );
    } catch (e) {
      print('Error in uploadResourceFromUrl: $e');
      return false;
    }
  }
}