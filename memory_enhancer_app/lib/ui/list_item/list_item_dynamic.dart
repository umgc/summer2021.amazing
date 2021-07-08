import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';

Card CustomDynamicListItem(
    {required PageEnums page,
    required String text,
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
    title: Text(text,
        style: GoogleFonts.anton(
            fontSize: 20, textStyle: TextStyle(letterSpacing: .6))),
  ));
}