import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/chat_message.dart';
import 'group_management_screen.dart'; // Added import for GroupManagementScreen

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _chatThreads = [
    {
      'id': '1',
      'title': 'Math Class - Group Chat',
      'lastMessage': 'Anyone understand question 5?',
      'timestamp': '2 min ago',
      'unreadCount': 3,
      'avatar': 'MC',
      'isGroup': true,
      'onlineCount': 12,
    },
    {
      'id': '2',
      'title': 'Physics Study Group',
      'lastMessage': 'What is Newton\'s third law?',
      'timestamp': '1 hour ago',
      'unreadCount': 0,
      'avatar': 'PS',
      'isGroup': true,
      'onlineCount': 8,
    },
    {
      'id': '3',
      'title': 'AI Tutor',
      'lastMessage': 'I can help you with that!',
      'timestamp': '3 hours ago',
      'unreadCount': 1,
      'avatar': 'AI',
      'isGroup': false,
      'onlineCount': 1,
    },
    {
      'id': '4',
      'title': 'Chemistry Lab',
      'lastMessage': 'Lab report due tomorrow',
      'timestamp': '5 hours ago',
      'unreadCount': 0,
      'avatar': 'CL',
      'isGroup': true,
      'onlineCount': 15,
    },
    {
      'id': '5',
      'title': 'English Literature',
      'lastMessage': 'Shakespeare essay discussion',
      'timestamp': '1 day ago',
      'unreadCount': 0,
      'avatar': 'EL',
      'isGroup': true,
      'onlineCount': 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Chats',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF4B6CB7),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF4B6CB7)),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF4B6CB7)),
            onPressed: () {
              _showChatOptions();
            },
          ),
        ],
      ),
      body: Column(
          children: [
          // Header section
            Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4B6CB7).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                    Icons.chat_bubble_outline,
                color: Colors.white,
                    size: 30,
              ),
            ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                        'Stay Connected',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                Text(
                        '${_chatThreads.length} active conversations',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
          ),

          // Chat threads
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _chatThreads.length,
              itemBuilder: (context, index) {
                final chat = _chatThreads[index];
                return _buildChatThread(chat);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showNewChatDialog();
        },
        backgroundColor: const Color(0xFF4B6CB7),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildChatThread(Map<String, dynamic> chat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Stack(
        children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  chat['avatar'],
                  style: GoogleFonts.poppins(
                color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (chat['unreadCount'] > 0)
              Positioned(
                right: 0,
                top: 0,
            child: Container(
                  padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    chat['unreadCount'].toString(),
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                  ),
                ],
              ),
        title: Row(
                children: [
            Expanded(
              child: Text(
                chat['title'],
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            if (chat['isGroup'] && chat['onlineCount'] > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${chat['onlineCount']} online',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                    ),
                  ),
                ],
              ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              chat['lastMessage'],
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              chat['timestamp'],
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/chat-detail',
            arguments: {'chatTitle': chat['title']},
          );
        },
      ),
    );
  }

  void _showNewChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Start New Chat',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
        children: [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
            decoration: BoxDecoration(
                  color: const Color(0xFF4B6CB7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
                  Icons.smart_toy,
                  color: Color(0xFF4B6CB7),
                ),
              ),
              title: Text(
                'Chat with AI Tutor',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Get instant help with your questions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/chat-detail',
                  arguments: {'chatTitle': 'AI Tutor'},
                );
              },
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
            decoration: BoxDecoration(
                  color: const Color(0xFF4B6CB7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.group,
                  color: Color(0xFF4B6CB7),
                ),
              ),
              title: Text(
                'Create Study Group',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Start a group chat with classmates'),
              onTap: () {
                Navigator.pop(context);
                _showCreateStudyGroupDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateStudyGroupDialog() {
    final TextEditingController groupNameController = TextEditingController();
    final TextEditingController subjectController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Create Study Group',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
        children: [
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                hintText: 'e.g., Math Study Group',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g., Mathematics',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (groupNameController.text.isNotEmpty) {
                Navigator.pop(context);
                
                // Navigate to group management screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupManagementScreen(
                      groupData: {
                        'name': groupNameController.text,
                        'subject': subjectController.text.isNotEmpty 
                            ? subjectController.text 
                            : 'Study Group',
                      },
                    ),
                  ),
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Study group "${groupNameController.text}" created successfully!'),
                    backgroundColor: const Color(0xFF4B6CB7),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B6CB7),
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.search, color: Color(0xFF4B6CB7)),
              title: Text(
                'Search Chats',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search');
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Color(0xFF4B6CB7)),
              title: Text(
                'Notification Settings',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive, color: Color(0xFF4B6CB7)),
              title: Text(
                'Archived Chats',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Archived chats feature coming soon!'),
                    backgroundColor: Color(0xFF4B6CB7),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
