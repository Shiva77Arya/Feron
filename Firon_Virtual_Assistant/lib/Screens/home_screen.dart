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

  Future<void> systemSpeak(String content) async
  {
     await flutterTts.speak(content);
  }

  void onSpeechResult(SpeechRecognitionResult result){
    setState(() {
      lastWords= result.recognizedWords;
      print(lastWords);
    });
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
               if(await speechToText.hasPermission && speechToText.isNotListening){
                 await startListening();
               }else if(speechToText.isListening){
                 final speech = await openAIService.isArtPromptAPI(lastWords);
                 if(speech.contains('https')){
                   generatedImageUrl=speech;
                   generatedContent=null;
                   setState(() {});
                 }else{
                   generatedImageUrl=null;
                   generatedContent=speech;
                   setState(() {});
                   await systemSpeak(speech);
                 }
                 //print(speech);

                 await stopListening();
               }else{
                 initSpeechToText();
               }
             },
             child:Icon(speechToText.isListening ? Icons.stop :  Icons.mic),
              ),
       ),
     );
   }
}