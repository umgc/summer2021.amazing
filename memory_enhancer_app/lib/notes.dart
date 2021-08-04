//********************************************
// Notes Class
// Author: Chauntika Broggin
//********************************************
import 'package:memory_enhancer_app/services/services.dart';
import 'package:xml/xml.dart' as xml;
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';

class Note {
  String noteID = '';
  var noteDate;
  String noteBody = '';

  Note(noteID, this.noteDate, this.noteBody) {
    if (noteID == '') {
      noteID = nanoid(3);
      this.noteID = noteID;
    } else {
      this.noteID = noteID;
    }
  }

  factory Note.fromXml(xml.XmlElement xml) {
    return Note(
        xml.findElements('id').single.text,
        xml.findElements('timestamp').single.text,
        xml.findElements('content').single.text);
  }

  /*factory Note.fromXML(Map<String, dynamic> xml) {
    return Note(xml['id'], xml['timestamp'], xml['content']);
  }*/

  get id => this.noteID;
  get timestamp => this.noteDate;
  get body => this.noteBody;

  // Custom toString method for note class
  @override
  String toString() {
    var noteDocument = newNoteBuilder();
    return noteDocument.toString();
  }

  // HELPER METHODS //
  // XML Structure Builder
  noteBuilder() {
    final DateTime now = noteDate;
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now);
    final builder = new xml.XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('notes', nest: () {
      builder.element('note', nest: () {
        builder.element('id', nest: () {
          builder.text(noteID);
        });
        builder.element('timestamp', nest: () {
          builder.text(formattedDate);
        });
        builder.element('content', nest: () {
          builder.text(noteBody);
        });
      });
    });
    final noteFileXML = builder.buildDocument();
    return noteFileXML;
  }

  newNoteBuilder() {
    final DateTime now = noteDate;
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String formatDate = formatter.format(now);
    final builder = new xml.XmlBuilder();
    builder.element('note', nest: () {
      builder.element('id', nest: () {
        builder.text(noteID);
      });
      builder.element('timestamp', nest: () {
        builder.text(formatDate);
      });
      builder.element('content', nest: () {
        builder.text(noteBody);
      });
    });
    final noteFileXML = builder.buildDocument();
    return noteFileXML;
  }

  buildNote(xml.XmlBuilder builder) {
    final DateTime now = noteDate;
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    String formattedDate = formatter.format(now);
    builder.element('note', nest: () {
      builder.element('id', nest: () {
        builder.text(noteID);
      });
      builder.element('timestamp', nest: () {
        builder.text(formattedDate);
      });
      builder.element('content', nest: () {
        builder.text(noteBody);
      });
    });
  }

  // Create notes file
  void createFile() async {
    try {
      final file = await fileOperations.getNotesFile();
      if (await file.exists()) {
        print('File already exists');
      } else {
        var noteDocument = noteBuilder();
        file.writeAsString(noteDocument.toString());
      }
    } catch (e) {
      print('An error occurred. MORE INFO: ' + e.toString());
    }
  }

  // Create instance of Note object
  Note createNote(DateTime time, String data) {
    Note textNote = Note('', time, data);
    return textNote;
  }
}
