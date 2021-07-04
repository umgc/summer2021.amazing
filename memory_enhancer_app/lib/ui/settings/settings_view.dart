//**************************************************************
// Settings view UI
// Author:
//**************************************************************
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'settings_view_model.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onModelReady: (model) {
        // model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Settings'),
          body: Center(
            child: Text('Settings Placeholder'),
          ),
          bottomNavigationBar: BottomNavigationBarController(pageIndex: PageEnums.settings.index),
        );
      },
    );
  }
}
