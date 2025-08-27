import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
// import 'package:encrypt/encrypt.dart' as encrypt; // Temporarily disabled
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Temporarily disabled
import 'package:flutter/foundation.dart';

class EncryptionService {
  static const String _storageKey = 'encryption_keys';
  static const String _masterKeyKey = 'master_key';
  
  // final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  // Generate a random AES key
  static String _generateAESKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
  
  // Generate a master key for the user
  Future<String> _getOrCreateMasterKey() async {
    // Temporarily disabled secure storage
    // try {
    //   String? masterKey = await _secureStorage.read(key: _masterKeyKey);
    //   if (masterKey == null) {
    //     masterKey = _generateAESKey();
    //     await _secureStorage.write(key: _masterKeyKey, value: masterKey);
    //   }
    //   return masterKey;
    // } catch (e) {
    //   if (kIsWeb) {
    //     // Fallback for web - use a deterministic key (less secure but functional)
    //     return _generateDeterministicKey();
    //   }
    //   rethrow;
    // }
    return _generateDeterministicKey(); // Return deterministic key for now
  }
  
  // Fallback for web platforms
  String _generateDeterministicKey() {
    // This is less secure but provides functionality on web
    const userId = 'default_user';
    final hash = sha256.convert(utf8.encode(userId));
    return base64Url.encode(hash.bytes.take(32).toList());
  }
  
  // Get or create encryption key for a chat/group
  Future<String> getChatKey(String chatId) async {
    // Temporarily disabled secure storage
    // try {
    //   final masterKey = await _getOrCreateMasterKey();
    //   final chatKeyKey = '${_storageKey}_$chatId';
    //   
    //   String? chatKey = await _secureStorage.read(key: chatKeyKey);
    //   if (chatKey == null) {
    //     // Generate new chat key
    //     chatKey = _generateAESKey();
    //     await _secureStorage.write(key: chatKeyKey, value: chatKey);
    //   }
    //   return chatKey;
    // } catch (e) {
    //   if (kIsWeb) {
    //     // Fallback for web
    //     return _generateDeterministicKey();
    //   }
    //   rethrow;
    // }
    return _generateDeterministicKey(); // Return deterministic key for now
  }
  
  // Encrypt message text
  Future<String> encryptMessage(String message, String chatId) async {
    // Temporarily disabled encryption
    // try {
    //   final key = await getChatKey(chatId);
    //   final keyBytes = Uint8List.fromList(base64Url.decode(key));
    //   final iv = encrypt.IV.fromSecureRandom(16);
    //   
    //   final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(keyBytes)));
    //   final encrypted = encrypter.encrypt(message, iv: iv);
    //   
    //   // Combine IV and encrypted data
    //   final combined = base64Url.encode(iv.bytes + encrypted.bytes);
    //   return combined;
    // } catch (e) {
    //   print('Encryption error: $e');
    //   // Return original message if encryption fails
    //   return message;
    // }
    return message; // Return original message for now
  }
  
  // Decrypt message text
  Future<String> decryptMessage(String encryptedMessage, String chatId) async {
    // Temporarily disabled decryption
    // try {
    //   final key = await getChatKey(chatId);
    //   final keyBytes = Uint8List.fromList(base64Url.decode(key));
    //   
    //   final combined = base64Url.decode(encryptedMessage);
    //   if (combined.length < 16) {
    //     // Message might not be encrypted
    //     return encryptedMessage;
    //   }
    //   
    //   final iv = encrypt.IV(Uint8List.fromList(combined.take(16).toList()));
    //   final encryptedBytes = combined.skip(16).toList();
    //   
    //   final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(keyBytes)));
    //   final decrypted = encrypter.decrypt64(base64Url.encode(encryptedBytes), iv: iv);
    //   
    //   return decrypted;
    // } catch (e) {
    //   print('Decryption error: $e');
    //   // Return encrypted message if decryption fails
    //   return encryptedMessage;
    // }
    return encryptedMessage; // Return original message for now
  }
  
  // Share group key with new members
  Future<void> shareGroupKey(String groupId, List<String> memberIds) async {
    // Temporarily disabled secure storage
    // try {
    //   final groupKey = await getChatKey(groupId);
    //   
    //   // In a real implementation, you would encrypt the group key with each member's public key
    //   // For now, we'll store it in secure storage for each member
    //   for (final memberId in memberIds) {
    //     final memberKeyKey = '${_storageKey}_${groupId}_$memberId';
    //     await _secureStorage.write(key: memberKeyKey, value: groupKey);
    //   }
    // } catch (e) {
    //   print('Error sharing group key: $e');
    // }
  }
  
  // Rotate group key (for security)
  Future<void> rotateGroupKey(String groupId) async {
    // Temporarily disabled secure storage
    // try {
    //   final newKey = _generateAESKey();
    //   final chatKeyKey = '${_storageKey}_$groupId';
    //   await _secureStorage.write(key: chatKeyKey, value: newKey);
    // } catch (e) {
    //   print('Error rotating group key: $e');
    // }
  }
  
  // Check if message is encrypted
  bool isEncrypted(String message) {
    try {
      final decoded = base64Url.decode(message);
      return decoded.length > 16;
    } catch (e) {
      return false;
    }
  }
  
  // Clear all encryption keys (for logout)
  Future<void> clearAllKeys() async {
    // Temporarily disabled secure storage
    // try {
    //   await _secureStorage.deleteAll();
    // } catch (e) {
    //   print('Error clearing keys: $e');
    // }
  }
}
