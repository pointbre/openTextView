import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/pages/MainPage.dart';

void main() {
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  Get.lazyPut(() => MainCtl());
  runApp(GetMaterialApp(
    theme: ThemeData(dialogTheme: DialogTheme(backgroundColor: Colors.white)),
    getPages: [
      GetPage(name: '/', page: () => MainPage()),
    ],
  ));
}
