//**************************************************************
// Notes View UI
// Author: Chauntika Broggin
//**************************************************************
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/alert/alert_popup.dart';
import 'package:memory_enhancer_app/ui/list_item/list_item_dynamic.dart';
import 'package:memory_enhancer_app/ui/notes/search_notes_view.dart';
import 'package:stacked/stacked.dart';

import 'package:memory_enhancer_app/notes.dart';
import 'note_view.dart';
import 'notes_view_model.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesView extends StatefulWidget {
  NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  final GlobalKey<ScaffoldState> _noteScaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _ntTxtControl = TextEditingController();
  List<Note> notes = List.empty(growable: true);

  // Subject note arrays
  List<Note> personalNotes = <Note>[];
  List<Note> dinnerNotes = <Note>[];
  List<Note> lunchNotes = <Note>[];
  List<Note> familyNotes = <Note>[];
  List<Note> medicalNotes = <Note>[];
  List<Note> otherNotes = <Note>[];
  List<Subject> _subjects = [];

  double fontSizePlaceholder = 35;
  double fontSizeMenu = 20;

  getNoteContent() =>
      getContent().then((value) {
        setState(() {
          notes = value;
          updateSubjectLists();
        });
      });

  @override
  void initState() {
    fileOperations.cleanupNotes();
    getNoteContent();
    fileOperations.getSettingsValue('fontSizeMenu').then((String value) {
      setState(() {
        fontSizeMenu = double.parse(value);
      });
    });
    fileOperations.getSettingsValue('fontSizePlaceholder').then((String value) {
      setState(() {
        fontSizePlaceholder = double.parse(value);
      });
    });
    setState(() {
      _subjects = [
        // Subject(1, 'Conversation', 'conversations+talk+speak+phone+call'),
        Subject(
            1,
            'Personal',
            [
              'personal',
              'ssn',
              'social security',
              'number',
              'insurance',
              'address',
              'work',
              'shopping',
              'grocery',
              'birthday',
              'exercise',
              'nutrition'
            ],
            personalNotes),
        Subject(2, 'Dinner', ['dinner', 'restaurant', 'food'],
            dinnerNotes),
        Subject(3, 'Lunch',
            ['lunch', 'food', 'eat', 'afternoon', 'restaurant'],
            lunchNotes),
        Subject(
            4,
            'Family and Friends',
            [
              'family',
              'friend',
              'friends',
              'mom',
              'dad',
              'son',
              'daughter',
              'father',
              'sister',
              'brother',
              'husband',
              'wife',
              'partner',
              'granddaughter',
              'grandson',
              'wedding',
              'funeral'
            ],
            familyNotes),
        Subject(
            5,
            'Medical',
            [
              'medical',
              'medicine',
              'dr.',
              'doctor',
              'hospital',
              'appointment',
              'sick',
              'illness',
              'insurance',
              'surgery',
              'medication',
              'procedure'
            ],
            medicalNotes),
        Subject(
            6,
            'Other',
            [],
            otherNotes),
      ];
    });
    updateSubjectLists();
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      updateSubjectLists();
      getNoteContent();
    });
  }

  @override
  void dispose() {
    _ntTxtControl.dispose();
    super.dispose();
  }

  // Update note lists.
  void updateSubjectLists() {
    setState(() {
      personalNotes = subjectNoteLists(_subjects[0].subjectID);
      dinnerNotes = subjectNoteLists(_subjects[1].subjectID);
      lunchNotes = subjectNoteLists(_subjects[2].subjectID);
      familyNotes = subjectNoteLists(_subjects[3].subjectID);
      medicalNotes = subjectNoteLists(_subjects[4].subjectID);
      otherNotes = subjectNoteLists(_subjects[5].subjectID);
    });
  }

  // Populating subject note lists
  List<Note> subjectNoteLists(int id) {
    personalNotes.clear();
    dinnerNotes.clear();
    lunchNotes.clear();
    familyNotes.clear();
    medicalNotes.clear();
    otherNotes.clear();
    if (id != 0) {
      for (var n in notes) {
        bool addNote = true;
        for (var t in _subjects[0].topics) {
          if (addNote && n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!personalNotes.contains(n)) {
              personalNotes.add(n);
              addNote = false;
            } else {
              print('Note already found');
            }
          }
        }
        for (var t in _subjects[1].topics) {
          if (addNote && n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!dinnerNotes.contains(n)) {
              dinnerNotes.add(n);
              addNote = false;
            } else {
              print('Note already found');
            }
          }
        }
        for (var t in _subjects[2].topics) {
          if (addNote && n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!lunchNotes.contains(n)) {
              lunchNotes.add(n);
              addNote = false;
            } else {
              print('Note already found');
            }
          }
        }
        for (var t in _subjects[3].topics) {
          if (addNote && n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!familyNotes.contains(n)) {
              familyNotes.add(n);
              addNote = false;
            } else {
              print('Note already found');
            }
          }
        }
        for (var t in _subjects[4].topics) {
          if (addNote && n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!medicalNotes.contains(n)) {
              medicalNotes.add(n);
              addNote = false;
            } else {
              print('Note already found');
            }
          }
        }
        if (addNote && !otherNotes.contains(n)){
          otherNotes.add(n);
        }
      }
    }

    switch (id) {
      case 1:
        return personalNotes;
      case 2:
        return dinnerNotes;
      case 3:
        return lunchNotes;
      case 4:
        return familyNotes;
      case 5:
        return medicalNotes;
      case 6:
        return otherNotes;
      default:
        return notes;
    }
  } // #End of subjectNoteLists()

  // Build note subject expansion panels.
  ExpansionPanel _buildPanel(Subject subject, NotesViewModel model) {
    return ExpansionPanel(
        isExpanded: subject.isExpanded,
        backgroundColor: Colors.grey[50],
        canTapOnHeader: true,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Container(
            child: ListTile(
              title: Text(subject.headerName,
                  style: GoogleFonts.anton(fontSize: fontSizeMenu)),
              subtitle: Text('Notes about ${subject.headerName.toLowerCase()}'),
            ),
          );
        },
        body: SingleChildScrollView(
            child: SizedBox(
                height: 200,
                child: noteLists(subject, subject.subjectID, model))));
  } // #End Expansion panels

  noteLists(subject, int id, NotesViewModel model) {
    // ignore: unnecessary_null_comparison
    return subjectNoteLists(id).isEmpty
        ? Text('No notes at this time.', style: TextStyle(fontSize: 20))
        : new ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: subjectNoteLists(id).length > 0
            ? subjectNoteLists(id).length
            : 0,
        itemBuilder: (BuildContext context, int index) {
          return CustomEditDeleteMenuItem(
              title: subjectNoteLists(id)[index].noteBody.isNotEmpty
                  ? subjectNoteLists(id)[index].noteBody
                  : 'There are no notes available.',
              onLongPress: () {
                viewNote(context, subjectNoteLists(id)[index]);
              },
              onEdit: () {
                _ntTxtControl.text = subjectNoteLists(id)[index].body;
                getNoteContent();
                updateSubjectLists();
                showDialog(
                  context: _noteScaffoldKey.currentContext!,
                  builder: (BuildContext _context) {
                    return CustomAlertTwoButton(
                        title: 'EDIT NOTE',
                        content: TextField(controller: _ntTxtControl, maxLines: null),
                        actionOneText: 'CANCEL',
                        actionOnePressed: (){
                          Navigator.pop(_context);
                          _ntTxtControl.clear();
                        },
                        actionTwoText: 'SAVE',
                        actionTwoPressed: (){
                          if(_ntTxtControl.text.isNotEmpty) {
                            fileOperations.editNote(subjectNoteLists(id)[index]
                                .noteID, _ntTxtControl.text);
                            // model.onEdit(subjectNoteLists(id)[index].noteID, _ntTxtControl.text);
                            setState(() {
                              getNoteContent();
                              updateSubjectLists();
                              model.notifyListeners();
                              subject.isExpanded = false;
                            });
                            Navigator.pop(_context);
                            _ntTxtControl.clear();
                            showAlertBox('NOTE EDITED',
                                'The note was edited successfully', context);
                          }
                        });
                  });
              },
              onDelete: () {
                showDialog (
                    context: context,
                    builder: (BuildContext context) {
                      return CustomAlertTwoButton(
                          title: 'DELETE NOTE?',
                          content: Text(subjectNoteLists(id)[index].noteBody,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                          actionOneText: 'CANCEL',
                          actionOnePressed: (){
                            Navigator.pop(context);
                          },
                          actionTwoText: 'DELETE',
                          actionTwoPressed: (){
                            fileOperations.deleteNote(subjectNoteLists(id)[index].noteID);
                            setState(() {
                              getNoteContent();
                              updateSubjectLists();
                              model.notifyListeners();
                              subject.isExpanded = false;
                            });
                            Navigator.pop(context);
                            showAlertBox('NOTE DELETED', 'The note was deleted successfully', context);
                          });
                    });
                getNoteContent();
                updateSubjectLists();
              },
              fontSizeMenu: fontSizeMenu,
              subtitle: subjectNoteLists(id)[index].noteDate);
        });
  } // #End of Note List View Lists

  // Write New Note
  Widget writeNoteAlert(BuildContext context, NotesViewModel model) {
    return CustomAlertTwoButton(
        title: 'WRITE NEW NOTE',
        content: TextField(controller: _ntTxtControl, maxLines: null),
        actionOneText: 'CANCEL',
        actionOnePressed: (){
          _ntTxtControl.clear();
          Navigator.pop(context);
        },
        actionTwoText: 'SAVE',
        actionTwoPressed:  (){
          if(_ntTxtControl.text.isNotEmpty) {
            updateSubjectLists();
            fileOperations.writeNewNote(_ntTxtControl.text, context);

            setState(() {
              getNoteContent();
              updateSubjectLists();
              model.notifyListeners();
            });
            model.notifyListeners();
            _ntTxtControl.clear();
            Navigator.pop(context);
            showAlertBox(
                'NOTE CREATED', 'The note was created successfully', context);
          }
        });
  } // End Write Note Alert

  @override
  Widget build(BuildContext context) {
    updateSubjectLists();
    getContent().then((value) => notes = value);
    return ViewModelBuilder<NotesViewModel>.reactive(
        viewModelBuilder: () => NotesViewModel(),
        onModelReady: (model) {
          model.initialize();
        },
        builder: (context, model, child) {
          return Scaffold(
            key: _noteScaffoldKey,
            appBar: CustomAppBar(title: PageEnums.notes.name,
                actions: [IconButton(onPressed:(){
                  searchNotes(context);
                  }, icon: Icon(Icons.search))]),
            bottomSheet: Container(
                height: 30,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Text(
                  'Please long press on note to view more',
                  style: TextStyle(fontSize: 16),
                )),
            body: SingleChildScrollView(
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _subjects[index].isExpanded = !isExpanded;
                    });
                  },
                  animationDuration: Duration(seconds: 1),
                  dividerColor: Colors.red,
                  elevation: 4,
                  expandedHeaderPadding: EdgeInsets.all(8),
                  children: [
                    //_subjects.map((e) => _buildPanel(e)).toList(),
                    _buildPanel(_subjects[0], model),
                    _buildPanel(_subjects[1], model),
                    _buildPanel(_subjects[2], model),
                    _buildPanel(_subjects[3], model),
                    _buildPanel(_subjects[4], model),
                    _buildPanel(_subjects[5], model),
                  ],
                )),
            bottomNavigationBar:
            BottomNavigationBarController(pageIndex: PageEnums.notes.index),
            persistentFooterButtons: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: lightTheme.accentColor),
                    child: Text('Write Note',
                        style: GoogleFonts.anton(fontSize: 25)),
                    onPressed: () {
                      // Show text field for writing new note.
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              writeNoteAlert(context, model));
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: lightTheme.accentColor),
                    child: Text(
                        !model.listening ? 'Record Note' : 'Stop Record',
                        style: GoogleFonts.anton(fontSize: 25)),
                    onPressed: () {
                      model.handleListening();
                    })
              ]),
            ],
          );
        });
  }

  Future viewNote(BuildContext context, Note note) async {
    Navigator.of(context).push(new MaterialPageRoute<NotesView>(
        builder: (BuildContext context) {
          return new NoteView(note);
        },
        fullscreenDialog: true));
  }

  Future searchNotes(BuildContext context) async {
    Navigator.of(context).push(new MaterialPageRoute<NotesView>(
        builder: (BuildContext context) {
          return new SearchNotes(notes);
        },
        fullscreenDialog: true));
  }
}

// Subject class for note subjects
class Subject {
  int id;
  String headerName;
  List<String> topics;
  List<Note> textNotes;
  bool isExpanded;

  Subject(this.id, this.headerName, this.topics, this.textNotes,
      {this.isExpanded = false});

  get subjectID => this.id;
  get name => this.headerName;
  get subjectTopic => this.topics;
  get notes => this.textNotes;
  get expanded => this.isExpanded;

  set notes(notes) {
    this.textNotes = notes;
  }

  set expanded(expanded) {
    this.isExpanded = expanded;
  }
}