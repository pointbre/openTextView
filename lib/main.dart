import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/pages/MainPage.dart';

void main() {
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  Get.lazyPut(() => MainCtl());
  runApp(GetMaterialApp(
    theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF02343F),
        cardTheme: CardTheme(color: Color(0xFF02343F)),
        iconTheme: IconThemeData(color: Color(0xFFF0EDCC)),
        textTheme: TextTheme(
          headline3: TextStyle(color: Color(0xFFF0EDCC)),
          headline4: TextStyle(color: Color(0xFFF0EDCC)),
          headline5: TextStyle(color: Color(0xFFF0EDCC)),
          headline6: TextStyle(color: Color(0xFFF0EDCC)),
          headline1: TextStyle(color: Color(0xFFF0EDCC)),
          headline2: TextStyle(color: Color(0xFFF0EDCC)),
          bodyText1: TextStyle(color: Color(0xFFF0EDCC)),
          bodyText2: TextStyle(color: Color(0xFFF0EDCC)),
          subtitle1: TextStyle(color: Color(0xFFF0EDCC)),
          subtitle2: TextStyle(color: Color(0xFFF0EDCC)),
          overline: TextStyle(color: Color(0xFFF0EDCC)),
          caption: TextStyle(color: Color(0xFFF0EDCC)),
        ),
        dialogTheme: DialogTheme(backgroundColor: Colors.white)),
    getPages: [
      GetPage(name: '/', page: () => MainPage()),
    ],
  ));
}
