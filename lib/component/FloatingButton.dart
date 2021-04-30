import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_charset_detector/flutter_charset_detector.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';
import 'package:path_provider/path_provider.dart';

class FloatingButton extends GetView<MainCtl> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: 2.0,
        onPressed: () async {
          Directory tempDir = await getApplicationDocumentsDirectory();
          print('${tempDir.path}/opentextview');
          File db = File('${tempDir.path}/opentextview');
          Uint8List u8list = db.readAsBytesSync();
          DecodingResult centents = await CharsetDetector.autoDecode(u8list);

          // String dirPath = await
          FilePicker.platform.getDirectoryPath().then((dirPath) {
            File("$dirPath/test.txt").create();
            // .writeAsString("Hello, world!");
            // var f = File('${dirPath}/opentextview');
            // f.create();
          });

          // print(dirPath);
          // print(centents.string);
          // print(db.readAsBytesSync());
          // Directory tempDir = await getTemporaryDirectory();
          // print(tempDir.listSync());
          // Directory filpikerDir = Directory(tempDir.path + '/file_picker');
          // List fileList = filpikerDir.listSync();
          // print(fileList);
          // fileList.forEach((element) {
          //   (element as File).delete();
          // });
          //  tts 플레이로직 필요
        },
        child: Icon(Icons.volume_up));
  }
}
