import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/recommendation.dart';
import '../models/chat_message.dart';
import '../models/group.dart';
import 'ai_service.dart';

class RecommendationService {
  // final FirebaseFirestore? _db;
  final AiService _aiService;
  final http.Client _client;
  final String _apiKey;

  RecommendationService({
    // FirebaseFirestore? firestore,
    AiService? aiService,
    http.Client? client,
    String? apiKey,
  }) // : _db = kIsWeb ? null : (firestore ?? FirebaseFirestore.instance),
       : _aiService = aiService ?? AiService(),
       _client = client ?? http.Client(),
       _apiKey = apiKey ?? const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');

  // Get recommendations for a user
  Stream<List<Recommendation>> getUserRecommendations(String userId) {
    // Temporarily disabled Firebase functionality
    // if (kIsWeb || _db == null) {
    //   return const Stream<List<Recommendation>>.empty();
    // }

    // return _db!
    //     .collection('recommendations')
    //     .where('userId', isEqualTo: userId)
    //     .orderBy('createdAt', descending: true)
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs
    //         .map((doc) => Recommendation.fromDoc(doc))
    //         .toList());
    return Stream.value([]); // Return empty list for now
  }

  // Generate AI-based recommendations
  Future<List<Recommendation>> generateRecommendations({
    required String userId,
    required String username,
    List<ChatMessage>? chatHistory,
    List<Map<String, dynamic>>? assignments,
    List<Group>? groups,
    int limit = 5,
  }) async {
    try {
      // Prepare context for AI
      final context = _buildUserContext(chatHistory, assignments, groups);
      
      // Generate recommendations using AI
      final aiRecommendations = await _generateAIRecommendations(context, limit);
      
      // Store recommendations in Firestore
      final recommendations = <Recommendation>[];
      for (final aiRec in aiRecommendations) {
        final recommendation = Recommendation(
          id: const Uuid().v4(),
          userId: userId,
          title: aiRec['title'],
          description: aiRec['description'],
          type: _parseRecommendationType(aiRec['type']),
          priority: _parseRecommendationPriority(aiRec['priority']),
          metadata: aiRec['metadata'] ?? {},
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(days: 30)),
          confidenceScore: aiRec['confidence'] ?? 0.8,
        );
        
        await _storeRecommendation(recommendation);
        recommendations.add(recommendation);
      }
      
      return recommendations;
    } catch (e) {
      print('Error generating recommendations: $e');
      // Return fallback recommendations
      return _generateFallbackRecommendations(userId, username);
    }
  }

  // Build user context for AI recommendations
  String _buildUserContext(
    List<ChatMessage>? chatHistory,
    List<Map<String, dynamic>>? assignments,
    List<Group>? groups,
  ) {
    final context = StringBuffer();
    
    // Add chat topics
    if (chatHistory != null && chatHistory.isNotEmpty) {
      final topics = chatHistory
          .where((msg) => !msg.isUser)
          .take(10)
          .map((msg) => msg.text)
          .join(', ');
      context.writeln('Recent chat topics: $topics');
    }
    
    // Add assignment subjects
    if (assignments != null && assignments.isNotEmpty) {
      final subjects = assignments
          .map((a) => a['subject'])
          .toSet()
          .join(', ');
      context.writeln('Current subjects: $subjects');
    }
    
    // Add group interests
    if (groups != null && groups.isNotEmpty) {
      final groupNames = groups.map((g) => g.groupName).join(', ');
      context.writeln('Study groups: $groupNames');
    }
    
    return context.toString();
  }

  // Generate AI recommendations using OpenAI API
  Future<List<Map<String, dynamic>>> _generateAIRecommendations(String context, int limit) async {
    if (_apiKey.isEmpty) {
      throw Exception('OpenAI API Key not configured');
    }

    final prompt = '''
Based on the following user context, generate $limit personalized learning recommendations:

Context:
$context

Generate recommendations in the following JSON format:
[
  {
    "title": "Short title",
    "description": "Detailed description",
    "type": "learningResource|chatGroup|studyTopic|assignment|aiTutor",
    "priority": "low|medium|high|urgent",
    "metadata": {
      "subject": "subject name",
      "difficulty": "beginner|intermediate|advanced",
      "estimatedTime": "time in minutes",
      "tags": ["tag1", "tag2"]
    },
    "confidence": 0.85
  }
]

Focus on:
- Learning resources that match their current subjects
- Study topics that build on their recent conversations
- Chat groups that align with their interests
- Assignments that complement their current workload
- AI tutor sessions for challenging subjects
''';

    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'You are an educational AI assistant that generates personalized learning recommendations.'},
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Parse JSON response
        try {
          final recommendations = jsonDecode(content) as List;
          return recommendations.cast<Map<String, dynamic>>();
        } catch (e) {
          print('Error parsing AI response: $e');
          return _generateFallbackRecommendationsData();
        }
      } else {
        print('OpenAI API Error: ${response.statusCode} - ${response.body}');
        return _generateFallbackRecommendationsData();
      }
    } catch (e) {
      print('Error calling OpenAI API: $e');
      return _generateFallbackRecommendationsData();
    }
  }

    // Store recommendation in Firestore
  Future<void> _storeRecommendation(Recommendation recommendation) async {
    // Temporarily disabled Firebase functionality
    // if (kIsWeb || _db == null) return;

    // await _db!
    //     .collection('recommendations')
    //     .doc(recommendation.id)
    //     .set(recommendation.toMap());
  }

    // Mark recommendation as read
  Future<void> markAsRead(String recommendationId) async {
    // Temporarily disabled Firebase functionality
    // if (kIsWeb || _db == null) return;

    // await _db!
    //     .collection('recommendations')
    //     .doc(recommendationId)
    //     .update({'isRead': true});
  }

    // Mark recommendation as accepted
  Future<void> markAsAccepted(String recommendationId) async {
    // Temporarily disabled Firebase functionality
    // if (kIsWeb || _db == null) return;

    // await _db!
    //     .collection('recommendations')
    //     .doc(recommendationId)
    //     .update({'isAccepted': true});
  }

    // Delete recommendation
  Future<void> deleteRecommendation(String recommendationId) async {
    // Temporarily disabled Firebase functionality
    // if (kIsWeb || _db == null) return;

    // await _db!
    //     .collection('recommendations')
    //     .doc(recommendationId)
    //     .delete();
  }

  // Parse recommendation type from string
  RecommendationType _parseRecommendationType(String type) {
    switch (type.toLowerCase()) {
      case 'learningresource':
        return RecommendationType.learningResource;
      case 'chatgroup':
        return RecommendationType.chatGroup;
      case 'studytopic':
        return RecommendationType.studyTopic;
      case 'assignment':
        return RecommendationType.assignment;
      case 'aitutor':
        return RecommendationType.aiTutor;
      default:
        return RecommendationType.learningResource;
    }
  }

  // Parse recommendation priority from string
  RecommendationPriority _parseRecommendationPriority(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return RecommendationPriority.low;
      case 'medium':
        return RecommendationPriority.medium;
      case 'high':
        return RecommendationPriority.high;
      case 'urgent':
        return RecommendationPriority.urgent;
      default:
        return RecommendationPriority.medium;
    }
  }

  // Generate fallback recommendations when AI fails
  List<Recommendation> _generateFallbackRecommendations(String userId, String username) {
    return [
      Recommendation(
        id: const Uuid().v4(),
        userId: userId,
        title: 'Mathematics Practice',
        description: 'Based on your recent assignments, practice quadratic equations and calculus concepts.',
        type: RecommendationType.learningResource,
        priority: RecommendationPriority.medium,
        metadata: {
          'subject': 'Mathematics',
          'difficulty': 'intermediate',
          'estimatedTime': 45,
          'tags': ['math', 'practice', 'calculus']
        },
        createdAt: DateTime.now(),
        confidenceScore: 0.7,
      ),
      Recommendation(
        id: const Uuid().v4(),
        userId: userId,
        title: 'Physics Study Group',
        description: 'Join a study group focused on Newton\'s Laws and mechanics.',
        type: RecommendationType.chatGroup,
        priority: RecommendationPriority.high,
        metadata: {
          'subject': 'Physics',
          'groupSize': '5-8 students',
          'focus': 'Mechanics',
          'meetingTime': 'Weekly'
        },
        createdAt: DateTime.now(),
        confidenceScore: 0.8,
      ),
    ];
  }

  // Generate fallback data for AI recommendations
  List<Map<String, dynamic>> _generateFallbackRecommendationsData() {
    return [
      {
        'title': 'Mathematics Practice',
        'description': 'Practice quadratic equations and calculus concepts based on your recent assignments.',
        'type': 'learningResource',
        'priority': 'medium',
        'metadata': {
          'subject': 'Mathematics',
          'difficulty': 'intermediate',
          'estimatedTime': 45,
          'tags': ['math', 'practice', 'calculus']
        },
        'confidence': 0.7
      },
      {
        'title': 'Physics Study Group',
        'description': 'Join a study group focused on Newton\'s Laws and mechanics.',
        'type': 'chatGroup',
        'priority': 'high',
        'metadata': {
          'subject': 'Physics',
          'groupSize': '5-8 students',
          'focus': 'Mechanics',
          'meetingTime': 'Weekly'
        },
        'confidence': 0.8
      },
    ];
  }
}
