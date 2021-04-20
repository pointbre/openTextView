import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/items/NavBtnItems.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FindObj {
  FindObj({this.pos, this.contents});
  int pos;
  String contents;
}

class TtsConfig {
  TtsConfig(
      {this.language, this.speechRate, this.volume, this.pitch, this.voice});
  String language;
  double speechRate;
  double volume;
  double pitch;
  var voice;
}

class MainCtl extends GetxController {
  final itemScrollctl = ItemScrollController();
  final itemPosListener = ItemPositionsListener.create();

  final bottomNavBtns = [...NAVBUTTON].obs;
  final curPos = 0.obs;

  final contents = [];

  // 기능 영역
  // --- 검색기능 ---
  final findText = "".obs;
  final findList = List<FindObj>.empty().obs;

  // --- tts기능 ---
  final ttsConfig = TtsConfig().obs;

  final config = {
    "theme": [].obs,
    "tts": {
      'language': 'ko-KR',
      'speechRate': 0.toDouble(),
      'volume': 0.toDouble(),
      'pitch': 0.toDouble(),
    }.obs,
    "find": {}.obs,
    "picker": {}.obs,
    "picker2": {}.obs,
    "picker3": {}.obs,
  };

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < 500; i++) {
      contents.add('Item $i');
    }
    itemPosListener.itemPositions.addListener(() {
      var min = itemPosListener.itemPositions.value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index;
      curPos.value = min;
      curPos.update((val) {});
    });

    ever(config['theme'], (v) {
      if (v != null && v.length <= 0) {
        return;
      }
      int color1 = v[0];
      int color2 = v[1];
      Get.changeTheme(ThemeData(
        scaffoldBackgroundColor: Color(color1),
        dialogBackgroundColor: Color(color1),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(color1)),
        cardTheme: CardTheme(color: Color(color1)),
        hintColor: Color(color2),
        colorScheme: ColorScheme.light(
          primary: Color(color2),
          primaryVariant: Color(color2),
          secondary: Color(color2),
          secondaryVariant: Color(color2),
          surface: Color(color1),
          // background: Color(color1),
          // error: Color(color1),
          onPrimary: Color(color1),
          onSecondary: Color(color1),
          onSurface: Color(color2),
        ),
        accentColor: Color(color2),
        iconTheme: IconThemeData(color: Color(color2)),
        accentIconTheme: IconThemeData(color: Color(color2)),
        primaryIconTheme: IconThemeData(color: Color(color2)),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(Color(color2)),
            checkColor: MaterialStateProperty.all(Color(color1))),
        textTheme: TextTheme(
          headline3: TextStyle(color: Color(color2)),
          headline4: TextStyle(color: Color(color2)),
          headline5: TextStyle(color: Color(color2)),
          headline6: TextStyle(color: Color(color2)),
          headline1: TextStyle(color: Color(color2)),
          headline2: TextStyle(color: Color(color2)),
          bodyText1: TextStyle(color: Color(color2)),
          bodyText2: TextStyle(color: Color(color2)),
          subtitle1: TextStyle(color: Color(color2)),
          subtitle2: TextStyle(color: Color(color2)),
          overline: TextStyle(color: Color(color2)),
          caption: TextStyle(color: Color(color2)),
        ),
      ));
    });
  }

  // void runFindContents(String text) {
  //   findList.clear();
  //   if (text != "") {
  //     this.contents.asMap().forEach((key, value) {
  //       if (value.toString().indexOf(text) >= 0) {
  //         findList.add(FindObj(pos: key, contents: value));
  //       }
  //     });
  //   }
  //   findText.value = text;
  //   update();
  // }
}
