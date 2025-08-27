// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';

enum UserRole { teacher, student, unknown }

class RoleService {
  // Temporarily disabled Firebase functionality
  // RoleService({FirebaseFirestore? firestore})
  //     : _db = kIsWeb ? null : (firestore ?? FirebaseFirestore.instance);

  // final FirebaseFirestore? _db; // null on web for this demo if Firebase not configured

  Future<UserRole> getCurrentUserRole(String userId) async {
    // Temporarily disabled Firebase functionality
    // if (_db == null) return UserRole.unknown;
    // try {
    //   final snap = await _db!.collection('users').doc(userId).get();
    //   final data = snap.data();
    //   final role = (data?['role'] as String?)?.toLowerCase();
    //   if (role == 'teacher') return UserRole.teacher;
    //   if (role == 'student') return UserRole.student;
    //   return UserRole.unknown;
    // } catch (_) {
    //   return UserRole.unknown;
    // }
    return UserRole.student; // Return default role for now
  }
}


