import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_textview/commonLibrary/HeroDialogRoute.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';

class Option_LineToCtl extends GetxController {
  final curpos = 0.0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    curpos.value = Get.find<MainCtl>().curPos.value.toDouble();
    debounce(curpos, (v) {
      var ctl = Get.find<MainCtl>();
      ctl.itemScrollctl.jumpTo(index: curpos.toInt());
    }, time: Duration(milliseconds: 300));
  }
}

class Option_LineTo extends OptionsBase {
  @override
  String get name => '위치 이동';

  BuildContext context = null;

  @override
  void openSetting() {
    Get.put(Option_LineToCtl());

    HeroPopup(
        tag: name,
        title: Row(children: [
          // buildIcon(),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.w700),
          )
        ]),
        callback: (completion) {},
        children: [
          SizedBox(
              height: Get.height * 0.5,
              child: GetBuilder<MainCtl>(builder: (ctl) {
                RxList filterlist = controller.config['filter'];
                int cententsLen = max(1, controller.contents.length);
                return Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      children: [
                        Obx(() => Text(
                              '현재 위치 : ${controller.curPos.value} / ${(controller.curPos.value / cententsLen * 100).toPrecision(2)}%',
                              style: Get.context.textTheme.subtitle1,
                            )),
                        Divider(),
                        GetBuilder<Option_LineToCtl>(builder: (ctl) {
                          return Slider(
                            value: ctl.curpos.value,
                            //controller.curPos.value.toDouble(),
                            min: 0,
                            max: cententsLen.toDouble(),
                            divisions: cententsLen,
                            label:
                                '${ctl.curpos.value.toInt().toString()} / ${(ctl.curpos.value / cententsLen * 100).toPrecision(2)}%',
                            onChanged: (double v) {
                              ctl.curpos.value = v;
                              ctl.update();
                            },
                          );
                        }),
                        Text(
                          '한번에 너무 많이 이동하거나. 빨리 이동하면 오류가 발생합니다. 원인을 못찾았으니 조금씩 천천히 이동해 주세요. ',
                        ),
                      ],
                    ));
              }))
        ]);
    // showDialog(
    //     context: Get.context,
    //     builder: (BuildContext context) {
    //       return GetBuilder<MainCtl>(builder: (ctl) {
    //         RxList filterlist = controller.config['filter'];
    //         int cententsLen = max(1, controller.contents.length);
    //         return SimpleDialog(title: Text(name), children: [
    //           SizedBox(
    //               height: Get.height * 0.3,
    //               width: Get.width * 0.9,
    //               child: Container(
    //                   padding: EdgeInsets.only(top: 10, left: 10, right: 10),
    //                   child: Column(
    //                     children: [
    //                       Obx(() => Text(
    //                             '현재 위치 : ${controller.curPos.value} / ${(controller.curPos.value / cententsLen * 100).toPrecision(2)}%',
    //                             style: Get.context.textTheme.subtitle1,
    //                           )),
    //                       Divider(),
    //                       GetBuilder<Option_LineToCtl>(builder: (ctl) {
    //                         return Slider(
    //                           value: ctl.curpos.value,
    //                           //controller.curPos.value.toDouble(),
    //                           min: 0,
    //                           max: cententsLen.toDouble(),
    //                           divisions: cententsLen,
    //                           label:
    //                               '${ctl.curpos.value.toInt().toString()} / ${(ctl.curpos.value / cententsLen * 100).toPrecision(2)}%',
    //                           onChanged: (double v) {
    //                             ctl.curpos.value = v;
    //                             ctl.update();
    //                           },
    //                         );
    //                       }),
    //                       Text(
    //                         '한번에 너무 많이 이동하거나. 빨리 이동하면 오류가 발생합니다. 원인을 못찾았으니 조금씩 천천히 이동해 주세요. ',
    //                       ),
    //                     ],
    //                   )))
    //         ]);
    //       });
    //     }).whenComplete(() {});
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
    this.context = context;
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
              icon: buildIcon())),
    );
  }

  @override
  Widget buildIcon() {
    // TODO: implement buildIcon
    return Stack(
      children: [
        Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14),
            child: Icon(
              Icons.low_priority,
            )),
      ],
    );
  }
}
