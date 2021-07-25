import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/items/NavBtnItems.dart';

class bottomnavCtl extends GetxController {
  ScrollController scrollctl = ScrollController();
}

class BottomNav extends OptionsBase {
  BuildContext context = null;

  Widget dragList() {
    return ListView(children: [
      // ...controller.bottomNavBtns
      ...NAVBUTTON
          .asMap()
          .map((idx, el) {
            return MapEntry(
                idx,
                Card(
                  key: ValueKey(idx),
                  elevation: 2,
                  child: ListTileTheme(
                      iconColor: Theme.of(Get.context).iconTheme.color,
                      child: ListTile(
                        leading: el,
                        title: Text(el.name),
                        trailing: Obx(() => Checkbox(
                              value: (controller.config['nav'] as RxList)
                                  .where((e) =>
                                      e.toString() == el.runtimeType.toString())
                                  .isNotEmpty,
                              onChanged: (value) {
                                if (value) {
                                  (controller.config['nav'] as RxList)
                                      .add(el.runtimeType.toString());
                                } else {
                                  (controller.config['nav'] as RxList)
                                      .remove(el.runtimeType.toString());
                                }
                                controller.update();
                              },
                            )),
                        onTap: () {
                          el.openSetting();
                        },
                      )),
                ));
          })
          .values
          .toList(),
    ]);
  }

  void openOptions() async {
    showDialog(
      context: Get.context,
      builder: (BuildContext context) {
        return SimpleDialog(title: Text('설정'),
            // contentPadding: EdgeInsets.all(1),

            children: [
              SizedBox(
                  height: Get.height * 0.7,
                  width: Get.width * 0.9,
                  child: Container(
                    child: Column(children: [
                      Expanded(child: dragList()),
                      // Divider(),
                      // Expanded(child: staticList())
                    ]),
                  ))
            ]);
      },
    );
  }

  void TESTopenSetting() {
    // if (!isOpen) {
    Get.back();
    // return;
    // }
    Future.delayed(const Duration(milliseconds: 300), () {
      openOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    // TESTopenSetting();
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Theme.of(Get.context).colorScheme.surface,
        // notchedShape: CircularNotchedRectangle(),
        child: Container(
            // color: Theme.of(Get.context).colorScheme.surface,
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                openOptions();
              },
              padding: EdgeInsets.zero,
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                // List<Widget> navList =
                return Row(
                  children: [
                    ...(controller.config['nav'] as RxList).map((cmpName) {
                      List<OptionsBase> tmp = NAVBUTTON
                          .where((element) =>
                              element.runtimeType.toString() == cmpName)
                          .toList();
                      if (tmp.isNotEmpty) {
                        return tmp.first;
                      }
                      return SizedBox();
                    }),
                  ],
                );
              }),
            ),
          ),
          Expanded(flex: 2, child: SizedBox()),
        ])));
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     IconButton(
    //       icon: Icon(Icons.add),
    //       onPressed: () {
    //         // controller.contents.clear();
    //         // controller.update();
    //         // for (int i = 0; i < 500; i++) {
    //         //   controller.contents.add('Item00 $i');
    //         // }
    //       },
    //     ),
    //     Expanded(
    //         child: ListView.builder(
    //       scrollDirection: Axis.horizontal,
    //       itemCount: 10,
    //       itemBuilder: (context, index) => Text('asdf'),
    //     ))
    //     // SizedBox(
    //     //   width: double.infinity,
    //     //   child: ListView.builder(
    //     //     // scrollDirection: Axis.horizontal,
    //     //     // shrinkWrap: true,
    //     //     itemCount: 10,
    //     //     itemBuilder: (context, index) => Text('asdf'),
    //     //     //   (){
    //     //     //     return element
    //     //     //   })
    //     //     // (
    //     //     //     scrollDirection: Axis.horizontal,
    //     //     //     shrinkWrap: true,
    //     //     //     children: [
    //     //     //   ...controller.bottomNavBtns.map((element) => element).toList(),
    //     //     // ]
    //     //   ),
    //     // ),
    //     // IconButton(
    //     //   icon: Icon(Icons.volume_up),
    //     //   onPressed: () {},
    //     // ),
    //   ],
    // );
    // TESTopenSetting();
    //   return BottomAppBar(
    //     shape: CircularNotchedRectangle(),
    //     child: Obx(
    //       () => Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           IconButton(
    //             icon: Icon(Icons.add),
    //             onPressed: () {
    //               // controller.contents.clear();
    //               // controller.update();
    //               // for (int i = 0; i < 500; i++) {
    //               //   controller.contents.add('Item00 $i');
    //               // }
    //             },
    //             padding: EdgeInsets.zero,
    //           ),
    //           // IconButton(
    //           //   icon: Icon(Icons.settings),
    //           //   onPressed: () {},
    //           //   padding: EdgeInsets.zero,
    //           // ),
    //           SizedBox(
    //               height: 10,
    //               width: double.infinity,
    //               child: Container(color: Colors.red)),
    //           // ListView(
    //           //   children: [
    //           //     ...controller.bottomNavBtns
    //           //         .map((element) => element)
    //           //         .toList(),
    //           //   ],
    //           // ),

    //           // ...controller.bottomNavBtns.map((element) => element).toList(),
    //           // ...controller.bottomNavBtns.map((element) => element).toList(),
    //           IconButton(
    //             icon: Icon(Icons.volume_up),
    //             onPressed: () {},
    //           ),
    //         ],
    //       ),
    //     ),
    //     // showSelectedLabels: false,
    //     // showUnselectedLabels: false,
    //     // items: [
    //     //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
    //     //   BottomNavigationBarItem(icon: Icon(Icons.settings), label: '')
    //     // ],
    //   );
  }

  @override
  Widget buildIcon() {
    // TODO: implement buildIcon
    throw UnimplementedError();
  }

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  void openSetting() {
    // TODO: implement openSetting
  }
}
