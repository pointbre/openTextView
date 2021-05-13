import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/BottomNav.dart';
import 'package:open_textview/component/FloatingButton.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MainPage extends GetView<MainCtl> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SafeArea(
        child: Scaffold(
      appBar: null,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5, right: 5, bottom: 3, top: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    Map m = controller.config['picker'];
                    String fileName = '파일 을 열어주세요.';
                    if (m.isNotEmpty) {
                      fileName = m['name'];
                    }
                    return Expanded(
                        child: Text(
                      fileName,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      maxLines: 1,
                    ));
                  }),
                  GetBuilder<MainCtl>(
                      id: 'scroll',
                      builder: (ctl) {
                        if (ctl.contents.length <= 0) {
                          return Text('0.0%');
                        }

                        return Text(
                            '${(ctl.curPos.value / ctl.contents.length * 100).toPrecision(2)}%');
                      })
                ],
              ),
            ),
            Obx(() {
              if (controller.ocrData['current'] !=
                      controller.ocrData['total'] &&
                  (controller.config['picker'] as Map)['extension'] == 'zip') {
                return Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Text(
                            '${controller.ocrData['current']} / ${controller.ocrData['total']}'),
                        LinearProgressIndicator(
                          value: max(controller.ocrData['current'], 1) /
                              max(controller.ocrData['total'], 1),
                          semanticsLabel: 'Linear progress indicator',
                        )
                      ],
                    ));
              }
              return SizedBox();
            }),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: StreamBuilder(
                  stream: AudioService.runningStream,
                  builder: (c, snapshot) => GetBuilder<MainCtl>(builder: (ctl) {
                        // if (ctl.contents.length == 0) {
                        //   return Container();
                        // }
                        return ScrollablePositionedList.builder(
                          itemCount: ctl.contents.length,
                          itemBuilder: (context, index) {
                            // String contens = controller.contents[index];
                            // String findText = controller.findText.value;
                            // if (findText != "" && contens.indexOf(findText) >= 0) {
                            //   int startIdx = contens.indexOf(findText);
                            //   int endIdx = startIdx + findText.length;

                            //   var deco = contens.substring(startIdx, endIdx);
                            //   var contensS = contens.substring(0, startIdx);
                            //   var contensE = contens.substring(endIdx);
                            //   return Text.rich(TextSpan(children: [
                            //     TextSpan(text: contensS),
                            //     TextSpan(
                            //         text: deco, style: TextStyle(color: Colors.blue)),
                            //     TextSpan(text: contensE),
                            //   ]));
                            // }

                            if (snapshot.data) {
                              int cnt =
                                  ((ctl.config['tts'] as RxMap)['groupcnt']);
                              int endpos = ctl.curPos.value + cnt;
                              if (index >= ctl.curPos.value && index < endpos) {
                                return Text(
                                  '${controller.contents[index]}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surface),
                                );
                              }
                            }
                            return Text('${controller.contents[index]}');
                          },
                          itemScrollController: controller.itemScrollctl,
                          itemPositionsListener: controller.itemPosListener,
                        );
                      })),
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingButton(),
    ));
  }
}
