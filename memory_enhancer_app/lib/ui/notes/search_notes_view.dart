import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/alert/alert_popup.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/list_item/list_item_dynamic.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

import '../../notes.dart';
import 'note_view.dart';
import 'notes_view.dart';
import 'package:xml/xml.dart' as xml;

class SearchNotes extends StatefulWidget {
  final List<Note> notes;

  SearchNotes(this.notes, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {
  double fontSizeNotes = 15;
  double fontSizeMenu = 20;
  double fontSizePlaceholder = 35;
  final TextEditingController ctrl = new TextEditingController();
  final TextEditingController popCtrl = new TextEditingController();
  String phText = 'Please use the search bar to find notes';

  List<Note> searchedNotes = List.empty();

  @override
  void initState() {
    fileOperations.getSettingsValue('fontSizeNote').then((String value) {
      setState(() {
        fontSizeNotes = double.parse(value);
      });
    });
    fileOperations.getSettingsValue('fontSizeNote').then((String value) {
      setState(() {
        fontSizeNotes = double.parse(value);
      });
    });
    fileOperations.getSettingsValue('fontSizePlaceholder').then((String value) {
      setState(() {
        fontSizePlaceholder = double.parse(value);
      });
    });
    super.initState();
  }

  @override
  void dispose(){
    ctrl.dispose();
    popCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarPopup(
        title: 'Search Notes',
      ),
      body: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: TextField(
              controller: ctrl,
              maxLines: null,
              onSubmitted: (value) {
                setState(() {
                  searchedNotes = searchNotes(value);
                });
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    color: lightTheme.accentColor,
                    onPressed: () {
                      ctrl.clear();
                      setState(() {
                        searchedNotes.clear();
                        phText = 'Please use the search bar to find notes';
                      });
                    },
                  ),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search),
                    color: lightTheme.accentColor,
                    onPressed: () {
                      setState(() {
                        searchedNotes = searchNotes(ctrl.text);
                      });
                    },
                  ),
                  border: InputBorder.none,
                  hintText: 'Enter the text of a note to search')),
        ),
        body: searchedNotes.length == 0
            ? Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
                child: Text(
                phText,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: fontSizePlaceholder),
              )))
            : ListView.builder(
                itemCount: searchedNotes.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomEditDeleteMenuItem(
                      onPress: (){
                        viewNote(context, searchedNotes[index]);
                      },
                      fontSizeMenu: fontSizeMenu,
                      onEdit: () {
                        popCtrl.text = searchedNotes[index].noteBody;
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertTwoButton(
                                  title: 'EDIT NOTE',
                                  content: TextFormField(controller: popCtrl),
                                  actionOneText: 'CANCEL',
                                  actionOnePressed: (){
                                    Navigator.pop(context);
                                    popCtrl.clear();
                                  },
                                  actionTwoText: 'SAVE',
                                  actionTwoPressed: (){
                                    setState(() {
                                      manageSearchedNotes('edit', searchedNotes[index].noteID, popCtrl.text);
                                    });
                                    Navigator.pop(context);
                                    popCtrl.clear();
                                    showAlertBox('NOTE EDITED', 'The note was edited successfully', context);
                                  });
                            });
                      },
                      onDelete: () {
                        showDialog (
                            context: context,
                            builder: (BuildContext context) {
                              return CustomAlertTwoButton(
                                  title: 'CONFIRM DELETION',
                                  content: Text(searchedNotes[index].noteBody,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                                  actionOneText: 'CANCEL',
                                  actionOnePressed: (){
                                    Navigator.pop(context);
                                  },
                                  actionTwoText: 'DELETE',
                                  actionTwoPressed: (){
                                    setState(() {
                                      manageSearchedNotes('delete', searchedNotes[index].noteID, popCtrl.text);
                                    });
                                    Navigator.pop(context);
                                    showAlertBox('NOTE DELETED', 'The note was deleted successfully.', context);
                                  });
                            });
                      },
                      title: searchedNotes[index].noteBody);
                }),
      ),
      bottomNavigationBar:
          BottomNavigationBarController(pageIndex: PageEnums.notes.index),
    );
  }

  void manageSearchedNotes(String type, String noteId, String text){
    List<List<Note>> noteArrays = [widget.notes, searchedNotes];

    switch(type){
      case 'edit':
        for(List<Note> array in noteArrays) {
          for (Note n in array) {
            if (n.noteID == noteId) {
              n.noteBody = text;
            }
          }
        }
        fileOperations.editNote(noteId, text);
        break;
      case 'delete':
        for(List<Note> array in noteArrays) {
          for (int i=0; i<array.length; i++) {
            if (array[i].noteID == noteId) {
              array.removeAt(i);
            }
          }
        }
        fileOperations.deleteNote(noteId);
        break;
    }
  }

  Future viewNote(BuildContext context, Note note) async {
    Navigator.of(context).push(new MaterialPageRoute<SearchNotes>(
        builder: (BuildContext context) {
          print('Search Length: ' + searchedNotes.length.toString());
          return new NoteView(note);
        },
        fullscreenDialog: true));
  }

  List<Note> searchNotes(String text) {
    List<Note> list = List.empty(growable: true);
    if (text.trim() == '') {
      phText = "Please search at least one character";
      return list;
    }
    for (Note note in widget.notes) {
      if (note.noteBody.toLowerCase().contains(text.toLowerCase())) {
        print("Found note: " + note.noteID);
        list.add(note);
      }
    }
    if (list.length == 0) {
      phText = "No note was found with that text";
    }
    return list;
  }
}
