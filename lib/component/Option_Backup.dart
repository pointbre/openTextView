import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_charset_detector/flutter_charset_detector.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:path_provider/path_provider.dart';

// var isOpen = false;

class Option_Backup extends OptionsBase {
  @override
  String get name => '뱩업/복구';

  @override
  void openSetting() async {
    String contents = '''
        {"config" : ${jsonEncode(controller.config)},"history" : ${jsonEncode(controller.history)}}
        ''';

    showDialog(
        context: Get.context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text.rich(TextSpan(children: [
                TextSpan(
                  text: name,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text: ' (복구후엔 어플을 재실행 해 주세요.)',
                  style: Theme.of(Get.context).textTheme.bodyText1,
                ),
              ])),
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
                      onPressed: () async {
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowMultiple: false,
                          allowedExtensions: ['txt'],
                        );

                        if (result.files.isNotEmpty) {
                          PlatformFile platformfile = result.files.first;
                          File file = File(platformfile.path);
                          Uint8List u8list = file.readAsBytesSync();
                          DecodingResult decodeContents =
                              await CharsetDetector.autoDecode(u8list);

                          String contents = decodeContents.string;
                          try {
                            var json = jsonDecode(contents);
                            if ((json['config'] as Map).isEmpty &&
                                (json['history'] as List).isEmpty) {
                              return;
                            }
                            showDialog(
                                context: Get.context,
                                builder: (c) => AlertDialog(
                                      title: Text('파일 내용'),
                                      content: SingleChildScrollView(
                                        child: Text(contents),
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () => Get.back(),
                                          child: Text('취소'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            controller.setConfig(
                                                (json['config'] as Map),
                                                (json['history'] as List));
                                            Get.back(); // 현재 팝업 닫기
                                            Get.back();
                                          },
                                          child: Text('적용'),
                                        )
                                      ],
                                    ));
                          } catch (e) {}
                        }
                      },
                      child: Text('파일로 복구(txt)'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        ClipboardData contents =
                            await Clipboard.getData('text/plain');
                        var json = {};
                        try {
                          json = jsonDecode(contents.text);
                          if ((json['config'] as Map).isEmpty &&
                              (json['history'] as List).isEmpty) {
                            return;
                          }

                          showDialog(
                              context: Get.context,
                              builder: (c) => AlertDialog(
                                    title: Text('클립보드 내용'),
                                    content: SingleChildScrollView(
                                      child: Text(contents.text),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () => Get.back(),
                                        child: Text('취소'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          controller.setConfig(
                                              json['config'], json['history']);

                                          Get.back(); // 현재 팝업 닫기
                                          Get.back(); // 백업 복구 팝업 닫기
                                        },
                                        child: Text('적용'),
                                      )
                                    ],
                                  ));
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Text('클립보드 복구'),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(contents),
                )
              ]);
        }).whenComplete(() {
      // controller.reloadConfig();
    });
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
    // TESTopenSetting();
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
