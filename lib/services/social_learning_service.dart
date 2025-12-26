import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudyGroup {
  final String id;
  final String name;
  final String description;
  final String subject;
  final String createdBy;
  final DateTime createdAt;
  final List<String> members;
  final int maxMembers;
  final bool isPrivate;
  final String? meetingLink;
  final Map<String, dynamic> settings;

  StudyGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.subject,
    required this.createdBy,
    required this.createdAt,
    required this.members,
    required this.maxMembers,
    required this.isPrivate,
    this.meetingLink,
    required this.settings,
  });

  factory StudyGroup.fromJson(Map<String, dynamic> json) {
    return StudyGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      subject: json['subject'] as String,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      members: List<String>.from(json['members'] as List),
      maxMembers: json['max_members'] as int,
      isPrivate: json['is_private'] as bool,
      meetingLink: json['meeting_link'] as String?,
      settings: Map<String, dynamic>.from(json['settings'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'subject': subject,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'members': members,
      'max_members': maxMembers,
      'is_private': isPrivate,
      'meeting_link': meetingLink,
      'settings': settings,
    };
  }

  bool get isFull => members.length >= maxMembers;
  int get availableSpots => maxMembers - members.length;
}

class TutoringSession {
  final String id;
  final String tutorId;
  final String studentId;
  final String subject;
  final DateTime scheduledTime;
  final int duration; // in minutes
  final String status; // scheduled, in_progress, completed, cancelled
  final String? meetingLink;
  final double? rating;
  final String? feedback;
  final Map<String, dynamic> metadata;

  TutoringSession({
    required this.id,
    required this.tutorId,
    required this.studentId,
    required this.subject,
    required this.scheduledTime,
    required this.duration,
    required this.status,
    this.meetingLink,
    this.rating,
    this.feedback,
    required this.metadata,
  });

  factory TutoringSession.fromJson(Map<String, dynamic> json) {
    return TutoringSession(
      id: json['id'] as String,
      tutorId: json['tutor_id'] as String,
      studentId: json['student_id'] as String,
      subject: json['subject'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      duration: json['duration'] as int,
      status: json['status'] as String,
      meetingLink: json['meeting_link'] as String?,
      rating: json['rating'] as double?,
      feedback: json['feedback'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutor_id': tutorId,
      'student_id': studentId,
      'subject': subject,
      'scheduled_time': scheduledTime.toIso8601String(),
      'duration': duration,
      'status': status,
      'meeting_link': meetingLink,
      'rating': rating,
      'feedback': feedback,
      'metadata': metadata,
    };
  }

  bool get isActive => status == 'scheduled' || status == 'in_progress';
  bool get isCompleted => status == 'completed';
}

class Question {
  final String id;
  final String title;
  final String content;
  final String askedBy;
  final DateTime createdAt;
  final String subject;
  final List<String> tags;
  final int upvotes;
  final int views;
  final bool hasAcceptedAnswer;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.title,
    required this.content,
    required this.askedBy,
    required this.createdAt,
    required this.subject,
    required this.tags,
    required this.upvotes,
    required this.views,
    required this.hasAcceptedAnswer,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      askedBy: json['asked_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      subject: json['subject'] as String,
      tags: List<String>.from(json['tags'] as List? ?? []),
      upvotes: json['upvotes'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      hasAcceptedAnswer: json['has_accepted_answer'] as bool? ?? false,
      answers: (json['answers'] as List? ?? [])
          .map((a) => Answer.fromJson(a))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'asked_by': askedBy,
      'created_at': createdAt.toIso8601String(),
      'subject': subject,
      'tags': tags,
      'upvotes': upvotes,
      'views': views,
      'has_accepted_answer': hasAcceptedAnswer,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class Answer {
  final String id;
  final String questionId;
  final String content;
  final String answeredBy;
  final DateTime createdAt;
  final int upvotes;
  final bool isAccepted;

  Answer({
    required this.id,
    required this.questionId,
    required this.content,
    required this.answeredBy,
    required this.createdAt,
    required this.upvotes,
    required this.isAccepted,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'] as String,
      questionId: json['question_id'] as String,
      content: json['content'] as String,
      answeredBy: json['answered_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      upvotes: json['upvotes'] as int? ?? 0,
      isAccepted: json['is_accepted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'content': content,
      'answered_by': answeredBy,
      'created_at': createdAt.toIso8601String(),
      'upvotes': upvotes,
      'is_accepted': isAccepted,
    };
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final int reputation;
  final List<String> subjects;
  final String? bio;
  final String? avatarUrl;
  final Map<String, dynamic> stats;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.reputation,
    required this.subjects,
    this.bio,
    this.avatarUrl,
    required this.stats,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      reputation: json['reputation'] as int? ?? 0,
      subjects: List<String>.from(json['subjects'] as List? ?? []),
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      stats: Map<String, dynamic>.from(json['stats'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'reputation': reputation,
      'subjects': subjects,
      'bio': bio,
      'avatar_url': avatarUrl,
      'stats': stats,
    };
  }
}

class SocialLearningService {
  static const String _socialBoxKey = 'social_learning';
  late Box _socialBox;
  final SupabaseClient _supabase = Supabase.instance.client;

  SocialLearningService() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      _socialBox = await Hive.openBox(_socialBoxKey);
    } catch (e) {
      debugPrint('Error initializing social learning service: $e');
    }
  }

  /// Get dashboard data for overview
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      await _initializeService();
      
      // Get user stats
      final userProfile = await getCurrentUserProfile();
      final joinedGroups = await getUserStudyGroups();
      final recentActivity = await getRecentActivity();
      
      // Get community stats
      final communityStats = await getCommunityStats();
      
      return {
        'user_reputation': userProfile?.reputation ?? 0,
        'joined_groups': joinedGroups.length,
        'helped_students': userProfile?.stats['helped_students'] ?? 0,
        'user_active_groups': joinedGroups.take(5).map((g) => {
          'name': g.name,
          'members': g.members.length,
          'subject': g.subject,
        }).toList(),
        'recent_activity': recentActivity,
        'total_users': communityStats['total_users'] ?? 0,
        'active_groups': communityStats['active_groups'] ?? 0,
        'questions_answered': communityStats['questions_answered'] ?? 0,
        'resources_shared': communityStats['resources_shared'] ?? 0,
      };
    } catch (e) {
      debugPrint('Error getting dashboard data: $e');
      return _getDefaultDashboardData();
    }
  }

  /// Get current user profile
  Future<UserProfile?> getCurrentUserProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return null;

      // Try to get from cache first
      final cachedProfile = _socialBox.get('user_profile');
      if (cachedProfile != null) {
        return UserProfile.fromJson(Map<String, dynamic>.from(cachedProfile));
      }

      // Create default profile if not exists
      final userBox = Hive.box('user_prefs');
      final userName = userBox.get('user_name', defaultValue: 'Student');
      
      final defaultProfile = UserProfile(
        id: userId,
        name: userName,
        email: _supabase.auth.currentUser?.email ?? '',
        reputation: 100, // Starting reputation
        subjects: ['General'],
        stats: {
          'questions_asked': 0,
          'answers_given': 0,
          'helped_students': 0,
          'groups_joined': 0,
        },
      );

      // Cache the profile
      await _socialBox.put('user_profile', defaultProfile.toJson());
      
      return defaultProfile;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  /// Get user's study groups
  Future<List<StudyGroup>> getUserStudyGroups() async {
    try {
      await _initializeService();
      
      // Get from local storage for now
      final groups = _socialBox.get('user_groups', defaultValue: <Map<String, dynamic>>[]);
      final groupsList = List<Map<String, dynamic>>.from(groups);
      
      return groupsList
          .map((json) => StudyGroup.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting user study groups: $e');
      return [];
    }
  }

  /// Get all available study groups
  Future<List<StudyGroup>> getAllStudyGroups({String? subject}) async {
    try {
      // Return sample data for now
      return _getSampleStudyGroups().where((group) {
        if (subject == null || subject.isEmpty) return true;
        return group.subject.toLowerCase().contains(subject.toLowerCase());
      }).toList();
    } catch (e) {
      debugPrint('Error getting study groups: $e');
      return [];
    }
  }

  /// Create a new study group
  Future<StudyGroup?> createStudyGroup({
    required String name,
    required String description,
    required String subject,
    required int maxMembers,
    bool isPrivate = false,
    String? meetingLink,
  }) async {
    try {
      await _initializeService();
      
      final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
      final groupId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final group = StudyGroup(
        id: groupId,
        name: name,
        description: description,
        subject: subject,
        createdBy: userId,
        createdAt: DateTime.now(),
        members: [userId], // Creator is first member
        maxMembers: maxMembers,
        isPrivate: isPrivate,
        meetingLink: meetingLink,
        settings: {},
      );

      // Save to local storage
      final userGroups = _socialBox.get('user_groups', defaultValue: <Map<String, dynamic>>[]);
      final groupsList = List<Map<String, dynamic>>.from(userGroups);
      groupsList.add(group.toJson());
      await _socialBox.put('user_groups', groupsList);

      // TODO: Sync with cloud storage
      
      return group;
    } catch (e) {
      debugPrint('Error creating study group: $e');
      return null;
    }
  }

  /// Join a study group
  Future<bool> joinStudyGroup(String groupId) async {
    try {
      await _initializeService();
      
      final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
      
      // Update user's groups
      final userGroups = _socialBox.get('user_groups', defaultValue: <Map<String, dynamic>>[]);
      final groupsList = List<Map<String, dynamic>>.from(userGroups);
      
      // Find and update the group
      for (int i = 0; i < groupsList.length; i++) {
        if (groupsList[i]['id'] == groupId) {
          final members = List<String>.from(groupsList[i]['members']);
          if (!members.contains(userId)) {
            members.add(userId);
            groupsList[i]['members'] = members;
          }
          break;
        }
      }
      
      await _socialBox.put('user_groups', groupsList);
      
      // Update user stats
      await _updateUserStats('groups_joined', 1);
      
      return true;
    } catch (e) {
      debugPrint('Error joining study group: $e');
      return false;
    }
  }

  /// Get available tutors for a subject
  Future<List<UserProfile>> getAvailableTutors({String? subject}) async {
    try {
      // Return sample tutors for now
      return _getSampleTutors().where((tutor) {
        if (subject == null || subject.isEmpty) return true;
        return tutor.subjects.any((s) => s.toLowerCase().contains(subject.toLowerCase()));
      }).toList();
    } catch (e) {
      debugPrint('Error getting tutors: $e');
      return [];
    }
  }

  /// Book a tutoring session
  Future<TutoringSession?> bookTutoringSession({
    required String tutorId,
    required String subject,
    required DateTime scheduledTime,
    required int duration,
  }) async {
    try {
      await _initializeService();
      
      final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
      final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final session = TutoringSession(
        id: sessionId,
        tutorId: tutorId,
        studentId: userId,
        subject: subject,
        scheduledTime: scheduledTime,
        duration: duration,
        status: 'scheduled',
        metadata: {},
      );

      // Save to local storage
      final sessions = _socialBox.get('tutoring_sessions', defaultValue: <Map<String, dynamic>>[]);
      final sessionsList = List<Map<String, dynamic>>.from(sessions);
      sessionsList.add(session.toJson());
      await _socialBox.put('tutoring_sessions', sessionsList);

      return session;
    } catch (e) {
      debugPrint('Error booking tutoring session: $e');
      return null;
    }
  }

  /// Get questions for Q&A platform
  Future<List<Question>> getQuestions({String? subject, String? searchQuery}) async {
    try {
      // Return sample questions for now
      return _getSampleQuestions().where((question) {
        bool matchesSubject = subject == null || question.subject.toLowerCase().contains(subject.toLowerCase());
        bool matchesSearch = searchQuery == null || 
            question.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            question.content.toLowerCase().contains(searchQuery.toLowerCase());
        return matchesSubject && matchesSearch;
      }).toList();
    } catch (e) {
      debugPrint('Error getting questions: $e');
      return [];
    }
  }

  /// Ask a new question
  Future<Question?> askQuestion({
    required String title,
    required String content,
    required String subject,
    List<String> tags = const [],
  }) async {
    try {
      await _initializeService();
      
      final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
      final questionId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final question = Question(
        id: questionId,
        title: title,
        content: content,
        askedBy: userId,
        createdAt: DateTime.now(),
        subject: subject,
        tags: tags,
        upvotes: 0,
        views: 0,
        hasAcceptedAnswer: false,
        answers: [],
      );

      // Save to local storage
      final questions = _socialBox.get('user_questions', defaultValue: <Map<String, dynamic>>[]);
      final questionsList = List<Map<String, dynamic>>.from(questions);
      questionsList.add(question.toJson());
      await _socialBox.put('user_questions', questionsList);

      // Update user stats
      await _updateUserStats('questions_asked', 1);

      return question;
    } catch (e) {
      debugPrint('Error asking question: $e');
      return null;
    }
  }

  /// Answer a question
  Future<Answer?> answerQuestion({
    required String questionId,
    required String content,
  }) async {
    try {
      await _initializeService();
      
      final userId = _supabase.auth.currentUser?.id ?? 'anonymous';
      final answerId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final answer = Answer(
        id: answerId,
        questionId: questionId,
        content: content,
        answeredBy: userId,
        createdAt: DateTime.now(),
        upvotes: 0,
        isAccepted: false,
      );

      // Save to local storage
      final answers = _socialBox.get('user_answers', defaultValue: <Map<String, dynamic>>[]);
      final answersList = List<Map<String, dynamic>>.from(answers);
      answersList.add(answer.toJson());
      await _socialBox.put('user_answers', answersList);

      // Update user stats
      await _updateUserStats('answers_given', 1);
      await _updateUserStats('helped_students', 1);

      return answer;
    } catch (e) {
      debugPrint('Error answering question: $e');
      return null;
    }
  }

  /// Get recent community activity
  Future<List<Map<String, dynamic>>> getRecentActivity() async {
    try {
      // Return sample activity for now
      return [
        {
          'type': 'question',
          'description': 'New question about calculus derivatives',
          'time': '2h ago',
        },
        {
          'type': 'answer',
          'description': 'Sarah answered a physics question',
          'time': '3h ago',
        },
        {
          'type': 'group_join',
          'description': 'Mike joined Advanced Mathematics group',
          'time': '5h ago',
        },
        {
          'type': 'resource_share',
          'description': 'New chemistry notes shared',
          'time': '1d ago',
        },
      ];
    } catch (e) {
      debugPrint('Error getting recent activity: $e');
      return [];
    }
  }

  /// Get community statistics
  Future<Map<String, dynamic>> getCommunityStats() async {
    try {
      // Return sample stats for now
      return {
        'total_users': 1247,
        'active_groups': 89,
        'questions_answered': 2341,
        'resources_shared': 567,
      };
    } catch (e) {
      debugPrint('Error getting community stats: $e');
      return {};
    }
  }

  /// Update user statistics
  Future<void> _updateUserStats(String statKey, int increment) async {
    try {
      final profile = await getCurrentUserProfile();
      if (profile != null) {
        final updatedStats = Map<String, dynamic>.from(profile.stats);
        updatedStats[statKey] = (updatedStats[statKey] ?? 0) + increment;
        
        final updatedProfile = UserProfile(
          id: profile.id,
          name: profile.name,
          email: profile.email,
          reputation: profile.reputation + (increment * 10), // 10 points per action
          subjects: profile.subjects,
          bio: profile.bio,
          avatarUrl: profile.avatarUrl,
          stats: updatedStats,
        );
        
        await _socialBox.put('user_profile', updatedProfile.toJson());
      }
    } catch (e) {
      debugPrint('Error updating user stats: $e');
    }
  }

  /// Get sample study groups
  List<StudyGroup> _getSampleStudyGroups() {
    return [
      StudyGroup(
        id: '1',
        name: 'Advanced Mathematics',
        description: 'Calculus, Linear Algebra, and more',
        subject: 'Mathematics',
        createdBy: 'user1',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        members: ['user1', 'user2', 'user3'],
        maxMembers: 10,
        isPrivate: false,
        settings: {},
      ),
      StudyGroup(
        id: '2',
        name: 'Physics Lab Group',
        description: 'Experimental physics and lab reports',
        subject: 'Physics',
        createdBy: 'user2',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        members: ['user2', 'user4'],
        maxMembers: 8,
        isPrivate: false,
        settings: {},
      ),
      StudyGroup(
        id: '3',
        name: 'Computer Science Fundamentals',
        description: 'Programming, algorithms, and data structures',
        subject: 'Computer Science',
        createdBy: 'user3',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        members: ['user3', 'user5', 'user6', 'user7'],
        maxMembers: 15,
        isPrivate: false,
        settings: {},
      ),
    ];
  }

  /// Get sample tutors
  List<UserProfile> _getSampleTutors() {
    return [
      UserProfile(
        id: 'tutor1',
        name: 'Sarah Johnson',
        email: 'sarah@example.com',
        reputation: 850,
        subjects: ['Mathematics', 'Physics'],
        bio: 'PhD in Mathematics, 5 years tutoring experience',
        stats: {'sessions_completed': 45, 'rating': 4.8},
      ),
      UserProfile(
        id: 'tutor2',
        name: 'Mike Chen',
        email: 'mike@example.com',
        reputation: 720,
        subjects: ['Computer Science', 'Programming'],
        bio: 'Software Engineer, loves teaching algorithms',
        stats: {'sessions_completed': 32, 'rating': 4.6},
      ),
      UserProfile(
        id: 'tutor3',
        name: 'Emma Davis',
        email: 'emma@example.com',
        reputation: 650,
        subjects: ['Chemistry', 'Biology'],
        bio: 'Medical student with strong science background',
        stats: {'sessions_completed': 28, 'rating': 4.7},
      ),
    ];
  }

  /// Get sample questions
  List<Question> _getSampleQuestions() {
    return [
      Question(
        id: '1',
        title: 'How to solve calculus derivatives?',
        content: 'I\'m struggling with finding derivatives of complex functions. Can someone explain the chain rule?',
        askedBy: 'student1',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        subject: 'Mathematics',
        tags: ['calculus', 'derivatives', 'chain-rule'],
        upvotes: 5,
        views: 23,
        hasAcceptedAnswer: false,
        answers: [],
      ),
      Question(
        id: '2',
        title: 'Best practices for algorithm design?',
        content: 'What are the key principles to follow when designing efficient algorithms?',
        askedBy: 'student2',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        subject: 'Computer Science',
        tags: ['algorithms', 'design', 'efficiency'],
        upvotes: 8,
        views: 45,
        hasAcceptedAnswer: true,
        answers: [],
      ),
      Question(
        id: '3',
        title: 'Understanding quantum mechanics basics',
        content: 'Can someone explain wave-particle duality in simple terms?',
        askedBy: 'student3',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        subject: 'Physics',
        tags: ['quantum', 'wave-particle', 'basics'],
        upvotes: 12,
        views: 67,
        hasAcceptedAnswer: false,
        answers: [],
      ),
    ];
  }

  /// Get default dashboard data
  Map<String, dynamic> _getDefaultDashboardData() {
    return {
      'user_reputation': 100,
      'joined_groups': 0,
      'helped_students': 0,
      'user_active_groups': [],
      'recent_activity': [],
      'total_users': 0,
      'active_groups': 0,
      'questions_answered': 0,
      'resources_shared': 0,
    };
  }

  /// Clear all social learning data
  Future<void> clearAllData() async {
    try {
      await _initializeService();
      await _socialBox.clear();
    } catch (e) {
      debugPrint('Error clearing social learning data: $e');
    }
  }
}