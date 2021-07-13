import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';

Card CustomDynamicListItem(
    {String? subtitle,
    required String title,
    required Function onEdit,
    required Function onDelete}) {
  return Card(
      child: ListTile(
    leading: IconButton(
        icon: const Icon(Icons.delete_rounded),
        onPressed: () {
          onDelete();
        },
        tooltip: "delete",
        color: lightTheme.accentColor),
    trailing: IconButton(
        icon: const Icon(Icons.create_rounded),
        onPressed: () {
          onEdit();
        },
        tooltip: "edit",
        color: lightTheme.accentColor),
    title: Text(title,
        style: GoogleFonts.anton(
            fontSize: 20, textStyle: TextStyle(letterSpacing: .6))),
    subtitle: subtitle != null ? Text(subtitle,
        style: GoogleFonts.anton(
            fontSize: 15, textStyle: TextStyle(letterSpacing: .6))) : null,
  ));
}