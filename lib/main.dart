import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/pages/MainPage.dart';

void main() {
  Get.lazyPut(() => MainCtl());

  runApp(AudioServiceWidget(
    child: GetMaterialApp(themeMode: ThemeMode.light, getPages: [
      GetPage(
          name: '/',
          page: () => WillPopScope(
                child: MainPage(),
                onWillPop: () async {
                  var ctl = Get.find<MainCtl>();
                  var rtn = true;
                  rtn &= ctl.ocrData['brun'] == 0;
                  rtn &= !AudioService.runningStream.value;

                  ctl.update();
                  print(rtn);
                  return rtn;
                },
              )),
    ]),
  ));
}
