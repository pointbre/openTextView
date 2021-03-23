import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';

var NAVBUTTON = {
  "find": IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.find_in_page,
      ),
      iconSize: 20,
      onPressed: () {
        showModalBottomSheet(
            context: Get.context,
            barrierColor: Colors.transparent,
            isDismissible: false,
            // backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Column(children: [
                Row(children: [Text('asdf'), Text('asdf'), Text('asdf')]),
                Text('aadsfa'),
              ]);
            });
        // final btns = Get.find<MainCtl>().bottomNavBtns;

        // btns.add(NAVBUTTON['find1']);
      }),
  "find1": IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.find_in_page,
      ),
      iconSize: 20,
      onPressed: () => {}),
};
