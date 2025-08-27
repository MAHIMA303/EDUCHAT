// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled

enum RecommendationType {
  learningResource,
  chatGroup,
  studyTopic,
  assignment,
  aiTutor,
}

enum RecommendationPriority {
  low,
  medium,
  high,
  urgent,
}

class Recommendation {
  final String id;
  final String userId;
  final String title;
  final String description;
  final RecommendationType type;
  final RecommendationPriority priority;
  final Map<String, dynamic> metadata;
  final bool isRead;
  final bool isAccepted;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final double confidenceScore; // AI confidence in this recommendation

  Recommendation({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.metadata,
    this.isRead = false,
    this.isAccepted = false,
    required this.createdAt,
    this.expiresAt,
    required this.confidenceScore,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.name,
      'priority': priority.name,
      'metadata': metadata,
      'isRead': isRead,
      'isAccepted': isAccepted,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'confidenceScore': confidenceScore,
    };
  }

  // Temporarily disabled Firebase functionality
  // factory Recommendation.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  //   final data = doc.data() ?? {};
  //   return Recommendation(
  //     id: doc.id,
  //     userId: data['userId'] ?? '',
  //     title: data['title'] ?? '',
  //     description: data['description'] ?? '',
  //     type: RecommendationType.values.firstWhere(
  //       (e) => e.name == data['type'],
  //       orElse: () => RecommendationType.learningResource,
  //     ),
  //     priority: RecommendationPriority.values.firstWhere(
  //       (e) => e.name == data['priority'],
  //       orElse: () => RecommendationPriority.medium,
  //     ),
  //     metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
  //     isRead: data['isRead'] ?? false,
  //     isAccepted: data['isAccepted'] ?? false,
  //     createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  //     expiresAt: (data['expiresAt'] as Timestamp?)?.toDate(),
  //     confidenceScore: (data['confidenceScore'] as num?)?.toDouble() ?? 0.0,
  //   );
  // }

  Recommendation copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    RecommendationType? type,
    RecommendationPriority? priority,
    Map<String, dynamic>? metadata,
    bool? isRead,
    bool? isAccepted,
    DateTime? createdAt,
    DateTime? expiresAt,
    double? confidenceScore,
  }) {
    return Recommendation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
      isAccepted: isAccepted ?? this.isAccepted,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }
}
