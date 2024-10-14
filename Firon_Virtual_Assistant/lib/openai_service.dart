import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firon_virtual_assistant/api_key.dart';

class OpenAIService {
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo", // Correct model name
          "messages": [
            {
              'role': 'user',
              'content': 'Does this message want to generate an AI image, picture or anything similar? $prompt. Simply answer in a yes or no.',
            }
          ],
        }),
      );

      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['message']['content']?.trim() ?? '';
        return (content.toLowerCase().contains('yes')) ? await dallEAPI(prompt) : await chatGPTAPI(prompt);
      } else {
        print('Error: ${res.statusCode}, ${res.body}');
        return 'An internal error has occurred';
      }
    } catch (e) {
      print('Exception: $e'); // More explicit error logging
      return 'An error occurred. Please try again.';
    }
  }

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({'role': 'user', 'content': prompt});
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choices'][0]['message']['content']?.trim() ?? '';
        messages.add({'role': 'assistant', 'content': content});
        return content;
      } else {
        print('Error: ${res.statusCode}, ${res.body}');
        return 'An internal error has occurred';
      }
    } catch (e) {
      print('Exception: $e');
      return 'An error occurred. Please try again.';
    }
  }

  Future<String> dallEAPI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({'prompt': prompt, 'n': 1}),
      );

      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url']?.trim() ?? '';
        messages.add({'role': 'assistant', 'content': imageUrl});
        return imageUrl;
      } else {
        print('Error: ${res.statusCode}, ${res.body}');
        return 'An internal error has occurred';
      }
    } catch (e) {
      print('Exception: $e');
      return 'An error occurred. Please try again.';
    }
  }
}
