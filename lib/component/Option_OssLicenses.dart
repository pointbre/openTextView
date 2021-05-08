import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/oss_licenses.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Option_OssLicenses extends OptionsBase {
  @override
  String get name => '오픈소스 라이선스';

  BuildContext context = null;

  @override
  void openSetting() async {
    Directory tempDir = await getTemporaryDirectory();
    showDialog(
        context: Get.context,
        builder: (BuildContext context) {
          return GetBuilder<MainCtl>(builder: (ctl) {
            // RxList filterlist = controller.config['filter'];
            // List copyList = [...ctl.history];
            // copyList.sort((a, b) {
            //   return b['date'].compareTo(a['date']);
            // });

            return SimpleDialog(title: Text(name), children: [
              SizedBox(
                  height: Get.height * 0.7,
                  width: Get.width * 0.9,
                  child: Container(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: ListView(
                        children: [
                          ...ossLicenses
                              .map((key, value) {
                                return MapEntry(
                                    key,
                                    Card(
                                      child: ListTile(
                                        title: Text(value["name"]),
                                        subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '라이선스 : ${value["license"]}',
                                                maxLines: 5,
                                              ),
                                              Divider(),
                                              Center(
                                                  child: InkWell(
                                                      child: new Text(
                                                        '홈페이지',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      onTap: () => launch(
                                                          value['homepage']))),
                                              // Text('${value["description"]}'),
                                            ]),
                                      ),
                                    ));
                              })
                              .values
                              .toList()
                          // ( {
                          //   return Card(
                          //     child: ListTile(
                          //       title: Text(element['name']),
                          //       subtitle: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Text('위치 : ${element['pos']}'),
                          //             Text('마지막 갱신 시간 : ${element['date']}')
                          //           ]),
                          //     ),
                          //   );
                          // }).toList(),
                        ],
                      )))
            ]);
          });
        }).whenComplete(() {});
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
    this.context = context;
    // TESTopenSetting();
    // TODO: implement build
    return IconButton(
      onPressed: () {
        openSetting();
      },
      icon: buildIcon(),
    );
  }

  @override
  Widget buildIcon() {
    // TODO: implement buildIcon
    return Stack(
      children: [
        Icon(
          Icons.menu_book,
        ),
      ],
    );
  }
}
