import 'package:flutter/cupertino.dart';
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

// var isOpen = false;
class Option_OcrCtl extends GetxController {
  final isBackgroundPermissions = true.obs;
  @override
  void onInit() async {
    bool hasPermission = await FlutterBackground.hasPermissions;
    isBackgroundPermissions.value = hasPermission;
    isBackgroundPermissions.update((val) {});
    print('${hasPermission} Option_OcrCtl : ${isBackgroundPermissions.value}');

    super.onInit();
  }
}

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
                                      return SizedBox();
                                    }
                                    return SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            var config =
                                                FlutterBackgroundAndroidConfig(
                                              notificationTitle:
                                                  'flutter_background example app',
                                              notificationText:
                                                  'Background notification for keeping the example app running in the background',
                                              notificationIcon: AndroidResource(
                                                  name: 'background_icon'),
                                            );
                                            // Demonstrate calling initialize twice in a row is possible without causing problems.

                                            ctl.isBackgroundPermissions.value =
                                                await FlutterBackground
                                                    .initialize(
                                                        androidConfig: config);
                                            ctl.isBackgroundPermissions
                                                .update((val) {});
                                          },
                                          child: Text('백그라운드 작동 활성화'),
                                        ));
                                  },
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Demonstrate calling initialize twice in a row is possible without causing problems.

                                        await FlutterBackground.initialize(
                                            androidConfig:
                                                FlutterBackgroundAndroidConfig(
                                                    notificationTitle: '오픈텍뷰',
                                                    notificationText:
                                                        'ocr 실행중입니다. ',
                                                    notificationIcon:
                                                        AndroidResource(
                                                            name:
                                                                'background_icon'),
                                                    notificationImportance:
                                                        AndroidNotificationImportance
                                                            .Max));
                                        FlutterBackground
                                            .enableBackgroundExecution();

                                        // var config =
                                        //     FlutterBackgroundAndroidConfig(
                                        //   notificationTitle:
                                        //       'flutter_background example app',
                                        //   notificationText:
                                        //       'Background notification for keeping the example app running in the background',
                                        //   notificationIcon: AndroidResource(
                                        //       name: 'background_icon'),
                                        // );
                                        // Demonstrate calling initialize twice in a row is possible without causing problems.

                                        // bool b = await FlutterBackground
                                        //     .initialize(
                                        //         androidConfig: config);
                                        // ctl.isBackgroundPermissions.value =
                                        //     b;
                                        // ctl.isBackgroundPermissions
                                        //     .update((val) {});
                                      },
                                      child: Text('test'),
                                    )),
                                SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        FlutterBackground
                                            .disableBackgroundExecution();
                                        // var config =
                                        //     FlutterBackgroundAndroidConfig(
                                        //   notificationTitle:
                                        //       'flutter_background example app',
                                        //   notificationText:
                                        //       'Background notification for keeping the example app running in the background',
                                        //   notificationIcon: AndroidResource(
                                        //       name: 'background_icon'),
                                        // );
                                        // Demonstrate calling initialize twice in a row is possible without causing problems.

                                        // bool b = await FlutterBackground
                                        //     .initialize(
                                        //         androidConfig: config);
                                        // ctl.isBackgroundPermissions.value =
                                        //     b;
                                        // ctl.isBackgroundPermissions
                                        //     .update((val) {});
                                      },
                                      child: Text('test'),
                                    )),
                                // Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Expanded(flex: 2, child: Text('속도 : ')),
                                //       Expanded(
                                //         flex: 6,
                                //         child: Slider(
                                //           value: (controller.config['tts']
                                //               as Map)['speechRate'],
                                //           min: 0,
                                //           max: 5,
                                //           divisions: 50,
                                //           label: ((controller.config['tts']
                                //                       as Map)['speechRate']
                                //                   as double)
                                //               .toPrecision(1)
                                //               .toString(),
                                //           onChanged: (double v) {
                                //             (controller.config['tts']
                                //                 as Map)['speechRate'] = v;

                                //             controller.update();
                                //           },
                                //         ),
                                //       ),
                                //     ]),
                                // Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Expanded(flex: 2, child: Text('볼륨 : ')),
                                //       Expanded(
                                //         flex: 6,
                                //         child: Slider(
                                //           value: (controller.config['tts']
                                //               as Map)['volume'],
                                //           min: 0,
                                //           max: 1,
                                //           divisions: 10,
                                //           label: ((controller.config['tts']
                                //                   as Map)['volume'] as double)
                                //               .toPrecision(1)
                                //               .toString(),
                                //           onChanged: (double v) {
                                //             (controller.config['tts']
                                //                 as Map)['volume'] = v;

                                //             controller.update();
                                //           },
                                //         ),
                                //       ),
                                //     ]),
                                // Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Expanded(flex: 2, child: Text('피치 : ')),
                                //       Expanded(
                                //         flex: 6,
                                //         child: Slider(
                                //           value: (controller.config['tts']
                                //               as Map)['pitch'],
                                //           min: 0.5,
                                //           max: 2,
                                //           divisions: 15,
                                //           label: ((controller.config['tts']
                                //                   as Map)['pitch'] as double)
                                //               .toPrecision(1)
                                //               .toString(),
                                //           onChanged: (double v) {
                                //             (controller.config['tts']
                                //                 as Map)['pitch'] = v;

                                //             controller.update();
                                //           },
                                //         ),
                                //       ),
                                //     ]),
                                // Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     children: [
                                //       Expanded(
                                //           flex: 2, child: Text('줄단위 읽기: ')),
                                //       Expanded(
                                //         flex: 6,
                                //         child: SpinBox(
                                //           min: 1,
                                //           max: 10,
                                //           incrementIcon: Icon(
                                //             Icons.add,
                                //             color: Theme.of(Get.context)
                                //                 .iconTheme
                                //                 .color,
                                //           ),
                                //           decrementIcon: Icon(
                                //             Icons.remove,
                                //             color: Theme.of(Get.context)
                                //                 .iconTheme
                                //                 .color,
                                //           ),
                                //           value: (controller.config['tts']
                                //                       as Map)['groupcnt']
                                //                   .toDouble() ??
                                //               1,
                                //           onChanged: (value) {
                                //             (controller.config['tts']
                                //                     as Map)['groupcnt'] =
                                //                 value.toInt();
                                //             controller.update();
                                //           },
                                //         ),
                                //       ),
                                //     ]),
                                // Divider(),
                                // CheckboxListTile(
                                //     contentPadding: EdgeInsets.all(0),
                                //     title: Text('헤드셋 버튼 사용'),
                                //     value: (controller.config['tts']
                                //             as Map)['headsetbutton'] ??
                                //         false,
                                //     onChanged: (b) {
                                //       (controller.config['tts']
                                //           as Map)['headsetbutton'] = b;
                                //       controller.update();
                                //     }),
                                // CheckboxListTile(
                                //     contentPadding: EdgeInsets.all(0),
                                //     title: Text('다른 플레이어 실행시 정지'),
                                //     value: (controller.config['tts']
                                //             as Map)['audiosession'] ??
                                //         false,
                                //     onChanged: (b) {
                                //       (controller.config['tts']
                                //           as Map)['audiosession'] = b;
                                //       controller.update();
                                //       // ctl.filterTmpCtl['expr'] = b;
                                //       // ctl.update();
                                //     }),
                              ],
                            );
                          },
                        ),
                      ),
                    ]))
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
        Text('OCR')

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
