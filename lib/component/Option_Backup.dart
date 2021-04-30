import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:open_textview/items/Languages.dart';
import 'package:path_provider/path_provider.dart';

// var isOpen = false;

class Option_Backup extends OptionsBase {
  @override
  String get name => '뱩업/복구';

  @override
  void openSetting() async {
    // openSettingLanguage();
    Directory tempDir = await getApplicationDocumentsDirectory();
    print('${tempDir.path}/opentextview');
    File db = File('${tempDir.path}/opentextview');
    String contents = await db.readAsString();
    print(contents);
    // DecodingResult centents = await CharsetDetector.autoDecode(u8list);

    showDialog(
        context: Get.context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              contentPadding: EdgeInsets.all(10),
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Clipboard.setData(ClipboardData(text: contents));
                    showDialog(
                        context: Get.context,
                        builder: (c) => AlertDialog(
                              title: Text('백업'),
                              content: new Text("클립보드에 복사 되었습니다."),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Get.back(),
                                  child: Text('닫기'),
                                )
                              ],
                            ));
                  },
                  child: Text('현재 설정 복사(백업)'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text('파일로 복구'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      child: Text('클립보드 복구'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('현재 상태 저장 '),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(contents + contents),
                )
              ]);
        }).whenComplete(() {});
    // TODO: implement openSetting
  }

  void TESTopenSetting() {
    // if (!isOpen) {
    Get.back();
    // return;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      openSetting();
    });
  }

  @override
  Widget build(BuildContext context) {
    TESTopenSetting();
    return IconButton(
        onPressed: () {
          openSetting();
        },
        icon: buildIcon());
  }

  @override
  Widget buildIcon() {
    return Stack(
      children: [
        Icon(
          Icons.backup_sharp,
        ),
      ],
    );
  }
}
