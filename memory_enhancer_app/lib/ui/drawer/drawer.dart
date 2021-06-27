import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';

//********************************************
// Application Navigation
// Author: Ahmed
//********************************************
class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                DrawerHeader(child: Center(
                  child: Text('Memory Enhancer',
                    style: GoogleFonts.lobster(fontSize: 30),),
                )),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings',
                    style: GoogleFonts.roboto(fontSize: 25),),
                  onTap: () async {
                    //ExtendedNavigator.named('topNav').pop();
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
