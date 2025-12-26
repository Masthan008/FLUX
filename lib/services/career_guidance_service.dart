import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CareerAssessment {
  final String id;
  final String title;
  final String description;
  final List<AssessmentQuestion> questions;
  final DateTime createdAt;
  final bool isCompleted;
  final Map<String, dynamic>? results;

  CareerAssessment({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
    required this.isCompleted,
    this.results,
  });

  factory CareerAssessment.fromJson(Map<String, dynamic> json) {
    return CareerAssessment(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List)
          .map((q) => AssessmentQuestion.fromJson(q))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      isCompleted: json['is_completed'] as bool? ?? false,
      results: json['results'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'is_completed': isCompleted,
      'results': results,
    };
  }
}

class AssessmentQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String type; // multiple_choice, rating, text
  final bool isRequired;
  final String? selectedAnswer;

  AssessmentQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.type,
    required this.isRequired,
    this.selectedAnswer,
  });

  factory AssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      type: json['type'] as String,
      isRequired: json['is_required'] as bool? ?? true,
      selectedAnswer: json['selected_answer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'type': type,
      'is_required': isRequired,
      'selected_answer': selectedAnswer,
    };
  }
}

class CareerPath {
  final String id;
  final String title;
  final String description;
  final List<String> requiredSkills;
  final String salaryRange;
  final String growthRate;
  final String education;
  final List<String> industries;
  final double matchPercentage;

  CareerPath({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredSkills,
    required this.salaryRange,
    required this.growthRate,
    required this.education,
    required this.industries,
    required this.matchPercentage,
  });

  factory CareerPath.fromJson(Map<String, dynamic> json) {
    return CareerPath(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      requiredSkills: List<String>.from(json['required_skills'] as List),
      salaryRange: json['salary_range'] as String,
      growthRate: json['growth_rate'] as String,
      education: json['education'] as String,
      industries: List<String>.from(json['industries'] as List),
      matchPercentage: json['match_percentage'] as double? ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'required_skills': requiredSkills,
      'salary_range': salaryRange,
      'growth_rate': growthRate,
      'education': education,
      'industries': industries,
      'match_percentage': matchPercentage,
    };
  }
}

class Skill {
  final String id;
  final String name;
  final String category;
  final String description;
  final int currentLevel; // 1-5 scale
  final int targetLevel;
  final List<String> resources;
  final DateTime lastUpdated;

  Skill({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.currentLevel,
    required this.targetLevel,
    required this.resources,
    required this.lastUpdated,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      currentLevel: json['current_level'] as int? ?? 1,
      targetLevel: json['target_level'] as int? ?? 5,
      resources: List<String>.from(json['resources'] as List? ?? []),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'current_level': currentLevel,
      'target_level': targetLevel,
      'resources': resources,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  double get progressPercentage => currentLevel / targetLevel;
}

class InterviewQuestion {
  final String id;
  final String question;
  final String category;
  final String difficulty;
  final List<String> tips;
  final String? sampleAnswer;

  InterviewQuestion({
    required this.id,
    required this.question,
    required this.category,
    required this.difficulty,
    required this.tips,
    this.sampleAnswer,
  });

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      tips: List<String>.from(json['tips'] as List? ?? []),
      sampleAnswer: json['sample_answer'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'category': category,
      'difficulty': difficulty,
      'tips': tips,
      'sample_answer': sampleAnswer,
    };
  }
}

class CareerGuidanceService {
  static const String _careerBoxKey = 'career_guidance';
  late Box _careerBox;
  final SupabaseClient _supabase = Supabase.instance.client;

  CareerGuidanceService() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      _careerBox = await Hive.openBox(_careerBoxKey);
    } catch (e) {
      debugPrint('Error initializing career guidance service: $e');
    }
  }

  /// Get dashboard data for overview
  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      await _initializeService();
      
      // Get user career profile
      final careerProfile = await getCareerProfile();
      final completedAssessments = await getCompletedAssessments();
      final trackedSkills = await getTrackedSkills();
      
      return {
        'career_level': careerProfile['level'] ?? 'Beginner',
        'completed_assessments': completedAssessments.length,
        'skills_tracked': trackedSkills.length,
        'career_progress': {
          'overall': _calculateOverallProgress(careerProfile, completedAssessments, trackedSkills),
        },
        'recommended_paths': await getRecommendedCareerPaths(),
      };
    } catch (e) {
      debugPrint('Error getting dashboard data: $e');
      return _getDefaultDashboardData();
    }
  }

  /// Get user career profile
  Future<Map<String, dynamic>> getCareerProfile() async {
    try {
      await _initializeService();
      
      final profile = _careerBox.get('career_profile', defaultValue: <String, dynamic>{});
      
      if (profile.isEmpty) {
        // Create default profile
        final defaultProfile = {
          'level': 'Beginner',
          'interests': <String>[],
          'strengths': <String>[],
          'goals': <String>[],
          'created_at': DateTime.now().toIso8601String(),
        };
        
        await _careerBox.put('career_profile', defaultProfile);
        return defaultProfile;
      }
      
      return Map<String, dynamic>.from(profile);
    } catch (e) {
      debugPrint('Error getting career profile: $e');
      return {};
    }
  }

  /// Get available career assessments
  Future<List<CareerAssessment>> getCareerAssessments() async {
    try {
      // Return sample assessments for now
      return _getSampleAssessments();
    } catch (e) {
      debugPrint('Error getting career assessments: $e');
      return [];
    }
  }

  /// Get completed assessments
  Future<List<CareerAssessment>> getCompletedAssessments() async {
    try {
      await _initializeService();
      
      final assessments = _careerBox.get('completed_assessments', defaultValue: <Map<String, dynamic>>[]);
      final assessmentsList = List<Map<String, dynamic>>.from(assessments);
      
      return assessmentsList
          .map((json) => CareerAssessment.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting completed assessments: $e');
      return [];
    }
  }

  /// Complete an assessment
  Future<bool> completeAssessment(String assessmentId, Map<String, String> answers) async {
    try {
      await _initializeService();
      
      // Calculate results based on answers
      final results = _calculateAssessmentResults(assessmentId, answers);
      
      // Save completed assessment
      final completedAssessments = _careerBox.get('completed_assessments', defaultValue: <Map<String, dynamic>>[]);
      final assessmentsList = List<Map<String, dynamic>>.from(completedAssessments);
      
      final assessment = CareerAssessment(
        id: assessmentId,
        title: _getAssessmentTitle(assessmentId),
        description: _getAssessmentDescription(assessmentId),
        questions: [], // We don't need to store questions for completed assessments
        createdAt: DateTime.now(),
        isCompleted: true,
        results: results,
      );
      
      assessmentsList.add(assessment.toJson());
      await _careerBox.put('completed_assessments', assessmentsList);
      
      // Update career profile based on results
      await _updateCareerProfileFromAssessment(results);
      
      return true;
    } catch (e) {
      debugPrint('Error completing assessment: $e');
      return false;
    }
  }

  /// Get recommended career paths
  Future<List<CareerPath>> getRecommendedCareerPaths() async {
    try {
      final careerProfile = await getCareerProfile();
      final completedAssessments = await getCompletedAssessments();
      
      // Get sample career paths and calculate match percentages
      final allPaths = _getSampleCareerPaths();
      
      // Calculate match percentages based on profile and assessments
      for (var path in allPaths) {
        path = CareerPath(
          id: path.id,
          title: path.title,
          description: path.description,
          requiredSkills: path.requiredSkills,
          salaryRange: path.salaryRange,
          growthRate: path.growthRate,
          education: path.education,
          industries: path.industries,
          matchPercentage: _calculateCareerMatch(path, careerProfile, completedAssessments),
        );
      }
      
      // Sort by match percentage
      allPaths.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
      
      return allPaths.take(10).toList();
    } catch (e) {
      debugPrint('Error getting recommended career paths: $e');
      return [];
    }
  }

  /// Get tracked skills
  Future<List<Skill>> getTrackedSkills() async {
    try {
      await _initializeService();
      
      final skills = _careerBox.get('tracked_skills', defaultValue: <Map<String, dynamic>>[]);
      final skillsList = List<Map<String, dynamic>>.from(skills);
      
      return skillsList
          .map((json) => Skill.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting tracked skills: $e');
      return [];
    }
  }

  /// Add skill to tracking
  Future<bool> addSkillToTracking(Skill skill) async {
    try {
      await _initializeService();
      
      final skills = _careerBox.get('tracked_skills', defaultValue: <Map<String, dynamic>>[]);
      final skillsList = List<Map<String, dynamic>>.from(skills);
      
      skillsList.add(skill.toJson());
      await _careerBox.put('tracked_skills', skillsList);
      
      return true;
    } catch (e) {
      debugPrint('Error adding skill to tracking: $e');
      return false;
    }
  }

  /// Update skill level
  Future<bool> updateSkillLevel(String skillId, int newLevel) async {
    try {
      await _initializeService();
      
      final skills = _careerBox.get('tracked_skills', defaultValue: <Map<String, dynamic>>[]);
      final skillsList = List<Map<String, dynamic>>.from(skills);
      
      for (int i = 0; i < skillsList.length; i++) {
        if (skillsList[i]['id'] == skillId) {
          skillsList[i]['current_level'] = newLevel;
          skillsList[i]['last_updated'] = DateTime.now().toIso8601String();
          break;
        }
      }
      
      await _careerBox.put('tracked_skills', skillsList);
      return true;
    } catch (e) {
      debugPrint('Error updating skill level: $e');
      return false;
    }
  }

  /// Get interview questions
  Future<List<InterviewQuestion>> getInterviewQuestions({String? category}) async {
    try {
      final allQuestions = _getSampleInterviewQuestions();
      
      if (category == null || category.isEmpty) {
        return allQuestions;
      }
      
      return allQuestions.where((q) => q.category.toLowerCase() == category.toLowerCase()).toList();
    } catch (e) {
      debugPrint('Error getting interview questions: $e');
      return [];
    }
  }

  /// Get industry insights
  Future<Map<String, dynamic>> getIndustryInsights() async {
    try {
      return {
        'trending_industries': _getTrendingIndustries(),
        'salary_data': _getSalaryData(),
        'job_market_stats': _getJobMarketStats(),
        'skill_demand': _getSkillDemand(),
      };
    } catch (e) {
      debugPrint('Error getting industry insights: $e');
      return {};
    }
  }

  /// Calculate overall progress
  double _calculateOverallProgress(
    Map<String, dynamic> profile,
    List<CareerAssessment> assessments,
    List<Skill> skills,
  ) {
    double progress = 0.0;
    
    // Profile completion (25%)
    if (profile.isNotEmpty) progress += 0.25;
    
    // Assessments completion (25%)
    if (assessments.isNotEmpty) progress += 0.25;
    
    // Skills tracking (25%)
    if (skills.isNotEmpty) {
      final avgSkillProgress = skills.fold(0.0, (sum, skill) => sum + skill.progressPercentage) / skills.length;
      progress += avgSkillProgress * 0.25;
    }
    
    // Additional activities (25%)
    progress += 0.1; // Base progress for using the system
    
    return progress.clamp(0.0, 1.0);
  }

  /// Calculate assessment results
  Map<String, dynamic> _calculateAssessmentResults(String assessmentId, Map<String, String> answers) {
    // Simple scoring system - in a real app, this would be more sophisticated
    final results = <String, dynamic>{};
    
    switch (assessmentId) {
      case 'personality':
        results['personality_type'] = _calculatePersonalityType(answers);
        results['strengths'] = _calculateStrengths(answers);
        break;
      case 'skills':
        results['technical_score'] = _calculateTechnicalScore(answers);
        results['soft_skills_score'] = _calculateSoftSkillsScore(answers);
        break;
      case 'interests':
        results['career_interests'] = _calculateCareerInterests(answers);
        results['work_environment'] = _calculateWorkEnvironment(answers);
        break;
    }
    
    results['completed_at'] = DateTime.now().toIso8601String();
    results['score'] = _calculateOverallScore(answers);
    
    return results;
  }

  /// Calculate career match percentage
  double _calculateCareerMatch(
    CareerPath path,
    Map<String, dynamic> profile,
    List<CareerAssessment> assessments,
  ) {
    double match = 0.5; // Base match
    
    // Check interests alignment
    final interests = profile['interests'] as List<dynamic>? ?? [];
    for (final interest in interests) {
      if (path.description.toLowerCase().contains(interest.toString().toLowerCase())) {
        match += 0.1;
      }
    }
    
    // Check skills alignment
    final userSkills = profile['strengths'] as List<dynamic>? ?? [];
    for (final skill in userSkills) {
      if (path.requiredSkills.any((s) => s.toLowerCase().contains(skill.toString().toLowerCase()))) {
        match += 0.1;
      }
    }
    
    // Assessment results alignment
    for (final assessment in assessments) {
      if (assessment.results != null) {
        // Add logic to match assessment results with career paths
        match += 0.05;
      }
    }
    
    return (match * 100).clamp(0.0, 100.0);
  }

  /// Update career profile from assessment
  Future<void> _updateCareerProfileFromAssessment(Map<String, dynamic> results) async {
    try {
      final profile = await getCareerProfile();
      
      // Update profile based on assessment results
      if (results.containsKey('strengths')) {
        profile['strengths'] = results['strengths'];
      }
      
      if (results.containsKey('career_interests')) {
        profile['interests'] = results['career_interests'];
      }
      
      if (results.containsKey('personality_type')) {
        profile['personality_type'] = results['personality_type'];
      }
      
      profile['last_updated'] = DateTime.now().toIso8601String();
      
      await _careerBox.put('career_profile', profile);
    } catch (e) {
      debugPrint('Error updating career profile: $e');
    }
  }

  /// Helper methods for assessment calculations
  String _calculatePersonalityType(Map<String, String> answers) {
    // Simplified personality type calculation
    return 'Analytical';
  }

  List<String> _calculateStrengths(Map<String, String> answers) {
    return ['Problem Solving', 'Communication', 'Leadership'];
  }

  int _calculateTechnicalScore(Map<String, String> answers) {
    return 75; // Placeholder score
  }

  int _calculateSoftSkillsScore(Map<String, String> answers) {
    return 80; // Placeholder score
  }

  List<String> _calculateCareerInterests(Map<String, String> answers) {
    return ['Technology', 'Innovation', 'Problem Solving'];
  }

  String _calculateWorkEnvironment(Map<String, String> answers) {
    return 'Collaborative';
  }

  int _calculateOverallScore(Map<String, String> answers) {
    return 78; // Placeholder overall score
  }

  /// Get assessment metadata
  String _getAssessmentTitle(String assessmentId) {
    switch (assessmentId) {
      case 'personality': return 'Personality Assessment';
      case 'skills': return 'Skills Evaluation';
      case 'interests': return 'Career Interests';
      default: return 'Career Assessment';
    }
  }

  String _getAssessmentDescription(String assessmentId) {
    switch (assessmentId) {
      case 'personality': return 'Discover your personality type and work style preferences';
      case 'skills': return 'Evaluate your technical and soft skills';
      case 'interests': return 'Identify your career interests and motivations';
      default: return 'Comprehensive career assessment';
    }
  }

  /// Sample data methods
  List<CareerAssessment> _getSampleAssessments() {
    return [
      CareerAssessment(
        id: 'personality',
        title: 'Personality Assessment',
        description: 'Discover your personality type and work style preferences',
        questions: _getPersonalityQuestions(),
        createdAt: DateTime.now(),
        isCompleted: false,
      ),
      CareerAssessment(
        id: 'skills',
        title: 'Skills Evaluation',
        description: 'Evaluate your technical and soft skills',
        questions: _getSkillsQuestions(),
        createdAt: DateTime.now(),
        isCompleted: false,
      ),
      CareerAssessment(
        id: 'interests',
        title: 'Career Interests',
        description: 'Identify your career interests and motivations',
        questions: _getInterestsQuestions(),
        createdAt: DateTime.now(),
        isCompleted: false,
      ),
    ];
  }

  List<AssessmentQuestion> _getPersonalityQuestions() {
    return [
      AssessmentQuestion(
        id: 'p1',
        question: 'I prefer to work:',
        options: ['Alone', 'In small groups', 'In large teams', 'It depends on the task'],
        type: 'multiple_choice',
        isRequired: true,
      ),
      AssessmentQuestion(
        id: 'p2',
        question: 'When making decisions, I rely more on:',
        options: ['Logic and facts', 'Intuition and feelings', 'Past experience', 'Others\' opinions'],
        type: 'multiple_choice',
        isRequired: true,
      ),
      AssessmentQuestion(
        id: 'p3',
        question: 'I am most energized by:',
        options: ['Solving complex problems', 'Helping others', 'Creating new things', 'Leading projects'],
        type: 'multiple_choice',
        isRequired: true,
      ),
    ];
  }

  List<AssessmentQuestion> _getSkillsQuestions() {
    return [
      AssessmentQuestion(
        id: 's1',
        question: 'Rate your programming skills (1-5):',
        options: ['1', '2', '3', '4', '5'],
        type: 'rating',
        isRequired: true,
      ),
      AssessmentQuestion(
        id: 's2',
        question: 'Rate your communication skills (1-5):',
        options: ['1', '2', '3', '4', '5'],
        type: 'rating',
        isRequired: true,
      ),
      AssessmentQuestion(
        id: 's3',
        question: 'Rate your leadership experience (1-5):',
        options: ['1', '2', '3', '4', '5'],
        type: 'rating',
        isRequired: true,
      ),
    ];
  }

  List<AssessmentQuestion> _getInterestsQuestions() {
    return [
      AssessmentQuestion(
        id: 'i1',
        question: 'Which field interests you most?',
        options: ['Technology', 'Healthcare', 'Education', 'Business', 'Arts'],
        type: 'multiple_choice',
        isRequired: true,
      ),
      AssessmentQuestion(
        id: 'i2',
        question: 'What motivates you most at work?',
        options: ['Solving problems', 'Helping people', 'Making money', 'Being creative', 'Leading others'],
        type: 'multiple_choice',
        isRequired: true,
      ),
    ];
  }

  List<CareerPath> _getSampleCareerPaths() {
    return [
      CareerPath(
        id: 'software_engineer',
        title: 'Software Engineer',
        description: 'Design and develop software applications and systems',
        requiredSkills: ['Programming', 'Problem Solving', 'System Design', 'Testing'],
        salaryRange: '\$70,000 - \$150,000',
        growthRate: '+22%',
        education: 'Bachelor\'s in Computer Science or related field',
        industries: ['Technology', 'Finance', 'Healthcare', 'Gaming'],
        matchPercentage: 0.0,
      ),
      CareerPath(
        id: 'data_scientist',
        title: 'Data Scientist',
        description: 'Analyze complex data to help organizations make decisions',
        requiredSkills: ['Statistics', 'Python/R', 'Machine Learning', 'Data Visualization'],
        salaryRange: '\$80,000 - \$160,000',
        growthRate: '+25%',
        education: 'Bachelor\'s in Statistics, Math, or Computer Science',
        industries: ['Technology', 'Finance', 'Healthcare', 'Retail'],
        matchPercentage: 0.0,
      ),
      CareerPath(
        id: 'product_manager',
        title: 'Product Manager',
        description: 'Guide product development from conception to launch',
        requiredSkills: ['Strategy', 'Communication', 'Analytics', 'Leadership'],
        salaryRange: '\$90,000 - \$180,000',
        growthRate: '+18%',
        education: 'Bachelor\'s degree, MBA preferred',
        industries: ['Technology', 'Consumer Goods', 'Finance'],
        matchPercentage: 0.0,
      ),
    ];
  }

  List<InterviewQuestion> _getSampleInterviewQuestions() {
    return [
      InterviewQuestion(
        id: 'behavioral_1',
        question: 'Tell me about a time when you had to work with a difficult team member.',
        category: 'Behavioral',
        difficulty: 'Medium',
        tips: [
          'Use the STAR method (Situation, Task, Action, Result)',
          'Focus on your actions and what you learned',
          'Show emotional intelligence and conflict resolution skills',
        ],
        sampleAnswer: 'In my previous role, I worked with a colleague who was resistant to new processes...',
      ),
      InterviewQuestion(
        id: 'technical_1',
        question: 'Explain the difference between a stack and a queue.',
        category: 'Technical',
        difficulty: 'Easy',
        tips: [
          'Define both data structures clearly',
          'Explain LIFO vs FIFO principles',
          'Give real-world examples of usage',
        ],
      ),
      InterviewQuestion(
        id: 'situational_1',
        question: 'How would you handle a situation where you disagree with your manager\'s decision?',
        category: 'Situational',
        difficulty: 'Medium',
        tips: [
          'Show respect for hierarchy',
          'Demonstrate communication skills',
          'Focus on finding solutions',
        ],
      ),
    ];
  }

  List<Map<String, dynamic>> _getTrendingIndustries() {
    return [
      {
        'name': 'Artificial Intelligence',
        'growth': '+25%',
        'jobs': 150000,
        'avg_salary': '\$120,000',
      },
      {
        'name': 'Cybersecurity',
        'growth': '+18%',
        'jobs': 120000,
        'avg_salary': '\$110,000',
      },
      {
        'name': 'Cloud Computing',
        'growth': '+22%',
        'jobs': 200000,
        'avg_salary': '\$115,000',
      },
    ];
  }

  Map<String, dynamic> _getSalaryData() {
    return {
      'entry_level': {
        'software_engineer': 70000,
        'data_scientist': 80000,
        'product_manager': 90000,
      },
      'mid_level': {
        'software_engineer': 110000,
        'data_scientist': 120000,
        'product_manager': 135000,
      },
      'senior_level': {
        'software_engineer': 150000,
        'data_scientist': 160000,
        'product_manager': 180000,
      },
    };
  }

  Map<String, dynamic> _getJobMarketStats() {
    return {
      'total_openings': 500000,
      'remote_percentage': 65,
      'top_locations': ['San Francisco', 'New York', 'Seattle', 'Austin'],
      'hiring_trends': 'Increasing demand for AI/ML skills',
    };
  }

  List<Map<String, dynamic>> _getSkillDemand() {
    return [
      {'skill': 'Python', 'demand': 95, 'growth': '+15%'},
      {'skill': 'JavaScript', 'demand': 90, 'growth': '+12%'},
      {'skill': 'Machine Learning', 'demand': 85, 'growth': '+25%'},
      {'skill': 'Cloud Platforms', 'demand': 80, 'growth': '+20%'},
    ];
  }

  /// Get default dashboard data
  Map<String, dynamic> _getDefaultDashboardData() {
    return {
      'career_level': 'Beginner',
      'completed_assessments': 0,
      'skills_tracked': 0,
      'career_progress': {'overall': 0.1},
      'recommended_paths': [],
    };
  }

  /// Clear all career guidance data
  Future<void> clearAllData() async {
    try {
      await _initializeService();
      await _careerBox.clear();
    } catch (e) {
      debugPrint('Error clearing career guidance data: $e');
    }
  }
}