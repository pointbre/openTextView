import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/pages/MainPage.dart';

void main() {
  Get.lazyPut(() => MainCtl());
  runApp(AudioServiceWidget(
    child: GetMaterialApp(getPages: [
      GetPage(name: '/', page: () => MainPage()),
    ]),
  ));
}
