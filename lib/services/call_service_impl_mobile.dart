import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart'; // Temporarily disabled
// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'package:uuid/uuid.dart';

class CallSession {
  CallSession({required this.callId, required this.isCaller});
  final String callId;
  final bool isCaller;
}

class CallService {
  // Temporarily disabled Firebase functionality
  // CallService({FirebaseFirestore? firestore}) : _db = firestore ?? FirebaseFirestore.instance;

  // final FirebaseFirestore _db;
  // RTCPeerConnection? _pc; // Temporarily disabled
  // MediaStream? _localStream; // Temporarily disabled
  final _uuid = const Uuid();
  bool _remoteDescriptionSet = false;

  Future<bool> isAvailable() async => true;

  Future<dynamic> _getUserMedia({bool video = true}) async {
    // Temporarily disabled - return null
    return null;
  }

  Future<dynamic> _createPeer() async {
    // Temporarily disabled - return null
    return null;
  }

  Future<CallSession?> startCall({required String calleeUserId}) async {
    // Temporarily disabled - return null
    return null;
  }

  Future<CallSession?> answerCall({required String callId}) async {
    // Temporarily disabled - return null
    return null;
  }

  Future<void> endCall(String callId) async {
    // Temporarily disabled
  }

  // MediaStream? get localStream => _localStream; // Temporarily disabled
  // RTCPeerConnection? get pc => _pc; // Temporarily disabled
}


