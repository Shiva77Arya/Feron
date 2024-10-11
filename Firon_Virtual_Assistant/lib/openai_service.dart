import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firon_virtual_assistant/api_key.dart';

class OpenAIService{
  final List<Map<String, String>> messages = [];

  Future<String> isArtPromptAPI(String prompt) async{
    try{
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers:{
          'Content-Type' : 'application/json',
          'Authorization':'Bearer $apiKey',
        },
        body: jsonEncode({
          "model":"gpt-4o",
          "messages":[
            {
              'role':'user',
              'content':
                  'Does this message want to generate an AI image, picture or anything similar? $prompt . Simply answer in a yes or no.',
            }
          ],
        }),
      );
      print(res.body);
      if(res.statusCode==200) {
        String content =
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        if ((content.contains('Yes')) || (content.contains('YES')) ||
            (content.contains('yes')) || (content.contains('yes.')) ||
            (content.contains('Yes.'))) {
          final res = await dallEAPI(prompt);
          return res;
        }
        else {
          final res = await chatGPTAPI(prompt);
          return res;
        }
      }
        return 'An internal error has occurred';
    }catch(e){
      return e.toString();
    }
  }

  Future<String> chatGPTAPI(String prompt) async{
    messages.add({
      'role':'user',
      'content': prompt,
    });
    try{
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers:{
          'Content-Type' : 'application/json',
          'Authorization':'Bearer $apiKey',
        },
        body: jsonEncode({
          "model":"gpt-3.5-turbo",
          "messages": messages,
        }),
      );
      if(res.statusCode==200){
        String content =
        jsonDecode(res.body)['choices'][0]['message']['content'];
        content=content.trim();

        messages.add({
          'role':'assistant',
          'content': content,
        });
        return content;
      }
      if (res.statusCode != 200) {
        print('Error: ${res.statusCode}, ${res.body}');
        return 'An internal error has occurred';
      }else{
        return 'there is something wrong with Open AI service';
      }
    }catch(e){
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async{
    try{
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers:{
          'Content-Type' : 'application/json',
          'Authorization':'Bearer $apiKey',
        },
        body: jsonEncode({
          'prompt':prompt,
          'n':1,
        }),
      );
      if(res.statusCode==200){
        String imageUrl =
        jsonDecode(res.body)['data'][0]['url'];
        imageUrl=imageUrl.trim();

        messages.add({
          'role' : 'assistant',
          'content':imageUrl,
        });
      return imageUrl;
    }else if (res.statusCode != 200) {
        print('Error: ${res.statusCode}, ${res.body}');
        return 'An internal error has occurred';
      }
      else{
        return 'there is something wrong with Open AI service';
      }
    }catch(e){
      return e.toString();
    }
  }
}