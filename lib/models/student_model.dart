/// Student model for Supabase authentication
class Student {
  final String? id;
  final String name;
  final String regdNo;
  final String group;
  final String section;
  final String year;
  final String? imageUrl;
  final String? mobileNumber;
  final String? email;
  final String subscriptionTier; // 'free', 'pro', 'ultra'
  final DateTime? subscriptionEndDate;
  final String? badgeUrl;
  final DateTime? createdAt;

  Student({
    this.id,
    required this.name,
    required this.regdNo,
    required this.group,
    required this.section,
    required this.year,
    this.imageUrl,
    this.mobileNumber,
    this.email,
    this.subscriptionTier = 'free',
    this.subscriptionEndDate,
    this.badgeUrl,
    this.createdAt,
  });

  /// Get tier level as number for comparisons
  int get tierLevel {
    switch (subscriptionTier.toLowerCase()) {
      case 'ultra':
        return 3;
      case 'pro':
        return 2;
      default:
        return 1; // free
    }
  }

  /// Check if user can access a specific tier
  bool canAccess(String requiredTier) {
    int requiredLevel;
    switch (requiredTier.toLowerCase()) {
      case 'ultra':
        requiredLevel = 3;
        break;
      case 'pro':
        requiredLevel = 2;
        break;
      default:
        requiredLevel = 1;
    }
    return tierLevel >= requiredLevel;
  }

  /// Check if subscription is active (not expired)
  bool get isSubscriptionActive {
    if (subscriptionTier == 'free') return true;
    if (subscriptionEndDate == null) return true; // No expiry = lifetime
    return DateTime.now().isBefore(subscriptionEndDate!);
  }

  /// Convert to Map for Supabase insert/update
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'regd_no': regdNo,
      'group_name': group,
      'section': section,
      'year': year,
      'image_url': imageUrl,
      'mobile_no': mobileNumber,
      'email_address': email,
      'subscription_tier': subscriptionTier,
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'badge_url': badgeUrl,
    };
  }

  /// Create Student from Supabase response
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'] ?? '',
      regdNo: map['regd_no'] ?? '',
      group: map['group_name'] ?? '',
      section: map['section'] ?? '',
      year: map['year'] ?? '',
      imageUrl: map['image_url'],
      mobileNumber: map['mobile_no'],
      email: map['email_address'],
      subscriptionTier: map['subscription_tier'] ?? 'free',
      subscriptionEndDate: map['subscription_end_date'] != null
          ? DateTime.tryParse(map['subscription_end_date'])
          : null,
      badgeUrl: map['badge_url'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  /// Create a copy with modified fields
  Student copyWith({
    String? id,
    String? name,
    String? regdNo,
    String? group,
    String? section,
    String? year,
    String? imageUrl,
    String? mobileNumber,
    String? email,
    String? subscriptionTier,
    DateTime? subscriptionEndDate,
    String? badgeUrl,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      regdNo: regdNo ?? this.regdNo,
      group: group ?? this.group,
      section: section ?? this.section,
      year: year ?? this.year,
      imageUrl: imageUrl ?? this.imageUrl,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      email: email ?? this.email,
      subscriptionTier: subscriptionTier ?? this.subscriptionTier,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      badgeUrl: badgeUrl ?? this.badgeUrl,
      createdAt: createdAt,
    );
  }

  @override
  String toString() {
    return 'Student(name: $name, regdNo: $regdNo, tier: $subscriptionTier)';
  }
}
