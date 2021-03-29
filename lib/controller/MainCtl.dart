import 'package:get/get.dart';
import 'package:open_textview/items/NavBtnItems.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FindObj {
  FindObj({this.pos, this.contents});
  int pos;
  String contents;
}

class TtsConfig {
  TtsConfig(
      {this.language, this.speechRate, this.volume, this.pitch, this.voice});
  String language;
  double speechRate;
  double volume;
  double pitch;
  var voice;
}

class MainCtl extends GetxController {
  final itemScrollctl = ItemScrollController();
  final itemPosListener = ItemPositionsListener.create();

  final bottomNavBtns =
      [NAVBUTTON['find'], NAVBUTTON['tts'], NAVBUTTON['filter']].obs;
  final curPos = 0.obs;

  final contents = [];

  // 기능 영역
  // --- 검색기능 ---
  final findText = "".obs;
  final findList = List<FindObj>.empty().obs;

  // --- tts기능 ---
  final ttsConfig = TtsConfig().obs;

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

  // void runFindContents(String text) {
  //   findList.clear();
  //   if (text != "") {
  //     this.contents.asMap().forEach((key, value) {
  //       if (value.toString().indexOf(text) >= 0) {
  //         findList.add(FindObj(pos: key, contents: value));
  //       }
  //     });
  //   }
  //   findText.value = text;
  //   update();
  // }
}
