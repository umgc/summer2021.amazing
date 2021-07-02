//********************************************
// File Operations
// Author: Ayodeji Fahumedin
// Modified by: Chauntika Broggin
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

  /*/// Gets trigger word file from application document directory.
  Future<io.File> get _localFile async {
    final filePath = await _localPath;
    return io.File('${filePath}/words.txt');
  }*/

  /// Gets notes file from application document directory.
  Future<io.File> get _noteFile async {
    final filePath = await _localPath;
    return io.File('${filePath}/notes.txt');
  }

  /// Reads trigger keywords from file.
  Future<String> readTriggers() async {
    return await rootBundle.loadString('assets/text/words.txt');
  }

  /// Reads notes from file.
  Future<String> readNotes() async {
    return await rootBundle.loadString('assets/text/notes.txt');
  }

  // Record notes to file.
  Future recordNotes(String keywords, String content) async {
    var _triggerList = keywords.split('\n'); // Makes array of trigger words.
    print(_triggerList
        .join('\n')); // temporary so I can see if my array is populated
    var exist = false; // boolean to see if word is in triggerList array
    // Checks to see if word is in triggerList array.
    for (var word in _triggerList) {
      if (content.contains('dinner')) {
        exist = true;
        break;
      }
    }
    // If word is present in array, then write content to file.
    if (exist) {
      await writeData('notes', content);
    } else {
      // else, print content was not saved.
      print('Did not save to file.');
    }
  }

  /*/// Delete content of file.
  Future deleteContents() async {
    final file = await _noteFile;
    file.writeAsString(' ');
  }*/

  /// Writes data to file.
  Future writeData(String name, String data) async {
    final file;
    String message = "Data saved to file.";
    if (name == 'triggers') {
      file = io.File('assets/text/words.txt');
      await file.writeAsString('${data}\n', mode: io.FileMode.append);
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
