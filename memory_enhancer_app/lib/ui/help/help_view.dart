//**************************************************************
// Help View UI
//**************************************************************
import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/ui/list_item/menu_list_item.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';

class HelpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Help'),
      body: Center(
        child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              CustomMenuListItem(location: PageEnums.contactUs),
              CustomMenuListItem(location: PageEnums.howToVideos),
            ]
        ),
      ),
      bottomNavigationBar: BottomNavigationBarController(
          pageIndex: PageEnums.help.index),
    );
  }
}