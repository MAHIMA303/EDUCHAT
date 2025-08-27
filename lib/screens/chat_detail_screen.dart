import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/points_service.dart';
// import '../services/call_service.dart'; // Temporarily disabled due to flutter_webrtc issues
import '../services/encryption_service.dart';
import '../constants/app_colors.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatTitle;
  final String? chatId;

  const ChatDetailScreen({
    super.key,
    required this.chatTitle,
    this.chatId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final AiService _aiService = AiService();
  final EncryptionService _encryptionService = EncryptionService();
  PointsService? _pointsService;
  // CallService? _callService; // Temporarily disabled due to flutter_webrtc issues
  bool _isLoadingAiResponse = false;
  final String _currentUserId = 'u_current'; // Replace with actual user ID
  bool _showAttachmentOptions = false;
  bool _showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();
  PlatformFile? _selectedFile; // Variable to store selected file

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _pointsService = PointsService();
      // _callService = CallService(); // Temporarily disabled due to flutter_webrtc issues
  }
    Permission.storage.request();

    // Add initial AI message if this is AI Tutor
    if (widget.chatTitle == 'AI Tutor') {
      _messages.add(
      ChatMessage(
          id: const Uuid().v4(),
          text: 'Hello! I\'m your AI tutor. How can I help you today?',
        isUser: false,
          timestamp: DateTime.now(),
          senderName: 'AI Tutor',
        ),
      );
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty && _selectedFile == null) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    // Create user message
    ChatMessage userChatMessage;
    
    if (_selectedFile != null) {
      // Send file message
      userChatMessage = ChatMessage(
        id: const Uuid().v4(),
        text: _selectedFile!.name,
        isUser: true,
        timestamp: DateTime.now(),
        senderName: 'You',
        messageType: MessageType.file,
        filePath: _selectedFile!.path,
        fileSize: _selectedFile!.size,
      );
      
      // Clear selected file after sending
      setState(() {
        _selectedFile = null;
      });
    } else {
      // Send text message
      userChatMessage = ChatMessage(
        id: const Uuid().v4(),
        text: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
        senderName: 'You',
      );
    }

    setState(() {
      _messages.add(userChatMessage);
    });

    _scrollToBottom();

    // Add points for chat participation
    _pointsService?.addPoints(
      userId: _currentUserId,
      username: 'John Doe',
      delta: 2,
    );

    // Handle AI response if this is AI Tutor
    if (widget.chatTitle == 'AI Tutor') {
        setState(() {
        _isLoadingAiResponse = true;
      });

      try {
        final aiResponse = await _aiService.getAiResponse(_messages, userMessage);
        
        final aiMessage = ChatMessage(
          id: const Uuid().v4(),
          text: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
          senderName: 'AI Tutor',
        );

        setState(() {
          _messages.add(aiMessage);
          _isLoadingAiResponse = false;
        });
      } catch (e) {
        final errorMessage = ChatMessage(
          id: const Uuid().v4(),
          text: 'Sorry, I encountered an error. Please try again.',
          isUser: false,
      timestamp: DateTime.now(),
          senderName: 'AI Tutor',
          isError: true,
        );

        setState(() {
          _messages.add(errorMessage);
          _isLoadingAiResponse = false;
        });
      }
    } else {
      // For regular chats, encrypt the message before storing
      try {
        final chatId = widget.chatId ?? 'default_chat';
        final encryptedText = await _encryptionService.encryptMessage(userMessage, chatId);
        
        // Update the message with encrypted text
        final encryptedMessage = userChatMessage.copyWithEncryptedText(encryptedText);
        
        setState(() {
          _messages[_messages.length - 1] = encryptedMessage;
        });
        
        // In a real app, you would send the encrypted message to Firestore here
        print('Encrypted message stored: ${encryptedMessage.encryptedText}');
      } catch (e) {
        print('Encryption error: $e');
        // Continue with unencrypted message if encryption fails
      }
    }

    _scrollToBottom();
  }

  Future<void> _pickFile() async {
    try {
      // Show file type selection dialog first
      String? selectedType = await _showFileTypeDialog();
      if (selectedType == null) return;

      FileType fileType;
      List<String>? allowedExtensions;

      switch (selectedType) {
        case 'image':
          fileType = FileType.image;
          allowedExtensions = null;
          break;
        case 'document':
          fileType = FileType.custom;
          allowedExtensions = ['pdf', 'doc', 'docx', 'txt', 'rtf'];
          break;
        case 'any':
          fileType = FileType.any;
          allowedExtensions = null;
          break;
        default:
          return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.single;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _showFileTypeDialog() async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select File Type',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.image, color: Colors.blue),
                title: Text('Image', style: GoogleFonts.inter()),
                subtitle: Text('JPG, PNG, GIF'),
                onTap: () => Navigator.of(context).pop('image'),
              ),
              ListTile(
                leading: Icon(Icons.description, color: Colors.green),
                title: Text('Document', style: GoogleFonts.inter()),
                subtitle: Text('PDF, DOC, TXT'),
                onTap: () => Navigator.of(context).pop('document'),
              ),
              ListTile(
                leading: Icon(Icons.folder, color: Colors.orange),
                title: Text('Any File', style: GoogleFonts.inter()),
                subtitle: Text('All file types'),
                onTap: () => Navigator.of(context).pop('any'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.single;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickDocumentFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'rtf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.single;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickAnyFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.single;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showMobileAttachmentOptions() {
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
            Text(
              'Choose Attachment',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMobileAttachmentOption(
                    Icons.image,
                    'Photo',
                    Colors.blue,
                    _pickImageFile,
                  ),
                  _buildMobileAttachmentOption(
                    Icons.description,
                    'Document',
                    Colors.green,
                    _pickDocumentFile,
                  ),
                  _buildMobileAttachmentOption(
                    Icons.folder,
                    'Any File',
                    Colors.orange,
                    _pickAnyFile,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMobileAttachmentOption(
                    Icons.videocam,
                    'Video',
                    Colors.purple,
                    () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Video attachment coming soon!')),
                      );
                    },
                  ),
                  _buildMobileAttachmentOption(
                    Icons.music_note,
                    'Audio',
                    Colors.red,
                    () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Audio attachment coming soon!')),
                      );
                    },
                  ),
                  _buildMobileAttachmentOption(
                    Icons.location_on,
                    'Location',
                    Colors.teal,
                    () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Location sharing coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileAttachmentOption(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startCall() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calling feature temporarily disabled')),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isAI = widget.chatTitle == 'AI Tutor' && !message.isUser;
    final backgroundColor = message.isUser
        ? AppColors.primary
        : isAI
            ? Colors.blue[600] // Fallback color for AI messages
            : Colors.grey[300];
    final textColor = message.isUser || isAI ? Colors.white : Colors.black;

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.senderName.isNotEmpty)
              Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 4),
            if (message.messageType == MessageType.file)
              _buildFileMessage(message, textColor)
            else
              Text(
                message.isEncrypted ? '[Encrypted Message]' : message.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileMessage(ChatMessage message, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.insert_drive_file,
          color: textColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message.text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatTitle,
              style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (widget.chatTitle != 'AI Tutor')
          IconButton(
              icon: const Icon(Icons.call),
              onPressed: _startCall,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoadingAiResponse ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoadingAiResponse) {
                  return _buildLoadingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      child: Row(
          mainAxisSize: MainAxisSize.min,
        children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(width: 8),
                    Text(
              'AI is typing...',
              style: TextStyle(
                color: Colors.grey[600],
                      fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_showAttachmentOptions) _buildAttachmentOptions(),
          if (_showEmojiPicker) _buildEmojiPicker(),
          // File preview container
          if (_selectedFile != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file, color: Colors.grey[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedFile!.name,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[700], size: 20),
                    onPressed: () {
                      setState(() {
                        _selectedFile = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.attach_file, color: Color(0xFF4B6CB7)),
                onPressed: () {
                  if (kIsWeb) {
                    _pickFile();
                  } else {
                    _showMobileAttachmentOptions();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.emoji_emotions, color: Color(0xFF4B6CB7)),
                onPressed: () {
                  setState(() {
                    _showEmojiPicker = !_showEmojiPicker;
                    _showAttachmentOptions = false;
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(Icons.image, 'Photo', () async {
            setState(() => _showAttachmentOptions = false);
            await _pickImageFile();
          }),
          _buildAttachmentOption(Icons.videocam, 'Video', () {
            setState(() => _showAttachmentOptions = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Video attachment coming soon!')),
            );
          }),
          _buildAttachmentOption(Icons.music_note, 'Audio', () {
            setState(() => _showAttachmentOptions = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Audio attachment coming soon!')),
            );
          }),
          _buildAttachmentOption(Icons.description, 'Document', () async {
            setState(() => _showAttachmentOptions = false);
            await _pickDocumentFile();
          }),
          _buildAttachmentOption(Icons.folder, 'Any File', () async {
            setState(() => _showAttachmentOptions = false);
            await _pickAnyFile();
          }),
        ],
      ),
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4B6CB7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4B6CB7), size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    const emojis = [
      '😀','😂','😉','😊','😍','😘','😎','😇','😢','😡','👍','👎','🙏','👏','🙌','🔥','✨','🎉','💯','✅','❌','❤️','💔','🤝','📚','🧠','📝','💡'
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: emojis.map((e) => GestureDetector(
          onTap: () {
            final text = _messageController.text;
            final selection = _messageController.selection;
            final insertIndex = selection.isValid ? selection.start : text.length;
            final newText = text.replaceRange(insertIndex, insertIndex, e);
            _messageController.text = newText;
            _messageController.selection = TextSelection.collapsed(offset: insertIndex + e.length);
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ]),
            child: Text(e, style: const TextStyle(fontSize: 20)),
          ),
        )).toList(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
