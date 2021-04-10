import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';

class BottomNav extends GetView<MainCtl> {
  BuildContext context = null;
  void openOptions() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('설정'),
          contentPadding: EdgeInsets.all(10),
          children: [
            ...controller.bottomNavBtns.map((element) {
              print(element.buildIcon());
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: element.buildIcon(),
                  ),
                  Expanded(
                    child: Text(element.name),
                  ),
                  IconButton(
                    onPressed: () async {
                      element.openBottomSheet();
                    },
                    icon: Icon(Icons.settings),
                  ),
                  Switch(
                    value: true,
                    onChanged: (bool v) {},
                  ),
                ],
              );
            }).toList()
          ],
        );
      },
    );
  }

  void TESTOPENBOTTOMSHEET() {
    // if (!isOpen) {
    Get.back();
    // return;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      openOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    TESTOPENBOTTOMSHEET();
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // controller.contents.clear();
                // controller.update();
                // for (int i = 0; i < 500; i++) {
                //   controller.contents.add('Item00 $i');
                // }
              },
              padding: EdgeInsets.zero,
            ),
            // IconButton(
            //   icon: Icon(Icons.settings),
            //   onPressed: () {},
            //   padding: EdgeInsets.zero,
            // ),
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
