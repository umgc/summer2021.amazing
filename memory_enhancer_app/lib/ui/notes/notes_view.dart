//**************************************************************
// Settings view UI
// Author:
//**************************************************************
import 'package:memory_enhancer_app/app/themes/light_Theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'notes_view_model.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

import 'package:google_fonts/google_fonts.dart';

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
          appBar: AppBar(
            title: Text(
              'Notes',
              style: GoogleFonts.passionOne(fontSize: 35),
            ),
            backgroundColor: lightTheme.accentColor,
          ),
          body: Center(
            child: Text('Placeholder'),
          ),
          bottomNavigationBar: BottomNavigationBarController(),
        );
      },
    );
  }
}
