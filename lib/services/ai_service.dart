import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class AiService {
  final String _apiKey;
  final http.Client _client;

  AiService({String? apiKey, http.Client? client})
      : _apiKey = apiKey ?? const String.fromEnvironment('OPENAI_API_KEY', defaultValue: ''),
        _client = client ?? http.Client();

  Future<String> getAiResponse(List<ChatMessage> history, String userInput) async {
    if (_apiKey.isEmpty) {
      throw Exception('OpenAI API Key not configured. Please provide it using --dart-define=OPENAI_API_KEY=YOUR_KEY');
    }

    final messages = history.map((msg) => {
          'role': msg.isUser ? 'user' : 'assistant',
          'content': msg.text,
        }).toList();

    messages.add({'role': 'user', 'content': userInput});

    try {
      final response = await _client.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': messages,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('OpenAI API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get AI response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error calling OpenAI API: $e');
      throw Exception('Network or API error: $e');
    }
  }
}


