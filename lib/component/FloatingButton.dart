import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainAudio.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:path_provider/path_provider.dart';

class FloatingButton extends GetView<MainCtl> {
  TextPlayerTask t = TextPlayerTask();

  FlutterTts tts = FlutterTts();
  bool bplayTts = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (c, snapshot) {
          // [*]------ TEST ------[*]

          // [*]------ TEST ------[*]
          bool bplay = snapshot.data ?? false;
          return FloatingActionButton(
              elevation: 2.0,
              onPressed: () async {
                if (bplay) {
                  controller.stop();
                } else {
                  // // bplayTts = true;
                  // Map params = controller.config;
                  // Map ttsConf = params['tts'];
                  // var filterList = (params['filter'] as List)
                  //     .where((element) => element['enable'])
                  //     .toList();
                  // filterList.forEach((e) {

                  //   if (e['expr']) {
                  //     test = test.replaceAllMapped(
                  //         RegExp('${e["filter"]}'), (match) => e['to']);
                  //   } else {
                  //     test = test.replaceAll(e["filter"], e['to']);
                  //   }
                  // });
                  // await tts.awaitSpeakCompletion(true);
                  // await tts.setSpeechRate(ttsConf['speechRate']);
                  // await tts.setVolume(ttsConf['volume']);
                  // await tts.setPitch(ttsConf['pitch']);
                  // await tts.speak('''
                  //   ***
                  //   !!!
                  //   (1)
                  //   [1]
                  //   []
                  //   ()
                  //   {}
                  //   1~3
                  //   1~
                  //   @
                  //   @@
                  //   ##
                  //   #
                  //   \$\$
                  //   \$
                  //   ^
                  //   ^^
                  //   &
                  //   &&
                  //   *

                  // ''');
                  // return;

                  controller.play();
                }
              },
              child: Icon(bplay ? Icons.volume_off_sharp : Icons.volume_up));
        });
  }
}
