import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';

final NAVBUTTON = {
  "find": IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.find_in_page,
      ),
      iconSize: 20,
      onPressed: () {
        final btns = Get.find<MainCtl>().bottomNavBtns;

        btns.add(NAVBUTTON['find1']);
      }),
  "find1": IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.find_in_page,
      ),
      iconSize: 20,
      onPressed: () => {}),
};
