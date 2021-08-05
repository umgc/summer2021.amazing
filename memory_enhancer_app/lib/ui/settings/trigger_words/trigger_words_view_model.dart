//**************************************************************
// Home view model
// Author: Mo Drammeh
//**************************************************************
import 'package:memory_enhancer_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class TriggerWordsViewModel extends ReactiveViewModel
    with WidgetsBindingObserver {
  String recognizedWords = "";
  String keywords = "";

  @override
  void dispose() {
    super.dispose();
    //speechService.stopListeningForWakeWord(); AHMED
    WidgetsBinding.instance?.removeObserver(this);
  }

  // Boolean storing value whether the speech engine is listening or not
  bool get listening {
    return speechService.isListening;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        //speechService.listenForWakeWord(); AHMED
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        //speechService.stopListeningForWakeWord(); AHMED
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

  // TODO : Ahmed - revisit
  /*
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

          // record notes
          keywords = await fileOperations.readTriggers(0);
          fileOperations.recordNotes(keywords, recognizedWords);
          notifyListeners();
        }
      });
    }
    notifyListeners();
  }

   */

  @override
  List<ReactiveServiceMixin> get reactiveServices => [speechService];
}
