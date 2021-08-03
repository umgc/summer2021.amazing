//**************************************************************
// Settings view UI
// Author:
//**************************************************************
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/notes.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

class NoteView extends StatefulWidget {
  final Note note;
  NoteView(this.note, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  double fontSizeNotes = 15;

  @override
  void initState() {
    fileOperations.getSettingsValue('fontSizeNote').then((String value) {
      setState(() {
        fontSizeNotes = double.parse(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: CustomAppBarPopup(title: 'View Note'),
            body: ListView(children: [
              Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text(widget.note.noteDate, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)))),
              Divider(thickness: 3),
              Padding(padding: EdgeInsets.all(10.0), child: Text(widget.note.noteBody, style: TextStyle(fontSize: fontSizeNotes)))],),
        bottomNavigationBar:
              BottomNavigationBarController(pageIndex: PageEnums.notes.index),
          );
  }
}
