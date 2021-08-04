//**************************************************************
// General Settings View UI
// Author: Mo Drammeh
//**************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/alert/alert_popup.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/list_item/list_item_dynamic.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:stacked/stacked.dart';
import 'general_settings_view_model.dart';
import 'dart:math';

class GeneralSettingsView extends StatefulWidget {
  GeneralSettingsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GeneralSettingsViewState();
}

class _GeneralSettingsViewState extends State<GeneralSettingsView> {
  int saveNoteDuration = 7;
  double fontSizeNote = 20;
  double fontSizeMenu = 25;
  double fontSizePlaceholder = 35;
  final txtEditCtrl = TextEditingController();

  void updateSettingsValues(){
    fileOperations.getSettingsValue('saveNoteDuration').then((String value) {
      setState(() {
        saveNoteDuration = int.parse(value);
      });
    });
    fileOperations.getSettingsValue('fontSizeNote').then((String value) {
      setState(() {
        fontSizeNote = double.parse(value);
      });
    });
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
  void initState() {
    super.initState();
    updateSettingsValues();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeneralSettingsViewModel>.reactive(
        viewModelBuilder: () => GeneralSettingsViewModel(),
        onModelReady: (model) {
          model.initialize();
        },
        builder: (context, model, child) {
          return Scaffold(
            appBar: CustomAppBar(title: PageEnums.generalSettings.name),
            body: Center(
              child:
                  ListView(padding: const EdgeInsets.all(8), children: <Widget>[
                CustomEditListItem(
                    fontSizeMenu: fontSizeMenu,
                    title: 'Delete Notes After ' +
                        saveNoteDuration.toString() +
                        ' Day(s)',
                    onEdit: () {
                      txtEditCtrl.text = saveNoteDuration.toString();
                      showDialog(
    context: context,
    builder: (BuildContext context) {
                      return CustomAlertTwoButton(
                        title: 'EDIT SAVE NOTE DURATION',
                          content: TextField(
                            controller: txtEditCtrl,
                            decoration: new InputDecoration(labelText: "Enter the day(s)"),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                          actionOneText: 'CANCEL',
                          actionOnePressed: () {
                            txtEditCtrl.clear();
                            Navigator.pop(context);
                          },
                          actionTwoText: 'UPDATE',
                          actionTwoPressed: () {
                          print('Changing days to ' + txtEditCtrl.text);
                          fileOperations.setSettingsValue('saveNoteDuration', txtEditCtrl.text);
                          updateSettingsValues();
                          txtEditCtrl.clear();
                            Navigator.pop(context);
                          });
    });}),
                    CustomEditListItem(
                        fontSizeMenu: fontSizeMenu,
                        title: 'Font Size (Menu) : ' +
                            fontSizeMenu.toInt().toString(),
                        onEdit: () {
                          txtEditCtrl.text = fontSizeMenu.toInt().toString();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertTwoButton(
                                    title: 'EDIT MENU FONT SIZE',
                                    content: TextField(
                                      controller: txtEditCtrl,
                                      decoration: new InputDecoration(labelText: "Enter the font size"),
                                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]),
                                    actionOneText: 'CANCEL',
                                    actionOnePressed: () {
                                      Navigator.pop(context);
                                    },
                                    actionTwoText: 'UPDATE',
                                    actionTwoPressed: () {
                                      print('Changing font size to ' + txtEditCtrl.text);
                                      fileOperations.setSettingsValue('fontSizeMenu', txtEditCtrl.text);
                                      updateSettingsValues();
                                      Navigator.pop(context);
                                    });
                              });}),
                    CustomEditListItem(
                        fontSizeMenu: fontSizeMenu,
                        title: 'Font Size (Notes) : ' +
                            fontSizeNote.toInt().toString(),
                        onEdit: () {
                          txtEditCtrl.text = fontSizeNote.toInt().toString();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertTwoButton(
                                    title: 'EDIT NOTES FONT SIZE',
                                    content: TextField(
                                      controller: txtEditCtrl,
                                      decoration: new InputDecoration(labelText: "Enter the font size"),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],),
                                    actionOneText: 'CANCEL',
                                    actionOnePressed: () {
                                      Navigator.pop(context);
                                    },
                                    actionTwoText: 'UPDATE',
                                    actionTwoPressed: () {
                                      print('Changing font size to ' + txtEditCtrl.text);
                                      fileOperations.setSettingsValue('fontSizeNote', txtEditCtrl.text);
                                      updateSettingsValues();
                                      Navigator.pop(context);
                                    });
                              });}),
                    CustomEditListItem(
                        fontSizeMenu: fontSizeMenu,
                        title: 'Font Size (Placeholders) : ' +
                            fontSizePlaceholder.toInt().toString(),
                        onEdit: () {
                          txtEditCtrl.text = fontSizePlaceholder.toInt().toString();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertTwoButton(
                                    title: 'EDIT PLACEHOLDER FONT SIZE',
                                    content: TextField(
                                      controller: txtEditCtrl,
                                      decoration: new InputDecoration(labelText: "Enter the font size"),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],),
                                    actionOneText: 'CANCEL',
                                    actionOnePressed: () {
                                      Navigator.pop(context);
                                    },
                                    actionTwoText: 'UPDATE',
                                    actionTwoPressed: () {
                                      print('Changing font size to ' + txtEditCtrl.text);
                                      fileOperations.setSettingsValue('fontSizePlaceholder', txtEditCtrl.text);
                                      updateSettingsValues();
                                      Navigator.pop(context);
                                    });
                              });})

                  ]),
            ),
              persistentFooterButtons: <Widget>[
                Center(
                    child: ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(primary: lightTheme.accentColor),
                        child: Text("Reset Settings",
                            style: GoogleFonts.anton(
                                fontSize: 25, textStyle: TextStyle(letterSpacing: .6))),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomAlertTwoButton(
                                    title: 'RESET SETTINGS',
                                    content: Text('Are you sure you want to reset all settings?'),
                                    actionTwoText: 'YES',
                                    actionTwoPressed: (){
                                      //fileOperations.deleteLocalFile('settingsValues.xml');
                                      fileOperations.initializeSettingsFile(true);
                                      updateSettingsValues();
                                      Navigator.pop(context);
                                      showAlertBox('SETTINGS RESET', 'The settings were successfully reset', context);
                                    },
                                    actionOneText: 'NO',
                                    actionOnePressed: (){
                                      Navigator.pop(context);
                                    }
                                );
                              });
                        }))
              ],
            bottomNavigationBar:
                BottomNavigationBarController(pageIndex: PageEnums.settings.index),
          );
        });
  }
}
