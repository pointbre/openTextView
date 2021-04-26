import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:open_textview/items/Languages.dart';

import 'package:url_launcher/url_launcher.dart';

// var isOpen = false;
const List<dynamic> DFFILTER = [
  {"name": "중국어(한자) 필터", "expr": true, "filter": "[一-龥]", "to": ''},
  {
    "name": "일본어(일어) 필터",
    "expr": true,
    "filter": "[ぁ-ゔ]+|[ァ-ヴー]+[々〆〤]",
    "to": ''
  },
  {"name": "아포스트로피(홀따음표) 필터", "expr": false, "filter": "'", "to": ''},
  {"name": "물음표 여러개 필터", "expr": true, "filter": "\?{1,}", "to": '?'},
  {"name": "느낌표 여러개 필터", "expr": true, "filter": "!{1,}", "to": '!'},
  {"name": "다시다시다시(----)", "expr": false, "filter": "-{2,}", "to": ''},
  {"name": "는는는(===)", "expr": false, "filter": "={2,}", "to": ''},
];

class Option_FilterCtl extends GetxController {
  final filterTmpCtl = {}.obs;
}

class Option_Filter extends OptionsBase {
  @override
  String get name => 'TTS 필터';

  BuildContext context = null;
  void openFilterList() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('제공 필터 목록'),
          children: [
            ...DFFILTER.map((e) {
              return Card(
                  child: ListTile(
                title: Text(e['name']),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(flex: 8, child: Text(e['filter'])),
                      Expanded(flex: 1, child: Icon(Icons.arrow_right)),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text(e['to'] == "" ? '없음' : e['to'])))
                    ]),
                onTap: () {
                  // 필터 적용후 닫기 필요
                  Get.back();
                },
                // isThreeLine: true,
              ));
            }).toList(),
          ],
        );
      },
    );
  }

  void openCustomFilter() async {
    Get.put(Option_FilterCtl());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<Option_FilterCtl>(
            builder: (ctl) => SimpleDialog(
                  title: Text('필터 추가'),
                  children: [
                    SizedBox(
                        height: Get.height * 0.7,
                        width: Get.width * 0.9,
                        child: Container(
                            padding:
                                EdgeInsets.only(top: 10, left: 10, right: 10),
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "필터 이름",
                                  ),
                                  onChanged: (value) {
                                    ctl.filterTmpCtl['name'] = value;
                                    ctl.update();
                                    // {"name": "", "expr": false, "filter": "", "to": ''}
                                  },
                                ),
                                Divider(),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "필터 조건",
                                  ),
                                  onChanged: (value) {
                                    ctl.filterTmpCtl['filter'] = value;
                                    ctl.update();
                                    // {"name": "", "expr": false, "filter": "", "to": ''}
                                  },
                                ),
                                Divider(),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "변환할 텍스트",
                                  ),
                                  onChanged: (value) {
                                    ctl.filterTmpCtl['to'] = value;
                                    ctl.update();
                                    // {"name": "", "expr": false, "filter": "", "to": ''}
                                  },
                                ),
                                Divider(),
                                CheckboxListTile(
                                    title: Text('정규식사용'),
                                    value: ctl.filterTmpCtl['expr'] ?? false,
                                    onChanged: (b) {
                                      print(
                                          '>>> : ${b} , ${ctl.filterTmpCtl['expr']}');
                                      ctl.filterTmpCtl['expr'] = b;
                                      ctl.update();
                                    }),
                              ],
                            ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print('----- ${controller.config['filter']}');
                            ctl.filterTmpCtl.clear();
                            Get.back();
                          },
                          child: Text('취소'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            (controller.config['filter'] as RxList)
                                .add(ctl.filterTmpCtl);
                            controller.update();
                            Get.back();
                            print(ctl.filterTmpCtl);
                          },
                          child: Text('추가'),
                        )
                      ],
                    )
                  ],
                ));
      },
    );
  }

  @override
  void openSetting() {
    // test----
    // Get.back();
    // Future.delayed(const Duration(milliseconds: 300), () {
    //   openCustomFilter();
    // });
    // test----

    RxList filterlist = controller.config['filter'];
    print('filterlistfilterlist : $filterlist');
    showDialog(
        context: Get.context,
        // barrierColor: Colors.transparent,
        // isDismissible: false,
        builder: (BuildContext context) {
          return Obx(() => SimpleDialog(title: Text(name), children: [
                SizedBox(
                    height: Get.height * 0.7,
                    width: Get.width * 0.9,
                    child: Container(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Column(
                          children: [
                            SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    openFilterList();
                                  },
                                  child: Text('제공 되는 TTS 필터 리스트 보기'),
                                )),
                            Text(
                              '적용된 필터 목록',
                              style: Get.context.textTheme.headline6,
                            ),
                            Divider(),
                            Expanded(
                                child: ListView(
                                    padding: EdgeInsets.all(5),
                                    children: [
                                  ...filterlist.map((e) {
                                    int idx = filterlist.indexOf(e);
                                    Map m = e;
                                    print('>>>: ${e} ${filterlist.indexOf(e)}');

                                    return Dismissible(
                                        key: Key('${idx}'),
                                        background:
                                            Container(color: Colors.red),
                                        onDismissed: (direction) {
                                          controller.config.update('filter',
                                              (value) {
                                            (value as RxList).removeAt(idx);
                                            return value;
                                          });
                                        },
                                        child: Card(
                                            child: Container(
                                          child: ListTile(
                                            title: Text(e['name'] ?? "---"),
                                            trailing: Checkbox(
                                                value: true, onChanged: (b) {}),

                                            // subtitle: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.spaceBetween,
                                            //     children: [
                                            //       // Checkbox(value: true, onChanged: (b) {}),
                                            //       Expanded(
                                            //           flex: 8,
                                            //           child:
                                            //               Text(e['filter'] ?? "")),
                                            //       Expanded(
                                            //           flex: 1,
                                            //           child:
                                            //               Icon(Icons.arrow_right)),
                                            //       Expanded(
                                            //         flex: 2,
                                            //         child: Center(
                                            //             child: Text(e['to'] == ""
                                            //                 ? '없음'
                                            //                 : e['to'])),
                                            //       ),
                                            //     ]),
                                          ),
                                        )));
                                  }).toList()
                                  // ...DFFILTER.map((e) {
                                  //   return Card(
                                  //     child: ListTile(
                                  //       title: Text(e['name']),
                                  //       trailing:
                                  //           Checkbox(value: true, onChanged: (b) {}),
                                  //       // Switch(
                                  //       //   onChanged: (e) {},
                                  //       //   value: true,
                                  //       // ),
                                  //       subtitle: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.spaceBetween,
                                  //           children: [
                                  //             // Checkbox(value: true, onChanged: (b) {}),
                                  //             Expanded(
                                  //                 flex: 8, child: Text(e['filter'])),
                                  //             Expanded(
                                  //                 flex: 1,
                                  //                 child: Icon(Icons.arrow_right)),
                                  //             Expanded(
                                  //               flex: 2,
                                  //               child: Center(
                                  //                   child: Text(e['to'] == ""
                                  //                       ? '없음'
                                  //                       : e['to'])),
                                  //             ),
                                  //           ]),
                                  //     ),
                                  //   );
                                  // }
                                  // ).toList()
                                ])),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      // openFilterList();
                                      openCustomFilter();
                                    },
                                    child: Icon(Icons.add),
                                  )
                                ],
                              ),
                            )
                          ],
                        )))
              ]));
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
    TESTopenSetting();

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
          Icons.volume_mute_rounded,
        ),
        Container(
            margin: EdgeInsets.only(left: 15, top: 4),
            child: Icon(
              Icons.filter_list_outlined,
              size: 15,
            )),
      ],
    );
  }
}
