import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class OfflineService {
  OfflineService._();
  static final OfflineService instance = OfflineService._();

  final ValueNotifier<bool> isOffline = ValueNotifier<bool>(false);
  late final StreamSubscription<List<ConnectivityResult>> _connSub;

  // Hive boxes
  static const String assignmentsBox = 'assignments_cache';
  static const String resourcesBox = 'resources_cache';
  static const String messageQueueBox = 'message_queue';

  Future<void> init() async {
    // Temporarily disabled Firebase functionality
    // // Enable Firestore offline persistence (skip on web since it's always enabled)
    // if (!kIsWeb) {
    //   FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
    // }

    await Hive.initFlutter();
    await Hive.openBox<Map>(assignmentsBox);
    await Hive.openBox<Map>(resourcesBox);
    await Hive.openBox<Map>(messageQueueBox);

    // Connectivity monitoring
    final connectivity = Connectivity();
    // Seed initial state
    final current = await connectivity.checkConnectivity();
    _updateOffline(current);
    _connSub = connectivity.onConnectivityChanged.listen((results) {
      _updateOffline(results);
      if (isOffline.value == false) {
        _flushMessageQueue();
      }
    });
  }

  void dispose() {
    _connSub.cancel();
  }

  void _updateOffline(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    isOffline.value = !online;
  }

  // Cache helpers
  Future<void> cacheAssignment(String id, Map<String, dynamic> data) async {
    final box = Hive.box<Map>(assignmentsBox);
    await box.put(id, data);
  }

  Map<String, dynamic>? getCachedAssignment(String id) {
    final box = Hive.box<Map>(assignmentsBox);
    final data = box.get(id);
    return data?.cast<String, dynamic>();
  }

  Future<void> cacheResource(String id, Map<String, dynamic> data) async {
    final box = Hive.box<Map>(resourcesBox);
    await box.put(id, data);
  }

  Map<String, dynamic>? getCachedResource(String id) {
    final box = Hive.box<Map>(resourcesBox);
    final data = box.get(id);
    return data?.cast<String, dynamic>();
  }

  // Message queue for offline sends
  Future<void> enqueueMessage(Map<String, dynamic> payload) async {
    final box = Hive.box<Map>(messageQueueBox);
    final key = DateTime.now().microsecondsSinceEpoch.toString();
    await box.put(key, payload);
  }

  Future<void> _flushMessageQueue() async {
    // Temporarily disabled Firebase functionality
    // final box = Hive.box<Map>(messageQueueBox);
    // final keys = box.keys.toList();
    // for (final key in keys) {
    //   final payload = box.get(key)!.cast<String, dynamic>();
    //   try {
    //     final col = FirebaseFirestore.instance
    //         .collection(payload['collection'] as String);
    //     final docPath = payload['doc'] as String?;
    //     if (docPath != null && docPath.isNotEmpty) {
    //       await col.doc(docPath).set(payload['data'] as Map<String, dynamic>, SetOptions(merge: true));
    //     } else {
    //       await col.add(payload['data'] as Map<String, dynamic>);
    //   }
    //   await box.delete(key);
    // } catch (_) {
    //   // Remain queued on failure
    // }
    // }
  }
}


