// *****************************************************************************
// Test class for the Data Processing Service
// Author: Christian Ahmed
// *****************************************************************************

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:memory_enhancer_app/services/file_operations/file_operations.dart';
import 'package:memory_enhancer_app/notes.dart';
import 'package:memory_enhancer_app/services/data_processing/data_processing.dart';
import 'package:memory_enhancer_app/services/speech/custom/text_to_speech_service.dart';

// For mockup purpose
import 'package:mockito/mockito.dart';

void main() {

  GetIt sl=GetIt.instance;
  sl.registerSingleton<FileOperations>(FileOperationsMock());
  sl.registerSingleton<TextToSpeechService>(NativeSpeechServiceMock());

  // Create instance of service
  DataProcessingService service = new DataProcessingService();
  service.initialize();

  test("No transcription", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = [];
    service.processSpeechTranscriptions(transcriptions);
  });

  test("No trigger found", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = ["Hello john remember lunch at the diplomat restaurant in dc at noon got it see you on saturday john"];
    service.processSpeechTranscriptions(transcriptions);
  });

  test("Start record trigger found and no stop trigger found", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = ["Hello john i will remember lunch at the diplomat restaurant in dc at noon"];
    service.processSpeechTranscriptions(transcriptions);
  });

  test("Start record and stop record triggers found", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = ["Hello john i will remember lunch at the diplomat restaurant in dc at noon got it see you on saturday john"];
    service.processSpeechTranscriptions(transcriptions);
  });

  test("Record and switch my to your", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = ["remember my social security number is 123456789"];
    service.processSpeechTranscriptions(transcriptions);
  });

  test("Recall user note / no input after trigger", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = ["if i recall about"];
    service.processSpeechTranscriptions(transcriptions);
  });

  test("Recall user note / more than one match", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = ["i expect to see you at the restaurant", "if i recall about a restaurant meetup"];
    service.processSpeechTranscriptions(transcriptions);
  });

  test("Recall user note / exact match", () async {
    print("\n-------------------------------------------------------------------------------------------------------------------------------------\n");
    List<String> transcriptions = ["i hope to see you at the chinese restaurant", "if i recall about a chinese restaurant meetup"];
    service.processSpeechTranscriptions(transcriptions);
  });

}

//Fake fileOperations class
class FileOperationsMock extends Fake implements FileOperations {

  @override
  Future<String> readTriggers(int type) async {
    String contents = "";
    switch(type) {
      case 0:
        contents = await ["help me remember", "so you are saying", "i will remember", "remember that my", "remember my"].join('\n');;
        break;
      case 1:
        contents = await ["it is noted", "got it", "i got it"].join('\n');;
        break;
      case 2:
        contents = await ["what is my", "can i remember", "if i recall about", "talking about"].join('\n');;
        break;
    }
    return contents;
  }

  @override
  Future writeNoteToFile(Note note) async {
    print("MOCK FILE OPERATIONS / Saving notes : $note");
  }

  @override
  Future<List<String>> getNotesData() async {
    List<String> notesData = [];
    notesData.add("lunch at the diplomat restaurant in dc saturday at noon");
    notesData.add("my social security number is one two three four five six seven eight nine");
    notesData.add("my doctor appointment on wednesday july nineteen at eight in the morning");
    notesData.add("dinner at the chinese restaurant friday evening");
    return notesData;
  }
}

// Fake Speech Service
class NativeSpeechServiceMock extends Fake implements TextToSpeechService {

  @override
  Future<void> synthesizeText(String text) async {
    print("MOCK SPEECH SERVICE / Synthesizing and playing sound for : $text");
  }
}