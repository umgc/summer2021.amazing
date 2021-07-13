//**************************************************************
// Settings view UI
// Author:
//**************************************************************
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/app/app_router.gr.dart';

import 'package:memory_enhancer_app/services/services.dart';
import 'package:stacked/stacked.dart';

import 'package:memory_enhancer_app/notes.dart';
import 'notes_view_model.dart';
import 'package:xml/xml.dart' as xml;
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesView extends StatefulWidget {
  NotesView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  TextEditingController _ntTxtControl = TextEditingController();
  List<Note> notes = List.empty(growable: true);

  getNoteContent() => getContent().then((value) {
        setState(() {
          notes = value;
        });
      });

  @override
  void initState() {
    getNoteContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getContent().then((value) {
      setState(() {
        notes = value;
      });
    });
    return ViewModelBuilder<NotesViewModel>.reactive(
        viewModelBuilder: () => NotesViewModel(),
        onModelReady: (model) {
          //model.initialize();
          getContent();
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Notes'),
            body: notes.isEmpty
                ? Center(
                    child: Text(
                    'There are no notes saved at this time. Please click on the "Write Note" button to type a note or the "Record Note" button to record a note.',
                    style: GoogleFonts.roboto(fontSize: 35),
                    textAlign: TextAlign.center,
                  ))
                : Center(
                    child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: notes.length,
                        reverse: false,
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            indent: 20,
                            endIndent: 20,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                _ntTxtControl.text = notes[index].noteBody;
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            contentTextStyle:
                                                GoogleFonts.anton(fontSize: 14),
                                            title: Text('Edit Note'),
                                            content: TextField(
                                                controller: _ntTxtControl),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  _ntTxtControl.clear();
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('CANCEL',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20)),
                                              ),
                                              TextButton(
                                                  child: Text('SAVE',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20)),
                                                  onPressed: () {
                                                    fileOperations.editNote(
                                                        notes[index].id,
                                                        _ntTxtControl.text,
                                                        context);
                                                    _ntTxtControl.clear();
                                                    getContent();
                                                    Navigator.pop(context);
                                                  })
                                            ]));
                              },
                              child: Card(
                                  child: Container(
                                      padding: const EdgeInsets.all(8),
                                      color: Colors.grey[200],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Text(
                                                  notes[index].timestamp +
                                                      '\n' +
                                                      notes[index].noteBody,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 20,
                                                      textStyle: TextStyle(
                                                          height: 1.5)))),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            color: Colors.red,
                                            iconSize: 35,
                                            onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                titleTextStyle:
                                                    GoogleFonts.roboto(
                                                        fontSize: 20),
                                                contentTextStyle:
                                                    GoogleFonts.roboto(
                                                        fontSize: 20),
                                                title: const Text(
                                                    'Delete Confirmation',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                content: const Text(
                                                    'You are about to delete this note. Are you sure?',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20)),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'NO'),
                                                    child: const Text('NO',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      fileOperations.deleteNote(
                                                          notes[index].id,
                                                          context);
                                                      getContent().then(
                                                          (value) =>
                                                              notes = value);
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text('YES',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20)),
                                                  ),
                                                ],
                                              ),
                                            ), // ShowDialog
                                          )
                                        ], // Children
                                      ))));
                        } // itemBuilder
                        ),
                  ),
            bottomNavigationBar:
                BottomNavigationBarController(pageIndex: PageEnums.notes.index),
            persistentFooterButtons: [
              Center(
                  child: Row(children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: lightTheme.accentColor),
                        child: Text('Write Note',
                            style: GoogleFonts.roboto(fontSize: 20)),
                        onPressed: () {
                          // Show text field for writing new note.
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  alert(context));
                        }))
              ])),
            ],
          );
        });
  }

  // Write New Note
  alert(BuildContext context) {
    // set up the AlertDialog
    return AlertDialog(
      contentTextStyle: GoogleFonts.anton(fontSize: 14),
      title: Text('Write Note'),
      content: TextField(
        controller: _ntTxtControl,
      ),
      actions: [
        TextButton(
          onPressed: () {
            _ntTxtControl.clear();
            Navigator.pop(context);
          },
          child: const Text('CANCEL',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        TextButton(
          child: Text('SAVE',
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          onPressed: () {
            Navigator.pop(context);
            fileOperations.writeNewNote(_ntTxtControl.text, context);
            getContent();
            _ntTxtControl.clear();
          },
        )
      ],
    );
  } // End Write Note Alert

} // End Widget
