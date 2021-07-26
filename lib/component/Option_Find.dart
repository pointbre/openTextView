import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_textview/commonLibrary/HeroDialogRoute.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';

// var isOpen = false;

class Option_Find extends OptionsBase {
  @override
  String get name => '페이지 검색';

  void TESTopenSetting() {
    // if (!isOpen) {
    Get.back();
    // return;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      openSetting();
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
    Get.find<MainCtl>().update();
  }

  @override
  Widget build(BuildContext context) {
    // TESTopenSetting();
    // TODO: implement build
    return Hero(
        tag: name,
        child: Material(
            type: MaterialType.transparency, // likely needed
            child: IconButton(
              onPressed: () {
                openSetting();
              },
              icon: buildIcon(),
            )));
  }

  @override
  Widget buildIcon() {
    return Icon(
      Icons.find_in_page,
    );
  }

  @override
  void openSetting() {
    HeroPopup(
        tag: name,
        title: Row(children: [
          // buildIcon(),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w700),
          )
        ]),
        callback: (completion) {
          runFindContents("");
        },
        children: [
          Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      // border: OutlineInputBorder(),
                      labelText: "검색할 단어 / 문장을 입력해 주세요.",
                    ),
                    onSubmitted: (value) {
                      runFindContents(value);
                    },
                  ),
                ],
              )),
          SizedBox(
            height: Get.height * 0.5,
            // width: Get.width * 0.9,
            child: Obx(() => ListView.builder(
                itemCount: controller.findList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      child: ListTile(
                    title: Text(
                      '내용 : ${controller.findList[index].contents}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('위치 : ${controller.findList[index].pos} 라인'),
                    onTap: () {
                      controller.itemScrollctl
                          .jumpTo(index: controller.findList[index].pos);
                      Get.back();
                    },
                  ));
                })),
          )
        ]);
  }
}
