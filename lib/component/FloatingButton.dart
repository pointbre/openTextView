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
                print('onPressed >> :${bplayTts}');

                // if (bplay) {
                if (bplayTts) {
                  bplayTts = false;
                  // print('onStop');
                  // t.onStop();
                  // controller.stop();
                  tts.stop();
                } else {
                  bplayTts = true;
                  Map params = controller.config;
                  Map ttsConf = params['tts'];
                  var filterList = (params['filter'] as List)
                      .where((element) => element['enable'])
                      .toList();
                  await tts.awaitSpeakCompletion(true);
                  await tts.setSpeechRate(ttsConf['speechRate']);
                  await tts.setVolume(ttsConf['volume']);
                  await tts.setPitch(ttsConf['pitch']);
                  // print('filter ${filterList}');

                  for (var i = 0; i < 600; i += 10) {
                    String speakText =
                        controller.contents.getRange(i, i + 10).join('\n');
                    filterList.forEach((e) {
                      if (e['expr']) {
                        speakText = speakText.replaceAllMapped(
                            RegExp('${e["filter"]}'), (match) => e['to']);
                      } else {
                        speakText = speakText.replaceAll(e["filter"], e['to']);
                      }
                    });
                    print('>>> ${speakText}');
                    print(speakText.split('\n'));

                    // var aa = await tts.speak(speakText);

                    // print(aa);
                  }

                  // AudioService.playbackStateStream.listen((event) {
                  // });
                  // await AudioService.start(
                  //     backgroundTaskEntrypoint: textToSpeechTaskEntrypoint,
                  //     androidNotificationChannelName: 'openTextView',
                  //     androidNotificationColor: 0xFF2196f3,
                  //     androidNotificationIcon: 'mipmap/ic_launcher',
                  //     params: {
                  //       ...(controller.config as Map),
                  //       "contents": controller.contents
                  //     });
                  // await AudioService.play();
                  // await t.onStart({
                  //   ...(controller.config as Map),
                  //   "contents": controller.contents
                  // });
                  // await t.onPlay();
                  // controller.play();
                }
              },
              child: Icon(bplay ? Icons.volume_off_sharp : Icons.volume_up));
        });
  }
}
