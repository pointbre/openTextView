import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';

// var isOpen = false;
const List<dynamic> DFFILTER = [
  {
    "name": "중국어(한자) 필터",
    "expr": true,
    "filter": "[一-龥]",
    "to": '',
    'enable': false
  },
  {
    "name": "일본어(일어) 필터",
    "expr": true,
    "filter": "[ぁ-ゔ]|[ァ-ヴー]|[々〆〤]",
    "to": '',
    'enable': false
  },
  {
    "name": "물음표 여러개 필터",
    "expr": true,
    "filter": "\\?{1,}",
    "to": '?',
    'enable': false
  },
  {
    "name": "느낌표 여러개 필터",
    "expr": true,
    "filter": "\\!{1,}",
    "to": '!',
    'enable': false
  },
  {
    "name": "다시다시다시(----)",
    "expr": true,
    "filter": "-{2,}",
    "to": '',
    'enable': false
  },
  {
    "name": "는는는(===)",
    "expr": true,
    "filter": "={2,}",
    "to": '',
    'enable': false
  },
  {
    "name": "점점점(......)",
    "expr": true,
    "filter": "\\.{2,}|\\…{1,}",
    "to": '',
    'enable': false
  },
  {
    "name": "물음표,느낌표제거(?!)",
    "expr": true,
    "filter": "\\?{1,}!{1,}",
    "to": '!',
    'enable': false
  },
  {
    "name": "느낌표,물음표제거(!?)",
    "expr": true,
    "filter": "!{1,}\\?{1,}",
    "to": '!',
    'enable': false
  },
  {
    "name": "여러 느낌표나 물음표 필터후 문장에 물음표만 있을경우 필터",
    "expr": true,
    "filter":
        """"!"|"\\."|"\\?"|'!'|'\\?'|“\\.”|“!”|“\\?”|‘!’|‘\\?|\\[!\\]|\\[\\?\\]|\\[\\.\\]""",
    "to": '',
    'enable': false
  },
  {
    "name": "아포스트로피(홀따음표) 필터",
    "expr": false,
    "filter": "'",
    "to": '',
    'enable': false
  },
  {
    "name": "특수문자 반복 된경우 필터",
    "expr": true,
    "filter":
        "\\&{2,}|\\#{2,}|\\@{2,}|\\\${2,}|~{1,}|\\*{2,}|\\[\\]|\\(\\)|\\{\\}",
    "to": '',
    'enable': true
  }
];

class Option_Filter extends OptionsBase {
  @override
  String get name => 'TTS 필터';

  BuildContext context = null;
  void openFilterList() async {
    showDialog(
      context: Get.context,
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

                  RxList rxlist = controller.config['filter'];
                  rxlist.add(Map.from({...e, "enable": true}));
                  controller.update();
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

  void openCustomFilter(int editIdx) async {
    var targetObj = {};

    if (editIdx >= 0) {
      targetObj = (controller.config['filter'] as RxList)[editIdx];
    } else {
      targetObj = {
        "name": "",
        "filter": "",
        "to": "",
        "expr": false,
        "enable": true
      };
    }
    showDialog(
      context: Get.context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('필터 추가'),
          children: [
            SizedBox(
                height: Get.height * 0.7,
                width: Get.width * 0.9,
                child: Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "필터 이름",
                          ),
                          controller:
                              TextEditingController(text: targetObj['name']),
                          onChanged: (value) {
                            targetObj['name'] = value;
                            // ctl.filterTmpCtl['name'] = value;
                            // ctl.update();
                          },
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "필터 조건",
                          ),
                          controller:
                              TextEditingController(text: targetObj['filter']),
                          onChanged: (value) {
                            targetObj['filter'] = value;
                            // ctl.filterTmpCtl['filter'] = value;
                            // ctl.update();
                          },
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "변환할 텍스트",
                          ),
                          controller:
                              TextEditingController(text: targetObj['to']),
                          onChanged: (value) {
                            targetObj['to'] = value;
                            // ctl.filterTmpCtl['to'] = value;
                            // ctl.update();
                          },
                        ),
                        Divider(),
                        CheckboxListTile(
                            title: Text('정규식 표현식 사용'),
                            value: targetObj['expr'] ?? false,
                            onChanged: (b) {
                              targetObj['expr'] = b;
                              // ctl.filterTmpCtl['expr'] = b;
                              // ctl.update();
                            }),
                      ],
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // ctl.filterTmpCtl.clear();
                    Get.back();
                  },
                  child: Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    RxList rxlist = controller.config['filter'];
                    if (editIdx >= 0) {
                      rxlist[editIdx] = Map.from(targetObj);
                    } else {
                      rxlist.add(Map.from(targetObj));
                    }
                    controller.update();
                    Get.back();
                  },
                  child: Text('추가'),
                )
              ],
            )
          ],
        );
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

    // RxList filterlist = controller.config['filter'];
    showDialog(
        context: Get.context,
        // barrierColor: Colors.transparent,
        // isDismissible: false,
        builder: (BuildContext context) {
          return GetBuilder<MainCtl>(builder: (ctl) {
            RxList filterlist = controller.config['filter'];
            return SimpleDialog(title: Text(name), children: [
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
                            '적용된 필터 목록 (좌우로 드래그하여 삭제)',
                            style: Get.context.textTheme.subtitle1,
                          ),
                          Divider(),
                          Expanded(
                              // (
                              //   children: [],
                              // )
                              child: ReorderableListView(
                                  onReorder: (oldIndex, newIndex) {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    var item =
                                        (controller.config['filter'] as RxList)
                                            .removeAt(oldIndex);
                                    (controller.config['filter'] as RxList)
                                        .insert(newIndex, item);
                                    controller.update();
                                  },
                                  padding: EdgeInsets.all(5),
                                  children: [
                                ...filterlist.map((e) {
                                  int idx = filterlist.indexOf(e);
                                  return Dismissible(
                                      key: UniqueKey(),
                                      background: Container(color: Colors.red),
                                      onDismissed: (direction) {
                                        controller.config.update('filter',
                                            (value) {
                                          (value as RxList).removeAt(idx);
                                          return value;
                                        });
                                        controller.update();
                                      },
                                      child: Card(
                                          child: Container(
                                        child: ListTile(
                                          title: Text(e['name'] ?? "---"),
                                          onTap: () {
                                            openCustomFilter(idx);
                                          },
                                          subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          flex: 8,
                                                          child: Text(
                                                              e['filter'] ??
                                                                  "")),
                                                      Expanded(
                                                          flex: 1,
                                                          child: Icon(Icons
                                                              .arrow_right)),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Center(
                                                              child: Text(e['to'] !=
                                                                          null &&
                                                                      e['to'] ==
                                                                          ""
                                                                  ? '없음'
                                                                  : e['to'])))
                                                    ]),
                                                Text(
                                                    '정규식 사용 여부 : ${e['expr'] != null && e['expr'] ? '사용' : '미사용'}'),
                                              ]),
                                          trailing: Checkbox(
                                              value: e['enable'] ?? false,
                                              onChanged: (b) {
                                                filterlist[idx]['enable'] = b;
                                                ctl.update();
                                              }),
                                        ),
                                      )));
                                }).toList()
                              ])),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    openCustomFilter(-1);
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ],
                            ),
                          )
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
