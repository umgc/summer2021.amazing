import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';

Card CustomEditDeleteListItem(
    {String? subtitle,
      required String title,
      required Function onEdit,
      required Function onDelete,
    required double fontSizeMenu}) {

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
        title: Center(child: Text(title,
            textAlign: TextAlign.left,
            style: GoogleFonts.anton(
                fontSize: fontSizeMenu, textStyle: TextStyle(letterSpacing: .6)))),
        subtitle: subtitle != null ? Text(subtitle,
            style: GoogleFonts.anton(
                fontSize: 15, textStyle: TextStyle(letterSpacing: .6))) : null,
      ));
}

Card CustomEditDeleteMenuItem(
    {String? subtitle,
      required String title,
      Function()? onPress,
      Function()? onLongPress,
      required Function onEdit,
      required Function onDelete,
      required double fontSizeMenu}) {
  return Card(
      child: InkWell(
          splashColor: lightTheme.accentColor,
          onTap: onPress,
          onLongPress: onLongPress,
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
                textAlign: TextAlign.left,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.anton(
                    fontSize: fontSizeMenu, textStyle: TextStyle(letterSpacing: .6))),
            subtitle: subtitle != null ? Text(subtitle,
                style: GoogleFonts.anton(
                    fontSize: 15, textStyle: TextStyle(letterSpacing: .6))) : null,
          )
      )
  );
}

Card CustomMenuItem(
    {String? subtitle,
      required String title,
      Function()? onPress,
      Function()? onLongPress,
      required double fontSizeMenu}) {
  return Card(
      child: InkWell(
          splashColor: lightTheme.accentColor,
          onTap: onPress,
          onLongPress: onLongPress,
          child: ListTile(
            title: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.anton(
                    fontSize: fontSizeMenu, textStyle: TextStyle(letterSpacing: .6))),
            subtitle: subtitle != null ? Text(subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.anton(
                    fontSize: 15, textStyle: TextStyle(letterSpacing: .6))) : null,
          )
      )
  );
}

Card CustomEditListItem(
    {String? subtitle,
      required String title,
      required Function onEdit,
      required double fontSizeMenu}) {
  return Card(
      child: ListTile(
        trailing: IconButton(
            icon: const Icon(Icons.create_rounded),
            onPressed: () {
              onEdit();
            },
            tooltip: "edit",
            color: lightTheme.accentColor),
        title: Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.anton(
                fontSize: fontSizeMenu, textStyle: TextStyle(letterSpacing: .6))),
        subtitle: subtitle != null ? Text(subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.anton(
                fontSize: 15, textStyle: TextStyle(letterSpacing: .6))) : null,
      ));
}

Card CustomOneButtonListItem(
    {String? subtitle,
      String? tooltip,
      required String title,
      required Icon icon,
      required Function onBtnOnePress,
      required double fontSizeMenu}) {
  return Card(
      child: ListTile(
        trailing: IconButton(
            icon: icon,
            onPressed: () {
              onBtnOnePress();
            },
            tooltip: tooltip != null ? tooltip : null,
            color: lightTheme.accentColor),
        title: Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.anton(
                fontSize: fontSizeMenu, textStyle: TextStyle(letterSpacing: .6))),
        subtitle: subtitle != null ? Text(subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.anton(
                fontSize: 15, textStyle: TextStyle(letterSpacing: .6))) : null,
      ));
}

Card CustomTwoButtonListItem(
    {String? subtitle,
      String? tooltipOne,
      String? tooltipTwo,
      required String title,
      required Icon iconOne,
      required Function onBtnOnePress,
      required Icon iconTwo,
      required Function onBtnTwoPress,
      required double fontSizeMenu}) {
  return Card(
      child: ListTile(
        trailing: IconButton(
            icon: iconTwo,
            onPressed: () {
              onBtnTwoPress();
            },
            tooltip: tooltipTwo != null ? tooltipTwo : null,
            color: lightTheme.accentColor),
        leading: IconButton(
            icon: iconOne,
            onPressed: () {
              onBtnOnePress();
            },
            tooltip: tooltipOne != null ? tooltipOne : null,
            color: lightTheme.accentColor),
        title: Center(child: Text(title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: GoogleFonts.anton(
                fontSize: fontSizeMenu, textStyle: TextStyle(letterSpacing: .6)))),
        subtitle: subtitle != null ? Text(subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.anton(
                fontSize: 15, textStyle: TextStyle(letterSpacing: .6))) : null,
      ));
}