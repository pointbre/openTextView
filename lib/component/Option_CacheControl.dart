import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/items/Languages.dart';
import 'package:path_provider/path_provider.dart';

class Option_CacheControl_Ctl extends GetxController {
  Directory tmpdir;
  @override
  void onInit() {
    super.onInit();
    loadTemp();
  }

  void loadTemp() async {
    Directory d = await getTemporaryDirectory();
    tmpdir = Directory('${d.path}/file_picker');
    update();
  }
}

class Option_CacheControl extends OptionsBase {
  @override
  String get name => '캐시관리';
  @override
  void openSetting() async {
    Get.put(Option_CacheControl_Ctl());

    showDialog(
        context: Get.context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              children: [
                SizedBox(
                    height: Get.height * 0.7,
                    width: Get.width * 0.9,
                    child: GetBuilder<Option_CacheControl_Ctl>(
                        builder: (ctl) => ListView(
                              children: [
                                ...ctl.tmpdir.listSync().map((e) {
                                  String type =
                                      e.runtimeType.toString() == '_File'
                                          ? 'file'
                                          : 'dir';
                                  String fileSize = "";
                                  if (type == 'file') {
                                    File file = e;
                                    int bytes = file.lengthSync();
                                    if (bytes <= 0) return "0 B";
                                    const suffixes = [
                                      'B',
                                      'KB',
                                      'MB',
                                      'GB',
                                    ];
                                    var i = (log(bytes) / log(1024)).floor();
                                    fileSize = ((bytes / pow(1024, i))
                                            .toStringAsFixed(2)) +
                                        ' ' +
                                        suffixes[i];
                                  }
                                  return Card(
                                      child: ListTile(
                                    title: Text(e.path.split('/').last),
                                    leading: type == "file"
                                        ? Icon(Icons.file_copy)
                                        : Icon(Icons.folder),
                                    subtitle: Text(fileSize),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        showDialog(
                                            context: Get.context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("openTextView"),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "삭제 하시겠습니까?",
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    child: new Text("취소"),
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    child: new Text("삭제"),
                                                    onPressed: () {
                                                      e.deleteSync(
                                                          recursive: true);
                                                      ctl.update();
                                                      Get.back();
                                                    },
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                    ),
                                  ));
                                }).toList(),
                                // ...d1.list().map((event) {
                                //   return Container();
                                // }).toList(),
                              ],
                            )))
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
          Icons.file_present,
        ),
      ],
    );
  }
}
