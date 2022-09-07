import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// typedef PopupMenuItemBuilder = Widget Function(PopMenuInfo info);

/// 菜单布局类型
/// horizontal 水平排布
/// vertical 垂直排布（默认）
enum MenuItemLayoutType {
  horizontal,
  vertical,
}

class PopMenuInfo {
  final String? icon;
  final String text;
  final Function()? onTap;

  PopMenuInfo({
    this.icon,
    required this.text,
    this.onTap,
  });
}

class PopButton extends StatelessWidget {
  final List<PopMenuInfo> menus;
  final Widget child;
  final Widget? popupChild;

  final CustomPopupMenuController? popCtrl;

  // final PopupMenuItemBuilder builder;
  final PressType pressType;
  final bool showArrow;
  final Color arrowColor;
  final Color barrierColor;
  final double horizontalMargin;
  final double verticalMargin;
  final double arrowSize;

  final Color menuBgColor;
  final double menuBgRadius;
  final Color? menuBgShadowColor;
  final Offset? menuBgShadowOffset;
  final double? menuBgShadowBlurRadius;
  final double? menuBgShadowSpreadRadius;

  final double? menuItemHeight;
  final double? menuItemWidth;
  final EdgeInsetsGeometry? menuItemPadding;
  final TextStyle menuItemTextStyle;
  final double menuItemIconSize;
  final Function()? pressFunc;
  final Function()? dismissCallback;
  final MenuItemLayoutType? menuItemLayoutType;
  final bool? isNeedFixOffsetOnPad;

  PopButton({
    Key? key,
    required this.menus,
    required this.child,
    // required this.builder,
    this.popupChild,
    this.popCtrl,
    this.arrowColor = const Color(0xFF1B72EC),
    this.showArrow = true,
    this.barrierColor = Colors.transparent,
    this.arrowSize = 10.0,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
    this.pressType = PressType.singleClick,
    this.menuBgColor = const Color(0xFF1B72EC),
    this.menuBgRadius = 10.0,
    this.menuBgShadowColor,
    this.menuBgShadowOffset,
    this.menuBgShadowBlurRadius,
    this.menuBgShadowSpreadRadius,
    this.menuItemHeight,
    this.menuItemWidth,
    this.menuItemTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
    this.menuItemIconSize = 18.0,
    this.menuItemPadding,
    this.pressFunc,
    this.dismissCallback,
    this.menuItemLayoutType = MenuItemLayoutType.vertical,
    this.isNeedFixOffsetOnPad = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CopyCustomPopupMenu(
      controller: popCtrl,
      arrowColor: arrowColor,
      showArrow: showArrow,
      barrierColor: barrierColor,
      arrowSize: arrowSize,
      verticalMargin: verticalMargin,
      horizontalMargin: horizontalMargin,
      pressType: pressType,
      child: child,
      menuBuilder: () => _buildPopBgView(
        child: popupChild ??
            (menuItemLayoutType == MenuItemLayoutType.vertical
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: menus.map((e) => _buildPopItemView(e)).toList(),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: menus.map((e) => _buildPopItemView(e)).toList(),
                  )),
      ),
      pressFunc: pressFunc,
      dismissCallback: dismissCallback,
      isNeedFixOffsetOnPad: isNeedFixOffsetOnPad ?? false,
    );
  }

  _clickArea(double dy) {
    for (var i = 0; i < menus.length; i++) {
      if (dy > i * menuItemHeight! && dy <= (i + 1) * menuItemHeight!) {
        menus.elementAt(i).onTap?.call();
        popCtrl?.hideMenu();
      }
    }
  }

  Widget _buildPopBgView({Widget? child}) => GestureDetector(
        onPanDown: null == menuItemHeight
            ? null
            : (details) {
                if (null != menuItemHeight) {
                  _clickArea(details.localPosition.dy);
                }
              },
        child: Container(
          child: child,
          padding: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: menuBgColor,
            borderRadius: BorderRadius.circular(menuBgRadius),
            boxShadow: [
              BoxShadow(
                color: menuBgShadowColor ?? Color(0xFF000000).withOpacity(0.5),
                offset: menuBgShadowOffset ?? Offset(0, 2),
                blurRadius: menuBgShadowBlurRadius ?? 6,
                spreadRadius: menuBgShadowSpreadRadius ?? 0,
              )
            ],
          ),
        ),
      );

  Widget _buildPopItemView(PopMenuInfo info) => GestureDetector(
        onTap: null == menuItemHeight
            ? () {
                popCtrl?.hideMenu();
                info.onTap?.call();
              }
            : null,
        onDoubleTap: null,
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: menuItemHeight,
          width: menuItemWidth,
          padding: menuItemPadding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (null != info.icon)
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Image.asset(
                    info.icon!,
                    width: menuItemIconSize,
                    height: menuItemIconSize,
                  ),
                ),
              Text(
                info.text,
                style: menuItemTextStyle,
              ),
            ],
          ),
        ),
      );
}
