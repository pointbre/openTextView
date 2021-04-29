import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_charset_detector/flutter_charset_detector.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:open_textview/items/Languages.dart';

import 'package:url_launcher/url_launcher.dart';

class Option_FilePicker extends OptionsBase {
  BuildContext context = null;

  @override
  String get name => '파일 탐색기';

  @override
  Widget build(BuildContext context) {
    // TESTopenSetting();
    this.context = context;

    // TODO: implement build
    return IconButton(
      onPressed: () {
        openSetting();
        // openSetting();
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
  void openSetting() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['txt'],
    );
    PlatformFile platformfile = result.files.first;

    print(platformfile.name);
    print(platformfile.bytes);
    print(platformfile.size);
    print(platformfile.extension);
    print(platformfile.path);
    File file = File(platformfile.path);
    Uint8List body = file.readAsBytesSync();
    DecodingResult centents = await CharsetDetector.autoDecode(body);
    print(centents.charset); // => e.g. 'SHIFT_JIS'
    print(centents.string); // => e.g. '日本語'
  }
}
