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

    return SafeArea(
        child: Scaffold(
      appBar: null,
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey[400],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text('열린 텍스트 파일 제목'),
                  ),
                  Obx(() => Text(
                      '${(controller.curPos.value / controller.contents.length * 100).toPrecision(2)}%'))
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 2),
              child: GetBuilder<MainCtl>(builder: (ctl) {
                return ScrollablePositionedList.builder(
                  itemCount: controller.contents.length,
                  itemBuilder: (context, index) {
                    String contens = controller.contents[index];
                    String findText = controller.findText.value;

                    if (findText != "" && contens.indexOf(findText) >= 0) {
                      int startIdx = contens.indexOf(findText);
                      int endIdx = startIdx + findText.length;

                      var deco = contens.substring(startIdx, endIdx);
                      var contensS = contens.substring(0, startIdx);
                      var contensE = contens.substring(endIdx);
                      return Text.rich(TextSpan(children: [
                        TextSpan(text: contensS),
                        TextSpan(
                            text: deco, style: TextStyle(color: Colors.blue)),
                        TextSpan(text: contensE),
                      ]));
                    }
                    return Text('${contens}');
                  },
                  itemScrollController: controller.itemScrollctl,
                  itemPositionsListener: controller.itemPosListener,
                );
              }),
            ))

            // GetBuilder<MainCtl>(builder: (ctl) {
            //   return Expanded(
            //       child: Container(
            //     padding: EdgeInsets.only(left: 5, right: 5, top: 2),
            //     child: ScrollablePositionedList.builder(
            //       itemCount: controller.contents.length,
            //       itemBuilder: (context, index) {
            //         print('aaa : ${context}');

            //         return Text('${controller.contents[index]}');
            //       },
            //       itemScrollController: controller.itemScrollctl,
            //       itemPositionsListener: controller.itemPosListener,
            //     ),
            //   ));
            // }),
            // Container(
            //   child: ElevatedButton(
            //       onPressed: () => {controller.itemScrollctl.jumpTo(index: 100)},
            //       child: Text('asdf')),
            // )
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(),
      //  Container(
      //   decoration: BoxDecoration(
      //     border: Border.all(
      //       width: 1,
      //       color: Colors.grey[400],
      //     ),
      //   ),
      //   // padding: EdgeInsets.all(8.8),
      //   child: Obx(
      //     () => Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         IconButton(
      //           icon: Icon(Icons.settings),
      //           onPressed: () {
      //             controller.contents.clear();
      //             controller.update();
      //             for (int i = 0; i < 500; i++) {
      //               controller.contents.add('Item00 $i');
      //             }
      //           },
      //           padding: EdgeInsets.zero,
      //         ),
      //         IconButton(
      //           icon: Icon(Icons.settings),
      //           onPressed: () {
      //             controller.contents.clear();
      //             controller.update();
      //             for (int i = 0; i < 100; i++) {
      //               controller.contents.add('Item-- $i');
      //             }
      //           },
      //           padding: EdgeInsets.zero,
      //         ),
      //         ...controller.bottomNavBtns.map((element) => element).toList()
      //       ],
      //     ),
      //   ),
      // ),

      // BottomNavigationBar(
      //   // showSelectedLabels: false,
      //   // showUnselectedLabels: false,

      //   // items: [BottomNavigationBarItem(icon: Icon(Icons.settings), label: '')],
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: FloatingButton(),
    ));
  }
}
