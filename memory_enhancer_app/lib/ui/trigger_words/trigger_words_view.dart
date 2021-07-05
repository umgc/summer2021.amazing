//**************************************************************
// Trigger Words View UI
// Author: Mo Drammeh
//**************************************************************

import 'package:memory_enhancer_app/app/themes/light_Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TriggerWordsView extends StatefulWidget {
  TriggerWordsView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TriggerWordsViewState();

}

class _TriggerWordsViewState extends State<TriggerWordsView> {
  List<String> triggerWords = <String>[];

  void getTriggerWordsFromFile() async {
    String fileText = await rootBundle.loadString('assets/text/words.txt');
    setState(() {
      triggerWords = fileText.split('\n');
    });
  }

  @override
  void initState() {
    super.initState();

    getTriggerWordsFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text(
                'Trigger Words',
                style: GoogleFonts.lobster(fontSize: 35),
              ),
              backgroundColor: lightTheme.accentColor,
            ),
            body: Center(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: triggerWords.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 50,
                      color: Colors.red[900],
                      child: Center(child: Text('${triggerWords[index]}', style: TextStyle(fontSize: 25, color: Colors.white)))
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
            ));
  }
}
