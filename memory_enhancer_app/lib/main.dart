import 'package:memory_enhancer_app/services/get_it.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'app/themes/dark_theme.dart';
import 'app/themes/light_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  // something
  await ThemeManager.initialise();
  await speechService.initialize();
  fileOperations.initialNoteFile();
  fileOperations.initializeTriggersFile();
  fileOperations.initializeSettingsFile(false);
  await dataProcessingService.initialize();
  fileOperations.cleanupNotes();
  runApp(MemoryEnhancerApp());
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
