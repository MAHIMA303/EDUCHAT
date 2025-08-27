import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallSession {
  CallSession({required this.callId, required this.isCaller});
  final String callId;
  final bool isCaller;
}

class CallService {
  CallService({FirebaseFirestore? firestore});

  Future<bool> isAvailable() async => false;

  Future<CallSession?> startCall({required String calleeUserId}) async {
    if (kDebugMode) {
      // Web implementation of flutter_webrtc disabled; return null to indicate unavailable
    }
    return null;
  }

  Future<CallSession?> answerCall({required String callId}) async {
    if (kDebugMode) {}
    return null;
  }

  Future<void> endCall(String callId) async {}

  // Placeholders to satisfy UI references; always null on web
  dynamic get localStream => null;
  dynamic get pc => null;
}


