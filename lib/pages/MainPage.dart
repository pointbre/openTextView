import 'dart:math';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/BottomNav.dart';
import 'package:open_textview/component/FloatingButton.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/items/NavBtnItems.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MainPage extends GetView<MainCtl> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Map m = controller.config['picker'];
    // print(' >>>>>>>>>>>>>>> : $m');
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          // centerTitle: true,
          title: GetBuilder<MainCtl>(builder: (ctl) {
            Map m = controller.config['picker'];
            String fileName = '파일 을 열어주세요.';
            if (m.isNotEmpty) {
              fileName = m['name'];
            }
            return Text(
              fileName,
              style: TextStyle(fontSize: 15),
            );
          }),
          leading: IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: 'Show Snackbar',
            onPressed: () {
              NAVBUTTON.every((element) {
                if (element.runtimeType.toString() == "Option_FilePicker") {
                  element.openSetting();
                  return false;
                }
                return true;
              });
              // ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          actions: [
            Obx(() {
              if (controller.contents.length <= 0) {
                return Center(child: Text('0.0%'));
              }
              return Center(
                  child: Text(
                      '${(controller.curPos.value / controller.contents.length * 100).toPrecision(2)}%'));
            }),
            PopupMenuButton(
                itemBuilder: (context) => [
                      ...NAVBUTTON.map((el) {
                        RxList nav = controller.config['nav'];
                        String name = el.runtimeType.toString();
                        return PopupMenuItem(
                            value: "12",
                            child: Obx(() => ListTileTheme(
                                iconColor:
                                    Theme.of(Get.context).iconTheme.color,
                                child: ListTile(
                                  leading: el,
                                  title: Text(el.name),
                                  trailing: Checkbox(
                                    value: nav
                                        .where((e) => e.toString() == name)
                                        .isNotEmpty,
                                    onChanged: (value) {
                                      if (value) {
                                        nav.add(name);
                                      } else {
                                        nav.remove(name);
                                      }
                                      controller.update();
                                    },
                                  ),
                                  onTap: () {
                                    el.openSetting();
                                  },
                                ))));
                      }).toList(),
                    ])
          ]),
      body: Container(
        child: Column(
          children: [
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
                        return ScrollablePositionedList.builder(
                          itemCount: ctl.contents.length,
                          itemBuilder: (context, index) {
                            // return InkWell(
                            //   child: Text("asdf"),
                            //   onLongPress: () {},
                            // );
                            if (index >= ctl.contents.length || index < 0) {
                              return Text('');
                            }
                            if (snapshot.data) {
                              int cnt =
                                  ((ctl.config['tts'] as RxMap)['groupcnt']);
                              int endpos = ctl.curPos.value + cnt;
                              if (index >= ctl.curPos.value && index < endpos) {
                                return InkWell(
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                          text: ctl.contents[index]));
                                      final snackBar = SnackBar(
                                        content: Text(
                                          '[${ctl.contents[index]}]\n클립보드에 복사됨.',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        backgroundColor:
                                            Theme.of(context).cardTheme.color,
                                        duration: Duration(milliseconds: 1000),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    },
                                    child: Text(
                                      '${ctl.contents[index]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        // backgroundColor: Theme.of(context)
                                        //     .colorScheme
                                        //     .surface
                                      ),
                                    ));
                              }
                            }
                            return InkWell(
                              child: Text('${ctl.contents[index] ?? ""}'),
                              onLongPress: () {
                                Clipboard.setData(
                                    ClipboardData(text: ctl.contents[index]));
                                final snackBar = SnackBar(
                                  content: Text(
                                    '[${ctl.contents[index]}]\n클립보드에 복사됨.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  backgroundColor:
                                      Theme.of(context).cardTheme.color,
                                  duration: Duration(milliseconds: 1000),
                                );

                                // Find the ScaffoldMessenger in the widget tree
                                // and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                            );
                          },
                          itemScrollController: ctl.itemScrollctl,
                          itemPositionsListener: ctl.itemPosListener,
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
