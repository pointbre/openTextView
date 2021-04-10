import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/BottomSheetBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:open_textview/items/Languages.dart';

import 'package:url_launcher/url_launcher.dart';

class BottomSheet_FilePicker extends BottomSheetBase {
  BuildContext context = null;

  @override
  String get name => '파일 탐색기';

  @override
  Widget build(BuildContext context) {
    // TESTOPENBOTTOMSHEET();
    this.context = context;

    // TODO: implement build
    return IconButton(
      onPressed: () async {
        FilePickerResult result = await FilePicker.platform.pickFiles();
        // openBottomSheet();
      },
      icon: buildIcon(),
      // Text('tts필터')
    );
  }

  @override
  Widget buildIcon() {
    // TODO: implement buildIcon
    return Icon(
      Icons.folder_open,
    );
  }

  @override
  void openBottomSheet() {
    // TODO: implement openBottomSheet
  }
}
