import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';

AlertDialog CustomAlertDialog({required Widget content, required String buttonText, required Function() onPress}) {
  return AlertDialog(
    content: content,
    actions: [Center(
        child: ElevatedButton(
          child: Text(buttonText),
          onPressed: onPress,
          style: ElevatedButton.styleFrom(primary: lightTheme.accentColor),
        ))],
  );
}