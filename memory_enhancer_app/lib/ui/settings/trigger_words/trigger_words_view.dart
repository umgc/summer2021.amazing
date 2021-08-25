//**************************************************************
// Trigger Words View UI
// Author: Mo Drammeh
//**************************************************************

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/ui/alert/alert_popup.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/list_item/list_item_dynamic.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:memory_enhancer_app/ui/settings/trigger_words/trigger_words_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:memory_enhancer_app/services/services.dart';

class TriggerWordsView extends StatefulWidget {
  TriggerWordsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TriggerWordsViewState();
}

class _TriggerWordsViewState extends State<TriggerWordsView> with TickerProviderStateMixin {
  String startTriggerWords = "";
  String stopTriggerWords = "";
  String recallTriggerWords = "";
  final txtEditCtrl = TextEditingController();
  double fontSizeMenu = 25;
  double fontSizePlaceholder = 35;
  late TabController tabCtrl;

  void updateTriggerWords() {
    fileOperations.readTriggers(0).then((String value) {
      setState(() {
        startTriggerWords = value;
      });
    });
    fileOperations.readTriggers(1).then((String value) {
      setState(() {
        stopTriggerWords = value;
      });
    });
    fileOperations.readTriggers(2).then((String value) {
      setState(() {
        recallTriggerWords = value;
      });
    });
  }

  List<String> getStartTriggerWords() {
    List<String> array = startTriggerWords.trimLeft().split('\n');
    if (array[0] == "" && array.length == 1) {
      return List.empty();
    }
    array.sort();
    return array;
  }

  List<String> getStopTriggerWords() {
    List<String> array = stopTriggerWords.trimLeft().split('\n');
    if (array[0] == "" && array.length == 1) {
      return List.empty();
    }
    array.sort();
    return array;
  }

  List<String> getRecallTriggerWords() {
    List<String> array = recallTriggerWords.trimLeft().split('\n');
    if (array[0] == "" && array.length == 1) {
      return List.empty();
    }
    array.sort();
    return array;
  }

  @override
  void initState() {
    super.initState();
    tabCtrl = TabController(length: 3, vsync: this);
    updateTriggerWords();
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
  }

  @override
  void dispose() {
    txtEditCtrl.dispose();
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
      appBar: CustomAppBarTabbed(
          title: PageEnums.triggerWords.name,
          bottom:  CustomTabBar(
              controller: tabCtrl,
              tabs: <Widget>[Tab(text: 'START'), Tab(text: 'STOP'), Tab(text: 'RECALL')])),
      body:
      TabBarView(
      controller: tabCtrl,
      children: <Widget>[TriggerTabs(getTriggers: getStartTriggerWords, textEditControl: txtEditCtrl,
          updateTriggers: updateTriggerWords, tabController: tabCtrl, fontSizeMenu: fontSizeMenu, fontSizePlaceholder: fontSizePlaceholder),
        TriggerTabs(getTriggers: getStopTriggerWords, textEditControl: txtEditCtrl,
            updateTriggers: updateTriggerWords, tabController: tabCtrl, fontSizeMenu: fontSizeMenu, fontSizePlaceholder: fontSizePlaceholder),
        TriggerTabs(getTriggers: getRecallTriggerWords, textEditControl: txtEditCtrl,
            updateTriggers: updateTriggerWords, tabController: tabCtrl, fontSizeMenu: fontSizeMenu, fontSizePlaceholder: fontSizePlaceholder)]),
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
                        return CustomAlertTwoButton(
                          title: 'ADD WORD OR PHRASE',
                          content: TextField(controller: txtEditCtrl),
                          actionTwoText: 'ADD',
                          actionTwoPressed: (){
                            if(txtEditCtrl.text.isNotEmpty) {
                              fileOperations.addTrigger(
                                  txtEditCtrl.text, tabCtrl.index);
                              updateTriggerWords();
                              Navigator.pop(context);
                              txtEditCtrl.clear();
                              showAlertBox('TRIGGER ADDED',
                                  'The trigger word was added successfully',
                                  context);
                            }
                          },
                          actionOneText: 'CANCEL',
                          actionOnePressed: (){
                            Navigator.pop(context);
                            txtEditCtrl.clear();
                          }
                        );
                      });
                }))
      ],
    );
    });
  }
}

TabBar CustomTabBar({required List<Widget> tabs, required TabController controller}){
  return TabBar(
      controller: controller,
      tabs: tabs,
      indicatorColor: Colors.white,
      indicatorWeight: 5);
}

Widget TriggerTabs({required Function() getTriggers, required TextEditingController textEditControl,
  required Function updateTriggers, required TabController tabController, required double fontSizeMenu, required double fontSizePlaceholder}){
  return getTriggers().length > 0
      ? ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: getTriggers().length,
    itemBuilder: (BuildContext context, int index) {
      return CustomEditDeleteListItem(
          fontSizeMenu: fontSizeMenu,
          onEdit: () {
            textEditControl.text = '${getTriggers()[index]}';
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomAlertTwoButton(
                    title: 'EDIT TRIGGER',
                      content: TextField(controller: textEditControl),
                      actionOneText: 'CANCEL',
                      actionOnePressed: (){
                        Navigator.pop(context);
                        textEditControl.clear();
                      },
                      actionTwoText: 'EDIT',
                      actionTwoPressed: (){
                      if(textEditControl.text.isNotEmpty) {
                        fileOperations.editTrigger(
                            '${getTriggers()[index]}', textEditControl.text,
                            tabController.index);
                        updateTriggers();
                        Navigator.pop(context);
                        textEditControl.clear();
                        showAlertBox('TRIGGER EDITED',
                            'The trigger word was edited successfully',
                            context);
                      }
                      });
                });
          },
          onDelete: () {
            showDialog (
                context: context,
                builder: (BuildContext context) {
                  return CustomAlertTwoButton(
                    title: 'CONFIRM DELETION',
                      content: Text('${getTriggers()[index]}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                      actionOneText: 'CANCEL',
                      actionOnePressed: (){
                        Navigator.pop(context);
                      },
                      actionTwoText: 'DELETE',
                      actionTwoPressed: (){
                        fileOperations.deleteTrigger('${getTriggers()[index]}', tabController.index);
                        updateTriggers();
                        Navigator.pop(context);
                        showAlertBox('TRIGGER DELETED', 'The trigger word was deleted successfully', context);
                      });
                });
          },
          title: '${getTriggers()[index]}');
    },
  )
      : Center(
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Add words or phrases with the button below',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: fontSizePlaceholder, fontWeight: FontWeight.w500))));
}