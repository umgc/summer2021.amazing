import 'package:auto_route/annotations.dart';
import 'package:memory_enhancer_app/ui/contact_us/contact_us_view.dart';
import 'package:memory_enhancer_app/ui/home/home_view.dart';
import 'package:memory_enhancer_app/ui/notes/notes_view.dart';
import 'package:memory_enhancer_app/ui/settings/general/general_settings_view.dart';
import 'package:memory_enhancer_app/ui/settings/settings_view.dart';
import 'package:memory_enhancer_app/ui/help/help_view.dart';
import 'package:memory_enhancer_app/ui/settings/trigger_words/trigger_words_view.dart';
import 'package:memory_enhancer_app/ui/how_to_videos/how_to_videos_view.dart';

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
  AutoRoute(page: HowToVideosView),
  AutoRoute(page: GeneralSettingsView),
  AutoRoute(page: ContactUsView),
])
class $AppRouter {}
