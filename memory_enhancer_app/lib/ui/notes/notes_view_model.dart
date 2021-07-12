//**************************************************************
// Notes view model
// Author:
//**************************************************************
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:xml/xml.dart' as xml;

import '../../notes.dart';

List<Note> memos = List.empty(growable: true); // Empty array for notes array

// Get content from notes file to display on page.
// XML parser is used to parse info from notes.xml file.
Future<List<Note>> getContent() async {
  String xmlContent = await fileOperations.readNotes();
  xml.XmlDocument xmlTextDoc = xml.XmlDocument.parse(xmlContent);
  final memo = xmlTextDoc
      .findAllElements('note')
      .map((xml) => Note.fromXml(xml))
      .toList();
  /*xml.XmlDocument xmlTextDoc = xml.XmlDocument.parse(xmlContent);
  var elements = xmlTextDoc.findAllElements('note');
  for (xml.XmlNode e in elements) {
    String id = e.findElements('id').first.text;
    String dateTime = e.findElements('timestamp').first.text;
    String body = e.findElements('content').first.text;
    Note note = Note(id, dateTime, body);
    memo.add(note);
  }*/
  return memo;
}

class NotesViewModel extends BaseViewModel {
  void initialize() {}

  @override
  void dispose() {
    super.dispose();
  }
}
