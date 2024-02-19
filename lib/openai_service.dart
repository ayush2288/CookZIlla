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
          "Generate a delicious and creative recipe using the following ingredients: [list of ingredients] and respond to doubts, suggestions, or recommendations only related to food and recipe. Provide step-by-step instructions, cooking tips, and any additional only food or recipe suggestions to make this recipe enjoyable for all skill levels. Make sure your response should be point to point and crisp. Your goal is to inspire and guide readers through a successful and delightful cooking experience. and also show its nutrition values and if user ask for irrelevent doubts than ask them to put food or recipe related doubts and guide users if they ask only food or recipe-related questions. Assist them promptly if they inquire about the recipe or recipe-related matters. and dont show any error directly in the chatbox. if error comes say user to check there internet connection$prompt",
    });

    try {
      final res = await http.post(
        Uri.parse(apiUri),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $apiKey',
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
