// Test class for the encryption/decryption service
// Author: Ayodeji Famudehin

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:memory_enhancer_app/services/speech/custom/text_to_speech_service.dart';
import 'package:text_to_speech/text_to_speech.dart';

// For mockup purpose
import 'package:mockito/mockito.dart';

void main() {

  test("Convert text to speech", () async {

    TextToSpeechService service = new TextToSpeechService();
    service.tts = new TextToSpeechMock();
    await service.synthesizeText("my text to convert to speech");
  });

}

// Fake Speech Service
class TextToSpeechMock extends Fake implements TextToSpeech {

  @override
  Future<bool?> speak(String text) async{
    print("MOCK PLATFORM TEXT-TO-SPEECH / playing sound : $text");
  }
}