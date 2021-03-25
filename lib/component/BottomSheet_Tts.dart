import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';

// var isOpen = false;

class BottomSheet_Tts extends GetView<MainCtl> {
  FlutterTts flutterTts = FlutterTts();
  void OpenBottomSheet() async {
    var langs = await flutterTts.getLanguages;

    print(langs);
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
                        CupertinoSearchTextField(
                          placeholder: "검색할 단어 / 문장을 입력해 주세요.",
                          onSubmitted: (value) {
                            runFindContents(value);
                          },
                        ),
                      ],
                    )),
                Expanded(
                  child: Obx(() => ListView.builder(
                      itemCount: controller.findList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              controller.itemScrollctl.jumpTo(
                                  index: controller.findList[index].pos);
                            },
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.grey),
                                )),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '내용 : ${controller.findList[index].contents}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                        '위치 : ${controller.findList[index].pos} 라인')
                                  ],
                                )));
                      })),
                ),
              ]));
        }).whenComplete(() {
      runFindContents("");
    });

    // isOpen = true;
  }

  void TESTOPENBOTTOMSHEET() {
    // if (!isOpen) {
    Get.back();
    // return;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      OpenBottomSheet();
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

    // TODO: implement build
    return IconButton(
        onPressed: () {
          OpenBottomSheet();
        },
        icon: Stack(
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
        ));
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
