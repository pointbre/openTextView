import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localstorage/localstorage.dart';
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

  final LocalStorage storage = new LocalStorage('opentextview');

  final config = {
    "theme": [].obs,
    "tts": {
      'language': 'ko-KR',
      'speechRate': 0.toDouble(),
      'volume': 0.toDouble(),
      'pitch': 0.toDouble(),
    }.obs,
    "find": {}.obs,
    "filter": {}.obs,
    "nav": [].obs, // 하단 네비게이션바
    "picker": {}.obs,
    "picker3": {}.obs, // 임시
  }.obs;

  @override
  void onInit() async {
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

    // 설정 이벤트
    ever(config['theme'], changeTheme);
    debounce(config['tts'], (v) {
      // tts 옵션 변경시 tts 옵션 처리 로직 부분 .
    }, time: Duration(milliseconds: 500));
    debounce(config['filter'], (v) {
      // tts 음성 시 무시하거나 대체될 로직 부분 ,
    }, time: Duration(seconds: 1));

    debounce(config['find'], (v) {
      // 검색 히스토리 저장을 위한 로직 , 추후 추가 예정.
    }, time: Duration(seconds: 1));
    debounce(config['picker'], (v) {
      // 열어본 파일 히스토리 저장을 위한 로직 부분, 추후 추가 예정.
    }, time: Duration(seconds: 1));

    // [*]--------------[*]
    // 옵션 로드 / 공통 이벤트 처리 로직
    // [*]--------------[*]
    print('loadConfig');
    await storage.ready;
    print('loadConfig');
    // 초기 설정 파일 로드
    assignConfig(storage.getItem('config'));

    // save config , 초기 설정 로드 후 저장 이벤트 를 셋팅 한다.
    config.keys.forEach((key) {
      debounce(config[key], (v) {
        storage.setItem('config', config.toJson());
      }, time: Duration(milliseconds: 500));
    });
  }

  assignConfig(Map<String, dynamic> tmpConfig) {
    tmpConfig.keys.forEach((key) {
      if (config[key] == null) {
        return;
      }
      if (config[key].runtimeType == RxList) {
        (config[key] as RxList).assignAll(tmpConfig[key]);
      } else {
        print(' >>>:>:>:>: ${config[key]}');
        (config[key] as RxMap).assignAll(tmpConfig[key]);
      }
    });
  }

  changeTheme(v) {
    if (v != null && v.length <= 0) {
      return;
    }
    int c1 = v[0];
    int c2 = v[1];
    Color color1 = Color(c1);
    Color color2 = Color(c2);
    Get.changeTheme(ThemeData(
        scaffoldBackgroundColor: color1,
        dialogBackgroundColor: color1,
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: color1),
        cardTheme: CardTheme(color: color1),
        hintColor: color2,
        colorScheme: ColorScheme.light(
          primary: color2,
          primaryVariant: color2,
          secondary: color2,
          secondaryVariant: color2,
          surface: color1,
          // background: color1,
          // error: color1,
          onPrimary: color1,
          onSecondary: color1,
          onSurface: color2,
        ),
        // accentColor: color2,
        iconTheme: IconThemeData(color: color2),
        // accentIconTheme: IconThemeData(color: color2),
        primaryIconTheme: IconThemeData(color: color2),
        checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(color2),
            checkColor: MaterialStateProperty.all(color1)),
        textTheme: TextTheme(
          headline3: TextStyle(color: color2),
          headline4: TextStyle(color: color2),
          headline5: TextStyle(color: color2),
          headline6: TextStyle(color: color2),
          headline1: TextStyle(color: color2),
          headline2: TextStyle(color: color2),
          bodyText1: TextStyle(color: color2),
          bodyText2: TextStyle(color: color2),
          subtitle1: TextStyle(color: color2),
          subtitle2: TextStyle(color: color2),
          overline: TextStyle(color: color2),
          caption: TextStyle(color: color2),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: color2),
          border: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color2,
            ),
          ),
        ),
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: color2)));
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
