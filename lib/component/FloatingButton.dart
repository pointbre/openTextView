import 'dart:io';
import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainAudio.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:path_provider/path_provider.dart';

class FloatingButton extends GetView<MainCtl> {
  TextPlayerTask t = TextPlayerTask();
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
                print('onPressed >> :${bplay}');

                if (bplay) {
                  // print('onStop');
                  t.onStop();
                  // controller.stop();
                } else {
                  print('start');

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
                  await t.onStart({
                    ...(controller.config as Map),
                    "contents": controller.contents
                  });
                  // await t.onPlay();
                  // controller.play();
                }
              },
              child: Icon(bplay ? Icons.volume_off_sharp : Icons.volume_up));
        });
  }
}
