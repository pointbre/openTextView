import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/BottomSheet_FilePicker.dart';
import 'package:open_textview/component/BottomSheet_Filter.dart';
import 'package:open_textview/component/BottomSheet_Find.dart';
import 'package:open_textview/component/BottomSheet_Tts.dart';
import 'package:open_textview/controller/MainCtl.dart';

var NAVBUTTON = [
  BottomSheet_Find(),
  BottomSheet_Tts(),
  BottomSheet_Filter(),
  BottomSheet_FilePicker(),
];

// var NAVBUTTON = {
//   "find": BottomSheet_Find(),
//   "tts": BottomSheet_Tts(),
//   "filter": BottomSheet_Filter(),
//   "filepicker": BottomSheet_FilePicker(),
// };
