// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';

class StudentEngagementMetrics {
  final String studentId;
  final String studentName;
  final int assignmentsSubmitted;
  final int messagesSent;
  final int pointsEarned;

  StudentEngagementMetrics({
    required this.studentId,
    required this.studentName,
    required this.assignmentsSubmitted,
    required this.messagesSent,
    required this.pointsEarned,
  });
}

class AnalyticsService {
  // Temporarily disabled Firebase functionality
  // AnalyticsService({FirebaseFirestore? firestore})
  //     : _db = kIsWeb ? null : (firestore ?? FirebaseFirestore.instance);

  // final FirebaseFirestore? _db; // null on web if Firebase not configured for demo

  // Collections used (expected):
  // - users: { role: 'student'|'teacher', name }
  // - assignment_submissions: { studentId, submittedAt, assignmentId }
  // - chat_messages: { senderId, createdAt }
  // - leaderboard: { userId, username, points }

  Future<List<StudentEngagementMetrics>> getClassroomMetrics({required String teacherId}) async {
    // Temporarily disabled Firebase functionality
    // if (_db == null) return <StudentEngagementMetrics>[];

    // // Assumption: teacher has access to a list of students via a class field on users
    // // or via groups. For simplicity, fetch all students for this demo.
    // final usersQs = await _db!.collection('users').where('role', isEqualTo: 'student').get();
    // final studentIds = usersQs.docs.map((d) => d.id).toList();
    // final studentNames = {for (final d in usersQs.docs) d.id: (d.data()['name'] as String?) ?? 'Student'};

    // // Aggregate assignments submissions per student
    // final submissionsQs = await _db!
    //     .collection('assignment_submissions')
    //     .where('studentId', whereIn: studentIds.isEmpty ? ['__none__'] : studentIds.length > 10 ? studentIds.sublist(0, 10) : studentIds)
    //     .get();
    // final Map<String, int> submissionsCount = {};
    // for (final doc in submissionsQs.docs) {
    //   final sid = doc.data()['studentId'] as String?;
    //   if (sid == null) continue;
    //   submissionsCount[sid] = (submissionsCount[sid] ?? 0) + 1;
    // }

    // // Aggregate chat messages per student
    // final messagesQs = await _db!
    //     .collection('chat_messages')
    //     .where('senderId', whereIn: studentIds.isEmpty ? ['__none__'] : studentIds.length > 10 ? studentIds.sublist(0, 10) : studentIds)
    //     .get();
    // final Map<String, int> messagesCount = {};
    // for (final doc in messagesQs.docs) {
    //   final sid = doc.data()['senderId'] as String?;
    //   if (sid == null) continue;
    //   messagesCount[sid] = (messagesCount[sid] ?? 0) + 1;
    // }

    // // Points from leaderboard
    // final leaderboardQs = await _db!.collection('leaderboard').get();
    // final Map<String, int> pointsMap = {
    //   for (final d in leaderboardQs.docs) (d.data()['userId'] as String? ?? d.id): (d.data()['points'] as num?)?.toInt() ?? 0
    // };

    // final List<StudentEngagementMetrics> result = [];
    // for (final sid in studentIds) {
    //   result.add(StudentEngagementMetrics(
    //     studentId: sid,
    //     studentName: studentNames[sid] ?? 'Student',
    //     assignmentsSubmitted: submissionsCount[sid] ?? 0,
    //     messagesSent: messagesCount[sid] ?? 0,
    //     pointsEarned: pointsMap[sid] ?? 0,
    //   ));
    // }
    // return result;
    return []; // Return empty list for now
  }
}


