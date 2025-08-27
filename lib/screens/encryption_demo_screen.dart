import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/encryption_service.dart';
import '../constants/app_colors.dart';

class EncryptionDemoScreen extends StatefulWidget {
  const EncryptionDemoScreen({super.key});

  @override
  State<EncryptionDemoScreen> createState() => _EncryptionDemoScreenState();
}

class _EncryptionDemoScreenState extends State<EncryptionDemoScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _chatIdController = TextEditingController();
  final EncryptionService _encryptionService = EncryptionService();
  
  String? _encryptedMessage;
  String? _decryptedMessage;
  String? _error;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _chatIdController.text = 'demo_chat_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _encryptMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
      _error = null;
      _encryptedMessage = null;
      _decryptedMessage = null;
    });

    try {
      final message = _messageController.text.trim();
      final chatId = _chatIdController.text.trim();
      
      final encrypted = await _encryptionService.encryptMessage(message, chatId);
      
      setState(() {
        _encryptedMessage = encrypted;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Encryption failed: $e';
        _isProcessing = false;
      });
    }
  }

  Future<void> _decryptMessage() async {
    if (_encryptedMessage == null) return;

    setState(() {
      _isProcessing = true;
      _error = null;
      _decryptedMessage = null;
    });

    try {
      final chatId = _chatIdController.text.trim();
      final decrypted = await _encryptionService.decryptMessage(_encryptedMessage!, chatId);
      
      setState(() {
        _decryptedMessage = decrypted;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Decryption failed: $e';
        _isProcessing = false;
      });
    }
  }

  Future<void> _testKeyRotation() async {
    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final chatId = _chatIdController.text.trim();
      
      // Encrypt with current key
      final message = _messageController.text.trim();
      final encrypted1 = await _encryptionService.encryptMessage(message, chatId);
      
      // Rotate the key
      await _encryptionService.rotateGroupKey(chatId);
      
      // Encrypt with new key
      final encrypted2 = await _encryptionService.encryptMessage(message, chatId);
      
      // Decrypt both messages
      final decrypted1 = await _encryptionService.decryptMessage(encrypted1, chatId);
      final decrypted2 = await _encryptionService.decryptMessage(encrypted2, chatId);
      
      setState(() {
        _isProcessing = false;
        _error = null;
      });

      // Show results
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Key Rotation Test'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Original message: $message'),
                const SizedBox(height: 8),
                Text('Encrypted (old key): ${encrypted1.substring(0, 20)}...'),
                Text('Encrypted (new key): ${encrypted2.substring(0, 20)}...'),
                const SizedBox(height: 8),
                Text('Decrypted (old key): $decrypted1'),
                Text('Decrypted (new key): $decrypted2'),
                const SizedBox(height: 8),
                Text(
                  'Keys are different: ${encrypted1 != encrypted2 ? 'Yes' : 'No'}',
                  style: TextStyle(
                    color: encrypted1 != encrypted2 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
    } catch (e) {
      setState(() {
        _error = 'Key rotation test failed: $e';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Encryption Demo',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildInputSection(),
            const SizedBox(height: 16),
            _buildResultsSection(),
            const SizedBox(height: 16),
            _buildTestButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: AppColors.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.security, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'AES-256 Encryption',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This demo shows end-to-end encryption for chat messages using AES-256. '
              'Each chat has a unique encryption key stored securely.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Input',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _chatIdController,
              decoration: const InputDecoration(
                labelText: 'Chat ID',
                hintText: 'Enter a unique chat identifier',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Enter a message to encrypt',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _encryptMessage,
                icon: _isProcessing
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lock),
                label: Text(_isProcessing ? 'Processing...' : 'Encrypt Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Results',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            if (_encryptedMessage != null) ...[
              _buildResultItem('Encrypted Message', _encryptedMessage!, true),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _decryptMessage,
                  icon: _isProcessing
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.lock_open),
                  label: Text(_isProcessing ? 'Processing...' : 'Decrypt Message'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
            if (_decryptedMessage != null) ...[
              const SizedBox(height: 8),
              _buildResultItem('Decrypted Message', _decryptedMessage!, false),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, bool isEncrypted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isEncrypted ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEncrypted ? Colors.orange.withOpacity(0.3) : Colors.green.withOpacity(0.3),
            ),
          ),
          child: SelectableText(
            value,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: isEncrypted ? Colors.orange[700] : Colors.green[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Tests',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _testKeyRotation,
                icon: const Icon(Icons.refresh),
                label: const Text('Test Key Rotation'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Key rotation creates a new encryption key for the chat, ensuring forward secrecy.',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }
}
