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
                  print('start');
                  var en = await tts.getEngines;
                  List vos = await tts.getVoices;

                  print(vos.where((element) => element['locale'] == 'ko-KR'));
                  await tts.awaitSpeakCompletion(true);
                  print('awaitSpeakCompletion');
                  await tts.setSpeechRate(2.8);
                  print('setSpeechRate');
                  await tts.setVolume(1.0);
                  print('setVolume');
                  await tts.setPitch(1.0);
                  print('setPitch');
                  await tts
                      .setVoice({"name": "ko-KR-language", "locale": "ko-KR"});

                  var aa = await tts
                      .speak([...controller.contents.getRange(0, 20)].join());
                  print(aa);

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
