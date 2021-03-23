import 'package:get/get.dart';
import 'package:open_textview/items/NavBtnItems.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MainCtl extends GetxController {
  final itemScrollctl = ItemScrollController();
  final itemPosListener = ItemPositionsListener.create();

  final bottomNavBtns = [NAVBUTTON['find']].obs;
  final curPos = 0.obs;

  final contents = [];

  // 기능 영역
  final isBottomSheetOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    for (int i = 0; i < 500; i++) {
      contents.add('Item $i');
    }
    itemPosListener.itemPositions.addListener(() {
      var min = itemPosListener.itemPositions.value
          .where((ItemPosition position) => position.itemTrailingEdge > 0)
          .reduce((ItemPosition min, ItemPosition position) =>
              position.itemTrailingEdge < min.itemTrailingEdge ? position : min)
          .index;
      curPos.value = min;
      curPos.update((val) {});
    });
  }
}
