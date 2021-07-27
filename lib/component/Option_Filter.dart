import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_textview/commonLibrary/HeroDialogRoute.dart';
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

class Option_Filter_ctl extends GetxController {
  double filerListHeight = 0.0;
  int editIndex = -1;
}

class Option_Filter extends OptionsBase {
  Option_Filter() {
    Get.put(Option_Filter_ctl());
  }
  @override
  String get name => 'TTS 필터';

  BuildContext context = null;
  ScrollController scrollController = ScrollController();

  Widget test(Function ontap) {
    return GestureDetector(onTap: ontap, child: Text("test"));
  }

  @override
  void openSetting() {
    HeroPopup(
      tag: name,
      title: Row(children: [
        // buildIcon(),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.w700),
        )
      ]),
      callback: (completion) {
        var tmpctl = Get.find<Option_Filter_ctl>();
        tmpctl.filerListHeight = 0.0;
        tmpctl.editIndex = -1;
      },
      children: [
        // width: double.infinity,
        GetBuilder<Option_Filter_ctl>(builder: (tmpCtl) {
          return ElevatedButton(
            onPressed: () async {
              // var tmpCtl = Get.find<Option_Filter_ctl>();
              if (tmpCtl.filerListHeight == 100) {
                // tmpCtl.filerListWidth = 0;
                tmpCtl.filerListHeight = 0;
              } else {
                // tmpCtl.filerListWidth = 500;
                tmpCtl.filerListHeight = 100;
              }
              tmpCtl.update();
            },
            child: tmpCtl.filerListHeight == 100
                ? Text('제공 되는 TTS 필터 리스트 숨기기')
                : Text('제공 되는 TTS 필터 리스트 보기'),
          );
        }),
        GetBuilder<Option_Filter_ctl>(builder: (ctl) {
          return AnimatedContainer(
            width: double.infinity,
            height: ctl.filerListHeight,
            duration: const Duration(milliseconds: 300),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...DFFILTER.map((e) {
                  return Card(
                      margin: EdgeInsets.all(10),
                      child: InkWell(
                          onTap: () {
                            RxList rxlist = controller.config['filter'];
                            rxlist.add(Map.from({...e, "enable": true}));
                            controller.update();
                          },
                          child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(e['name']),
                                    Text(e['filter'])
                                  ]))));
                }).toList()
              ],
            ),
          );
        }),
        Text(
          '적용된 필터 목록 (좌우로 드래그하여 삭제)',
          style: Get.context.textTheme.subtitle1,
        ),
        Divider(),
        SizedBox(
            height: Get.height * 0.5,
            // width: Get.width * 0.9,
            child: Obx(() {
              RxList filterlist = controller.config['filter'];

              return ReorderableListView(
                  scrollController: scrollController,
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    var item = filterlist.removeAt(oldIndex);
                    filterlist.insert(newIndex, item);
                    controller.update();
                  },
                  padding: EdgeInsets.all(5),
                  children: [
                    ...filterlist.map((e) {
                      int idx = filterlist.indexOf(e);
                      var targetObj = e;
                      return Dismissible(
                          key: UniqueKey(),
                          background: Container(color: Colors.red),
                          onDismissed: (direction) {
                            filterlist.removeAt(idx);
                            return filterlist;
                          },
                          child: Card(child:
                              GetBuilder<Option_Filter_ctl>(builder: (ctl) {
                            return AnimatedContainer(
                              width: double.infinity,
                              height: ctl.editIndex == idx ? 280 : 100,
                              duration: const Duration(milliseconds: 300),
                              child: ListTile(
                                title: ctl.editIndex == idx
                                    ? TextField(
                                        decoration: InputDecoration(
                                          labelText: "필터 이름",
                                        ),
                                        controller: TextEditingController(
                                            text: targetObj['name']),
                                        onChanged: (value) {
                                          targetObj['name'] = value;
                                        },
                                      )
                                    : Text(e['name'] ?? "---"),
                                onLongPress: () {
                                  ctl.editIndex = idx;
                                  ctl.update();
                                },
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                flex: 8,
                                                child: ctl.editIndex == idx
                                                    ? TextField(
                                                        decoration:
                                                            InputDecoration(
                                                          labelText: "필터 조건",
                                                        ),
                                                        controller:
                                                            TextEditingController(
                                                                text: targetObj[
                                                                    'filter']),
                                                        onChanged: (value) {
                                                          targetObj['filter'] =
                                                              value;
                                                          // ctl.filterTmpCtl['filter'] = value;
                                                          // ctl.update();
                                                        },
                                                      )
                                                    : Text(e['filter'] ?? "")),
                                            Expanded(
                                                flex: 1,
                                                child: Icon(Icons.arrow_right)),
                                            Expanded(
                                                flex: 3,
                                                child: Center(
                                                    child: ctl.editIndex == idx
                                                        ? TextField(
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "변환할 텍스트",
                                                            ),
                                                            controller:
                                                                TextEditingController(
                                                                    text: targetObj[
                                                                        'to']),
                                                            onChanged: (value) {
                                                              targetObj['to'] =
                                                                  value;
                                                              // ctl.filterTmpCtl['to'] = value;
                                                              // ctl.update();
                                                            },
                                                          )
                                                        : Text(e['to'] !=
                                                                    null &&
                                                                e['to'] == ""
                                                            ? '없음'
                                                            : e['to'])))
                                          ]),
                                      ctl.editIndex == idx
                                          ? CheckboxListTile(
                                              title: Text('정규식 표현식 사용'),
                                              value: targetObj['expr'] ?? false,
                                              onChanged: (b) {
                                                targetObj['expr'] = b;
                                                // ctl.filterTmpCtl['expr'] = b;
                                                ctl.update();
                                              })
                                          : Text(
                                              '정규식 사용 여부 : ${e['expr'] != null && e['expr'] ? '사용' : '미사용'}'),
                                      ctl.editIndex == idx
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      ctl.editIndex = -1;
                                                      ctl.update();
                                                    },
                                                    child: Text('닫기'))
                                              ],
                                            )
                                          : SizedBox()
                                    ]),
                                trailing: Checkbox(
                                    value: e['enable'] ?? false,
                                    onChanged: (b) {
                                      filterlist[idx]['enable'] = b;
                                      ctl.update();
                                    }),
                              ),
                            );
                          })));
                    }).toList(),
                  ]);
            })),
        Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    RxList filterlist = controller.config['filter'];
                    filterlist.add({
                      "name": "",
                      "filter": "",
                      "to": "",
                      "expr": false,
                      "enable": true
                    });
                    controller.update();

                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 300,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500));
                  },
                  child: Text('+'),
                )
              ],
            )),
      ],
    );
    // ]);
    return;
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
    return Hero(
        tag: name,
        child: Material(
            type: MaterialType.transparency, // likely needed
            child: IconButton(
              onPressed: () {
                openSetting();
              },
              icon: buildIcon(),
            )));
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
