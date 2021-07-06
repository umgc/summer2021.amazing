//**************************************************************
// Settings view UI
// Author:
//**************************************************************
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'notes_view_model.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

class NotesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotesViewModel>.reactive(
      viewModelBuilder: () => NotesViewModel(),
      onModelReady: (model) {
        //model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: CustomAppBar(title: 'Notes'),
          body: Center(
            child: Text('Notes Placeholder'),
          ),
          bottomNavigationBar: BottomNavigationBarController(pageIndex: PageEnums.notes.index),
        );
      },
    );
  }
}
