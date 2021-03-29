import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:open_textview/items/Languages.dart';

// var isOpen = false;
const List<dynamic> DFFILTER = [
  {"name": "중국어(한자) 필터", "expr": true, "filter": "", "to": ''},
  {"name": "일본어(일어) 필터", "expr": true, "filter": "", "to": ''},
  {"name": "아포스트로피(홀따음표) 필터", "expr": false, "filter": "", "to": ''},
  {"name": "물음표 여러개 필터", "expr": false, "filter": "??", "to": '?'},
  {"name": "느낌표 여러개 필터", "expr": false, "filter": "!!", "to": '!'},
  {"name": "다시다시다시(----)", "expr": false, "filter": "--", "to": ''},
  {"name": "는는는(===)", "expr": false, "filter": "==", "to": ''},
];

class BottomSheet_Filter extends GetView<MainCtl> {
  BuildContext context = null;
  void openFilterList() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.9,
            child: Container(
              color: context.theme.dialogTheme.backgroundColor,
              child: ListView(
                  children: DFFILTER.map((e) {
                return Text(e['name']);
              }).toList()),
            ));
      },
    );
  }

  void openBottomSheet() {
    // print(context.theme.dialogTheme.backgroundColor);

    showModalBottomSheet(
        context: Get.context,
        barrierColor: Colors.transparent,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  )),
              width: double.infinity,
              height: 400,
              child: Column(children: [
                Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Icon(Icons.keyboard_arrow_down_sharp),
                        Container(
                          child: Text('TTS 필터'),
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                openFilterList();
                              },
                              child: Text('기본 제공 되는 TTS 필터 리스트 보기'),
                            )),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: Text('speechRate : ')),
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
              ]));
        }).whenComplete(() {
      runFindContents("");
    });
    openFilterList();

    // isOpen = true;
  }

  void TESTOPENBOTTOMSHEET() {
    // if (!isOpen) {
    Get.back();
    // return;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      openBottomSheet();
    });
  }

  void runFindContents(String text) {
    Get.find<MainCtl>().findList.clear();
    if (text != "") {
      Get.find<MainCtl>().contents.asMap().forEach((key, value) {
        if (value.toString().indexOf(text) >= 0) {
          Get.find<MainCtl>().findList.add(FindObj(pos: key, contents: value));
        }
      });
    }
    Get.find<MainCtl>().findText.value = text;
    Get.find<MainCtl>().update();
  }

  @override
  Widget build(BuildContext context) {
    TESTOPENBOTTOMSHEET();
    this.context = context;

    // TODO: implement build
    return IconButton(
      onPressed: () {
        openBottomSheet();
      },
      icon: Stack(
        children: [
          Icon(
            Icons.volume_mute_rounded,
          ),
          Container(
              margin: EdgeInsets.only(left: 15, top: 4),
              child: Icon(
                Icons.filter_list_outlined,
                size: 15,
              )),
        ],
      ),
      // Text('tts필터')
    );
    // IconButton(
    //     padding: EdgeInsets.zero,
    //     icon: Icon(
    //       Icons.find_in_page,
    //     ),
    //     iconSize: 20,
    //     onPressed: () {
    //       // final btns = Get.find<MainCtl>().bottomNavBtns;
    //       OpenBottomSheet();
    //       // btns.add(NAVBUTTON['find1']);
    //     });
  }
}
