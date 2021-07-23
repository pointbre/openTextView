import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class HeroPopup {
  HeroPopup({this.tag, this.children, this.title, this.titleTextStyle}) {
    // IconButton
    Navigator.of(Get.context).push(HeroDialogRoute(builder: (context) {
      return Center(
          child: Hero(
              tag: tag,
              child: Card(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  DefaultTextStyle(
                      style: titleTextStyle ??
                          DialogTheme.of(context).titleTextStyle ??
                          Theme.of(context).textTheme.headline6,
                      child: Semantics(
                        container: true,
                        child: title,
                      )),
                  Divider(),
                  ...children,
                ],
              ))));
    }));
  }
  // final WidgetBuilder builder;
  final List<Widget> children;
  final Widget title;
  final TextStyle titleTextStyle;
  final String tag;
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;
  @override
  String get barrierLabel => "";
  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 600);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // print(child);
    // return Text("1");
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: Column(children: [
          child,
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.volume_mute_rounded,
              ))
        ]));
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }
}
