import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
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
    List<dynamic> langs = await flutterTts.getLanguages;
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
          return SimpleDialog(children: [
            SizedBox(
                height: Get.height * 0.8,
                width: Get.width * 0.9,
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(5),
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
                                  Expanded(
                                      flex: 2, child: Text('speechRate : ')),
                                  Expanded(
                                    flex: 6,
                                    child: Slider(
                                      value: (controller.config['tts']
                                          as Map)['speechRate'],
                                      min: 0,
                                      max: 100,
                                      label: 0.round().toString(),
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
                                  Expanded(flex: 2, child: Text('volume : ')),
                                  Expanded(
                                    flex: 6,
                                    child: Slider(
                                      value: (controller.config['tts']
                                          as Map)['volume'],
                                      min: 0,
                                      max: 100,
                                      // divisions: 1,
                                      label: 0.round().toString(),
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
                                  Expanded(flex: 2, child: Text('pitch : ')),
                                  Expanded(
                                    flex: 6,
                                    child: Slider(
                                      value: (controller.config['tts']
                                          as Map)['pitch'],
                                      min: 0,
                                      max: 100,
                                      label: 0.round().toString(),
                                      onChanged: (double v) {
                                        (controller.config['tts']
                                            as Map)['pitch'] = v;

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
