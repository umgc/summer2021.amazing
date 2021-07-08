//**************************************************************
// Trigger Words View UI
// Author: Mo Drammeh
//**************************************************************

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/ui/alert/alert_popup.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/list_item/list_item_dynamic.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:memory_enhancer_app/file_operations.dart';
import 'package:memory_enhancer_app/ui/trigger_words/trigger_words_view_model.dart';
import 'package:stacked/stacked.dart';

class TriggerWordsView extends StatefulWidget {
  TriggerWordsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TriggerWordsViewState();
}

class _TriggerWordsViewState extends State<TriggerWordsView> {
  FileOperations fileOperations = FileOperations();
  String triggerWords = "";

  void updateTriggerWords() {
    print("updating words");
    fileOperations.readTriggers().then((String value) {
      setState(() {
        triggerWords = value;
      });
    });
  }

  List<String> getTriggerWords() {
    List<String> array = triggerWords.trimLeft().split('\n');
    if (array[0] == "" && array.length == 1) {
      return List.empty();
    }
    array.sort();
    return array;
  }

  @override
  void initState() {
    super.initState();
    updateTriggerWords();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TriggerWordsViewModel>.reactive(
    viewModelBuilder: () => TriggerWordsViewModel(),
    onModelReady: (model) {
    model.initialize();
    },

    builder: (context, model, child) {
    return Scaffold(
      appBar: CustomAppBar(title: PageEnums.triggerWords.name),
      body: getTriggerWords().length > 0
          ? ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: getTriggerWords().length,
        itemBuilder: (BuildContext context, int index) {
          return CustomDynamicListItem(
            onEdit: () {
              model.txtEditCtrl.text = '${getTriggerWords()[index]}';
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                        content: TextFormField(controller: model.txtEditCtrl),
                        buttonText: 'Edit',
                        onPress: (){
                          fileOperations.editTrigger('${getTriggerWords()[index]}', model.txtEditCtrl.text);
                          updateTriggerWords();
                          Navigator.pop(context);
                          model.txtEditCtrl.clear();
                        });
                  });
              },
            onDelete: () {
              showDialog (
                  context: context,
                  builder: (BuildContext context) {
                    return CustomAlertDialog(
                        content: Text('Confirm deletion',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                        buttonText: 'Delete',
                        onPress: (){
                          fileOperations.deleteTrigger('${getTriggerWords()[index]}');
                          updateTriggerWords();
                          Navigator.pop(context);
                        });
                  });
              },
            page: PageEnums.triggerWords,
            text: '${getTriggerWords()[index]}');
        },
      )
          : const Center(
          child: Text('Add words or phrases with the button below',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500))),
      bottomNavigationBar:
      BottomNavigationBarController(pageIndex: PageEnums.settings.index),
      persistentFooterButtons: <Widget>[
        Center(
            child: ElevatedButton(
                style:
                ElevatedButton.styleFrom(primary: lightTheme.accentColor),
                child: Text("Add Words/Phrases",
                    style: GoogleFonts.anton(
                        fontSize: 25, textStyle: TextStyle(letterSpacing: .6))),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: TextFormField(controller: model.txtEditCtrl),
                          actions: [Center(
                              child: ElevatedButton(
                                child: Text("Add"),
                                onPressed: () {
                                  fileOperations.addTrigger(model.txtEditCtrl.text);
                                  updateTriggerWords();
                                  Navigator.pop(context);
                                  model.txtEditCtrl.clear();
                            },
                            style: ElevatedButton.styleFrom(primary: lightTheme.accentColor),
                          ))],
                        );
                      });
                }))
      ],
    );
    });
  }
}
