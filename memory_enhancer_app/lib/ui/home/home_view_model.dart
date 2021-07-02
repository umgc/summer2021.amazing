//**************************************************************
// Home view model
// Author: Christian Ahmed
//**************************************************************
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/file_operations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends ReactiveViewModel with WidgetsBindingObserver {
  String recognizedWords = '';
  String _triggers = '';
  FileOperations fileOperations = FileOperations();

  // Boolean storing value whether the speech engine is listening or not
  bool get listening {
    return speechService.speech.isListening;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        speechService.listenForWakeWord();
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        speechService.stopListeningForWakeWord();
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }

    notifyListeners();
  }

  void initialize() {
    WidgetsBinding.instance?.addObserver(this);
  }

  void startListening() async {
    // If already listening, stop listening
    if (listening) {
      speechService.stopListening();
    }
    // else start listening
    else {
      speechService.startListening(resultCallback: (result) async {
        if (result.recognizedWords.isNotEmpty) {
          recognizedWords = result.recognizedWords;

          String keywords = await fileOperations.readTriggers();
          _triggers = keywords;
          await fileOperations.recordNotes(_triggers, recognizedWords);
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    speechService.stopListeningForWakeWord();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [speechService];
}