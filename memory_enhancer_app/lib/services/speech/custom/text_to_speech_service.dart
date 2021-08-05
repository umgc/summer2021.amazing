// Author: Mitchell O.
// File to support convert text to speech using Watson Text-to-Speech cloud system.

import 'package:injectable/injectable.dart';
import 'package:stacked/stacked.dart';
import 'dart:async';

import 'package:text_to_speech/text_to_speech.dart';

@singleton
class TextToSpeechService with ReactiveServiceMixin {

  TextToSpeech tts = TextToSpeech();

  Future<void> synthesizeText(String text) async {
    print("TEXT-TO-SPEECH SERVICE / Speech synthesizing result : $text");
    tts.speak(text);
  }

}
