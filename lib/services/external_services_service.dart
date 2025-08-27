import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExternalService {
  final String name;
  final String icon;
  final String description;
  final bool isConnected;
  final String? accessToken;

  ExternalService({
    required this.name,
    required this.icon,
    required this.description,
    this.isConnected = false,
    this.accessToken,
  });
}

class GoogleClassroomAssignment {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String courseName;
  final DateTime dueDate;
  final String state; // 'DRAFT', 'PUBLISHED', 'DELETED'

  GoogleClassroomAssignment({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.courseName,
    required this.dueDate,
    required this.state,
  });

  factory GoogleClassroomAssignment.fromJson(Map<String, dynamic> json) {
    return GoogleClassroomAssignment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      courseId: json['courseId'] ?? '',
      courseName: json['courseName'] ?? '',
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime.now().toIso8601String()),
      state: json['state'] ?? 'DRAFT',
    );
  }
}

class GoogleDriveFile {
  final String id;
  final String name;
  final String mimeType;
  final DateTime modifiedTime;
  final String webViewLink;
  final int size;

  GoogleDriveFile({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.modifiedTime,
    required this.webViewLink,
    required this.size,
  });

  factory GoogleDriveFile.fromJson(Map<String, dynamic> json) {
    return GoogleDriveFile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mimeType: json['mimeType'] ?? '',
      modifiedTime: DateTime.parse(json['modifiedTime'] ?? DateTime.now().toIso8601String()),
      webViewLink: json['webViewLink'] ?? '',
      size: json['size'] ?? 0,
    );
  }
}

class ExternalServicesService {
  static const String _storageKey = 'external_services_tokens';
  
  // Supported external services
  static final List<ExternalService> _supportedServices = [
    ExternalService(
      name: 'Google Classroom',
      icon: '🎓',
      description: 'Sync assignments and courses from Google Classroom',
    ),
    ExternalService(
      name: 'Google Drive',
      icon: '📁',
      description: 'Access and share files from Google Drive',
    ),
    ExternalService(
      name: 'Canvas LMS',
      icon: '🎨',
      description: 'Connect to Canvas Learning Management System',
    ),
    ExternalService(
      name: 'Moodle',
      icon: '🌐',
      description: 'Integrate with Moodle LMS',
    ),
    ExternalService(
      name: 'Blackboard',
      icon: '📚',
      description: 'Connect to Blackboard Learn',
    ),
  ];

  // Get list of supported external services
  List<ExternalService> getSupportedServices() {
    return _supportedServices;
  }

  // Check if a service is connected
  Future<bool> isServiceConnected(String serviceName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('${_storageKey}_$serviceName');
    return token != null && token.isNotEmpty;
  }

  // Connect to Google Classroom
  Future<bool> connectToGoogleClassroom() async {
    try {
      // In a real implementation, this would use Google OAuth
      // For demo purposes, we'll simulate a successful connection
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_storageKey}_Google Classroom', 'demo_token_${DateTime.now().millisecondsSinceEpoch}');
      
      if (kDebugMode) {
        print('Connected to Google Classroom (demo mode)');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to connect to Google Classroom: $e');
      }
      return false;
    }
  }

  // Connect to Google Drive
  Future<bool> connectToGoogleDrive() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${_storageKey}_Google Drive', 'demo_token_${DateTime.now().millisecondsSinceEpoch}');
      
      if (kDebugMode) {
        print('Connected to Google Drive (demo mode)');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to connect to Google Drive: $e');
      }
      return false;
    }
  }

  // Get Google Classroom assignments
  Future<List<GoogleClassroomAssignment>> getGoogleClassroomAssignments() async {
    if (!await isServiceConnected('Google Classroom')) {
      throw Exception('Google Classroom not connected');
    }

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data for demo
    return [
      GoogleClassroomAssignment(
        id: 'assignment_1',
        title: 'Math Quiz - Chapter 5',
        description: 'Complete the quiz on quadratic equations',
        courseId: 'course_math_101',
        courseName: 'Mathematics 101',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        state: 'PUBLISHED',
      ),
      GoogleClassroomAssignment(
        id: 'assignment_2',
        title: 'Physics Lab Report',
        description: 'Write a report on the pendulum experiment',
        courseId: 'course_physics_101',
        courseName: 'Physics 101',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        state: 'PUBLISHED',
      ),
    ];
  }

  // Get Google Drive files
  Future<List<GoogleDriveFile>> getGoogleDriveFiles({String? query}) async {
    if (!await isServiceConnected('Google Drive')) {
      throw Exception('Google Drive not connected');
    }

    await Future.delayed(const Duration(seconds: 1));

    // Return mock data for demo
    return [
      GoogleDriveFile(
        id: 'file_1',
        name: 'Study Notes - Calculus.pdf',
        mimeType: 'application/pdf',
        modifiedTime: DateTime.now().subtract(const Duration(hours: 2)),
        webViewLink: 'https://drive.google.com/file/d/file_1/view',
        size: 2048576,
      ),
      GoogleDriveFile(
        id: 'file_2',
        name: 'Physics Formulas.docx',
        mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        modifiedTime: DateTime.now().subtract(const Duration(days: 1)),
        webViewLink: 'https://drive.google.com/file/d/file_2/view',
        size: 1048576,
      ),
    ];
  }

  // Import assignment from Google Classroom
  Future<bool> importAssignmentFromGoogleClassroom(String assignmentId) async {
    try {
      // Simulate import process
      await Future.delayed(const Duration(seconds: 2));
      
      if (kDebugMode) {
        print('Imported assignment $assignmentId from Google Classroom');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to import assignment: $e');
      }
      return false;
    }
  }

  // Share file to Google Drive
  Future<String?> shareFileToGoogleDrive(String filePath, String fileName) async {
    try {
      // Simulate file upload
      await Future.delayed(const Duration(seconds: 2));
      
      final fileId = 'shared_file_${DateTime.now().millisecondsSinceEpoch}';
      if (kDebugMode) {
        print('Shared file $fileName to Google Drive with ID: $fileId');
      }
      return fileId;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to share file: $e');
      }
      return null;
    }
  }

  // Disconnect from a service
  Future<bool> disconnectService(String serviceName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${_storageKey}_$serviceName');
      
      if (kDebugMode) {
        print('Disconnected from $serviceName');
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to disconnect from $serviceName: $e');
      }
      return false;
    }
  }

  // Get connection status for all services
  Future<List<ExternalService>> getConnectionStatus() async {
    final List<ExternalService> services = [];
    
    for (final service in _supportedServices) {
      final isConnected = await isServiceConnected(service.name);
      services.add(ExternalService(
        name: service.name,
        icon: service.icon,
        description: service.description,
        isConnected: isConnected,
      ));
    }
    
    return services;
  }
}
