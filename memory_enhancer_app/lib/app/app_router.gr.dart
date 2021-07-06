// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;
import 'package:memory_enhancer_app/ui/help/help_view.dart' as _i6;
import 'package:memory_enhancer_app/ui/home/home_view.dart' as _i3;
import 'package:memory_enhancer_app/ui/notes/notes_view.dart' as _i5;
import 'package:memory_enhancer_app/ui/settings/settings_view.dart' as _i4;
import 'package:memory_enhancer_app/ui/trigger_words/trigger_words_view.dart'
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
        builder: (_) {
          return _i4.SettingsView();
        }),
    NotesViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i5.NotesView();
        }),
    HelpViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i6.HelpView();
        }),
    TriggerWordsViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (data) {
          final args = data.argsAs<TriggerWordsViewRouteArgs>(
              orElse: () => const TriggerWordsViewRouteArgs());
          return _i7.TriggerWordsView(key: args.key);
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomeViewRoute.name, path: '/'),
        _i1.RouteConfig(SettingsViewRoute.name, path: '/settings-view'),
        _i1.RouteConfig(NotesViewRoute.name, path: '/notes-view'),
        _i1.RouteConfig(HelpViewRoute.name, path: '/help-view'),
        _i1.RouteConfig(TriggerWordsViewRoute.name, path: '/trigger-words-view')
      ];
}

class HomeViewRoute extends _i1.PageRouteInfo {
  const HomeViewRoute() : super(name, path: '/');

  static const String name = 'HomeViewRoute';
}

class SettingsViewRoute extends _i1.PageRouteInfo {
  const SettingsViewRoute() : super(name, path: '/settings-view');

  static const String name = 'SettingsViewRoute';
}

class NotesViewRoute extends _i1.PageRouteInfo {
  const NotesViewRoute() : super(name, path: '/notes-view');

  static const String name = 'NotesViewRoute';
}

class HelpViewRoute extends _i1.PageRouteInfo {
  const HelpViewRoute() : super(name, path: '/help-view');

  static const String name = 'HelpViewRoute';
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
