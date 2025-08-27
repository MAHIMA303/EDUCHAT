import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AIService {
  static const String baseUrl = 'http://localhost:8000'; // Change to your backend URL
  
  // Chat with AI tutor
  static Future<Map<String, dynamic>> chatWithTutor({
    required String question,
    String? subject,
    String? tutorId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'question': question,
          if (subject != null) 'subject': subject,
          if (tutorId != null) 'tutor_id': tutorId,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to chat with tutor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to AI service: $e');
    }
  }

  // Upload educational document
  static Future<Map<String, dynamic>> uploadDocument({
    required File file,
    required String subject,
    String? topic,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload-document'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      request.fields['subject'] = subject;
      if (topic != null) {
        request.fields['topic'] = topic;
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception('Failed to upload document: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading document: $e');
    }
  }

  // Get available subjects
  static Future<List<Map<String, dynamic>>> getAvailableSubjects() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subjects'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['subjects']);
      } else {
        throw Exception('Failed to get subjects: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting subjects: $e');
    }
  }

  // Get tutor information
  static Future<Map<String, dynamic>> getTutorInfo(String tutorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tutor/$tutorId'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get tutor info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting tutor info: $e');
    }
  }

  // Check backend health
  static Future<bool> checkBackendHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Get AI response for chat
  static Future<String> getAiResponse(List<dynamic> messages, String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chat-json'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'messages': messages,
          'user_message': userMessage,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'] ?? 'Sorry, I could not generate a response.';
      } else {
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting AI response: $e');
    }
  }

  // Generate practice quiz
  static Future<Map<String, dynamic>> generatePracticeQuiz({
    required String subject,
    required String topic,
    String difficulty = 'medium',
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/practice-quiz'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'subject': subject,
          'topic': topic,
          'difficulty': difficulty,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to generate quiz: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating quiz: $e');
    }
  }
}

// AI Tutor Chat Message Model
class AITutorMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? subject;
  final String? tutorId;
  final List<String>? relatedDocuments;

  AITutorMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.subject,
    this.tutorId,
    this.relatedDocuments,
  });

  factory AITutorMessage.fromJson(Map<String, dynamic> json) {
    return AITutorMessage(
      id: json['id'],
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      subject: json['subject'],
      tutorId: json['tutorId'],
      relatedDocuments: json['relatedDocuments'] != null
          ? List<String>.from(json['relatedDocuments'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'subject': subject,
      'tutorId': tutorId,
      'relatedDocuments': relatedDocuments,
    };
  }
}

// AI Tutor Session Model
class AITutorSession {
  final String id;
  final String tutorId;
  final String tutorName;
  final String subject;
  final DateTime startTime;
  final List<AITutorMessage> messages;
  final bool isActive;

  AITutorSession({
    required this.id,
    required this.tutorId,
    required this.tutorName,
    required this.subject,
    required this.startTime,
    required this.messages,
    this.isActive = true,
  });

  factory AITutorSession.fromJson(Map<String, dynamic> json) {
    return AITutorSession(
      id: json['id'],
      tutorId: json['tutorId'],
      tutorName: json['tutorName'],
      subject: json['subject'],
      startTime: DateTime.parse(json['startTime']),
      messages: (json['messages'] as List)
          .map((msg) => AITutorMessage.fromJson(msg))
          .toList(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutorId': tutorId,
      'tutorName': tutorName,
      'subject': subject,
      'startTime': startTime.toIso8601String(),
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'isActive': isActive,
    };
  }
}


