//**************************************************************
// Home view UI
// Author: Christian Ahmed
//**************************************************************
import 'package:memory_enhancer_app/app/themes/dark_theme.dart';
import 'package:memory_enhancer_app/app/themes/light_theme.dart';
import 'package:memory_enhancer_app/services/services.dart';
import 'package:memory_enhancer_app/ui/app_bar/app_bar.dart';
import 'package:memory_enhancer_app/ui/enums/enums.dart';
import 'package:memory_enhancer_app/ui/navigation/navigation_controller.dart';
import 'package:memory_enhancer_app/ui/home/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:avatar_glow/avatar_glow.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      // Initialize the HomeView model
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) {
        model.initialize();
      },

      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: lightTheme.primaryColor,
          appBar: CustomAppBar(title: 'Memory Enhancer'),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
                      child: Text(
                        speechService.interimTranscription,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                        ),
                        textAlign: TextAlign.left,
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
                          endRadius: 200.0,
                          duration: const Duration(milliseconds: 2000),
                          repeatPauseDuration:
                              const Duration(milliseconds: 100),
                          repeat: true,
                          child: Container(
                            height: 200,
                            width: 200,
                            child: FloatingActionButton(
                              elevation: 10,
                              backgroundColor: darkTheme.primaryColor,
                              foregroundColor: Colors.white,
                              onPressed: () {
                                model.handleListening();
                              },
                              child: Icon(
                                model.listening ? Icons.mic : Icons.mic_none,
                                size: 180,
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar:
              BottomNavigationBarController(pageIndex: PageEnums.home.index),
        );
      },
    );
  }
}
