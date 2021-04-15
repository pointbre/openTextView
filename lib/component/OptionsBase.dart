import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:open_textview/controller/MainCtl.dart';

abstract class OptionsBase extends GetView<MainCtl> {
  BuildContext context;
  String get name;
  void openSetting();
  Widget buildIcon();
  Widget build(BuildContext context);
}
