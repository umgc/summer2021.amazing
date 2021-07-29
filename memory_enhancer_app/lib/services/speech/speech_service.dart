//**************************************************************
// Native Speech Service
// Author: Christian Ahmed
//**************************************************************

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:memory_enhancer_app/services/data_processing/data_processing.dart';
import 'package:stacked/stacked.dart';

@singleton
class SpeechService with ReactiveServiceMixin {
  // The Method Channel to access the native custom speech service
  static const speechServiceChannel = const MethodChannel('amazing.com/amazing_speech_service');

  bool isListening = false;

  // Interim Transcript
  String interimTranscript = "";

  //----------------------------------------------------------------------------
  // Service instantiation
  //----------------------------------------------------------------------------
  SpeechService() {
    // Initialize the service
    _initialize();
  }


  //----------------------------------------------------------------------------
  // Service initialization
  //----------------------------------------------------------------------------
  void _initialize() {
    print("SPEECH SERVICE / Initializing Speech Service.");
    // Register callback method
    speechServiceChannel.setMethodCallHandler(_processSpeechServiceOutput);
  }


  //----------------------------------------------------------------------------
  // Start listening
  //----------------------------------------------------------------------------
  Future<void> startListening() async {
    if(!isListening) {
      try {
        synthesizeTextToSpeech("Memory Enhancer is now listening to you.");
        isListening = true;
        await speechServiceChannel.invokeMethod('startListening');
      } on PlatformException catch (e) {
        print("SPEECH SERVICE / Start listening call failed : '${e.message}'.");
      }
    }
  }


  //----------------------------------------------------------------------------
  // Start listening
  //----------------------------------------------------------------------------
  Future<void> stopListening() async {
    if(isListening){
      try {
        synthesizeTextToSpeech("Memory Enhancer is no longer listening to you.");
        isListening = false;
        String result = await speechServiceChannel.invokeMethod('stopListening');
        List<String> transcriptions = (jsonDecode(result) as List<dynamic>).cast<String>();
        print("SPEECH SERVICE / Returned transcripts : $transcriptions");

        //GetIt.I.get<DataProcessingService>().processSpeechTranscriptions(transcriptions);

        //TODO : AHMED - Diarization display.  Delete later
        interimTranscript =  "";
        for(int i = 0; i < transcriptions.length; i++) {
          int id = i + 1;
          String transcription = transcriptions[i];
          interimTranscript += "SPEAKER #$id : $transcription\n\n";
          notifyListeners();
        }
        // TODO END
      }
      on PlatformException catch (e) {
        print("SPEECH SERVICE / Stop listening call failed : '${e.message}'.");
      }
    }
  }


  //----------------------------------------------------------------------------
  // Initiate the IBM Watson Listening service to transcribe the user's speech
  //----------------------------------------------------------------------------
  Future<void> synthesizeTextToSpeech(String text) async {
    try {
      final String result = await speechServiceChannel.invokeMethod('synthesizeTextToSpeech', {"text": text});
      print("SPEECH SERVICE / Speech synthesizing result : $result");
    } on PlatformException catch (e) {
      print("SPEECH SERVICE / Failed to synthesize text : '${e.message}'.");
    }
  }


  //----------------------------------------------------------------------------
  // Callback sending from the native speech service
  //----------------------------------------------------------------------------
  Future<void> _processSpeechServiceOutput(MethodCall call) async {
    if (call.method == 'processTranscription') {
      GetIt.I.get<DataProcessingService>().processSpeechTranscriptions([call.arguments]);
    }
    else if (call.method == 'interimTranscription') {
      interimTranscript = call.arguments;
      notifyListeners();
      print("---------- $interimTranscript");
    }
  }


}