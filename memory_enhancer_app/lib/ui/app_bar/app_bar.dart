import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:google_fonts/google_fonts.dart';


AppBar CustomAppBar({required String title}){
  return AppBar(
    title: Text(
      title,
      style: GoogleFonts.passionOne(fontSize: 37),
    ),
    centerTitle: true,
    backgroundColor: lightTheme.accentColor,
    automaticallyImplyLeading: false, // Hide the BACK button
  );
}