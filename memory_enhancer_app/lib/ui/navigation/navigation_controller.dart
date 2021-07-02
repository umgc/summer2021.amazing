//********************************************
// Application Menu Navigation Controller
// Author: Christian Ahmed
//********************************************
import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';

class NavigationController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(
                    child: Center(
                      child: Text('Memory Enhancer',
                        style: GoogleFonts.lobster(fontSize: 30),
                      ),
                    )
                ),
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('Trigger Words',
                    style: GoogleFonts.roboto(fontSize: 25),),
                  onTap: () async {
                    appRouter.push(
                      TriggerWordsViewRoute(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings',
                    style: GoogleFonts.roboto(fontSize: 25),),
                  onTap: () async {
                    appRouter.push(
                      SettingsViewRoute(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_alarm),
                  title: Text('<Menu 3>',
                    style: GoogleFonts.roboto(fontSize: 25),),
                  onTap: () async {
                    appRouter.push(
                      SettingsViewRoute(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.comment),
                  title: Text('<Menu 3>',
                    style: GoogleFonts.roboto(fontSize: 25),),
                  onTap: () async {
                    appRouter.push(
                      SettingsViewRoute(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.record_voice_over_sharp),
                  title: Text('<Menu 4>',
                    style: GoogleFonts.roboto(fontSize: 25),),
                  onTap: () async {
                    appRouter.push(
                      SettingsViewRoute(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
