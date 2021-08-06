//**************************************************************
// Notes view model
// Author:
//**************************************************************

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:xml/xml.dart' as xml;

import '../../notes.dart';

List<Note> memos = List.empty(growable: true); // Empty array for notes array
BuildContext? context;

// Get content from notes file to display on page.
// XML parser is used to parse info from notes.xml file.
Future<List<Note>> getContent() async {
  try {
    String xmlContent = await fileOperations.readNotes();
    xml.XmlDocument xmlTextDoc = xml.XmlDocument.parse(xmlContent);
    var newXml = await fileOperations.decryptContent(xmlTextDoc);
    final memo = newXml
        .findAllElements('note')
        .map((xml) => Note.fromXml(xml))
        .toList();

    return memo;
  } catch (e) {
    print('An error occurred. MORE INFO: ' + e.toString());
    return List.empty();
  }
}

class NotesViewModel extends BaseViewModel {
  // Boolean storing value whether the speech engine is listening or not
  bool get listening {
    return speechService.isListening;
  }

  void initialize() {}

  // Edit notes.
  void onEdit(String id, String edits) async {
    fileOperations.editNote(id, edits);
    notifyListeners();
  }

  // Delete notes.
  void onDelete(String id) async {
    fileOperations.deleteNote(id);
    dataProcessingService.initializeUserNotes();
  notifyListeners();
  }

  //Create note from recording/speaking
  void speakNote(String data) async {
    // If data is not empty , make a Note object and save to file
    if (data.isNotEmpty) {
      data = data.split('you ')[1];
      Note note = Note('', DateTime.now(), data); // New Note
      fileOperations.writeNoteToFile(note); // Save Note to file
      dataProcessingService.initializeUserNotes();
      notifyListeners();
    } else {
      // else error occurred recording note
      print('Error has occurred. Note was not recorded.');
    }
    notifyListeners();
  }

  Future<void> handleListening() async {
    // If already listening, stop listening
    speechService.processSpeechRecognize();
    this.speakNote(speechService.interimTranscription);
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
  }
}
