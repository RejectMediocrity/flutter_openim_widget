import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//edit by wang.haoran at 2022-01-07
//控制弹出菜单样式

class MenuInfo {
  Widget icon;
  String text;
  TextStyle? textStyle;
  Function()? onTap;
  bool enabled;

  MenuInfo({
    required this.icon,
    required this.text,
    this.textStyle,
    this.onTap,
    this.enabled = true,
  });
}

class MenuStyle {
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final Color background;
  final double radius;

  MenuStyle({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.background,
    required this.radius,
  });

  const MenuStyle.base()
      : crossAxisCount = 4,
        mainAxisSpacing = 10,
        crossAxisSpacing = 10,
        background = const Color(0xFF666666),
        radius = 4;
}

class ChatLongPressMenu extends StatelessWidget {
  final CustomPopupMenuController controller;
  final List<MenuInfo> menus;
  final MenuStyle menuStyle;

  const ChatLongPressMenu({
    Key? key,
    required this.controller,
    required this.menus,
    this.menuStyle = const MenuStyle.base(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var childrens = _children();
    if (childrens.length == 0) {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.w),
      decoration: BoxDecoration(
        color: menuStyle.background,
        borderRadius: BorderRadius.circular(menuStyle.radius),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withAlpha(25),
            blurRadius: 8.h,
            spreadRadius: 1.h,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: childrens,
      ),
    );
  }

  List<Widget> _children() {
    var widgets = <Widget>[];
    menus.removeWhere((element) => !element.enabled);
    var rows = menus.length ~/ menuStyle.crossAxisCount;
    if (menus.length % menuStyle.crossAxisCount != 0) {
      rows++;
    }
    for (var i = 0; i < rows; i++) {
      var start = i * menuStyle.crossAxisCount;
      var end = (i + 1) * menuStyle.crossAxisCount;
      if (end > menus.length) {
        end = menus.length;
      }
      var subList = menus.sublist(start, end);
      widgets.add(Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subList
            .map((e) => _menuItem(
                  icon: e.icon,
                  label: e.text,
                  onTap: e.onTap,
                  style: e.textStyle ??
                      TextStyle(fontSize: 12.sp, color: Color(0xFF333333)),
                ))
            .toList(),
      ));
    }
    return widgets;
  }

  Widget _menuItem({
    required Widget icon,
    required String label,
    TextStyle? style,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: () {
          controller.hideMenu();
          if (null != onTap) onTap();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              SizedBox(height: 10.h),
              Text(
                label,
                // maxLines: 1,
                // overflow: TextOverflow.ellipsis,
                style: style,
              ),
            ],
          ),
        ),
      );
}
