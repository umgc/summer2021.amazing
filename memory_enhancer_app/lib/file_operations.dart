//********************************************
// File Operations
// Author: Ayodeji Fahumedin
// Modified by: Chauntika Broggin, Mo Drammeh
//********************************************
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart' as xml;

import 'notes.dart';

/// File operations for the Memory Enhancer app.
class FileOperations {
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

  /// Writes notes to file.
  Future writeNoteToFile(Note note) async {
    String message = "Data saved to file.";
    try {
      String xmlString = await readNotes(); // Read notes file
      var fileXML = xml.XmlDocument.parse(xmlString); // Parse data
      final builder = xml.XmlBuilder(); // Builder for XML
      note.buildNote(builder); // Build note

      // Adding note to XML file
      fileXML.firstElementChild!.children.add(builder.buildFragment());
      final file = await _noteFile;
      await file.writeAsString(fileXML.toString()); // Get notes XML file
      print(message); // Print that the note was saved.
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
      await writeNoteToFile(textNote);
    }
  }

  // Create note from typing in note
  void writeNewNote(String data, BuildContext context) {
    if (data.isNotEmpty) {
      Note note = Note('', DateTime.now(), data); // Make new Note object.
      writeNoteToFile(note); // Save to file.
      showAlertBox(
          'Note Created', 'Your note was successfully saved.', context);
    } else {
      print('Note cannot be empty');
      showAlertBox(
          'Note Empty', 'You cannot save a note without content.', context);
    }
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
  void speakNote(String data, BuildContext context) async {
    // If data is not empty , make a Note object and save to file
    if (data.isNotEmpty) {
      Note note = Note('', DateTime.now(), data); // New Note
      writeNoteToFile(note); // Save Note to file
      // Display alert to user that note recorded.
      showAlertBox(
          'Note Recorded', 'Your note was recorded successfully', context);
    } else {
      // else error occurred recording note
      print('Error has occurred. Note was not recorded.');
      // Display alert dialog that note was not recorded.
      showAlertBox(
          'Note Not Recorded',
          'Your note was not recorded. Please visit the Help page for assistance.',
          context);
    }
  }

  // Create initial notes file
  void initialNoteFile() async {
    try {
      final file = await _noteFile;
      if (await file.exists()) {
        print('File already exists');
      } else {
        Note note = Note('', DateTime.now(), "Sample note.");
        note.createFile();
        print('Notes file created.');
      }
    } catch (e) {
      print('An error occured. MORE INFO: ' + e.toString());
    }
  }

  /// Edits notes in notes file.
  void editNote(String id, String edits, BuildContext context) async {
    try {
      String editContent = await readNotes(); // Read notes from file
      var editFile = xml.XmlDocument.parse(editContent); // Parses data
      var elements =
          editFile.findAllElements('note'); // Collects all the note items
      // Check each note to see if it has a matching id number.
      for (var e in elements) {
        // If it does, get the body content of the note and replace with user changes
        if (e.findElements('id').first.text == id) {
          e.findElements('content').first.innerText = edits;
          final file = await _noteFile;
          file.writeAsString(editFile.toString());
          // Display alert box for edit saving confirmation.
          showAlertBox(
              'Note Saved', 'The edits were saved successfully.', context);
        }
      }
    } catch (e) {
      print('An error has occured. MORE INFO: ' + e.toString());
    } // catch
  }

  // Delete note.
  void deleteNote(String id, BuildContext context) async {
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
          } else {
            Note sampleNote = Note(
                '', DateTime.now(), 'Sample Note.\nPlease add your own note.');
            writeNoteToFile(sampleNote);
            node.parent!.children.remove(node);
          }
          print('Note deleted.');
          file.writeAsString(fileXML.toString());
            showAlertBox('Note Deleted', 'The note was successfully deleted',
                context); // Show deletion confirmation box.
        } else {
          // else tell user the note was not found
          print('No note found.');
        } // End if..else
      } // End for in loop
    } catch (e) {
      // if there is a file or parsing error, print error
      print('An error has occurred.' + e.toString());
    } // End try...catch
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
      print("Start triggers file needs to be created\nCreating from assets/words.txt");
      String initFile = await rootBundle.loadString('assets/text/words.txt');
      startFile.writeAsString(initFile);
    }
    try {
      stopFile.readAsStringSync();
      print("Stop triggers file exists");
    } catch (e) {
      print("Stop triggers file needs to be created\nCreating from assets/words.txt");
      String initFile = await rootBundle.loadString('assets/text/words.txt');
      stopFile.writeAsString(initFile);
    }
    try {
      recallFile.readAsStringSync();
      print("Recall triggers file exists");
    } catch (e) {
      print("Recall triggers file needs to be created\nCreating from assets/words.txt");
      String initFile = await rootBundle.loadString('assets/text/words.txt');
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
    // file = await _startTriggersFile;
    List<String> triggersArray = file.readAsLinesSync();
    if(!triggersArray.contains(text.trim())) {
      file.writeAsString('\n${text}', mode: io.FileMode.append);
      print("Trigger added: " + text);
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

      var xmlFile = xml.XmlDocument.parse(xmlBody);
      xmlFile.findElements('settings').first.findElements(setting).first.innerText = value;
      file.writeAsString(xmlFile.toString());
    } catch (e) {
      String errorMessage = 'An error has occurred while retrieving settings. MORE INFO: ' + e.toString();
      print(errorMessage);
    }
  }

  void cleanupNotes() async {
    DateTime now = DateTime.now();
    int days = int.parse(await getSettingsValue('saveNoteDuration'));
    var deleteTimeframe = now.subtract(Duration(days: days));
    try {
      String editContent = await readNotes();
      var editFile = xml.XmlDocument.parse(editContent);
      var noteElements = editFile.findAllElements('note');
      for (var note in noteElements) {
        String noteTs = note.findElements('timestamp').first.innerText;
        String noteId = note.findElements('id').first.innerText;
        DateTime noteTimestamp = DateTime.parse(noteTs);
        bool delete = noteTimestamp.isBefore(deleteTimeframe);
        if(delete){
          print('Deleting note "' + noteId + '", Timestamp: ' + noteTimestamp.toString());
          deleteCleanupNote(noteId);
        }
      }
    } catch (e) {
      print('An error has occurred. MORE INFO: ' + e.toString());
    }
  }

  // Delete notes based on time created
  void deleteCleanupNote(String id) async {
    try {
      String xmlContent = await readNotes();
      var fileXML = xml.XmlDocument.parse(xmlContent.toString());
      var nodes = fileXML.findAllElements('note');
      for (var node in nodes) {
        if (node.findElements('id').first.text == id) {
          final file = await _noteFile;
          if (nodes.length >=0) {
            node.parent!.children.remove(node);
            print('Note "' + id + '" deleted.');
            file.writeAsString(fileXML.toString());
          }
        } else {
          print('No note found with ID "' + id + '"');
        }
      }
    } catch (e) {
      print('An error has occurred.' + e.toString());
    }
  }
}
