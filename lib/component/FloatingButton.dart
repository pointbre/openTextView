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
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: 2.0,
        onPressed: () async {
          print('000000000000000');
          await AudioService.connect();
          print('p[pppppppppppp');
          var brady = await AudioService.start(
            backgroundTaskEntrypoint: textToSpeechTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            androidNotificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
          );
          print(brady);
          // await AudioService.connect(); // Note: the "await" is necessary!
          AudioService.play();
          // AudioService.stop();

          //  tts 플레이로직 필요
        },
        child: Icon(Icons.volume_up));
  }
}
