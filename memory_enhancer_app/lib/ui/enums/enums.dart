enum PageEnums {
  home,
  notes,
  settings,
  help,
  triggerWords,
  howToVideos,
  generalSettings,
  contactUs
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
      case PageEnums.howToVideos:
        return 'How To Videos';
      case PageEnums.generalSettings:
        return 'General Settings';
      case PageEnums.contactUs:
        return 'Contact Us';
      default:
        return "";
    }
  }
}