//**************************************************************
// Help View UI
// Author:
//**************************************************************
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'help_view_model.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

class HelpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HelpViewModel>.reactive(
      viewModelBuilder: () => HelpViewModel(),
      onModelReady: (model) {
        // model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Help'),
          body: Center(
            child: Text('Help Placeholder'),
          ),
          bottomNavigationBar: BottomNavigationBarController(pageIndex: PageEnums.help.index),
        );
      },
    );
  }
}
