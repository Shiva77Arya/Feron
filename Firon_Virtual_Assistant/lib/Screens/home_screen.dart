import 'package:animate_do/animate_do.dart';
import 'package:firon_virtual_assistant/feature_box.dart';
import 'package:firon_virtual_assistant/openai_service.dart';
import 'package:firon_virtual_assistant/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  @override
  final speechToText = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  String lastWords="";
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start =200;
  int delay = 200;

  @override
  void initState(){
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);

    // Set the voice to a male voice if available
    List<dynamic> voices = await flutterTts.getVoices;
    for (var voice in voices) {
      if (voice['name'].toString().toLowerCase().contains('male')) {
        await flutterTts.setVoice(voice['name']);
        break; // Exit loop once we find a male voice
      }
    }

    await flutterTts.speak(content);
  }


  Future<void> initTextToSpeech() async{
    await  flutterTts.setSharedInstance(true);
    setState(() {
    });
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {
    });
  }

  Future<void> startListening() async{
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {
    });
  }

  Future<void> stopListening() async{
    await speechToText.stop();
    setState(() {
    });
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      setState(() {
        lastWords = result.recognizedWords;  // Update lastWords only for final results
        print(lastWords);  // Log the recognized words
      });
      await Future.delayed(Duration(seconds: 2));

      // Call the chatbot API
      final speech = await simpleChatbot(lastWords);
      print(speech);

      // Update the UI based on the response
      if (speech.contains('https')) {
        generatedImageUrl = speech;
        generatedContent = null; // Reset generated content
      } else {
        generatedImageUrl = null; // Reset generated image URL
        generatedContent = speech; // Assign the response
        systemSpeak(speech);
      }
    }

  }

  String simpleChatbot(String userInput) {
    // Normalize the input to lower case for easier matching
    String input = userInput.toLowerCase().trim();

    // Define keywords and corresponding replies
    Map<String, String> responses = {
      "hello": "Hi there! How can I assist you today?",
      "hello Firaun": "Hi there! How can I assist you today?",
      "hi Firaun": "Hi there! How can I assist you today?",
      "hi": "Hello! What can I do for you?",
      "how are you": "I'm just a computer program, but I'm here to help you!",
      "what is your name": "My name is Firaun, I am your virtual assistant.",
      "tell me a joke": "Why did the scarecrow win an award? Because he was outstanding in his field!",
      "what can you do": "I can chat with you, answer questions, and help you with tasks.",
      "thank you": "You're welcome! If you have more questions, feel free to ask.",
      "goodbye": "Goodbye! Have a great day!",
      "what is the weather": "I can't check the weather right now, but you can look it up online!",
      "tell me something interesting": "Did you know honey never spoils? Archaeologists have found pots of honey in ancient Egyptian tombs that are over 3000 years old and still perfectly good to eat!",
      "who created you": "I was created by Mr.Aarya to assist you.",
      "what is your purpose": "My purpose is to help you find information and make your tasks easier.",
      "help": "I'm here to assist you! You can ask me questions or request tasks.",
      "what time is it": "I'm unable to check the time, but you can easily find it on your device.",
      "tell me a fun fact": "A group of flamingos is called a 'flamboyance'. Isn't that cool?",
    };
    // Check if the input contains any key phrases
    for (String key in responses.keys) {
      if (input.contains(key)) {
        setState(() {

        });
        return responses[key]!;
      }
    }

    // Default response if no matches are found
    return "I'm sorry, I didn't understand that. Can you try asking in a different way?";
  }

  @override void dispose(){
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

   @override build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: BounceInDown(child: const Text("Firon")),
         leading: const Icon(Icons.menu),
         centerTitle: true,
       ),
       body: SingleChildScrollView(
         child: Column(
           children: [
             Stack(
               children: [
                 Center(
                   child: Container(
                     height: 120,
                     width: 120,
                     margin: const EdgeInsets.only(top: 4),
                     decoration: const BoxDecoration(
                       color: Pallete.assistantCircleColor,
                       shape: BoxShape.circle,
                     ),
                   ),
                 ),
                 Container(
                   height: 123,
                   decoration: const BoxDecoration(
                     shape: BoxShape.circle,
                     image: DecorationImage(
                       image: AssetImage(
                         'assets/images/virtualAssistant.png',
                       ),
                     ),
                   ),
                 ),
               ],
             ),
             //chat bubble
             FadeInRight(
               child: Visibility(
                 visible: generatedImageUrl==null,
                 child: Container(
                   padding: const EdgeInsets.symmetric(
                     horizontal: 20,
                     vertical: 10,
                   ),
                   margin:const EdgeInsets.symmetric(horizontal: 40).copyWith(
                     top: 30,
                   ),
                   decoration: BoxDecoration(
                     border: Border.all(
                       color: Pallete.borderColor,
                     ),
                     borderRadius: BorderRadius.circular(20).copyWith(
                       topLeft: Radius.zero,
                     ),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(vertical:10.0),
                     child: Text( //check for string and const
                       generatedContent == null ? "Greetings Welcome to NCS, How can I help you?" : generatedContent.toString(),
                       style: TextStyle(
                         fontFamily: 'Cera Pro',
                         color: Pallete.mainFontColor,
                         fontSize: generatedContent == null ? 25 : 18,
                       ),
                     ),
                   ),
                 ),
               ),
             ),
             Visibility(
               visible: generatedContent == null && generatedImageUrl==null,
               child: SlideInLeft(
                 child: Container(
                   padding: const EdgeInsets.all(10),
                   alignment: Alignment.centerLeft,
                   margin:const EdgeInsets.only(top:10,left:22),
                   child: const Text(
                      "Here are my few features:",
                     style: TextStyle(
                       fontFamily: 'Cera Pro',
                       color: Pallete.mainFontColor,
                       fontSize: 20,
                       fontWeight:FontWeight.bold,
                     ),
                   ),
                 ),
               ),
             ),
             if(generatedImageUrl!=null) Padding(
               padding: const EdgeInsets.all(10.0),
               child: ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: Image.network(generatedImageUrl!),
               ),
             ),
             Visibility(
               visible: generatedContent == null && generatedImageUrl==null,
               child: Column(
                 children: [
                   SlideInLeft(
                     delay: Duration(milliseconds: start),
                     child: const FeatureBox(
                         color: Pallete.firstSuggestionBoxColor,
                         headerText: "ChatGPt",
                       descriptionText: "Chat gpt description",
                     ),
                   ),
                   SlideInLeft(
                     delay: Duration(milliseconds: start  + delay),
                     child: const FeatureBox(
                       color: Pallete.secondSuggestionBoxColor,
                       headerText: "DallE",
                       descriptionText: "DallE description",
                     ),
                   ),
                   SlideInLeft(
                       delay: Duration(milliseconds: start + 2 * delay),
                       child: const FeatureBox(
                       color: Pallete.thirdSuggestionBoxColor,
                       headerText: "Smart Voice Assistant",
                       descriptionText: "Smart Voice Assistant description",
                     ),
                   ),
                 ],
               ),
             )//Feature List
           ],
         ),
       ),
       floatingActionButton:  ZoomIn(
         delay: Duration(milliseconds: start + 4 * delay),
         child: FloatingActionButton(
             backgroundColor: Pallete.thirdSuggestionBoxColor,
           onPressed: () async {
             if (await speechToText.hasPermission && !speechToText.isListening) {
               await startListening();
             } else if (speechToText.isListening) {
               await stopListening();
             } else {
               initSpeechToText();
             }
           },
             child:Icon(speechToText.isListening ? Icons.stop :  Icons.mic),
              ),
       ),
     );
   }
}