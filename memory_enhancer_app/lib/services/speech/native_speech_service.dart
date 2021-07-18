//**************************************************************
// Native Speech Service
// Author: Christian Ahmed
//**************************************************************

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';

// Porcupine for wake words
import 'package:porcupine/porcupine.dart';
import 'package:porcupine/porcupine_error.dart';
import 'package:porcupine/porcupine_manager.dart';
import 'package:wakelock/wakelock.dart';

@singleton
class NativeSpeechService with ReactiveServiceMixin {
  // The Method Channel to access the native custom speech service
  static const speechServiceChannel = const MethodChannel('amazing.com/amazing_speech_service');

  bool isListening = false;

  // Interim Transcript
  String interimTranscript = "";

  // Porcupine
  PorcupineManager? porcupineManager;


  //----------------------------------------------------------------------------
  // Service instantiation
  //----------------------------------------------------------------------------
  NativeSpeechService() {
    // Initialize the service
    _initialize();
  }


  //----------------------------------------------------------------------------
  // Service initialization
  //----------------------------------------------------------------------------
  void _initialize() {
    // Register callback method
    speechServiceChannel.setMethodCallHandler(_processSpeechServiceOutput);
  }


  //----------------------------------------------------------------------------
  // Initiate the IBM Watson Listening service to transcribe the user's speech
  //----------------------------------------------------------------------------
  Future<void> listenToSpeech() async {
    if(isListening){
      stopListening();
    } else {
      startListening();
    }
  }


  //----------------------------------------------------------------------------
  // Start listening
  //----------------------------------------------------------------------------
  Future<void> startListening() async {
    if(!isListening) {
      try {
        isListening = true;
        await speechServiceChannel.invokeMethod('startListening');
      } on PlatformException catch (e) {
        print("Start listening call failed : '${e.message}'.");
      }
    }
  }


  //----------------------------------------------------------------------------
  // Start listening
  //----------------------------------------------------------------------------
  Future<void> stopListening() async {
    if(isListening){
      try {
        isListening = false;
        final String result = await speechServiceChannel.invokeMethod('stopListening');
        var output = jsonDecode(result);
        print(output);
      } on PlatformException catch (e) {
        print("Stop listening call failed : '${e.message}'.");
      }
    }
  }

  //----------------------------------------------------------------------------
  // Initiate the IBM Watson Listening service to transcribe the user's speech
  //----------------------------------------------------------------------------
  Future<void> synthesizeTextToSpeech(String text) async {
    try {
      final String result = await speechServiceChannel.invokeMethod('synthesizeTextToSpeech', {"text": text});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to synthesize text : '${e.message}'.");
    }
  }


  //----------------------------------------------------------------------------
  // Callback sending from the native speech service
  //----------------------------------------------------------------------------
  Future<void> _processSpeechServiceOutput(MethodCall call) async {
    if (call.method != 'interimTranscription') return;
    interimTranscript = call.arguments;
    notifyListeners();
    print("---------- $interimTranscript");
  }


  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //
  // PORCUPINE LOGIC
  //
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  // Create an instance of your porcupineManager which will listen for the given wake words
  // Must call start on the manager to actually start listening
  //----------------------------------------------------------------------------
  Future<void> createPorcupineManager() async {
    try {
      porcupineManager = await PorcupineManager.fromKeywords(
          Porcupine.BUILT_IN_KEYWORDS, wakeWordCallback);
    } on PvError catch (err) {
      // handle porcupine init error
      print('Porcupine error: ' + (err.message ?? 'None'));
    }
  }


  //----------------------------------------------------------------------------
  // The function that's triggered when the Porcupine instance recognizes a wake word
  // Input is the index of the wake word in the list of those being used
  //----------------------------------------------------------------------------
  Future<void> wakeWordCallback(int word) async {
    print('Wake word index : ' + word.toString());

    // Terminator - resets audio resources
    if (word == 13) {
      await disposeResources();
      await createPorcupineManager();
      await listenForWakeWord();
    } else {
      await startListening();
    }
  }


  //----------------------------------------------------------------------------
  // // Begin listening for a wake word
  //----------------------------------------------------------------------------
  Future<void> listenForWakeWord() async {
    try {
      await porcupineManager?.start();
    } on PvAudioException catch (ex) {
      print('PvAudioException: ' + (ex.message ?? 'None'));
    }
  }


  //----------------------------------------------------------------------------
  // Stop listening for a wake word
  //----------------------------------------------------------------------------
  Future<void> stopListeningForWakeWord() async {
    print('Stopping wake word listener');
    await porcupineManager?.stop();
  }


  //----------------------------------------------------------------------------
  // Dispose all the resources
  //----------------------------------------------------------------------------
  Future<void> disposeResources() async {
    print('Disposing speech resources');
    porcupineManager?.delete();
  }


  //----------------------------------------------------------------------------
  // Keep the screen on while the voice recognition screen is open
  //----------------------------------------------------------------------------
  void setWakelock(bool val) {
    val ? Wakelock.enable() : Wakelock.disable();
  }


}