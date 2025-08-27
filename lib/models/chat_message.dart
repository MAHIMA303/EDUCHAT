enum MessageType {
  text,
  file,
  voice,
  image,
  video,
  location,
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String senderName;
  final bool isError;
  final bool isEncrypted; // New field to track encryption status
  final String? encryptedText; // Store encrypted text separately
  final MessageType messageType;
  final String? filePath;
  final int? fileSize;
  final String? audioPath;
  final String? imagePath;
  final String? videoPath;
  final Map<String, double>? location; // latitude, longitude

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.senderName = '',
    this.isError = false,
    this.isEncrypted = false,
    this.encryptedText,
    this.messageType = MessageType.text,
    this.filePath,
    this.fileSize,
    this.audioPath,
    this.imagePath,
    this.videoPath,
    this.location,
  });

  // Create encrypted message
  ChatMessage.encrypted({
    required this.id,
    required this.encryptedText,
    required this.isUser,
    required this.timestamp,
    this.senderName = '',
    this.isError = false,
    this.messageType = MessageType.text,
    this.filePath,
    this.fileSize,
    this.audioPath,
    this.imagePath,
    this.videoPath,
    this.location,
  }) : text = '', isEncrypted = true;

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': isEncrypted ? encryptedText : text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'senderName': senderName,
        'isError': isError,
        'isEncrypted': isEncrypted,
        'messageType': messageType.name,
        'filePath': filePath,
        'fileSize': fileSize,
        'audioPath': audioPath,
        'imagePath': imagePath,
        'videoPath': videoPath,
        'location': location,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final isEncrypted = json['isEncrypted'] ?? false;
    final messageType = MessageType.values.firstWhere(
      (e) => e.name == (json['messageType'] ?? 'text'),
      orElse: () => MessageType.text,
    );
    
    if (isEncrypted) {
      return ChatMessage.encrypted(
        id: json['id'],
        encryptedText: json['text'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
        senderName: json['senderName'] ?? '',
        isError: json['isError'] ?? false,
        messageType: messageType,
        filePath: json['filePath'],
        fileSize: json['fileSize'],
        audioPath: json['audioPath'],
        imagePath: json['imagePath'],
        videoPath: json['videoPath'],
        location: json['location'] != null 
            ? Map<String, double>.from(json['location'])
            : null,
      );
    } else {
      return ChatMessage(
        id: json['id'],
        text: json['text'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
        senderName: json['senderName'] ?? '',
        isError: json['isError'] ?? false,
        messageType: messageType,
        filePath: json['filePath'],
        fileSize: json['fileSize'],
        audioPath: json['audioPath'],
        imagePath: json['imagePath'],
        videoPath: json['videoPath'],
        location: json['location'] != null 
            ? Map<String, double>.from(json['location'])
            : null,
      );
    }
  }

  // Create a copy with decrypted text
  ChatMessage copyWithDecryptedText(String decryptedText) {
    return ChatMessage(
      id: id,
      text: decryptedText,
      isUser: isUser,
      timestamp: timestamp,
      senderName: senderName,
      isError: isError,
      isEncrypted: false,
      messageType: messageType,
      filePath: filePath,
      fileSize: fileSize,
      audioPath: audioPath,
      imagePath: imagePath,
      videoPath: videoPath,
      location: location,
    );
  }

  // Create a copy with encrypted text
  ChatMessage copyWithEncryptedText(String encryptedText) {
    return ChatMessage.encrypted(
      id: id,
      encryptedText: encryptedText,
      isUser: isUser,
      timestamp: timestamp,
      senderName: senderName,
      isError: isError,
      messageType: messageType,
      filePath: filePath,
      fileSize: fileSize,
      audioPath: audioPath,
      imagePath: imagePath,
      videoPath: videoPath,
      location: location,
    );
  }

  // Create a copy with updated properties
  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? senderName,
    bool? isError,
    bool? isEncrypted,
    String? encryptedText,
    MessageType? messageType,
    String? filePath,
    int? fileSize,
    String? audioPath,
    String? imagePath,
    String? videoPath,
    Map<String, double>? location,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      isError: isError ?? this.isError,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptedText: encryptedText ?? this.encryptedText,
      messageType: messageType ?? this.messageType,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      audioPath: audioPath ?? this.audioPath,
      imagePath: imagePath ?? this.imagePath,
      videoPath: videoPath ?? this.videoPath,
      location: location ?? this.location,
    );
  }
}
