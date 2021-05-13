import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/items/Languages.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

// var isOpen = false;
class Option_OcrCtl extends GetxController {
  final isBackgroundPermissions = true.obs;
  final traineddataFiles = [].obs;
  final bDownloadawait = false.obs;
  @override
  void onInit() async {
    bool hasPermission = await FlutterBackground.hasPermissions;
    isBackgroundPermissions.value = hasPermission;
    isBackgroundPermissions.update((val) {});
    loadTraineData();

    super.onInit();
  }

  loadTraineData() async {
    Directory dir = Directory(await FlutterTesseractOcr.getTessdataPath());
    if (!dir.existsSync()) {
      dir.create();
    }
    traineddataFiles.clear();

    dir.list().forEach((element) async {
      traineddataFiles.add(element.path.split('/').last);
      update();
    });
  }
}

const traineddatas = [
  {
    'name': 'kor',
    'langname': '한글',
    'url':
        'https://github.com/tesseract-ocr/tessdata/raw/master/kor.traineddata'
  },
  {
    'name': 'eng',
    'langname': '영어',
    'url':
        'https://github.com/tesseract-ocr/tessdata/raw/master/eng.traineddata'
  },
];

class Option_Ocr extends OptionsBase {
  @override
  String get name => 'OCR 설정';

  @override
  void openSetting() async {
    Get.put(Option_OcrCtl());
    // openSettingLanguage();
    // bool isBackgroundPermissions = await FlutterBackground.hasPermissions;
    showDialog(
        context: Get.context,
        // barrierColor: Colors.transparent,
        // isDismissible: false,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              children: [
                Stack(children: [
                  SizedBox(
                      height: Get.height * 0.7,
                      width: Get.width * 0.9,
                      child: Column(children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: GetBuilder<MainCtl>(
                            builder: (context) {
                              String langCode =
                                  (controller.config['tts'] as Map)['language'];

                              return Column(
                                children: [
                                  GetX<Option_OcrCtl>(
                                    builder: (ctl) {
                                      if (ctl.isBackgroundPermissions.value) {
                                        return Text('백그라운드 실행 이 허용 되었습니다.');
                                      }
                                      return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              var config =
                                                  FlutterBackgroundAndroidConfig(
                                                notificationTitle: '오픈텍뷰',
                                                notificationText: 'ocr 실행중입니다.',
                                              );

                                              ctl.isBackgroundPermissions
                                                      .value =
                                                  await FlutterBackground
                                                      .initialize(
                                                          androidConfig:
                                                              config);
                                              ctl.isBackgroundPermissions
                                                  .update((val) {});
                                            },
                                            child: Text('백그라운드 작동 활성화'),
                                          ));
                                    },
                                  ),
                                  Divider(),
                                  Text('학습데이터'),
                                  GetBuilder<Option_OcrCtl>(builder: (ctl) {
                                    return ListView(
                                      shrinkWrap: true,
                                      children: [
                                        ...traineddatas.map((e) {
                                          String targetFileName =
                                              e['url'].split('/').last;
                                          print(ctl.traineddataFiles);
                                          return ListTile(
                                            title: Text(e['langname']),
                                            leading: Checkbox(
                                              value: ctl.traineddataFiles
                                                      .indexOf(
                                                          targetFileName) >=
                                                  0,
                                              onChanged: (value) {},
                                            ),
                                            trailing: ElevatedButton(
                                              onPressed: () async {
                                                // print(e['url'].split('/').last);
                                                ctl.bDownloadawait.value = true;

                                                ctl.update();
                                                HttpClient httpClient =
                                                    new HttpClient();
                                                HttpClientRequest request =
                                                    await httpClient.getUrl(
                                                        Uri.parse(e['url']));
                                                HttpClientResponse response =
                                                    await request.close();
                                                Uint8List bytes =
                                                    await consolidateHttpClientResponseBytes(
                                                        response);
                                                String dir =
                                                    await FlutterTesseractOcr
                                                        .getTessdataPath();
                                                File file = new File(
                                                    '$dir/${targetFileName}');
                                                await file.writeAsBytes(bytes);
                                                ctl.bDownloadawait.value =
                                                    false;
                                                ctl.update();

                                                ctl.loadTraineData();
                                                return file;
                                              },
                                              child: Text(e['langname']),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  })
                                ],
                              );
                            },
                          ),
                        ),
                      ])),
                  GetBuilder<Option_OcrCtl>(builder: (ctl) {
                    if (ctl.bDownloadawait.value) {
                      return Container(
                        height: Get.height * 0.7,
                        color: Colors.black26,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        )),
                      );
                    }
                    return SizedBox();
                  })
                ]),
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
        // Center(
        // child:
        Column(
          // padding: EdgeInsets.only(top: 0),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'OCR',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        )
        // )

        // Icon(
        //   Icons.photo,
        // ),
        // Container(
        //     margin: EdgeInsets.only(left: 0, top: 0),
        //     child: Icon(
        //       Icons.format_color_text,
        //       color: Theme.of(Get.context).cardTheme.color,
        //       // size: 18,
        //     )),
      ],
    );
  }
}
