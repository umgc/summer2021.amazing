enum PageEnums {
  home,
  notes,
  settings,
  help,
  triggerWords
}

extension PageEnumsExtention on PageEnums {

  String get name {
    switch (this) {
      case PageEnums.home:
        return 'Home';
      case PageEnums.notes:
        return 'Notes';
      case PageEnums.settings:
        return 'Settings';
      case PageEnums.help:
        return 'Help';
      case PageEnums.triggerWords:
        return 'Trigger Words';
      default:
        return "";
    }
  }
}