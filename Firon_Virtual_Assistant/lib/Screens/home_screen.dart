import 'package:firon_virtual_assistant/feature_box.dart';
import 'package:firon_virtual_assistant/pallete.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget
{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
   TextEditingController userInputTextEditingController=TextEditingController();
   final SpeechToText speechToTextInstance=SpeechToText();
   String recordedAudioString="";
   bool isLoading = false; //so it takes time to listen

   @override build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text("Firon"),
         leading: const Icon(Icons.menu),
         centerTitle: true,
       ),
       body: Column(
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
           Container(
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
             child: const Padding(
               padding: EdgeInsets.symmetric(vertical:10.0),
               child: Text(
                 "Greetings Welcome to NCS, How can I help you?",
                 style: TextStyle(
                   fontFamily: 'Cera Pro',
                   color: Pallete.mainFontColor,
                   fontSize: 25,
                 ),
               ),
             ),
           ),
           Container(
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
           Column(
             children: [
               FeatureBox(
                   color: Pallete.firstSuggestionBoxColor,
                   headerText: "ChatGPt",
                 descriptionText: "Chat gpt description",
               ),
               FeatureBox(
                 color: Pallete.secondSuggestionBoxColor,
                 headerText: "DallE",
                 descriptionText: "DallE description",
               ),
               FeatureBox(
                 color: Pallete.thirdSuggestionBoxColor,
                 headerText: "Smart Voice Assistant",
                 descriptionText: "Smart Voice Assistant description",
               ),
             ],
           )//Feature List
         ],
       ),
       floatingActionButton:FloatingActionButton(
           backgroundColor: Pallete.thirdSuggestionBoxColor,
           onPressed: (){},
           child:const Icon(Icons.mic),
     ),
     );
   }
}