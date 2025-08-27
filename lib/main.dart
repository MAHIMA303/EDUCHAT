import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // Temporarily disabled
// import 'package:firebase_messaging/firebase_messaging.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Temporarily disabled
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/assignments_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/chat_detail_screen.dart';
import 'screens/search_screen.dart';
import 'screens/add_assignment_screen.dart';
import 'screens/assignment_detail_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/resource_library_screen.dart';
import 'screens/multi_language_settings_screen.dart';
import 'screens/group_management_screen.dart';
import 'screens/ai_tutor_screen.dart';
import 'screens/create_group_screen.dart';
import 'screens/group_chat_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'services/notification_service.dart';
import 'screens/call_screen.dart';
import 'screens/incoming_call_screen.dart';
import 'screens/encryption_demo_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/whiteboard_screen.dart';
import 'screens/external_services_screen.dart';
import 'models/group.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if (kIsWeb) return;
//   try {
//     await Firebase.initializeApp();
//   } catch (e) {
//     // Firebase not configured
//     print('Firebase not configured in background handler: $e');
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Temporarily disable Firebase to avoid configuration errors
  // if (!kIsWeb) {
  //   try {
  //     await Firebase.initializeApp();
  //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //     await NotificationService.initializeNotifications();
  //   } catch (e) {
  //     // Firebase not configured - app will work without Firebase features
  //     print('Firebase not configured: $e');
  //   }
  // }
  runApp(const EduChatBotApp());
}

class EduChatBotApp extends StatelessWidget {
  const EduChatBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduChatBot',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/group-chat': (context) => GroupChatScreen(
          group: Group(
            groupId: 'demo_group',
            groupName: 'Demo Group',
            members: ['user1', 'user2'],
            createdBy: 'user1',
            createdAt: DateTime.now(), // Temporarily use DateTime instead of Timestamp
          ),
        ),
        '/assignments': (context) => const AssignmentsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/chat-detail': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final chatTitle = args?['chatTitle'] ?? 'Chat';
          final chatId = args?['chatId'] ?? 'demo_chat';
          
          return ChatDetailScreen(
            chatTitle: chatTitle,
            chatId: chatId,
          );
        },
        // '/ai-tutor': (context) => const AITutorScreen(), // Removed - using direct AI Tutor chat instead
        '/search': (context) => const SearchScreen(),
        '/create-group': (context) => const CreateGroupScreen(),
        '/add-assignment': (context) => const AddAssignmentScreen(),
        '/assignment-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return AssignmentDetailScreen(assignment: args ?? {});
        },
        '/notifications': (context) => const NotificationsScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/resource-library': (context) => const ResourceLibraryScreen(),
        '/language-settings': (context) => const MultiLanguageSettingsScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
        '/encryption-demo': (context) => const EncryptionDemoScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/whiteboard': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return WhiteboardScreen(
            whiteboardId: args?['whiteboardId'] ?? 'demo_whiteboard',
            title: args?['title'] ?? 'Collaborative Whiteboard',
          );
        },
        '/external-services': (context) => const ExternalServicesScreen(),
        '/call': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return CallScreen(callId: args['callId'] as String, isCaller: args['isCaller'] as bool? ?? false);
        },
        '/incoming-call': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return IncomingCallScreen(callId: args['callId'] as String, callerName: args['callerName'] as String? ?? 'Caller');
        },
      },
    );
  }
}
