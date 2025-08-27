import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../services/ai_service.dart';
import 'dart:convert';

class AITutorChatScreen extends StatefulWidget {
  final Map<String, dynamic> tutor;
  
  const AITutorChatScreen({
    super.key,
    required this.tutor,
  });

  @override
  State<AITutorChatScreen> createState() => _AITutorChatScreenState();
}

class _AITutorChatScreenState extends State<AITutorChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AITutorMessage> _messages = [];
  bool _isLoading = false;
  bool _isBackendConnected = false;

  @override
  void initState() {
    super.initState();
    _checkBackendConnection();
    _addWelcomeMessage();
  }

  Future<void> _checkBackendConnection() async {
    try {
      final isConnected = await AIService.checkBackendHealth();
      setState(() {
        _isBackendConnected = isConnected;
      });
      
      if (!isConnected) {
        _showBackendError();
      }
    } catch (e) {
      setState(() {
        _isBackendConnected = false;
      });
      _showBackendError();
    }
  }

  void _addWelcomeMessage() {
    final welcomeMessage = AITutorMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: "Hello! I'm ${widget.tutor['name']}, your ${widget.tutor['specialization']} tutor. How can I help you today?",
      isUser: false,
      timestamp: DateTime.now(),
      subject: widget.tutor['specialization'],
      tutorId: widget.tutor['id'],
    );
    
    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  void _showBackendError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Backend connection failed. Please check if the Haystack server is running.',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _checkBackendConnection,
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isLoading) return;

    // Add user message
    final userMessage = AITutorMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: message,
      isUser: true,
      timestamp: DateTime.now(),
      subject: widget.tutor['specialization'],
      tutorId: widget.tutor['id'],
    );

    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      // Send message to AI tutor via Haystack
      final response = await AIService.chatWithTutor(
        question: message,
        subject: widget.tutor['specialization'],
        tutorId: widget.tutor['id'],
      );

      if (response['success'] == true) {
        // Add AI response
        final aiMessage = AITutorMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _extractAnswerFromResponse(response),
          isUser: false,
          timestamp: DateTime.now(),
          subject: widget.tutor['specialization'],
          tutorId: widget.tutor['id'],
          relatedDocuments: _extractDocumentsFromResponse(response),
        );

        setState(() {
          _messages.add(aiMessage);
        });
      } else {
        _showErrorMessage('Failed to get response from AI tutor');
      }
    } catch (e) {
      _showErrorMessage('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  String _extractAnswerFromResponse(Map<String, dynamic> response) {
    // Extract the answer from Haystack response
    final answers = response['answer'] as List?;
    if (answers != null && answers.isNotEmpty) {
      return answers.first.toString();
    }
    
    // Fallback response
    return "I'm processing your question. Let me provide you with a comprehensive answer based on my knowledge.";
  }

  List<String>? _extractDocumentsFromResponse(Map<String, dynamic> response) {
    final documents = response['documents'] as List?;
    if (documents != null && documents.isNotEmpty) {
      return documents.map((doc) => doc.toString()).toList();
    }
    return null;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B6CB7)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.tutor['color'], widget.tutor['color'].withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  widget.tutor['avatar'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tutor['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4B6CB7),
                    ),
                  ),
                  Text(
                    widget.tutor['specialization'],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isBackendConnected ? Icons.wifi : Icons.wifi_off,
              color: _isBackendConnected ? Colors.green : Colors.red,
            ),
            onPressed: _checkBackendConnection,
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection Status Bar
          if (!_isBackendConnected)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.red[100],
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Backend disconnected. Some features may not work.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.red[700],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _checkBackendConnection,
                    child: Text(
                      'Retry',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.red[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Loading indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.tutor['color'], widget.tutor['color'].withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${widget.tutor['name']} is thinking...',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Input area
          Container(
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask ${widget.tutor['name']} anything...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[500],
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
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [widget.tutor['color'], widget.tutor['color'].withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: Icon(
                      _isLoading ? Icons.hourglass_empty : Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AITutorMessage message) {
    final isUser = message.isUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.tutor['color'], widget.tutor['color'].withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  widget.tutor['avatar'][0],
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
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF4B6CB7) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: isUser ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: isUser ? Colors.white70 : Colors.grey[500],
                    ),
                  ),
                  
                  // Show related documents if available
                  if (!isUser && message.relatedDocuments != null && message.relatedDocuments!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📚 Related Sources:',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...message.relatedDocuments!.take(3).map((doc) => 
                            Text(
                              '• ${doc.length > 50 ? '${doc.substring(0, 50)}...' : doc}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.blue[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
