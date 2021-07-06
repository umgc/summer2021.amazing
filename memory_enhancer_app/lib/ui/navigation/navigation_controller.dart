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
import 'package:memory_enhancer_app/app/themes/dark_theme.dart';

import 'package:google_fonts/google_fonts.dart';

// Bottom Navigation
class BottomNavigationBarController extends StatefulWidget {
  int pageIndex = 0;
  // Constructor with page index
  BottomNavigationBarController({required int pageIndex}) {
    this.pageIndex = pageIndex;
  }

  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState(index: pageIndex);
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {

  int _selectedIndex = 0;

  // Constructor with page index
  _BottomNavigationBarControllerState({required int index}){
    _selectedIndex = index;
  }

  void _onTapped(int index) {
    switch (index) {
      case 0:
       appRouter.pushAndPopUntil(HomeViewRoute(), predicate: (_) => false);
        break;
      case 1:
        appRouter.pushAndPopUntil(NotesViewRoute(), predicate: (_) => false);
        break;
      case 2:
        appRouter.pushAndPopUntil(SettingsViewRoute(), predicate: (_) => false);
        break;
      case 3:
        appRouter.pushAndPopUntil(HelpViewRoute(), predicate: (_) => false);
        break;
      default:
        appRouter.pushAndPopUntil(HomeViewRoute(), predicate: (_) => false);
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
            border: Border(top: BorderSide(color: darkTheme.primaryColor, width: 3.0))),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'HOME',
              tooltip: 'Home',
            ), // Home
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1 ? Icons.text_snippet_rounded : Icons.text_snippet_outlined),
              label: 'NOTES',
              tooltip: 'Notes',
            ), // Notes
            BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 2 ? Icons.settings_sharp : Icons.settings_outlined),
                label: 'SETTINGS',
                tooltip: 'Settings'),
            BottomNavigationBarItem(
                icon: Icon(_selectedIndex == 3 ? Icons.help_outlined : Icons.help_outline_sharp),
                label: 'HELP',
                tooltip: 'Help') // Help
          ],
          currentIndex: _selectedIndex,
          onTap: _onTapped,
          type: BottomNavigationBarType.fixed,
          iconSize: 52,
          selectedItemColor: darkTheme.primaryColor,
          selectedFontSize: 16.0,
          unselectedFontSize: 16.0,
          unselectedLabelStyle:
              GoogleFonts.anton(fontSize: 25, fontWeight: FontWeight.w200),
          selectedLabelStyle:
              GoogleFonts.anton(fontSize: 25, fontWeight: FontWeight.w200),
        )
    );
  } // Widget
}
