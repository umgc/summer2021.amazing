// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:memory_enhancer_app/ui/home/home_view.dart' as _i3;
import 'package:memory_enhancer_app/ui/settings/settings_view.dart' as _i4;
import 'package:memory_enhancer_app/ui/trigger_words/trigger_words_view.dart' as _i5;
import 'package:flutter/material.dart' as _i2;

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
    TriggerWordsViewRoute.name: (routeData) => _i1.AdaptivePage<dynamic>(
        routeData: routeData,
        builder: (_) {
          return _i5.TriggerWordsView();
        })
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(HomeViewRoute.name, path: '/'),
    _i1.RouteConfig(SettingsViewRoute.name,
        path: '/settings-view'),
    _i1.RouteConfig(TriggerWordsViewRoute.name,
        path: '/trigger-words-view')
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

class TriggerWordsViewRoute extends _i1.PageRouteInfo {
  const TriggerWordsViewRoute() : super(name, path: '/trigger-words-view');

  static const String name = 'TriggerWordsViewRoute';
}