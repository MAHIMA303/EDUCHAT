// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
// import 'package:firebase_messaging/firebase_messaging.dart'; // Temporarily disabled
import '../models/group.dart';

class GroupService {
  // Temporarily disabled Firebase functionality
  // GroupService({FirebaseFirestore? firestore})
  //     : _db = firestore ?? FirebaseFirestore.instance;

  // final FirebaseFirestore _db;

  // CollectionReference<Map<String, dynamic>> get _groups => _db.collection('groups');

  Future<Group> createGroup({
    required String groupName,
    required String createdBy,
    required List<String> memberUserIds,
  }) async {
    // Temporarily disabled Firebase functionality
    // final doc = _groups.doc();
    final group = Group(
      groupId: 'temp_${DateTime.now().millisecondsSinceEpoch}', // Temporary ID
      groupName: groupName,
      members: {...memberUserIds, createdBy}.toList(),
      createdBy: createdBy,
      createdAt: DateTime.now(), // Temporarily use DateTime instead of Timestamp
    );
    // await doc.set(group.toMap());

    // Subscribe creator to FCM topic for this group
    // await FirebaseMessaging.instance.subscribeToTopic('group_${group.groupId}');
    return group;
  }

  Future<void> joinGroup({required String groupId, required String userId}) async {
    // Temporarily disabled Firebase functionality
    // final ref = _groups.doc(groupId);
    // await _db.runTransaction((tx) async {
    //   final snap = await tx.get(ref);
    //   if (!snap.exists) return;
    //   final data = snap.data() as Map<String, dynamic>;
    //   final members = List<String>.from(data['members'] ?? <String>[]);
    //   if (!members.contains(userId)) {
    //     members.add(userId);
    //     tx.update(ref, {'members': members});
    //   }
    // });
    // await FirebaseMessaging.instance.subscribeToTopic('group_$groupId');
  }

  Future<void> removeMember({required String groupId, required String userId}) async {
    // Temporarily disabled Firebase functionality
    // final ref = _groups.doc(groupId);
    // await ref.update({'members': FieldValue.arrayRemove([userId])});
    // await FirebaseMessaging.instance.unsubscribeFromTopic('group_$groupId');
  }

  Stream<List<Group>> streamUserGroups(String userId) {
    // Temporarily disabled Firebase functionality
    // return _groups.where('members', arrayContains: userId).orderBy('createdAt', descending: true).snapshots().map(
    //   (qs) => qs.docs.map((d) => Group.fromDoc(d)).toList(),
    // );
    return Stream.value([]); // Return empty list for now
  }

  Future<Group?> getGroup(String groupId) async {
    // Temporarily disabled Firebase functionality
    // final doc = await _groups.doc(groupId).get();
    // if (!doc.exists) return null;
    // return Group.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
    return null; // Return null for now
  }
}


