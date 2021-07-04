import 'package:auto_route/annotations.dart';
import 'package:memory_enhancer_app/ui/home/home_view.dart';
import 'package:memory_enhancer_app/ui/notes/notes_view.dart';
import 'package:memory_enhancer_app/ui/settings/settings_view.dart';

@AdaptiveAutoRouter(routes: <AutoRoute>[
  AutoRoute(page: HomeView, initial: true),
  AutoRoute(page: SettingsView),
  AutoRoute(page: NotesView)
])
class $AppRouter {}
