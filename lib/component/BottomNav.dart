import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';

class BottomNav extends GetView<MainCtl> {
  @override
  Widget build(BuildContext context) {
    print(Get.isBottomSheetOpen);
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                controller.contents.clear();
                controller.update();
                for (int i = 0; i < 500; i++) {
                  controller.contents.add('Item00 $i');
                }
              },
              padding: EdgeInsets.zero,
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // controller.contents.clear();
                // controller.update();
                // for (int i = 0; i < 100; i++) {
                //   controller.contents.add('Item-- $i');
                // }
                // 검색기능 테스트
                showModalBottomSheet(
                    context: Get.context,
                    barrierColor: Colors.transparent,
                    // isDismissible: false,
                    // backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                          height: 300,
                          child: Column(children: [
                            Row(children: [
                              Text('asdf'),
                              Text('asdf'),
                              Text('asdf')
                            ]),
                            Text('aadsfa'),
                          ]));
                    });
              },
              padding: EdgeInsets.zero,
            ),
            ...controller.bottomNavBtns.map((element) => element).toList()
          ],
        ),
      ),
      // showSelectedLabels: false,
      // showUnselectedLabels: false,
      // items: [
      //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
      //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: '')
      // ],
    );
  }
}
