import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart'; // Temporarily disabled
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // Temporarily disabled
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class NotificationService {
  // static final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    if (kIsWeb) {
      // Web: skip local notifications and FCM permissions to avoid runtime errors
      return;
    }
    // Temporarily disabled local notifications
    // const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    // const initSettings = InitializationSettings(android: androidInit);
    // await _fln.initialize(
    //   initSettings,
    //   onDidReceiveNotificationResponse: (NotificationResponse response) {
    //     if (response.payload == null) return;
    //     try {
    //       final data = jsonDecode(response.payload!);
    //       _handleDeepLinkFromData(Map<String, dynamic>.from(data));
    //     } catch (_) {}
    //   },
    // );

    // Temporarily disabled Firebase messaging
    // await FirebaseMessaging.instance.requestPermission();

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   final notification = message.notification;
    //   if (notification != null) {
    //     await _fln.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       const NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           'group_messages',
    //           'Group Messages',
    //           importance: Importance.max,
    //           priority: Priority.high,
    //         ),
    //       ),
    //       payload: jsonEncode(message.data),
    //     );
    //   }
    // });
  }

  static Future<void> handleBackgroundOrTerminatedTap() async {
    // Temporarily disabled Firebase messaging
    // // App opened from terminated state
    // final initial = await FirebaseMessaging.instance.getInitialMessage();
    // if (initial != null) {
    //   _handleDeepLinkFromData(initial.data);
    // }
    // // App in background and brought to foreground
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   _handleDeepLinkFromData(message.data);
    // });
  }

  static void _handleDeepLinkFromData(Map<String, dynamic> data) {
    final nav = NavigationService.navigatorKey.currentState;
    if (nav == null) return;
    final type = data['type'] as String?;
    if (type == null) return;
    switch (type) {
      case 'chat':
        final chatTitle = data['chatTitle'] as String? ?? 'Chat';
        nav.pushNamed('/chat-detail', arguments: {'chatTitle': chatTitle});
        break;
      case 'group_chat':
        final groupId = data['groupId'] as String?;
        if (groupId != null) {
          nav.pushNamed('/group-chat', arguments: {'groupId': groupId});
        }
        break;
      case 'assignment':
        // Expect either a full assignment map or an id to fetch
        final assignmentId = data['assignmentId'] as String?;
        final assignmentTitle = data['title'] as String?;
        nav.pushNamed('/assignment-detail', arguments: {
          'id': assignmentId ?? '',
          'title': assignmentTitle ?? 'Assignment',
          'subject': data['subject'] ?? 'Subject',
          'description': data['description'] ?? '',
          // Additional fields can be fetched in the detail screen using id
        });
        break;
      case 'leaderboard':
        nav.pushNamed('/leaderboard');
        break;
      default:
        break;
    }
  }
}


