import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/chat_message.dart';
import '../models/group.dart';
import '../services/encryption_service.dart';
import '../constants/app_colors.dart';

class GroupChatScreen extends StatefulWidget {
  final Group group;

  const GroupChatScreen({super.key, required this.group});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final EncryptionService _encryptionService = EncryptionService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isPlaying = false;
  String? _currentPlayingMessageId;
  bool _showAttachmentOptions = false;
  bool _showEmojiPicker = false;
  FocusNode _focusNode = FocusNode();
  bool _isRecording = false; // UI-only flag; recording disabled on web

  @override
  void initState() {
    super.initState();
    _loadInitialMessages();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
  }

  void _loadInitialMessages() {
    // Add some sample messages for demonstration
    _messages.addAll([
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Welcome to ${widget.group.groupName}!',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        senderName: 'System',
        messageType: MessageType.text,
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Hi everyone! Ready to study?',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        senderName: 'Alice',
        messageType: MessageType.text,
      ),
      ChatMessage(
        id: const Uuid().v4(),
        text: 'Yes! Let\'s start with the math problems',
        isUser: false,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        senderName: 'Bob',
        messageType: MessageType.text,
      ),
    ]);
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
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    // Create user message
    final userChatMessage = ChatMessage(
      id: const Uuid().v4(),
      text: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
      senderName: 'You',
      messageType: MessageType.text,
    );

    setState(() {
      _messages.add(userChatMessage);
    });

    _scrollToBottom();

    // Encrypt the message for group chat
    try {
      final groupId = widget.group.groupId;
      final encryptedText = await _encryptionService.encryptMessage(userMessage, groupId);
      
      // Update the message with encrypted text
      final encryptedMessage = userChatMessage.copyWithEncryptedText(encryptedText);
      
      setState(() {
        _messages[_messages.length - 1] = encryptedMessage;
      });
      
      // In a real app, you would send the encrypted message to Firestore here
      print('Encrypted group message stored: ${encryptedMessage.encryptedText}');
      
      // Simulate other group members receiving the message
      _simulateGroupResponse();
    } catch (e) {
      print('Encryption error: $e');
      // Continue with unencrypted message if encryption fails
    }
  }

  void _simulateGroupResponse() {
    // Simulate a response from another group member
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        final responses = [
          'Great idea!',
          'I agree with that',
          'Let me think about it...',
          'That makes sense!',
        ];
        
        final randomResponse = responses[DateTime.now().millisecond % responses.length];
        
        setState(() {
          _messages.add(
            ChatMessage(
              id: const Uuid().v4(),
              text: randomResponse,
              isUser: false,
              timestamp: DateTime.now(),
              senderName: 'Group Member',
              messageType: MessageType.text,
            ),
          );
        });
        
        _scrollToBottom();
      }
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        final file = result.files.first;
        final fileName = file.name;
        final fileSize = file.size;
        final filePath = file.path;

        // Create file message
        final fileMessage = ChatMessage(
          id: const Uuid().v4(),
          text: fileName,
          isUser: true,
          timestamp: DateTime.now(),
          senderName: 'You',
          messageType: MessageType.file,
          filePath: filePath,
          fileSize: fileSize,
        );

        setState(() {
          _messages.add(fileMessage);
        });

        _scrollToBottom();
        _showAttachmentOptions = false;
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  // Voice recording temporarily disabled to stabilize build

  Future<void> _playAudio(String audioPath, String messageId) async {
    try {
      if (_isPlaying && _currentPlayingMessageId == messageId) {
        await _audioPlayer.stop();
        setState(() {
          _isPlaying = false;
          _currentPlayingMessageId = null;
        });
      } else {
        if (_isPlaying) {
          await _audioPlayer.stop();
        }
        
        await _audioPlayer.play(DeviceFileSource(audioPath));
        setState(() {
          _isPlaying = true;
          _currentPlayingMessageId = messageId;
        });

        _audioPlayer.onPlayerComplete.listen((_) {
          setState(() {
            _isPlaying = false;
            _currentPlayingMessageId = null;
          });
        });
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void _makeCall() {
    // In a real app, this would integrate with a calling service
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call Group', style: GoogleFonts.poppins()),
        content: Text('Initiating group call with ${widget.group.members.length} members...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _makeVideoCall() {
    // In a real app, this would integrate with a video calling service
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Video Call', style: GoogleFonts.poppins()),
        content: Text('Initiating video call with ${widget.group.members.length} members...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;
    final backgroundColor = isUser ? AppColors.primary : Colors.grey[300];
    final textColor = isUser ? Colors.white : Colors.black;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
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
            if (!isUser && message.senderName.isNotEmpty)
              Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            const SizedBox(height: 4),
            _buildMessageContent(message, textColor),
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

  Widget _buildMessageContent(ChatMessage message, Color textColor) {
    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.isEncrypted ? '[Encrypted Message]' : message.text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        );
      
      case MessageType.file:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.attach_file, color: textColor, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (message.fileSize != null)
                    Text(
                      _formatFileSize(message.fileSize!),
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      
      case MessageType.voice:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                _isPlaying && _currentPlayingMessageId == message.id
                    ? Icons.stop
                    : Icons.play_arrow,
                color: textColor,
              ),
              onPressed: () => _playAudio(message.audioPath!, message.id),
            ),
            const SizedBox(width: 8),
            Text(
              'Voice Message',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ],
        );
      
      default:
        return Text(
          message.text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          ),
        );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.groupName,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${widget.group.members.length} members',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: _makeCall,
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: _makeVideoCall,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showGroupInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
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
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _showAttachmentOptions ? Icons.close : Icons.attach_file,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _showAttachmentOptions = !_showAttachmentOptions;
                    _showEmojiPicker = false;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  _showEmojiPicker ? Icons.close : Icons.emoji_emotions,
                  color: AppColors.primary,
                ),
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
                    hintText: 'Type a message to the group...',
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
              // Voice icon (UI only on web)
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(_isRecording ? Icons.mic : Icons.mic_none, color: AppColors.primary),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Voice recording is available on mobile builds.')),
                    );
                  },
                  tooltip: 'Hold to record (mobile)'.toString(),
                ),
              ),
              const SizedBox(width: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAttachmentOption(
            icon: Icons.image,
            label: 'Photo',
            onTap: () {
              // Implement photo picker
              _showAttachmentOptions = false;
            },
          ),
          _buildAttachmentOption(
            icon: Icons.videocam,
            label: 'Video',
            onTap: () {
              // Implement video picker
              _showAttachmentOptions = false;
            },
          ),
          _buildAttachmentOption(
            icon: Icons.music_note,
            label: 'Audio',
            onTap: () {
              // Implement audio picker
              _showAttachmentOptions = false;
            },
          ),
          _buildAttachmentOption(
            icon: Icons.description,
            label: 'Document',
            onTap: _pickFile,
          ),
          _buildAttachmentOption(
            icon: Icons.location_on,
            label: 'Location',
            onTap: () {
              // Implement location sharing
              _showAttachmentOptions = false;
            },
          ),
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
        children: emojis.map((e) {
          return GestureDetector(
            onTap: () {
              final text = _messageController.text;
              final selection = _messageController.selection;
              final insertIndex = selection.isValid ? selection.start : text.length;
              final newText = text.replaceRange(insertIndex, insertIndex, e);
              _messageController.text = newText;
              final newPos = insertIndex + e.length;
              _messageController.selection = TextSelection.collapsed(offset: newPos);
              FocusScope.of(context).requestFocus(_focusNode);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(e, style: const TextStyle(fontSize: 20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showGroupInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Group Info', style: GoogleFonts.poppins()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.group.groupName}'),
            Text('Members: ${widget.group.members.length}'),
            const SizedBox(height: 16),
            Text('Encryption: Enabled', style: TextStyle(color: Colors.green)),
            Text('All messages are encrypted with AES-256'),
            const SizedBox(height: 16),
            Text('Features:'),
            Text('• File sharing'),
            Text('• Voice messages'),
            Text('• Group calls'),
            Text('• Video calls'),
            Text('• End-to-end encryption'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}


