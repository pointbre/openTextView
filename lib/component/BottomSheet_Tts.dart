import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/BottomSheetBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:open_textview/items/Languages.dart';

// var isOpen = false;

class BottomSheet_Tts extends BottomSheetBase {
  @override
  String get name => 'tts 설정';

  final flutterTts = FlutterTts();
  void openSettingLanguage() async {
    List<dynamic> langs = await flutterTts.getLanguages;
    Picker(
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
                    child: Text(e.toString()),
                  )),
                  Expanded(child: Text(tmplang['ko'])),
                ],
              ),
              value: e.toString(),
            );
          }).toList(),
        ),
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.adapter.text);
        }).showModal(Get.overlayContext);
  }

  @override
  void openSetting() {
    showModalBottomSheet(
        context: Get.context,
        barrierColor: Colors.transparent,
        isDismissible: false,
        builder: (BuildContext context) {
          return FractionallySizedBox(
              heightFactor: 1,
              child: Card(
                  elevation: 5,
                  child: Column(children: [
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Icon(Icons.keyboard_arrow_down_sharp),
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    openSettingLanguage();
                                  },
                                  child: Text('현재 설정 언어 : ko_KR (한국어) '),
                                )),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 2, child: Text('speechRate : ')),
                                  Expanded(
                                    flex: 6,
                                    child: Slider(
                                      value: 0,
                                      min: 0,
                                      max: 100,
                                      divisions: 5,
                                      label: 0.round().toString(),
                                      onChanged: (double value) {},
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
                                      value: 0,
                                      min: 0,
                                      max: 100,
                                      divisions: 1,
                                      label: 0.round().toString(),
                                      onChanged: (double value) {},
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
                                      value: 0,
                                      min: 0,
                                      max: 100,
                                      divisions: 5,
                                      label: 0.round().toString(),
                                      onChanged: (double value) {},
                                    ),
                                  ),
                                ]),
                          ],
                        )),
                  ])));
        }).whenComplete(() {});
    // TODO: implement openSetting
  }

  @override
  Widget build(BuildContext context) {
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
