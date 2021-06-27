import 'package:memory_enhancer_app/app/themes/light_Theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'settings_view_model.dart';

import 'package:google_fonts/google_fonts.dart';

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
         appBar: AppBar(
            title: Text('Settings',
                style: GoogleFonts.lobster(fontSize: 35),
            ),
           backgroundColor: lightTheme.accentColor,
          ),
            body: Center(
              child: Text('Placeholder'),
            )
        );
      },
    );
  }
}