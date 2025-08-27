// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled

class Group {
  final String groupId;
  final String groupName;
  final List<String> members;
  final String createdBy;
  final DateTime createdAt; // Temporarily use DateTime instead of Timestamp

  Group({
    required this.groupId,
    required this.groupName,
    required this.members,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }

  // Temporarily disabled Firebase functionality
  // factory Group.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  //   final data = doc.data() ?? {};
  //   return Group(
  //     groupId: data['groupId'] ?? doc.id,
  //     groupName: data['groupName'] ?? '',
  //     members: List<String>.from(data['members'] ?? <String>[]),
  //     createdBy: data['createdBy'] ?? '',
  //     createdAt: data['createdAt'] is Timestamp
  //         ? data['createdAt']
  //         : Timestamp.now(),
  //   );
  // }
}


