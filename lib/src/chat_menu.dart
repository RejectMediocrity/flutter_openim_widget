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
    menus.removeWhere((element) => element.enabled != true);
    if (menus.length == 0) {
      return Container();
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: menuStyle.background,
        borderRadius: BorderRadius.circular(menuStyle.radius),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withAlpha(25),
            blurRadius: 8.w,
            spreadRadius: 1.w,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuGridView(),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 20.w),
          //   color: Color(0xFF999999),
          //   height: 1.w,
          // ),
        ],
      ),
    );
  }

  GridView _buildMenuGridView() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 15.w),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: menuStyle.crossAxisCount,
        crossAxisSpacing: menuStyle.crossAxisSpacing,
        mainAxisSpacing: menuStyle.mainAxisSpacing,
      ),
      itemBuilder: (BuildContext context, int index) {
        MenuInfo info = menus[index];
        return _menuItem(
          icon: info.icon,
          label: info.text,
          onTap: info.onTap,
          style: info.textStyle ??
              TextStyle(fontSize: 12.sp, color: Color(0xFF333333)),
        );
      },
      itemCount: menus.length,
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            SizedBox(height: 10.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ],
        ),
      );
}
