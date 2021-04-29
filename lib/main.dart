import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/pages/MainPage.dart';

void main() {
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  Get.lazyPut(() => MainCtl());
  var testColor = [0xFF0A174E, 0xFFF5D042];
  runApp(GetMaterialApp(
    getPages: [
      GetPage(name: '/', page: () => MainPage()),
    ],
  ));
}
