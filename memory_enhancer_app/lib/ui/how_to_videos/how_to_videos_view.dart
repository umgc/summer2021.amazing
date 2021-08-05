//**************************************************************
// Trigger Words View UI
// Author: Mo Drammeh
//**************************************************************

import 'package:flutter/material.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:xml/xml.dart' as xml;

class HowToVideosView extends StatefulWidget {
  HowToVideosView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HowToVideosViewState();
}

class _HowToVideosViewState extends State<HowToVideosView> {
  final List<Map> videoUrls = <Map<String, String>>[];

  @override
  void initState() {
    fileOperations.getHowToVideoLinks().then((value) {
      setState(() {
        for(xml.XmlElement xmlElement in value){
          String title = xmlElement.findElements('title').first.innerText;
          String url = xmlElement.findElements('url').first.innerText;
          videoUrls.add(<String, String>{'title':title, 'url':url});
        }
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
            appBar: CustomAppBar(title: PageEnums.howToVideos.name),
            body: ListView.separated(
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              padding: const EdgeInsets.all(8),
              itemCount: videoUrls.length,
              itemBuilder: (BuildContext context, int index) {
                return YouTubePlayerInline(title: videoUrls[index]['title'], url: videoUrls[index]['url']);
              },
            ),
            bottomNavigationBar: BottomNavigationBarController(
                pageIndex: PageEnums.help.index),
          );
  }
}

ListBody YouTubePlayerInline({required String url, required String title}) {
  YoutubePlayerController ytCtrl = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(url).toString(),
    flags: YoutubePlayerFlags(
      hideControls: false,
      controlsVisibleAtStart: true,
      autoPlay: false,
      mute: false,
    ),
  );

  return ListBody(children: <Widget>[
    Center(child: Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25))),
    YoutubePlayer(
      controller: ytCtrl,
      showVideoProgressIndicator: true,
      progressIndicatorColor: lightTheme.accentColor,
    )
  ]);
}