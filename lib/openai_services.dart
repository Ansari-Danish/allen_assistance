import 'dart:convert';

import 'package:allen/secrete.dart';
import 'package:http/http.dart' as http;

class OpenaiServices {

List <Map> message = [];
  Future<String> isArtPromptAPI(String prompt ) async {
    try {

      final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $openAISecerateKey",
        },
        body: jsonEncode({
          "model":"gpt-3.5-turbo-16k",
          "messages":[
        
            {
              "role" : "user",
              "content": "does this message want to generate an AI picture, image , art or anything similar ? $prompt . Simplify answer with a yes or no.",
            }
          ]

          
        }),
        
      );
      print(res.body);
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choice'][0]['content'];
        content = content.trim();
        switch(content){
          case "Yes":
          case "yes":
          case "Yes.":
          case "yes.":
          final res = await dallEAPI(prompt);
          return res;

          default : 
          final res = await chatGPTAPI(prompt);
          return res;

        }
      }
      return "An internal error occured";
    } catch (e) {
      return e.toString();
      
    }

  }
   Future<String> chatGPTAPI(String prompt ) async {
    message.add({
      "role" : "User",
      "content" : prompt,
    });
    try {

       final res = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $openAISecerateKey",
        },
        body: jsonEncode({
          "model":"gpt-3.5-turbo-16k",
          "messages":message

          
        }),
        
      );
     
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['choice'][0]['content'];
        content = content.trim();

        message.add({
          "role":"assistance",
          "content" : content,
        });
        return content;
      
      }
      return "An internal error occured";

    }catch (e) {
      return e.toString();

    }
 



    
    
  }
   Future<String> dallEAPI(String prompt ) async {
    
     message.add({
      "role" : "User",
      "content" : prompt,
    });
    try {

       final res = await http.post(
        Uri.parse("https://api.openai.com/v1/images/generations"),
        headers: {
          "Content-type" : "application/json",
          "Authorization" : "Bearer $openAISecerateKey",
        },
        body: jsonEncode({
          "model":"dall-e-3",
          "prompt":prompt,
          "n":1,

          
        }),
        
      );
     
      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();

        message.add({
          "role":"assistance",
          "content" : imageUrl,
        });
        return imageUrl;
      
      }
      return "An internal error occured";

    }catch (e) {
      return e.toString();

    }
  }
}