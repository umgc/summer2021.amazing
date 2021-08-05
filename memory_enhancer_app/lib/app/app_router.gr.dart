// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;
import 'package:memory_enhancer_app/ui/contact_us/contact_us_view.dart' as _i10;
import 'package:memory_enhancer_app/ui/help/help_view.dart' as _i6;
import 'package:memory_enhancer_app/ui/home/home_view.dart' as _i3;
import 'package:memory_enhancer_app/ui/how_to_videos/how_to_videos_view.dart'
    as _i8;
import 'package:memory_enhancer_app/ui/notes/notes_view.dart' as _i5;
import 'package:memory_enhancer_app/ui/settings/general/general_settings_view.dart'
    as _i9;
import 'package:memory_enhancer_app/ui/settings/settings_view.dart' as _i4;
import 'package:memory_enhancer_app/ui/settings/trigger_words/trigger_words_view.dart'
    as _i7;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    HomeViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i3.HomeView();
        }),
    SettingsViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<SettingsViewRouteArgs>(
              orElse: () => const SettingsViewRouteArgs());
          return _i4.SettingsView(key: args.key);
        }),
    NotesViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<NotesViewRouteArgs>(
              orElse: () => const NotesViewRouteArgs());
          return _i5.NotesView(key: args.key);
        }),
    HelpViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<HelpViewRouteArgs>(
              orElse: () => const HelpViewRouteArgs());
          return _i6.HelpView(key: args.key);
        }),
    TriggerWordsViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<TriggerWordsViewRouteArgs>(
              orElse: () => const TriggerWordsViewRouteArgs());
          return _i7.TriggerWordsView(key: args.key);
        }),
    HowToVideosViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<HowToVideosViewRouteArgs>(
              orElse: () => const HowToVideosViewRouteArgs());
          return _i8.HowToVideosView(key: args.key);
        }),
    GeneralSettingsViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<GeneralSettingsViewRouteArgs>(
              orElse: () => const GeneralSettingsViewRouteArgs());
          return _i9.GeneralSettingsView(key: args.key);
        }),
    ContactUsViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<ContactUsViewRouteArgs>(
              orElse: () => const ContactUsViewRouteArgs());
          return _i10.ContactUsView(key: args.key);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomeViewRoute.name, path: '/'),
        _i1.RouteConfig(SettingsViewRoute.name, path: '/settings-view'),
        _i1.RouteConfig(NotesViewRoute.name, path: '/notes-view'),
        _i1.RouteConfig(HelpViewRoute.name, path: '/help-view'),
        _i1.RouteConfig(TriggerWordsViewRoute.name,
            path: '/trigger-words-view'),
        _i1.RouteConfig(HowToVideosViewRoute.name, path: '/how-to-videos-view'),
        _i1.RouteConfig(GeneralSettingsViewRoute.name,
            path: '/general-settings-view'),
        _i1.RouteConfig(ContactUsViewRoute.name, path: '/contact-us-view')
      ];
}

class HomeViewRoute extends _i1.PageRouteInfo {
  const HomeViewRoute() : super(name, path: '/');

  static const String name = 'HomeViewRoute';
}

class SettingsViewRoute extends _i1.PageRouteInfo<SettingsViewRouteArgs> {
  SettingsViewRoute({_i2.Key? key})
      : super(name,
            path: '/settings-view', args: SettingsViewRouteArgs(key: key));

  static const String name = 'SettingsViewRoute';
}

class SettingsViewRouteArgs {
  const SettingsViewRouteArgs({this.key});

  final _i2.Key? key;
}

class NotesViewRoute extends _i1.PageRouteInfo<NotesViewRouteArgs> {
  NotesViewRoute({_i2.Key? key})
      : super(name, path: '/notes-view', args: NotesViewRouteArgs(key: key));

  static const String name = 'NotesViewRoute';
}

class NotesViewRouteArgs {
  const NotesViewRouteArgs({this.key});

  final _i2.Key? key;
}

class HelpViewRoute extends _i1.PageRouteInfo<HelpViewRouteArgs> {
  HelpViewRoute({_i2.Key? key})
      : super(name, path: '/help-view', args: HelpViewRouteArgs(key: key));

  static const String name = 'HelpViewRoute';
}

class HelpViewRouteArgs {
  const HelpViewRouteArgs({this.key});

  final _i2.Key? key;
}

class TriggerWordsViewRoute
    extends _i1.PageRouteInfo<TriggerWordsViewRouteArgs> {
  TriggerWordsViewRoute({_i2.Key? key})
      : super(name,
            path: '/trigger-words-view',
            args: TriggerWordsViewRouteArgs(key: key));

  static const String name = 'TriggerWordsViewRoute';
}

class TriggerWordsViewRouteArgs {
  const TriggerWordsViewRouteArgs({this.key});

  final _i2.Key? key;
}

class HowToVideosViewRoute extends _i1.PageRouteInfo<HowToVideosViewRouteArgs> {
  HowToVideosViewRoute({_i2.Key? key})
      : super(name,
            path: '/how-to-videos-view',
            args: HowToVideosViewRouteArgs(key: key));

  static const String name = 'HowToVideosViewRoute';
}

class HowToVideosViewRouteArgs {
  const HowToVideosViewRouteArgs({this.key});

  final _i2.Key? key;
}

class GeneralSettingsViewRoute
    extends _i1.PageRouteInfo<GeneralSettingsViewRouteArgs> {
  GeneralSettingsViewRoute({_i2.Key? key})
      : super(name,
            path: '/general-settings-view',
            args: GeneralSettingsViewRouteArgs(key: key));

  static const String name = 'GeneralSettingsViewRoute';
}

class GeneralSettingsViewRouteArgs {
  const GeneralSettingsViewRouteArgs({this.key});

  final _i2.Key? key;
}

class ContactUsViewRoute extends _i1.PageRouteInfo<ContactUsViewRouteArgs> {
  ContactUsViewRoute({_i2.Key? key})
      : super(name,
            path: '/contact-us-view', args: ContactUsViewRouteArgs(key: key));

  static const String name = 'ContactUsViewRoute';
}

class ContactUsViewRouteArgs {
  const ContactUsViewRouteArgs({this.key});

  final _i2.Key? key;
}
