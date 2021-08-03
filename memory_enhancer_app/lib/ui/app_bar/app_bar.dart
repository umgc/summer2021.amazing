import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:google_fonts/google_fonts.dart';


AppBar CustomAppBar({required String title, List<Widget>? actions}){
  return AppBar(
    actions: actions,
    title: Text(
      title,
      style: GoogleFonts.passionOne(fontSize: 37),
    ),
    centerTitle: true,
    backgroundColor: lightTheme.accentColor,
    automaticallyImplyLeading: false, // Hide the BACK button
  );
}

AppBar CustomAppBarTabbed({required String title, required PreferredSizeWidget bottom, List<Widget>? actions}){
  return AppBar(
    actions: actions,
    title: Text(
      title,
      style: GoogleFonts.passionOne(fontSize: 37),
    ),
    bottom: bottom,
    centerTitle: true,
    backgroundColor: lightTheme.accentColor,
    automaticallyImplyLeading: false, // Hide the BACK button
  );
}

AppBar CustomAppBarPopup({required String title, List<Widget>? actions}){
  return AppBar(
    title: Text(title, style: GoogleFonts.passionOne(fontSize: 37)),
    actions: actions,
    centerTitle: true,
    backgroundColor: lightTheme.accentColor,
  );
}