//**************************************************************
// Contact Us View UI
// Author: Mo Drammeh
//**************************************************************

import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/list_item/list_item_dynamic.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsView extends StatefulWidget {
  ContactUsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {

  double fontSizeMenu = 20;

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: CustomAppBar(title: PageEnums.contactUs.name),
            body: ListView(
              padding: const EdgeInsets.all(8),
          children: <Widget>[
            CustomOneButtonListItem(fontSizeMenu: fontSizeMenu, title: 'Call Us ', icon: Icon(Icons.phone), onBtnOnePress: (){launch('tel:3012405555'); print('Call (301) 240-5555');}),
            CustomOneButtonListItem(fontSizeMenu: fontSizeMenu, title: 'Email Us', icon: Icon(Icons.mail), onBtnOnePress: (){launch('mailto:help@team.amazing.com'); print('Email help@team.amazing.com');}),
            CustomOneButtonListItem(fontSizeMenu: fontSizeMenu, title: 'Visit Us', icon: Icon(Icons.public), onBtnOnePress: (){launch('https://umgc.edu/'); print('Visit UMGC');}),
            CustomOneButtonListItem(fontSizeMenu: fontSizeMenu, title: 'Facebook', icon: Icon(Icons.facebook), onBtnOnePress: (){launch('https://facebook.com/umgc'); print('Facebook');}),
            CustomOneButtonListItem(fontSizeMenu: fontSizeMenu, title: 'YouTube', icon: Icon(Icons.tv), onBtnOnePress: (){launch('https://youtube.com/channel/UCC1suhu1lcmqv6a1uagvXjA'); print('YouTube');}),
              ]
            ),
            bottomNavigationBar: BottomNavigationBarController(
                pageIndex: PageEnums.help.index),
          );
  }
}