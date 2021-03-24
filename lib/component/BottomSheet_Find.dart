import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';

// var isOpen = false;

class BottomSheet_Find extends GetView<MainCtl> {
  TextEditingController _textController =
      TextEditingController(text: 'initial text');

  void OpenBottomSheet() {
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
              height: 300,
              child: Column(children: [
                Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Icon(Icons.keyboard_arrow_down_sharp),
                        CupertinoSearchTextField(
                          placeholder: "검색할 단어 / 문장을 입력해 주세요.",
                          onSubmitted: (value) {
                            Get.find<MainCtl>().runFindContents(value);
                          },
                          // test
                          // controller: TextEditingController(text: 'em'),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '내용 : ${controller.findList[index].contents}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                          '위치 : ${controller.findList[index].pos} 라인')
                                    ],
                                  )));
                        }))
                    // padding: EdgeInsets.only(top: 5),
                    // children: [Text('asd1')])),
                    ),
              ]));
          // SizedBox(
          //     height: 300,
          //     width: double.infinity,
          //     child:
          //     );
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

  @override
  Widget build(BuildContext context) {
    TESTOPENBOTTOMSHEET();

    // TODO: implement build
    return IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.find_in_page,
        ),
        iconSize: 20,
        onPressed: () {
          // final btns = Get.find<MainCtl>().bottomNavBtns;
          OpenBottomSheet();
          // btns.add(NAVBUTTON['find1']);
        });
  }
}
