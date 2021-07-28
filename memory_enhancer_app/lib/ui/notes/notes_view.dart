//**************************************************************
// Notes view UI
// Author:Chauntika Broggin
//**************************************************************
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/services/services.dart';
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
  List<Note> notes = []; // Notes array

  // Subject note arrays
  List<Note> personalNotes = <Note>[];
  List<Note> dinnerNotes = <Note>[];
  List<Note> lunchNotes = <Note>[];
  List<Note> birthdayNotes = <Note>[];
  List<Note> familyNotes = <Note>[];
  List<Note> medicalNotes = <Note>[];
  List<Note> otherNotes = <Note>[];
  List<Subject> _subjects = [];

  @override
  void initState() {
    getNoteContent();
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
              'sample',
              'exercise',
              'nutrition'
            ],
            personalNotes),
        Subject(2, 'Dinner', ['dinner', 'restaurant', 'food', 'sample'], dinnerNotes),
        Subject(3, 'Lunch', ['lunch', 'food', 'eat', 'afternoon', 'restaurant', 'sample'],
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
              'funeral',
              'sample'
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
              'procedure',
              'sample'
            ],
            medicalNotes),
        Subject(
            6,
            'Other',
            [
              'conversations',
              'talk',
              'speak',
              'phone',
              'work',
              'call',
              'holiday',
              'party',
              'other',
              'note',
              'sample',
              'hello',
              'breakfast',
              'sample'
            ],
            otherNotes),
      ];
    });
    updateSubjectLists();
    for (var n in notes) {
      print(n.toString());
    }
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

  // Get list of notes.
  List<Note>? getNoteContent() {
    getContent().then((value) {
      setState(() {
        notes = value;
        updateSubjectLists();
      });
    });
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
        for (var t in _subjects[0].topics) {
          if (n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!personalNotes.contains(n)) {
              personalNotes.add(n);
            } else {
              print('Note already found');
            }
          }
        }

        for (var t in _subjects[1].topics) {
          if (n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!dinnerNotes.contains(n)) {
              dinnerNotes.add(n);
            } else {
              print('Note already found');
            }
          }
        }

        for (var t in _subjects[2].topics) {
          if (n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!lunchNotes.contains(n)) {
              lunchNotes.add(n);
            } else {
              print('Note already found');
            }
          }
        }

        for (var t in _subjects[3].topics) {
          if (n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!familyNotes.contains(n)) {
              familyNotes.add(n);
            } else {
              print('Note already found');
            }
          }
        }

        for (var t in _subjects[4].topics) {
          if (n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!medicalNotes.contains(n)) {
              medicalNotes.add(n);
            } else {
              print('Note already found');
            }
          }
        }

        for (var t in _subjects[5].topics) {
          if (n.noteBody.toLowerCase().contains(t.toLowerCase())) {
            if (!otherNotes.contains(n)) {
              otherNotes.add(n);
            } else {
              print('Note already found');
            }
          }
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
                  style: GoogleFonts.anton(fontSize: 22)),
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
        ? Text('No notes at this time.')
        : new ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: subjectNoteLists(id).length > 0
            ? subjectNoteLists(id).length
            : 0,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: ListTile(
                  onLongPress: () async {
                    viewNote(context, subjectNoteLists(id)[index]);
                  },
                  leading: IconButton(
                      icon: const Icon(Icons.delete_rounded),
                      onPressed: () {
                        showDialog(
                            context: _noteScaffoldKey.currentContext!,
                            builder: (context) => AlertDialog(
                                contentTextStyle:
                                GoogleFonts.anton(fontSize: 18),
                                title: Text('Delete Note?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('NO',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                  TextButton(
                                      child: Text('YES',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 20)),
                                      onPressed: () {
                                        model.onDelete(
                                            subjectNoteLists(id)[index]
                                                .noteID);
                                        model.notifyListeners();
                                        setState(() {
                                          getNoteContent();
                                          updateSubjectLists();
                                        });
                                        Navigator.pop(context);
                                      })
                                ]));
                        getNoteContent();
                        updateSubjectLists();
                      },
                      tooltip: "delete",
                      color: lightTheme.accentColor),
                  trailing: IconButton(
                      icon: const Icon(Icons.create_rounded),
                      onPressed: () {
                        _ntTxtControl.text =
                            subjectNoteLists(id)[index].body;
                        getNoteContent();
                        updateSubjectLists();
                        showDialog(
                            context: _noteScaffoldKey.currentContext!,
                            builder: (_context) => AlertDialog(
                                contentTextStyle:
                                GoogleFonts.anton(fontSize: 18),
                                title: Text('Edit Note',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25)),
                                content: TextField(
                                    controller: _ntTxtControl,
                                    style: TextStyle(fontSize: 20)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
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
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 20)),
                                      onPressed: () {
                                        model.onEdit(
                                            subjectNoteLists(id)[index]
                                                .noteID,
                                            _ntTxtControl.text);
                                        _ntTxtControl.clear();
                                        setState(() {
                                          getNoteContent();
                                          updateSubjectLists();
                                          model.notifyListeners();
                                        });
                                        Navigator.pop(context);
                                      })
                                ]));
                      },
                      tooltip: "edit",
                      color: lightTheme.accentColor),
                  title: Text(
                      subjectNoteLists(id)[index].noteBody.isNotEmpty
                          ? subjectNoteLists(id)[index].noteBody
                          : 'There are no notes available.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: GoogleFonts.roboto(
                          fontSize: 25,
                          textStyle:
                          TextStyle(letterSpacing: .6, height: 1.2))),
                  subtitle: Text(subjectNoteLists(id)[index].noteDate,
                      style: GoogleFonts.anton(
                          fontSize: 14,
                          textStyle: TextStyle(letterSpacing: .6)))));
        });
  } // #End of Note List View Lists

  // Write New Note
  Widget writeNoteAlert(BuildContext context, NotesViewModel model) {
    // set up the AlertDialog
    return AlertDialog(
      contentTextStyle: GoogleFonts.anton(fontSize: 14),
      title: Text('Write Note',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
      content: Container(
          width: 500,
          child: TextField(
            controller: _ntTxtControl,
          )),
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
            updateSubjectLists();
            fileOperations.writeNewNote(_ntTxtControl.text, context);
            setState(() {
              getNoteContent();
              updateSubjectLists();
            });
            model.notifyListeners();
            _ntTxtControl.clear();
          },
        )
      ],
    );
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
            appBar: CustomAppBar(title: PageEnums.notes.name),
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
                      model.startListening();
                    })
              ]),
            ],
          );
        });
  }

  @override
  void dispose() {
    _ntTxtControl.dispose();
    super.dispose();
  }
}

Future viewNote(BuildContext context, Note note) async {
  Navigator.of(context).push(new MaterialPageRoute<NotesView>(
      builder: (BuildContext context) {
        return new NoteView(note);
      },
      fullscreenDialog: true));
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

