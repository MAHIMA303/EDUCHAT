import 'dart:convert';
import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DrawingPoint {
  final double x;
  final double y;
  final double pressure;
  final Color color;
  final double strokeWidth;

  DrawingPoint({
    required this.x,
    required this.y,
    required this.pressure,
    required this.color,
    required this.strokeWidth,
  });

  Map<String, dynamic> toMap() {
    return {
      'x': x,
      'y': y,
      'pressure': pressure,
      'color': color.value,
      'strokeWidth': strokeWidth,
    };
  }

  factory DrawingPoint.fromMap(Map<String, dynamic> map) {
    return DrawingPoint(
      x: map['x']?.toDouble() ?? 0.0,
      y: map['y']?.toDouble() ?? 0.0,
      pressure: map['pressure']?.toDouble() ?? 1.0,
      color: Color(map['color'] ?? 0xFF000000),
      strokeWidth: map['strokeWidth']?.toDouble() ?? 2.0,
    );
  }
}

class DrawingStroke {
  final String id;
  final String userId;
  final String userName;
  final List<DrawingPoint> points;
  final DateTime timestamp;
  final Color color;

  DrawingStroke({
    required this.id,
    required this.userId,
    required this.userName,
    required this.points,
    required this.timestamp,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'points': points.map((p) => p.toMap()).toList(),
      'timestamp': timestamp.toIso8601String(),
      'color': color.value,
    };
  }

  factory DrawingStroke.fromMap(Map<String, dynamic> map) {
    return DrawingStroke(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      points: List<DrawingPoint>.from(
        (map['points'] ?? []).map((p) => DrawingPoint.fromMap(p)),
      ),
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      color: Color(map['color'] ?? 0xFF000000),
    );
  }
}

class WhiteboardService {
  // Temporarily disabled Firebase functionality
  // WhiteboardService({FirebaseFirestore? firestore})
  //     : _db = kIsWeb ? null : (firestore ?? FirebaseFirestore.instance);

  // final FirebaseFirestore? _db;

  // Get real-time stream of drawing strokes for a whiteboard
  Stream<List<DrawingStroke>> getWhiteboardStream(String whiteboardId) {
    // Temporarily disabled Firebase functionality
    // if (_db == null) return const Stream<List<DrawingStroke>>.empty();

    // return _db!
    //     .collection('whiteboards')
    //     .doc(whiteboardId)
    //     .collection('strokes')
    //     .orderBy('timestamp', descending: false)
    //     .snapshots()
    //     .map((snapshot) => snapshot.docs
    //         .map((doc) => DrawingStroke.fromMap(doc.data()))
    //         .toList());
    return Stream.value([]); // Return empty list for now
  }

  // Add a new drawing stroke
  Future<void> addStroke(String whiteboardId, DrawingStroke stroke) async {
    // Temporarily disabled Firebase functionality
    // if (_db == null) return;

    // await _db!
    //     .collection('whiteboards')
    //     .doc(whiteboardId)
    //     .collection('strokes')
    //     .doc(stroke.id)
    //     .set(stroke.toMap());
  }

  // Clear the whiteboard
  Future<void> clearWhiteboard(String whiteboardId) async {
    // Temporarily disabled Firebase functionality
    // if (_db == null) return;

    // final strokesSnapshot = await _db!
    //     .collection('whiteboards')
    //     .doc(whiteboardId)
    //     .collection('strokes')
    //     .get();

    // final batch = _db!.batch();
    // for (final doc in strokesSnapshot.docs) {
    //   batch.delete(doc.reference);
    // }
    // await batch.commit();
  }

  // Create a new whiteboard
  Future<String> createWhiteboard({
    required String title,
    required String createdBy,
    required List<String> participants,
  }) async {
    // Temporarily disabled Firebase functionality
    // if (_db == null) return '';

    // final whiteboardId = const Uuid().v4();
    // await _db!.collection('whiteboards').doc(whiteboardId).set({
    //   'title': title,
    //   'createdBy': createdBy,
    //   'participants': participants,
    //   'createdAt': FieldValue.serverTimestamp(),
    //   'updatedAt': FieldValue.serverTimestamp(),
    // });

    // return whiteboardId;
    return 'temp_whiteboard_id'; // Return temporary ID for now
  }

  // Get whiteboard metadata
  Stream<Map<String, dynamic>?> getWhiteboardMetadata(String whiteboardId) {
    // Temporarily disabled Firebase functionality
    // if (_db == null) return const Stream<Map<String, dynamic>?>.empty();

    // return _db!
    //     .collection('whiteboards')
    //     .doc(whiteboardId)
    //     .snapshots()
    //     .map((doc) => doc.data());
    return Stream.value(null); // Return null for now
  }
}
