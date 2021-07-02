//********************************************
// Application Menu Navigation Controller
// Author: Christian Ahmed
//********************************************
import 'dart:core';

import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:memory_enhancer_app/custom_fonts/my_flutter_app_icons.dart';

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
                  child: Text(
                    'Memory Enhancer',
                    style: GoogleFonts.passionOne(fontSize: 35),
                  ),
                )),
                ListTile(
                  leading: Icon(Icons.home_filled),
                  title: Text(
                    'HOME',
                    style: GoogleFonts.roboto(fontSize: 25),
                  ),
                  onTap: () async {
                    appRouter.push(
                      HomeViewRoute(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(MyFlutterApp.doc_text),
                  title: Text(
                    'NOTES',
                    style: GoogleFonts.roboto(fontSize: 25),
                  ),
                  onTap: () async {
                    appRouter.push(
                      SettingsViewRoute(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'SETTINGS',
                    style: GoogleFonts.roboto(fontSize: 25),
                  ),
                  onTap: () async {
                    appRouter.push(
                      SettingsViewRoute(),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text(
                    'HELP',
                    style: GoogleFonts.roboto(fontSize: 25),
                  ),
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

// Bottom Navigation
class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  int _selectedIndex = 0;

  void _onTapped(int index) {
    switch (index) {
      case 0:
        appRouter.navigate(HomeViewRoute());
        break;
      case 2:
        appRouter.push(SettingsViewRoute());
        break;
      default:
        appRouter.navigate(HomeViewRoute());
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.red, width: 3.0))),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'HOME',
              tooltip: 'Home',
            ), // Home
            BottomNavigationBarItem(
              icon: Icon(MyFlutterApp.doc_text),
              label: 'NOTES',
              tooltip: 'Notes',
            ), // Notes
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'SETTINGS',
                tooltip: 'Settings'),
            BottomNavigationBarItem(
                icon: Icon(Icons.help_outlined),
                label: 'HELP',
                tooltip: 'Help') // Help
          ],
          currentIndex: _selectedIndex,
          onTap: _onTapped,
          type: BottomNavigationBarType.fixed,
          iconSize: 55,
          selectedItemColor: Colors.black,
          selectedFontSize: 16.0,
          unselectedFontSize: 16.0,
          unselectedLabelStyle:
              GoogleFonts.anton(fontSize: 25, fontWeight: FontWeight.w200),
          selectedLabelStyle:
              GoogleFonts.anton(fontSize: 25, fontWeight: FontWeight.w200),
        ));
  } // Widget
}
