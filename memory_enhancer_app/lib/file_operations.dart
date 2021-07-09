//********************************************
// File Operations
// Author: Ayodeji Fahumedin
// Modified by: Chauntika Broggin, Mo Drammeh
//********************************************
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

/// File operations for the Memory Enhancer app.
class FileOperations {

  /// Gets path to local application document directory.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Gets trigger word file from application document directory.
  Future<io.File> get _triggersFile async {
    final filePath = await _localPath;
    return io.File('${filePath}/triggerWords.txt');
  }

  /// Gets notes file from application document directory.
  Future<io.File> get _noteFile async {
    final filePath = await _localPath;
    return io.File('${filePath}/notes.txt');
  }

  /// Reads trigger keywords from file.
  Future<String> readTriggers() async {
    try {
      final file = await _triggersFile;
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      print("[ERROR] " + e.toString());
      return '[ERROR] Problem reading trigger words file.';
    }
  }

  /// Reads notes from file.
  Future<String> readNotes() async {
    final file = await _noteFile;
    String body = await file.readAsString();
    return body;
  }

  // Record notes to file.
  Future recordNotes(String keywords, String content) async {
    /*var _triggerList = keywords.split('\n'); // Makes array of trigger words.
    print(_triggerList
        .join('\n')); // temporary so I can see if my array is populated 
        var exist = false; // boolean to see if word is in triggerList array   
    // Checks to see if word is in triggerList array.
    for (var word in _triggerList) { 
      if (content.contains(word)){
        exist = true;
        break;
      }
      if (exists) {
        await writeData('notes', content);
      }else {
      // else, print content was not saved.
      print('Did not save to file.');
    }
    }*/

    if (content.contains('dinner') || content.contains('So you are saying')) {
      await writeData('notes', content);
    }
  }

  void initializeTriggersFile() async {
    final file = await _triggersFile;
    try {
      final contents = file.readAsStringSync();
      print("Triggers file exists");
    } catch (e) {
      print("Triggers file needs to be created\nCreating from assets/words.txt");
      String initFile = await rootBundle.loadString('assets/text/words.txt');
      file.writeAsString(initFile);
    }
  }

  /// Add trigger word to file.
  Future addTrigger(String text) async {
    final file = await _triggersFile;
    List<String> triggersArray = file.readAsLinesSync();
    if(!triggersArray.contains(text)) {
      file.writeAsString('\n${text}', mode: io.FileMode.append);
      print("Trigger added: " + text);
    } else {
      print(text + " is already a trigger");
    }
  }

  /// Delete trigger word from file.
  Future deleteTrigger(String text) async {
    final file = await _triggersFile;

    String triggersText = file.readAsStringSync();
    List<String> triggersArray = triggersText.trimLeft().split("\n");
    triggersArray.remove(text);
    print("Trigger removed: " + text);

    triggersText = triggersArray.join('\n');
    file.writeAsString('${triggersText}', mode: io.FileMode.write);

  }

  /// Edit trigger word from file.
  Future editTrigger(String before, String after) async {
    final file = await _triggersFile;

    String triggersText = file.readAsStringSync();
    List<String> triggersArray = triggersText.trimLeft().split("\n");

    triggersArray[triggersArray.indexOf(before)] = after;
    print("Editing trigger: " + before + " -> " + after);
    triggersText = triggersArray.join('\n');
    file.writeAsString('${triggersText}', mode: io.FileMode.write);
  }

  /// Writes data to file.
  Future writeData(String name, String data) async {
    final file;
    String message = "Data saved to file.";
    if (name == 'triggers') {
      file = await _triggersFile;
      file.writeAsString('\n${data}', mode: io.FileMode.append);
      print(message);
    } else if (name == 'notes') {
      file = await _noteFile;
      await file.writeAsString('${data}...End note\n',
          mode: io.FileMode.append);
      print(message);
      String reminder = await file.readAsString();
      print(reminder);
    } else {
      print('No data saved.');
    }
  }
}
