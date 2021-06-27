import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

/// File operations for the Memory Enhancer app.
class FileOperations {
  /// Gets path to local application document directory.
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Gets trigger word file from application document directory.
  Future<io.File> get _localFile async {
    final filePath = await _localPath;
    return io.File('${filePath}/trigger_words.txt');
  }

  /// Gets notes file from application document directory.
  Future<io.File> get _noteFile async {
    final filePath = await _localPath;
    return io.File('${filePath}/notes.txt');
  }

  /// Reads data from file.
  Future<String> readData(String data) async {
    try {
      final file;
      if (data == 'triggers') {
        file = await _localFile;
      } else if (data == 'notes') {
        file = await _noteFile;
      } else {
        file = await _localFile;
        print('No data read.');
      }
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  /// Delete content of file.
  Future deleteContents() async {
    final file = await _noteFile;
    file.writeAsString(' ');
  }

  /// Reads trigger words from trigger word file.
  Future<String> readTriggers() async {
    try {
      final file = await _localFile;
      String body = await file.readAsString();
      return body;
    } catch (e) {
      return e.toString();
    }
  }

  /// Writes data to file.
  Future<io.File> writeData(String name, String data) async {
    final file;
    if (name == 'triggers') {
      file = await _localFile;
      await file.writeAsString('${data}\n');
    } else if (name == 'notes') {
      file = await _noteFile;
      await file.writeAsString('${data}...End note\n');
    } else {
      file = await _localFile;
      print('No data saved.');
    }
    print('Data saved to file.');
    return file;
  }
}
