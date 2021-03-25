import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:open_textview/controller/MainCtl.dart';

class FloatingButton extends GetView<MainCtl> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        elevation: 2.0,
        onPressed: () {
          //  tts 플레이로직 필요
        },
        child: Icon(Icons.volume_up));
  }
}
