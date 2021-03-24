import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/BottomSheet_Find.dart';
import 'package:open_textview/controller/MainCtl.dart';

var NAVBUTTON = {
  "find": BottomSheet_Find(),
  "find1": IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.find_in_page,
      ),
      iconSize: 20,
      onPressed: () => {}),
};
