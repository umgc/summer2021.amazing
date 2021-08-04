import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memory_enhancer_app/app/app_router.gr.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';

Card CustomMenuListItem({required PageEnums location, required double fontSizeMenu}) {
  return Card(
      child: InkWell(
          splashColor: lightTheme.accentColor,
          onTap: () {
            navigate(location);
          },
          child: ListTile(
            title: Text(location.name,
                style: GoogleFonts.anton(
                    fontSize: fontSizeMenu, textStyle: TextStyle(letterSpacing: .75))),
          )));
}

void navigate(PageEnums location) {
  switch (location.index) {
    case 4:
      appRouter.pushAndPopUntil(TriggerWordsViewRoute(),
          predicate: (_) => false);
      break;
    case 5:
      appRouter.pushAndPopUntil(HowToVideosViewRoute(),
          predicate: (_) => false);
      break;
    case 6:
      appRouter.pushAndPopUntil(GeneralSettingsViewRoute(),
          predicate: (_) => false);
      break;
    case 7:
      appRouter.pushAndPopUntil(ContactUsViewRoute(),
          predicate: (_) => false);
      break;
    default:
      appRouter.pushAndPopUntil(HomeViewRoute(), predicate: (_) => false);
  }
}
