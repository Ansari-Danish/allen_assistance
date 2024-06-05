import 'package:allen/feature_box.dart';
import 'package:allen/openai_services.dart';
import 'package:allen/pallate.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
final  speechToText = SpeechToText();
final FlutterTts flutterTts = FlutterTts();
String lastWords ="";
String? aiImage ;
String? aiText ;
int start = 200;
int delay = 200;
final OpenaiServices openAIservice = OpenaiServices();
  
  

  @override
  void initState() {
    super.initState();
    initSpeech();
    initTexttoSpech();
  }

  Future<void> initTexttoSpech () async {
    await flutterTts.setSharedInstance(true);
  }

  /// This has to happen only once per app
  Future<void> initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);


  }

 @override
  void dispose() {
    
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        
        title: BounceInDown(child: const Text("Allen")),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        
        
      ),
      
      
     
      body: SingleChildScrollView(
        child: Column(
          children: [
            //assistance profile
            ZoomIn(
              child: Stack(
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
                      image: DecorationImage(image: AssetImage("assets/images/virtualAssistant.png"))
                    ),
                  )
                ],
              ),
            ),
            // chat bubble
            FadeInRight(
              child: Visibility(
                visible: aiImage == null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20,
                  vertical: 10,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                    top: 30,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.borderColor,
                      
                      
                    ),
                    borderRadius: BorderRadius.circular(10).copyWith(topLeft: Radius.zero)
                  ) ,
                  child:  Padding(
                    padding: const  EdgeInsets.symmetric(vertical: 10),
                    child:  Text( aiText== null ? "Good Morning, what task can I do for you?" : aiText! ,style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: aiText == null ? 25 : 18,
                      fontFamily: "Cera Pro"
                    ),
                    ),
                     )
                   ),
              ),
            ),
               if (aiImage!= null) Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: ClipRRect( borderRadius: BorderRadius.circular(20), child: Image.network(aiImage!)),
               ) ,
             SlideInLeft(
               child: Visibility(
                visible: aiText == null && aiImage==null,
                 child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10 ,
                  left: 22 ),
                   child: const  Text("Here are a few Feature",
                   style: TextStyle(
                    fontFamily: "Cera Pro",
                    fontWeight: FontWeight.bold
                    
                   ),
                   ),
                 ),
               ),
             ),
          Visibility(
            visible: aiText ==null && aiImage == null,
            child:    Column(
                children: [
                  SlideInLeft( 
                    delay: Duration(milliseconds: start) ,

                    child:const FeatureBox(headerText: "ChatGPT",
                    color: Pallete.firstSuggestionBoxColor ,
                    descriptionText: "A smarter way to stay orgnized and informed with ChatGPT",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay) ,
                    child: const FeatureBox(headerText: "Dall-E",
                    color: Pallete.secondSuggestionBoxColor ,
                    descriptionText: "A smarter way to stay orgnized and informed with Dall-E",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2* delay ) ,
                    child: const FeatureBox(headerText: "Voice Assistance",
                    color: Pallete.thirdSuggestionBoxColor ,
                    descriptionText: "A smarter way to stay orgnized and informed with Voice Assistance",
                    ),
                  ),
                  
                    
                ],
               ),
          )  // Feature List
        
               
               
        
          ],
        
        ),
      ),
      floatingActionButton: ZoomIn(
        delay: Duration(milliseconds: start + 3 * delay),
        child: FloatingActionButton(onPressed: () async{
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          }
          else if (speechToText.isListening) {
          final speech = await openAIservice.isArtPromptAPI(lastWords);
          if (speech.contains("https")) {
            aiImage = speech ;
            aiText = null ;
            setState(() {
              
            });
          } else {
            aiImage = null;
            aiText = speech;
            setState(() {
              
            });
            await systemSpeak(speech);
          }
         
            await stopListening();
        
          }
          else {
            initSpeech();
          }
        },
        backgroundColor: Pallete.firstSuggestionBoxColor,
        child: 
         Icon( speechToText.isListening ? Icons.stop : Icons.mic ,
         ),
         
         ),
      ),
    );
  }
}