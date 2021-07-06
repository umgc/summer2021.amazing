import 'package:auto_route/annotations.dart';
import 'package:memory_enhancer_app/ui/home/home_view.dart';
import 'package:memory_enhancer_app/ui/notes/notes_view.dart';
import 'package:memory_enhancer_app/ui/settings/settings_view.dart';
import 'package:memory_enhancer_app/ui/help/help_view.dart';
import 'package:memory_enhancer_app/ui/trigger_words/trigger_words_view.dart';

// Ahmed: Execute below to generated dependency injection
    // flutter packages pub run build_runner watch
    // - OR -
    // flutter packages pub run build_runner build

@AdaptiveAutoRouter(routes: <AutoRoute>[
  AutoRoute(page: HomeView, initial: true),
  AutoRoute(page: SettingsView),
  AutoRoute(page: NotesView),
  AutoRoute(page: HelpView),
  AutoRoute(page: TriggerWordsView),
])
class $AppRouter {}
