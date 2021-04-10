import 'package:flutter/widgets.dart';
import 'package:get/state_manager.dart';
import 'package:open_textview/controller/MainCtl.dart';

abstract class BottomSheetBase extends GetView<MainCtl> {
  BuildContext context;
  String get name;
  void openBottomSheet();
  Widget buildIcon();
  Widget build(BuildContext context);
}
