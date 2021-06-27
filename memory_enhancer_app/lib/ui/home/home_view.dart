import 'package:memory_enhancer_app/app/themes/light_Theme.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/drawer/drawer.dart';
import 'package:memory_enhancer_app/ui/home/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:avatar_glow/avatar_glow.dart';

import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        model.initialize();
      },

      builder: (context, model, child) {
        return Scaffold(
            backgroundColor: lightTheme.primaryColor,
            endDrawer: NavDrawer(),
            appBar: AppBar(
              title: Text(
                'Memory Enhancer',
                style: GoogleFonts.lobster(fontSize: 35),
              ),
              backgroundColor: lightTheme.accentColor,
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 100.0),
                        child: Text(
                          speechService.speech.lastRecognizedWords,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400,
                              fontSize: 30
                          ),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Stack(
                      children: [
                        Positioned.fill(
                            child: Center(
                              child: AvatarGlow(
                                showTwoGlows: true,
                                animate: model.listening,
                                glowColor: Colors.grey,
                                endRadius: 250.0,
                                duration: const Duration(milliseconds: 2000),
                                repeatPauseDuration: const Duration(milliseconds: 100),
                                repeat: true,
                                child: Container(
                                  height: 250,
                                  width: 250,
                                  child: FloatingActionButton(
                                    elevation: 10,
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    onPressed: () {
                                      model.startListening();
                                    },
                                    child: Icon(model.listening ? Icons.mic : Icons.mic_none, size: 190,),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}