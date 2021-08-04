//**************************************************************
// Help View UI
//**************************************************************
import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/list_item/menu_list_item.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

class HelpView extends StatefulWidget {
  HelpView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  double fontSizeMenu = 25;

  @override
  void initState() {
    fileOperations.getSettingsValue('fontSizeMenu').then((String value) {
      setState(() {
        fontSizeMenu = double.parse(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Help'),
      body: Center(
        child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              CustomMenuListItem(location: PageEnums.contactUs, fontSizeMenu: fontSizeMenu),
              CustomMenuListItem(location: PageEnums.howToVideos, fontSizeMenu: fontSizeMenu),
            ]
        ),
      ),
      bottomNavigationBar: BottomNavigationBarController(
          pageIndex: PageEnums.help.index),
    );
  }
}