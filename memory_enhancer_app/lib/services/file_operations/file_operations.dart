//***************************************************************************
// File Operations
// Author: Ayodeji Fahumedin
// Modified by: Chauntika Broggin, Mo Drammeh, Christian Ahmed
//***************************************************************************
import 'dart:io' as io;

import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

import '../../notes.dart';

/// File operations for the Memory Enhancer app.
@singleton
class FileOperations with ReactiveServiceMixin {

  /// Gets path to local application document directory.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Gets trigger word file from application document directory.
  Future<io.File> get _startTriggersFile async {
    final filePath = await _localPath;
    return io.File(filePath + '/startTriggerWords.txt');
  }

  /// Gets trigger word file from application document directory.
  Future<io.File> get _stopTriggersFile async {
    final filePath = await _localPath;
    return io.File(filePath + '/stopTriggerWords.txt');
  }

  /// Gets trigger word file from application document directory.
  Future<io.File> get _recallTriggersFile async {
    final filePath = await _localPath;
    return io.File(filePath + '/recallTriggerWords.txt');
  }

  /// Gets notes file from application document directory.
  Future<io.File> get _noteFile async {
    final filePath = await _localPath;
    final file = io.File(filePath + '/notes.xml');
    return file;
  }

  Future<io.File> getNotesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = io.File(directory.path + '/notes.xml');
    return file;
  }

  /// Reads notes from file.
  Future<String> readNotes() async {
    try {
      final file = await _noteFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      String errorMessage = 'An error has occurred. MORE INFO: ' + e.toString();
      print(errorMessage);
      return errorMessage;
    }
  }

  // Decrypt note content
  Future<xml.XmlDocument> decryptContent(xml.XmlDocument notes) async{
    try{
      var elements =
      notes.findAllElements('note'); // Collects all the note items
      // Check each note to see if it has a matching id number.
      for (var e in elements) {
        // If it does, get the body content of the note and replace with user changes
        var oldContent = e.findElements('content').first.innerText;
        var decryptedContent = encryptionService.decryptText(encrypted: oldContent);
        e.findElements('content').first.innerText = decryptedContent;
      }
      return notes;
    } catch (e){
      print (e.toString());
      return notes;
    }
  }

  /// Writes notes to file.
  Future writeNoteToFile(Note note) async {
    String message = "Data saved to file.";
    try {
      String xmlString = await readNotes(); // Read notes file
      var fileXML = xml.XmlDocument.parse(xmlString); // Parse data
      // Encrypt content
      note.noteBody = encryptionService.encryptText(text:note.noteBody);
      final builder = xml.XmlBuilder(); // Builder for XML
      note.buildNote(builder); // Build note

      // Adding note to XML file
      fileXML.firstElementChild!.children.add(builder.buildFragment());
      final file = await _noteFile;
      file.writeAsStringSync(fileXML.toString()); // Get notes XML file
      print(message); // Print that the note was saved.
      dataProcessingService.initializeUserNotes();
    } catch (e) {
      print('Error has occured. ' + e.toString());
    }
  }

  // Record notes to file.
  void recordNotes(String keywords, String content) async {
    var _triggerList = keywords.split('\n'); // Makes array of trigger words.
    var exist = false; // Boolean to see if word is in triggerList array

    // Checks to see if word is in triggerList array.
    for (var keyword in _triggerList) {
      if (content.contains(keyword.trim())) {
        exist = true;
      } // If word is in the list, make new Note object and save to file.
    }
    if (exist) {
      var textNote = Note('', DateTime.now(), content);
      writeNoteToFile(textNote);
    }

    dataProcessingService.initializeUserNotes();
  }

  // Create note from typing in note
  void writeNewNote(String data, BuildContext context) {
      Note note = Note('', DateTime.now(), data); // Make new Note object.
      writeNoteToFile(note); // Save to file.
    dataProcessingService.initializeUserNotes();
  }

  // Displays Alert Dialog Box
  Future<void> showAlertBox(
      String title, String message, BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                    child: Text('OK',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]);
        });
  }

  //Create note from recording/speaking
  void speakNote(String data) async {
    // If data is not empty , make a Note object and save to file
    if (data.isNotEmpty && !speechService.isListening) {
      Note note = Note('', DateTime.now(), data); // New Note
      writeNoteToFile(note); // Save Note to file
      dataProcessingService.initializeUserNotes();
    } else {
      // else error occurred recording note
      print('Error has occurred. Note was not recorded.');
    }

    dataProcessingService.initializeUserNotes();
  }

  // Create initial notes file
  void initialNoteFile() async {
    try {
      final file = await _noteFile;
      if (await file.exists()) {
        print('File already exists');
      } else {
        String noteText = "Sample initial note";
        String encryptedNoteContent = encryptionService.encryptText(text: noteText);
        Note note = Note('', DateTime.now(), encryptedNoteContent);
        note.createFile();
        print('Notes file created.');
      }
    } catch (e) {
      print('An error occured. MORE INFO: ' + e.toString());
    }
  }

  /// Edits notes in notes file.
  void editNote(String id, String edits) async {
    try {
      String editContent = await readNotes(); // Read notes from file
      var editFile = xml.XmlDocument.parse(editContent); // Parses data
      var elements =
      editFile.findAllElements('note'); // Collects all the note items
      // Check each note to see if it has a matching id number.
      for (var e in elements) {
        // If it does, get the body content of the note and replace with user changes
        if (e.findElements('id').first.text == id) {
          e.findElements('content').first.innerText = encryptionService.encryptText(text: edits);
          final file = await _noteFile;
          file.writeAsStringSync(editFile.toString());
        }
      }
    } catch (e) {
      print('An error has occured. MORE INFO: ' + e.toString());
    } // catch
    dataProcessingService.initializeUserNotes();
  }

  // Delete note.
  void deleteNote(String id) async {
    try {
      String xmlContent = await readNotes(); // Read notes from file
      var fileXML = xml.XmlDocument.parse(xmlContent.toString()); // Parses data
      var nodes =
          fileXML.findAllElements('note'); // Collects all the note items
      // Check each note to see if it has a matching id number.
      for (var node in nodes) {
        // If it does, remove note and inform user
        if (node.findElements('id').first.text == id) {
          // Write changes to file
          final file = await _noteFile;
          if (nodes.length >= 0) {
            node.parent!.children.remove(node); // Remove note
            dataProcessingService.initializeUserNotes();
          } else {
            String noteText = "Sample initial note";
            String encryptedNoteContent = encryptionService.encryptText(text: noteText);
            Note note = Note('', DateTime.now(), encryptedNoteContent);
            writeNoteToFile(note);
            dataProcessingService.initializeUserNotes();
          }
          print('Note deleted.');
          file.writeAsStringSync(fileXML.toString());
          dataProcessingService.initializeUserNotes();

        } else {
          // else tell user the note was not found
          print('No note found.');
        } // End if..else
      } // End for in loop

      dataProcessingService.initializeUserNotes();
    } catch (e) {
      // if there is a file or parsing error, print error
      print('An error has occurred.' + e.toString());
    } // End try...catch
    dataProcessingService.initializeUserNotes();
  }

  /*/// Retrieves notes in notes file.
  Future<List<String>> getNotesData() async {
    List<String> notesData = [];
    try {
      String notes = await readNotes(); // Read notes from file
      var xmlNotes = xml.XmlDocument.parse(notes); // Parses data
      var elements = xmlNotes.findAllElements('note'); // Collects all the note items
      for (var e in elements) {
        notesData.add(e.findElements('content').first.innerText);
      }
    } catch (e) {
      print('An error has occurred. MORE INFO: ' + e.toString());
    } // catch

    return notesData;
  }*/

  /// Retrieves notes in notes file.
  Future<List<String>> getNotesData() async {
    List<String> notesData = [];
    try {
      String notes = await readNotes(); // Read notes from file
      var xmlNotes = xml.XmlDocument.parse(notes); // Parses data
      var elements = xmlNotes.findAllElements('note'); // Collects all the note items
      for (var e in elements) {
        var encryptedContent = e.findElements('content').first.innerText;
        var decryptedText = encryptionService.decryptText(encrypted: encryptedContent);
        notesData.add(decryptedText);
      }
    } catch (e) {
      print('An error has occurred. MORE INFO: ' + e.toString());
    } // catch

    return notesData;
  }

  /// Reads trigger keywords from file.
  Future<String> readTriggers(int type) async {
    String contents = '';
    late final io.File file;
    try {
      switch(type) {
        case 0:
          file = await _startTriggersFile;
          break;
        case 1:
          file = await _stopTriggersFile;
          break;
        case 2:
          file = await _recallTriggersFile;
          break;
      }
      contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("[ERROR] " + e.toString());
      return '[ERROR] Problem reading trigger words file.';
    }
  }

  void initializeTriggersFile() async {
    final startFile = await _startTriggersFile;
    final stopFile = await _stopTriggersFile;
    final recallFile = await _recallTriggersFile;

    try {
      startFile.readAsStringSync();
      print("Start triggers file exists");
    } catch (e) {
      print("Start triggers file needs to be created\nCreating from assets/default_start_record_triggers.txt");
      String initFile = await rootBundle.loadString('assets/settings/default_start_record_triggers.txt');
      startFile.writeAsString(initFile);
    }
    try {
      stopFile.readAsStringSync();
      print("Stop triggers file exists");
    } catch (e) {
      print("Stop triggers file needs to be created\nCreating from assets/default_stop_record_triggers.txt");
      String initFile = await rootBundle.loadString('assets/settings/default_stop_record_triggers.txt');
      stopFile.writeAsString(initFile);
    }
    try {
      recallFile.readAsStringSync();
      print("Recall triggers file exists");
    } catch (e) {
      print("Recall triggers file needs to be created\nCreating from assets/default_recall_triggers.txt");
      String initFile = await rootBundle.loadString('assets/settings/default_recall_triggers.txt');
      recallFile.writeAsString(initFile);
    }
  }

  void deleteLocalFile(String fileName) async {
    final filePath = await _localPath;
    final file = await io.File(filePath + '/' + fileName);
    file.delete();
  }

  /// Add trigger word to file.
  Future addTrigger(String text, int type) async {
    late final io.File file;
    switch(type) {
      case 0:
        file = await _startTriggersFile;
        break;
      case 1:
        file = await _stopTriggersFile;
        break;
      case 2:
        file = await _recallTriggersFile;
        break;
    }
    List<String> triggersArray = file.readAsLinesSync();
    if(!triggersArray.contains(text.trim())) {
      file.writeAsString('\n${text}', mode: io.FileMode.append);
      print("Trigger added: " + text);
      dataProcessingService.initializeTriggers();
    } else {
      print(text + " is already a trigger");
    }
  }

  /// Delete trigger word from file.
  Future deleteTrigger(String text, int type) async {
    late final io.File file;
    switch(type) {
      case 0:
        file = await _startTriggersFile;
        break;
      case 1:
        file = await _stopTriggersFile;
        break;
      case 2:
        file = await _recallTriggersFile;
        break;
    }
    //final file = await _startTriggersFile;
    String triggersText = file.readAsStringSync();
    List<String> triggersArray = triggersText.trimLeft().split("\n");
    triggersArray.remove(text);
    print("Trigger removed: " + text);

    triggersText = triggersArray.join('\n');
    file.writeAsString('${triggersText}', mode: io.FileMode.write);

    dataProcessingService.initializeTriggers();
  }

  /// Edit trigger word from file.
  Future editTrigger(String before, String after, int type) async {
    late final io.File file;
    switch(type) {
      case 0:
        file = await _startTriggersFile;
        break;
      case 1:
        file = await _stopTriggersFile;
        break;
      case 2:
        file = await _recallTriggersFile;
        break;
    }
    String triggersText = file.readAsStringSync();
    List<String> triggersArray = triggersText.trimLeft().split("\n");

    triggersArray[triggersArray.indexOf(before)] = after;
    print("Editing trigger: " + before + " -> " + after);
    triggersText = triggersArray.join('\n');
    file.writeAsString('${triggersText}', mode: io.FileMode.write);

    dataProcessingService.initializeTriggers();
  }

  void initializeSettingsFile(bool reset) async {
    final settingsFile = await _settingsValuesFile;
    if(reset){
      String xmlBody = await rootBundle.loadString('assets/settings/settingsValues.xml');
      settingsFile.writeAsString(xmlBody);
    }
    try {
      settingsFile.readAsStringSync();
      print("Settings file exists");
    } catch (e) {
      print("Settings file needs to be created\nCreating from assets/settingsValues.xml");
      String xmlBody = await rootBundle.loadString('assets/settings/settingsValues.xml');
      settingsFile.writeAsString(xmlBody);
    }
  }

  Future<io.File> get _settingsValuesFile async {
    final filePath = await _localPath;
    return io.File(filePath + '/settingsValues.xml');
  }

  Future<String> getSettingsValue(String setting) async {
    late final io.File file;
    String xmlBody = '';
    try {
      file = await _settingsValuesFile;
      xmlBody = await file.readAsString();
      var xmlFile = xml.XmlDocument.parse(xmlBody);
      var element = xmlFile.findElements('settings').first.findElements(setting);

      return element.first.innerText;

    } catch (e) {
      String errorMessage = 'An error has occurred while retrieving settings. MORE INFO: ' + e.toString();
      print(errorMessage);
      return errorMessage;
    }
  }

  void setSettingsValue(String setting, String value) async {
    try {
      final file = await _settingsValuesFile;
      String xmlBody = await file.readAsStringSync();
      String newValue = value;

      var xmlFile = xml.XmlDocument.parse(xmlBody);
      if(setting.startsWith('font') && int.parse(value) < 15){
        newValue = '15';
        print('Cannot set value to ' + value + ' changing to ' + newValue);
      } else if (setting == 'saveNoteDuration' && int.parse(value) < 1) {
        newValue = '1';
        print('Cannot set value to ' + value + ' changing to ' + newValue);
      }
      value = newValue;

      xmlFile.findElements('settings').first.findElements(setting).first.innerText = value;
      file.writeAsString(xmlFile.toString());
    } catch (e) {
      String errorMessage = 'An error has occurred while retrieving settings. MORE INFO: ' + e.toString();
      print(errorMessage);
    }
  }

  void cleanupNotes() async {
    List<String> notesToBeDeleted = List.empty(growable: true);
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    int days = int.parse(await getSettingsValue('saveNoteDuration'));
    DateTime deleteTimeframe = formatter.parse(formatter.format((DateTime.now().subtract(Duration(days: days)))));
    try {
      String editContent = await readNotes();
      var editFile = xml.XmlDocument.parse(editContent);
      var noteElements = editFile.findAllElements('note');
      for (var note in noteElements) {
        String noteTs = note.findElements('timestamp').first.innerText;
        String noteId = note.findElements('id').first.innerText;
        DateTime noteTimestamp = formatter.parse(noteTs);
        bool delete = noteTimestamp.isBefore(deleteTimeframe);
        Duration duration = deleteTimeframe.difference(noteTimestamp);
        if(delete){
          print('Setting note to be deleted: "' + noteId + '", Timestamp: ' + noteTimestamp.toString());
          notesToBeDeleted.add(noteId);
        }
      }
      deleteMultipleNotes(notesToBeDeleted);
    } catch (e) {
      print('An error has occurred while cleaning up notes. MORE INFO: ' + e.toString());
    }
  }

  void deleteMultipleNotes(List<String> ids) async {
    try {
      String xmlContent = await readNotes();
      xml.XmlDocument fileXML = xml.XmlDocument.parse(xmlContent);
      var nodes = fileXML.findAllElements('note');
      final file = await _noteFile;
      for (var node in nodes) {
        if (ids.contains(node.firstChild!.innerText)) {
          fileXML.getElement('notes')!.children.remove(node);
        }
      }
      file.writeAsStringSync(fileXML.toXmlString());
    } catch (e) {
      print('An error has occurred while deleting notes for cleanup.' + e.toString());
    }
    dataProcessingService.initializeUserNotes();
  }

  Future<Iterable<xml.XmlElement>> getHowToVideoLinks() async {
    String xmlBody = '';
    try {
      xmlBody = await rootBundle.loadString('assets/how_to_videos/howToVideoLinks.xml');
      var xmlFile = xml.XmlDocument.parse(xmlBody);
      var elements = xmlFile.findElements('videos').first.findElements('video');

      return elements;

    } catch (e) {
      String errorMessage = 'An error has occurred while retrieving video links. MORE INFO: ' + e.toString();
      print(errorMessage);
      return Iterable.empty();
    }
  }
}
