/// Video model for tech education content
class Video {
  final String id;
  final String title;
  final String youtubeLink;
  final String category;
  final String? description;
  final String? thumbnailUrl;
  final int? durationMinutes;
  final String minTierRequired; // 'free', 'pro', 'ultra'
  final DateTime createdAt;

  Video({
    required this.id,
    required this.title,
    required this.youtubeLink,
    required this.category,
    this.description,
    this.thumbnailUrl,
    this.durationMinutes,
    this.minTierRequired = 'free',
    required this.createdAt,
  });

  /// Check if video requires premium access
  bool get isPremium => minTierRequired != 'free';

  /// Check if video is ultra tier
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

  /// Format duration as "X min"
  String get formattedDuration {
    if (durationMinutes == null) return '';
    if (durationMinutes! < 60) return '${durationMinutes}m';
    final hours = durationMinutes! ~/ 60;
    final mins = durationMinutes! % 60;
    return '${hours}h ${mins}m';
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: (json['id'] ?? '').toString(),
      title: json['title'] ?? '',
      youtubeLink: json['youtube_link'] ?? '',
      category: json['category'] ?? '',
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      durationMinutes: json['duration_minutes'],
      minTierRequired: json['min_tier_required'] ?? 'free',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'youtube_link': youtubeLink,
      'category': category,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'duration_minutes': durationMinutes,
      'min_tier_required': minTierRequired,
    };
  }
}
