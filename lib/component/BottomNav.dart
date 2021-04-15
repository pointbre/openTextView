import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:open_textview/items/NavBtnItems.dart';

class bottomnavCtl extends GetxController {
  ScrollController scrollctl = ScrollController();
}

class BottomNav extends GetView<MainCtl> {
  BuildContext context = null;
  Widget dragList() {
    return ReorderableListView(
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = controller.bottomNavBtns.removeAt(oldIndex);
          controller.bottomNavBtns.insert(newIndex, item);
          controller.update();
          // controller.bottomNavBtns.
        },
        children: [
          ...controller.bottomNavBtns
              .asMap()
              .map((idx, el) {
                return MapEntry(
                    idx,
                    Card(
                      key: ValueKey(idx),
                      elevation: 2,
                      child: ListTile(
                        leading: Container(child: el.buildIcon()),
                        title: Text(el.name),
                        trailing: Switch(
                          value: true,
                          onChanged: (bool v) {
                            controller.bottomNavBtns.removeAt(idx);
                            controller.update();
                          },
                        ),
                        onTap: () {
                          el.openSetting();
                        },
                      ),
                    ));
              })
              .values
              .toList(),
        ]);
  }

  Widget staticList() {
    return ListView(children: [
      ...NAVBUTTON.where((el) {
        int idx = controller.bottomNavBtns.indexOf(el);
        return idx < 0;
      }).map((el) {
        int idx = NAVBUTTON.indexOf(el);
        return Card(
          key: ValueKey('0$idx'),
          elevation: 2,
          child: ListTile(
            leading: Container(child: el.buildIcon()),
            title: Text(el.name),
            trailing: Switch(
              value: false,
              onChanged: (bool v) {
                controller.bottomNavBtns.add(el);
                controller.update();
              },
            ),
            onTap: () {
              el.openSetting();
            },
          ),
        );
      }).toList()
    ]);
  }

  void openOptions() async {
    showDialog(
      context: context,
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
                      Divider(),
                      Expanded(child: staticList())
                    ]),
                  )
                  // Expanded(
                  //   child: Column(
                  //     children: [dragList()],
                  //     // itemBuilder: (context, index) {
                  //     //   if (index == 0) {
                  //     //     return
                  //     //   }
                  //     //   return Text('asd');
                  //     // },
                  //   ),
                  // )
                  // GetBuilder<MainCtl>(builder: (ctl) {
                  //   return dragList();
                  // })
                  // Divider(key: ValueKey('asdf')),
                  //         ...NAVBUTTON.where((el) {
                  //           int idx = ctl.bottomNavBtns.indexOf(el);
                  //           return idx < 0;
                  //         }).map((el) {
                  //           int idx = NAVBUTTON.indexOf(el);
                  //           return Card(
                  //             key: ValueKey('0$idx'),
                  //             elevation: 2,
                  //             child: ListTile(
                  //               leading: Container(child: el.buildIcon()),
                  //               title: Text(el.name),
                  //               trailing: Switch(
                  //                 value: false,
                  //                 onChanged: (bool v) {
                  //                   // if (v == false) {
                  //                   //   ctl.bottomNavBtns.removeAt(idx);
                  //                   // } else {
                  //                   ctl.bottomNavBtns.add(el);
                  //                   // }
                  //                   ctl.update();
                  //                 },
                  //               ),
                  //               onTap: () {
                  //                 el.openSetting();
                  //               },
                  //             ),
                  //           );
                  //         })
                  )
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

    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
          child: Row(
            children: [
              ...controller.bottomNavBtns.map((element) => element).toList(),
              // ...controller.bottomNavBtns.map((element) => element).toList(),
              // ...controller.bottomNavBtns.map((element) => element).toList(),
            ],
          ),
        ),
      ),
      Expanded(flex: 2, child: SizedBox()
          // IconButton(
          //   icon: Icon(Icons.settings),
          //   onPressed: () {},
          //   padding: EdgeInsets.zero,
          // )
          ),
    ]);
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
}
