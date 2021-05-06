import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charset_detector/flutter_charset_detector.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainAudio.dart';
import 'package:open_textview/items/NavBtnItems.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FindObj {
  FindObj({this.pos, this.contents});
  int pos;
  String contents;
}

class MainCtl extends GetxController {
  final itemScrollctl = ItemScrollController();
  final itemPosListener = ItemPositionsListener.create();

  final curPos = 0.obs;

  final contents = [].obs;

  // 기능 영역
  // --- 검색기능 ---
  final findText = "".obs;
  final findList = List<FindObj>.empty().obs;

// AudioService.play();
  // --- tts기능 ---

  final LocalStorage storage = new LocalStorage('opentextview');

  final playState = false.obs;

  final history = [].obs;
  final config = {
    "theme": [].obs,
    "tts": {
      'language': 'ko-KR',
      'speechRate': 1.toDouble(),
      'volume': 1.toDouble(),
      'pitch': 1.toDouble(),
      'groupcnt': 1,
    }.obs,
    "filter": [].obs,
    "nav": [].obs, // 하단 네비게이션바
    "picker": {}.obs,
  }.obs;

  void onScroll() {
    var min = itemPosListener.itemPositions.value
        .where((ItemPosition position) => position.itemTrailingEdge > 0)
        .reduce((ItemPosition min, ItemPosition position) =>
            position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
        .index;

    curPos.value = min;
    int whereIdx = history.indexWhere((element) {
      return element['name'] == (config['picker'] as Map)['name'];
    });
    DateTime now = DateTime.now();
    DateFormat formatter = new DateFormat('yyyy-MM-dd hh-mm-ss');
    if (curPos.value > 0) {
      history[whereIdx]['pos'] = curPos.value;
    }
    history[whereIdx]['date'] = formatter.format(now);
    history.refresh();
    update(['scroll']);
  }

  @override
  void onInit() async {
    super.onInit();

    itemPosListener.itemPositions.addListener(onScroll);

    // 설정 이벤트
    ever(config['theme'], changeTheme);
    debounce(config['tts'], (ttsConf) async {
      // tts 옵션 변경시 tts 옵션 처리 로직 부분 .
      // FlutterTts tts = FlutterTts();
      // await tts.setSpeechRate(ttsConf['speechRate']);
      // await tts.setVolume(ttsConf['volume']);
      // await tts.setPitch(ttsConf['pitch']);
    }, time: Duration(milliseconds: 500));
    debounce(config['filter'], (v) {
      // tts 음성 시 무시하거나 대체될 로직 부분 ,
    }, time: Duration(seconds: 1));

    debounce(config['picker'], (v) async {
      print('configconfigFilePickerFilePickerFilePicker${v}');
      // return;
      if ((v as Map).isNotEmpty) {
        File file = File(v['path']);
        if (file.existsSync()) {
          Uint8List u8list = file.readAsBytesSync();
          DecodingResult decodeContents =
              await CharsetDetector.autoDecode(u8list);
          // contents.clear();
          contents.assignAll(decodeContents.string.split('\n'));
          update();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            int whereIdx = history.indexWhere((element) {
              return element['name'] == (config['picker'] as Map)['name'];
            });
            DateTime now = DateTime.now();
            DateFormat formatter = new DateFormat('yyyy-MM-dd hh-mm-ss');

            if (whereIdx < 0) {
              history.add(
                  {'name': v['name'], 'pos': 0, 'date': formatter.format(now)});
              itemScrollctl.jumpTo(index: 0);
            } else {
              itemScrollctl.jumpTo(index: history[whereIdx]['pos']);
              history[whereIdx]['date'] = formatter.format(now);
            }
            itemPosListener.itemPositions.addListener(onScroll);
          });
        }
      }
    }, time: Duration(milliseconds: 300));

    // [*]--------------[*]
    // 옵션 로드 / 공통 이벤트 처리 로직
    // [*]--------------[*]
    await storage.ready;

    // 초기 설정 파일 로드
    print('초기 설정 파일 로드');
    print(storage.getItem('config'));
    print(storage.getItem('history'));
    print('초기 설정 파일 로드 end');
    try {
      assignConfig(storage.getItem('config') ?? {});
      assignHistory(storage.getItem('history') ?? []);
    } catch (e) {
      // storage.clear();
    }

    // save config , 초기 설정 로드 후 저장 이벤트 를 셋팅 한다.
    config.keys.forEach((key) {
      debounce(config[key], (v) async {
        await storage.ready;
        await storage.setItem('config', config.toJson());
      }, time: Duration(milliseconds: 1000));
    });

    debounce(history, (v) async {
      await storage.ready;
      await storage.setItem('history', history.toJson());
    }, time: Duration(milliseconds: 1100));
  }

  setConfig(Map<String, dynamic> config, List history) {
    try {
      assignConfig(config ?? {});
      assignHistory(history ?? []);
    } catch (e) {}
  }

  assignHistory(List tmpHistory) {
    // print(tmpHistory);
    history.assignAll(tmpHistory);
  }

  assignConfig(Map<String, dynamic> tmpConfig) {
    tmpConfig.keys.forEach((key) {
      if (config[key] == null) {
        return;
      }
      try {
        if (config[key] is RxList && (tmpConfig[key] as List).isNotEmpty) {
          (config[key] as RxList).assignAll(tmpConfig[key]);
        } else if (config[key] is RxMap && (tmpConfig[key] as Map).isNotEmpty) {
          (config[key] as RxMap).assignAll(tmpConfig[key]);
        }
      } catch (e) {
        print(e);
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
        cardTheme: CardTheme(color: getSwatchShade(color1, 400)), //
        hintColor: color2,
        colorScheme: ColorScheme.light(
          primary: color2,
          primaryVariant: color2,
          secondary: color2,
          secondaryVariant: color2,
          surface: getSwatchShade(color1, 400),
          // background: color1,
          // error: color1,
          onPrimary: color1,
          onSecondary: color1,
          onSurface: color2,
        ),
        accentColor: color2,
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

  Color getSwatchShade(Color c, int swatchValue) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withSaturation(1 - (swatchValue / 1000)).toColor();
  }

  void play() async {
    if (!AudioService.connected) {
      await AudioService.connect();
    }
    await AudioService.start(
      backgroundTaskEntrypoint: textToSpeechTaskEntrypoint,
      androidNotificationChannelName: 'openTextView',
      androidNotificationColor: 0xFF2196f3,
      androidNotificationIcon: 'mipmap/ic_launcher',
      params: {
        ...Map.from(config),
        "contents": contents,
        "history": List.from(history)
      },
    );
    AudioService.currentMediaItemStream.listen((event) {
      print('event.extras : ${event?.extras}');
      if (event?.extras != null) {
        itemScrollctl.jumpTo(index: event.extras['pos']);

        curPos.update((val) {
          val = event.extras['pos'];
          return val;
        });
        update();
      }
      // itemScrollctl.jumpTo(index: event.extras['pos']);
      // print('currentMediaItemStream : ${event.extras}');
    });
    await AudioService.play();
  }

  void stop() async {
    await AudioService.stop();
    await AudioService.disconnect();
  }
}
