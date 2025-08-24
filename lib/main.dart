import 'package:flutter/material.dart';
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

void main() {
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
        '/assignments': (context) => const AssignmentsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/chat-detail': (context) => const ChatDetailScreen(chatTitle: 'Chat'),
        '/search': (context) => const SearchScreen(),
        '/add-assignment': (context) => const AddAssignmentScreen(),
        '/assignment-detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return AssignmentDetailScreen(assignment: args ?? {});
        },
        '/notifications': (context) => const NotificationsScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/resource-library': (context) => const ResourceLibraryScreen(),
        '/language-settings': (context) => const MultiLanguageSettingsScreen(),
      },
    );
  }
}
