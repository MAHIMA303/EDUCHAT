import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../models/chat_message.dart';
import '../screens/group_management_screen.dart'; // Added import for GroupManagementScreen

class ChatDetailScreen extends StatefulWidget {
  final String chatTitle;
  
  const ChatDetailScreen({super.key, required this.chatTitle});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final List<String> _quickReplies = [
    "Can you explain this?",
    "I need help with this topic",
    "What does this mean?",
    "Can you give me an example?",
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
  }

  void _loadInitialMessages() {
    _messages.addAll([
      ChatMessage(
        text: "Hello! I'm here to help you with your studies. What would you like to learn about?",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        senderName: widget.chatTitle == 'AI Tutor' ? 'AI Assistant' : 'Teacher',
      ),
      ChatMessage(
        text: "Hi! I have a question about quadratic equations.",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        senderName: 'You',
      ),
      ChatMessage(
        text: "Great! I'd be happy to help you with quadratic equations. What specific aspect would you like to understand?",
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        senderName: widget.chatTitle == 'AI Tutor' ? 'AI Assistant' : 'Teacher',
      ),
      ChatMessage(
        text: "I'm confused about the quadratic formula. Can you explain it step by step?",
        isUser: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        senderName: 'You',
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = ChatMessage(
      text: _messageController.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      senderName: 'You',
    );

    setState(() {
      _messages.add(message);
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              text: "The quadratic formula is: x = (-b ± √(b² - 4ac)) / 2a. Let me break this down step by step...",
          isUser: false,
          timestamp: DateTime.now(),
              senderName: widget.chatTitle == 'AI Tutor' ? 'AI Assistant' : 'Teacher',
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _sendQuickReply(String reply) {
    final message = ChatMessage(
      text: reply,
      isUser: true,
      timestamp: DateTime.now(),
      senderName: 'You',
        );

        setState(() {
      _messages.add(message);
      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              text: "I'd be happy to help you with that! Let me explain...",
              isUser: false,
              timestamp: DateTime.now(),
              senderName: widget.chatTitle == 'AI Tutor' ? 'AI Assistant' : 'Teacher',
            ),
          );
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.image, color: Color(0xFF4B6CB7)),
              title: Text(
                'Photo or Video',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _attachMedia('photo');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF4B6CB7)),
              title: Text(
                'Document',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _attachMedia('document');
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF4B6CB7)),
              title: Text(
                'Camera',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                Navigator.pop(context);
                _attachMedia('camera');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _attachMedia(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$type attachment feature coming soon!'),
        backgroundColor: const Color(0xFF4B6CB7),
      ),
    );
  }

  void _startVoiceInput() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Voice Message',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF4B6CB7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.mic,
                color: Color(0xFF4B6CB7),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Hold to record your message',
              style: GoogleFonts.inter(fontSize: 16),
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
              Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
                  content: Text('Voice message feature coming soon!'),
                  backgroundColor: Color(0xFF4B6CB7),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4B6CB7),
              foregroundColor: Colors.white,
            ),
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
                'Search Messages',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search feature coming soon!'),
                    backgroundColor: Color(0xFF4B6CB7),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Color(0xFF4B6CB7)),
              title: Text(
                'Mute Notifications',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications muted'),
                    backgroundColor: Color(0xFF4B6CB7),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Color(0xFF4B6CB7)),
              title: Text(
                'Block User',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User blocked'),
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

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final chatTitle = args?['chatTitle'] ?? 'Chat';
    final isGroupChat = chatTitle != 'AI Tutor';
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B6CB7)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatTitle,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4B6CB7),
              ),
            ),
            if (isGroupChat)
            Text(
                '${_messages.length} members • 3 online',
              style: GoogleFonts.inter(
                fontSize: 12,
                  color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          if (isGroupChat)
          IconButton(
              icon: const Icon(Icons.group, color: Color(0xFF4B6CB7)),
            onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupManagementScreen(
                      groupData: {
                        'name': chatTitle,
                        'subject': 'Study Group',
                      },
                    ),
                  ),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF4B6CB7)),
            onPressed: _showChatOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          
          // Quick Reply Suggestions
          if (_messages.isNotEmpty && _messages.last.isUser)
            _buildQuickReplies(),

          // Input bar
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  message.senderName.substring(0, 1).toUpperCase(),
                  style: GoogleFonts.poppins(
                color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF4B6CB7) : Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: isUser ? null : Border.all(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    Text(
                      message.senderName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4B6CB7),
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.text,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isUser ? Colors.white : Colors.black,
                      height: 1.4,
                      fontWeight: isUser ? FontWeight.w400 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isUser 
                          ? Colors.white.withOpacity(0.7) 
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF4B6CB7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _quickReplies.map((reply) {
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: ActionChip(
                label: Text(
                  reply,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF4B6CB7),
                  ),
                ),
                backgroundColor: const Color(0xFF4B6CB7).withOpacity(0.1),
                onPressed: () => _sendQuickReply(reply),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Attachment button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                Icons.attach_file,
                color: Colors.grey[600],
                size: 20,
              ),
              onPressed: () {
                _showAttachmentOptions();
              },
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Text input field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  hintStyle: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Voice input button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4B6CB7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: Icon(
                Icons.mic,
                color: const Color(0xFF4B6CB7),
                size: 20,
              ),
              onPressed: () {
                _startVoiceInput();
              },
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Send button
          Container(
            width: 40,
            height: 40,
      decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4B6CB7), Color(0xFF182848)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
