import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:open_textview/items/Languages.dart';

// var isOpen = false;

class Option_Tts extends OptionsBase {
  @override
  String get name => 'tts 설정';

  final flutterTts = FlutterTts();
  void openSettingLanguage() async {
    List<dynamic> langs = [];
    // 4월 23 일 :
    // 3월 31 일자 구글 tts 패치후 음성 1번 의 경우 남녀 목소리가 같이 나오는 버그로 인해.
    // 강제로 버전을 다운그레이드 하여 tts 엔진 사용시 지원 언어가나오지 않는 현상으로 인하여 우회 처리 로직 추가

    try {
      langs =
          await flutterTts.getLanguages.timeout(Duration(milliseconds: 300));
    } catch (e) {
      langs = LANG.keys.toList();
    }

    Picker(
        backgroundColor: Theme.of(Get.context).scaffoldBackgroundColor,
        headerColor: Theme.of(Get.context).scaffoldBackgroundColor,
        selecteds: [
          langs.indexOf((controller.config['tts'] as Map)['language'])
        ],
        height: 300,
        adapter: PickerDataAdapter<String>(
          data: langs.map((e) {
            var tmplang = LANG[e.toString()];
            return PickerItem(
              text: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Text(e.toString(),
                        style: TextStyle(
                            color: Theme.of(Get.context).accentColor)),
                  )),
                  Expanded(
                      child: Text(tmplang['ko'],
                          style: TextStyle(
                              color: Theme.of(Get.context).accentColor))),
                ],
              ),
              value: e.toString(),
            );
          }).toList(),
        ),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          (controller.config['tts'] as Map)['language'] = langs[value[0]];
          controller.update();
        }).showModal(Get.overlayContext);
  }

  @override
  void openSetting() {
    // openSettingLanguage();

    showDialog(
        context: Get.context,
        // barrierColor: Colors.transparent,
        // isDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              children: [
                SizedBox(
                    height: Get.height * 0.8,
                    width: Get.width * 0.9,
                    child: Column(children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: GetBuilder<MainCtl>(
                          builder: (context) {
                            String langCode =
                                (controller.config['tts'] as Map)['language'];
                            return Column(
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        openSettingLanguage();
                                      },
                                      child: Text(
                                          '현재 설정 언어 : ${langCode} (${LANG[langCode]['ko']}) '),
                                    )),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 2, child: Text('속도 : ')),
                                      Expanded(
                                        flex: 6,
                                        child: Slider(
                                          value: (controller.config['tts']
                                              as Map)['speechRate'],
                                          min: 0,
                                          max: 5,
                                          divisions: 50,
                                          label: ((controller.config['tts']
                                                      as Map)['speechRate']
                                                  as double)
                                              .toPrecision(1)
                                              .toString(),
                                          onChanged: (double v) {
                                            (controller.config['tts']
                                                as Map)['speechRate'] = v;

                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 2, child: Text('볼륨 : ')),
                                      Expanded(
                                        flex: 6,
                                        child: Slider(
                                          value: (controller.config['tts']
                                              as Map)['volume'],
                                          min: 0,
                                          max: 1,
                                          divisions: 10,
                                          label: ((controller.config['tts']
                                                  as Map)['volume'] as double)
                                              .toPrecision(1)
                                              .toString(),
                                          onChanged: (double v) {
                                            (controller.config['tts']
                                                as Map)['volume'] = v;

                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 2, child: Text('피치 : ')),
                                      Expanded(
                                        flex: 6,
                                        child: Slider(
                                          value: (controller.config['tts']
                                              as Map)['pitch'],
                                          min: 0.5,
                                          max: 2,
                                          divisions: 15,
                                          label: ((controller.config['tts']
                                                  as Map)['pitch'] as double)
                                              .toPrecision(1)
                                              .toString(),
                                          onChanged: (double v) {
                                            (controller.config['tts']
                                                as Map)['pitch'] = v;

                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          flex: 2, child: Text('줄단위 읽기: ')),
                                      Expanded(
                                        flex: 6,
                                        child: SpinBox(
                                          min: 1,
                                          max: 10,
                                          incrementIcon: Icon(
                                            Icons.add,
                                            color: Theme.of(Get.context)
                                                .iconTheme
                                                .color,
                                          ),
                                          decrementIcon: Icon(
                                            Icons.remove,
                                            color: Theme.of(Get.context)
                                                .iconTheme
                                                .color,
                                          ),
                                          value: (controller.config['tts']
                                                      as Map)['groupcnt']
                                                  .toDouble() ??
                                              1,
                                          onChanged: (value) {
                                            (controller.config['tts']
                                                as Map)['groupcnt'] = value;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ]),
                              ],
                            );
                          },
                        ),
                      ),
                    ]))
              ]);
        }).whenComplete(() {});
    // TODO: implement openSetting
  }

  void TESTopenSetting() {
    // if (!isOpen) {
    Get.back();
    // return;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      openSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TESTopenSetting();
    // print('tts load--------');
    return IconButton(
        onPressed: () {
          openSetting();
        },
        icon: buildIcon());
  }

  @override
  Widget buildIcon() {
    return Stack(
      children: [
        Icon(
          Icons.volume_mute_rounded,
        ),
        Container(
            margin: EdgeInsets.only(left: 15, top: 4),
            child: Icon(
              Icons.settings_rounded,
              size: 15,
            )),
      ],
    );
  }
}
