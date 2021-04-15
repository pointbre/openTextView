import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/Option_FilePicker.dart';
import 'package:open_textview/component/Option_Filter.dart';
import 'package:open_textview/component/Option_Find.dart';
import 'package:open_textview/component/Option_Tts.dart';
import 'package:open_textview/controller/MainCtl.dart';

var NAVBUTTON = [
  Option_FilePicker(),
  Option_Find(),
  Option_Tts(),
  Option_Filter(),
];

// var NAVBUTTON = {
//   "find": Option_Find(),
//   "tts": Option_Tts(),
//   "filter": Option_Filter(),
//   "filepicker": Option_FilePicker(),
// };
