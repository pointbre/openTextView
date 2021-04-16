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
    theme: ThemeData(
      scaffoldBackgroundColor: Color(testColor[0]),
      dialogBackgroundColor: Color(testColor[0]),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Color(testColor[0])),
      cardTheme: CardTheme(color: Color(testColor[0])),

      primarySwatch: MaterialColor(testColor[1], {
        50: Color(testColor[1]),
        100: Color(testColor[1]),
        200: Color(testColor[1]),
        300: Color(testColor[1]),
        400: Color(testColor[1]),
        500: Color(testColor[1]),
        600: Color(testColor[1]),
        700: Color(testColor[1]),
        800: Color(testColor[1]),
        900: Color(testColor[1])
      }),

      // primaryColor: Color(testColor[0]),
      // dividerColor: Color(testColor[1]),
      // colorScheme: ColorScheme(
      //     primary: Color(testColor[1]),
      //     primaryVariant: Color(testColor[1]),
      //     secondary: Color(testColor[1]),
      //     secondaryVariant: Color(testColor[1]),
      //     surface: Color(testColor[1]),
      //     background: Color(testColor[0]),
      //     error: Color(0xFFd32f2f),
      //     onPrimary: Color(testColor[0]),
      //     onSecondary: Color(testColor[1]),
      //     onSurface: Color(testColor[0]),
      //     onBackground: Color(testColor[0]),
      //     onError: Color(0xFFFFFFFF),
      //     brightness: Brightness.light),
      //
      iconTheme: IconThemeData(color: Color(testColor[1])),
      // primaryIconTheme: IconThemeData(color: Color(testColor[1])),
      // accentIconTheme: IconThemeData(color: Color(testColor[1])),
      // floatingActionButtonTheme: FloatingActionButtonThemeData(
      //   backgroundColor: Color(testColor[1]),
      //   foregroundColor: Color(testColor[0]),
      // ),
      //

      checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all(Color(testColor[1])),
          checkColor: MaterialStateProperty.all(Color(testColor[0]))),
      textTheme: TextTheme(
        headline3: TextStyle(color: Color(testColor[1])),
        headline4: TextStyle(color: Color(testColor[1])),
        headline5: TextStyle(color: Color(testColor[1])),
        headline6: TextStyle(color: Color(testColor[1])),
        headline1: TextStyle(color: Color(testColor[1])),
        headline2: TextStyle(color: Color(testColor[1])),
        bodyText1: TextStyle(color: Color(testColor[1])),
        bodyText2: TextStyle(color: Color(testColor[1])),
        subtitle1: TextStyle(color: Color(testColor[1])),
        subtitle2: TextStyle(color: Color(testColor[1])),
        overline: TextStyle(color: Color(testColor[1])),
        caption: TextStyle(color: Color(testColor[1])),
      ),

      // accentIconTheme: IconThemeData(color: Color(testColor[1])),
      // primaryIconTheme: IconThemeData(color: Color(testColor[1])),
      // accentColor: Color(testColor[1]),
      // backgroundColor: Color(testColor[1]),
      // hintColor: Color(testColor[1]),
      // focusColor: Color(testColor[1]),
      // textButtonTheme: TextButtonThemeData(
      //     style: TextButton.styleFrom(
      //         backgroundColor: Color(testColor[1]),
      //         textStyle: TextStyle(color: Color(testColor[0])))),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //   onPrimary: Color(testColor[0]),
      //   primary: Color(testColor[1]),
      // )),

      // sliderTheme: SliderThemeData(
      //   inactiveTrackColor: Color(testColor[1]),
      //   inactiveTickMarkColor: Color(testColor[1]),
      //   thumbColor: Color(testColor[1]),
      // ),
      // buttonTheme: ButtonThemeData(
      //     buttonColor: Color(testColor[1]), textTheme: ButtonTextTheme.primary),

      // dialogTheme: DialogTheme(backgroundColor: Colors.white)
    ),
    getPages: [
      GetPage(name: '/', page: () => MainPage()),
    ],
  ));
}
