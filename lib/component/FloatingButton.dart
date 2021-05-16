import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainAudio.dart';
import 'package:open_textview/controller/MainCtl.dart';

class FloatingButton extends GetView<MainCtl> {
  // TextPlayerTask t = TextPlayerTask();

  // FlutterTts tts = FlutterTts();
  // bool bplayTts = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioService.runningStream,
        builder: (c, snapshot) {
          bool bplay = snapshot.data ?? false;
          return FloatingActionButton(
              elevation: 2.0,
              onPressed: () async {
                if (bplay) {
                  controller.stop();
                } else {
                  controller.play();
                }
              },
              child: Icon(bplay ? Icons.volume_off_sharp : Icons.volume_up));
        });
  }
}
