import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];
  static const apiUri = 'https://api.openai.com/v1/chat/completions';

  Future<String> chatGPTAPI(String prompt) async {
    // await dotenv.load();
    var apiKey = dotenv.env['OpenAiKey'];
    apiKey = apiKey;

    if (apiKey == null) {
      return 'API key not found. Make sure to set OpenAiKey in your .env file.';
    }

    messages.add({
      "role": "user",
      "content":
          "Gngredn$prompt",
    });

    try {
      final res = await http.post(
        Uri.parse(apiUri),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $apmiKey',
          'OpenAI-Organization': ''
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
          "temperature": 0.7
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
