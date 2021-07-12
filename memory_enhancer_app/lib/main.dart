import 'package:memory_enhancer_app/notes.dart';
import 'package:memory_enhancer_app/services/get_it.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/ui/notes/notes_view_model.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'app/themes/dark_theme.dart';
import 'app/themes/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await ThemeManager.initialise();
  await speechService.initializeSpeechService();
  runApp(MemoryEnhancerApp());
  fileOperations.initialNoteFile();
}

class MemoryEnhancerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultThemeMode: ThemeMode.light,
      lightTheme: lightTheme,
      darkTheme: darkTheme,
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        themeMode: themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        debugShowCheckedModeBanner: false,
        builder: (context, nativeNavigator) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerDelegate: appRouter.delegate(),
            routeInformationParser: appRouter.defaultRouteParser(),
          );
        },
      ),
    );
  }
}
