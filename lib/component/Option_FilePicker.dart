import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:open_textview/component/OptionsBase.dart';

class Option_FilePicker extends OptionsBase {
  BuildContext context = null;

  @override
  String get name => '파일 탐색기';

  @override
  Widget build(BuildContext context) {
    // TESTopenSetting();
    this.context = context;

    // TODO: implement build
    return IconButton(
      onPressed: () {
        openSetting();
        // openSetting();
      },
      icon: buildIcon(),
      // Text('tts필터')
    );
  }

  @override
  Widget buildIcon() {
    // TODO: implement buildIcon
    return Icon(
      Icons.folder_open,
    );
  }

  @override
  void openSetting() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['txt'],
    );
    if (result.files.isNotEmpty) {
      PlatformFile platformfile = result.files.first;
      RxMap picker = controller.config['picker'];

      picker.updateAll((key, value) {
        if (key == 'name') return platformfile.name;
        if (key == 'bytes') return platformfile.bytes;
        if (key == 'size') return platformfile.size;
        if (key == 'extension') return platformfile.extension;
        if (key == 'path') return platformfile.path;
      });
      // ---------- 마지막 연 파일은 캐시에 남기고 다른 캐시 삭제 로직 --------
      // Directory tempDir = await getTemporaryDirectory();
      // Directory filpikerDir = Directory(tempDir.path + '/file_picker');
      // List fileList = filpikerDir.listSync();
      // fileList.forEach((element) {
      //   String fileName = element.path.split('/').last;
      //   if (platformfile.name != fileName) {
      //     (element as File).delete();
      //   }
      // });

      // controller.update();
    }
  }
}
