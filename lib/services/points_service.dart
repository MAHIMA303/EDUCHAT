// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';

class UserPoints {
  final String userId;
  final String username;
  final int points;

  UserPoints({required this.userId, required this.username, required this.points});

  // Temporarily disabled Firebase functionality
  // factory UserPoints.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  //   final data = doc.data() ?? <String, dynamic>{};
  //   return UserPoints(
  //     userId: data['userId'] as String? ?? doc.id,
  //     username: data['username'] as String? ?? 'User',
  //     points: (data['points'] as num?)?.toInt() ?? 0,
  //   );
  // }
}

class PointsService {
  // Temporarily disabled Firebase functionality
  // PointsService({FirebaseFirestore? firestore})
  //     : _db = kIsWeb ? null : (firestore ?? FirebaseFirestore.instance);

  // final FirebaseFirestore? _db; // null on web (no Firebase configured)

  // CollectionReference<Map<String, dynamic>> get _col => _db!.collection('leaderboard');

  Future<void> addPoints({required String userId, required String username, required int delta}) async {
    // Temporarily disabled Firebase functionality
    // // On web in this project, Firebase may not be initialized. Guard softly.
    // if (kIsWeb) {
    //   return; // no-op for web demo unless Firebase is configured
    // }
    // final doc = _col.doc(userId);
    // await _db!.runTransaction((tx) async {
    //   final snap = await tx.get(doc);
    //   if (!snap.exists) {
    //     tx.set(doc, {'userId': userId, 'username': username, 'points': delta});
    //   } else {
    //     tx.update(doc, {
    //       'username': username,
    //       'points': FieldValue.increment(delta),
    //     });
    //   }
    // });
  }

  Stream<List<UserPoints>> leaderboardStream({int limit = 50}) {
    // Temporarily disabled Firebase functionality
    // if (_db == null) {
    //   return const Stream<List<UserPoints>>.empty();
    // }
    // return _col
    //     .orderBy('points', descending: true)
    //     .limit(limit)
    //     .snapshots()
    //     .map((qs) => qs.docs.map((d) => UserPoints.fromDoc(d)).toList());
    return Stream.value([]); // Return empty list for now
  }
}


