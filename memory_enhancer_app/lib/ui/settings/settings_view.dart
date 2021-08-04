//**************************************************************
// Settings view UI
// Author:
//**************************************************************
import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:stacked/stacked.dart';

import 'settings_view_model.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:memory_enhancer_app/ui/list_item/menu_list_item.dart';

class SettingsView extends StatefulWidget {
  SettingsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  double fontSizeMenu = 25;

  @override
  void initState() {
    fileOperations.getSettingsValue('fontSizeMenu').then((String value) {
      setState(() {
        fontSizeMenu = double.parse(value);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onModelReady: (model) {
        // model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(title: PageEnums.settings.name),
          body: Center(
            child: ListView(
              padding: const EdgeInsets.all(8),
                children: <Widget>[
                  CustomMenuListItem(location: PageEnums.generalSettings, fontSizeMenu: fontSizeMenu),
                  CustomMenuListItem(location: PageEnums.triggerWords, fontSizeMenu: fontSizeMenu),
                  ]
            ),
          ),
          bottomNavigationBar: BottomNavigationBarController(pageIndex: PageEnums.settings.index),
        );
      },
    );
  }
}
