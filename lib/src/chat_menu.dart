import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/util/recently_used_emoji_manager.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class ChatLongPressMenu extends StatefulWidget {
  final CustomPopupMenuController controller;
  final List<MenuInfo> menus;
  final MenuStyle menuStyle;
  final Function(String)? onTapEmoji;

  /// enableEmoji false 禁止添加表情功能, default true
  final bool enableEmoji;
  const ChatLongPressMenu({
    Key? key,
    required this.controller,
    required this.menus,
    this.menuStyle = const MenuStyle.base(),
    this.onTapEmoji,
    this.enableEmoji = true,
  }) : super(key: key);

  @override
  State<ChatLongPressMenu> createState() => _ChatLongPressMenuState();
}

class _ChatLongPressMenuState extends State<ChatLongPressMenu> {
  bool openEmoji = false;
  bool isTop = false;
  @override
  void initState() {
    widget.menus.removeWhere((element) => element.enabled != true);
    double height = 0;
    if (widget.menus.length > 6) {
      height = 210 / 667 * 1.sh;
    } else {
      height = 139 / 667 * 1.sh;
    }
    double free = 1.sh - widget.controller.details.globalPosition.dy;
    isTop = free <= height;
    if (!isTop) {
      height = 275 / 667 * 1.sh;
      isTop = free <= height;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.menus.length == 0) {
      return Container();
    }
    widget.menus.removeWhere((element) => element.enabled != true);

    return Container(
      constraints: BoxConstraints(
          maxWidth: DeviceUtil.instance.isPadOrTablet ? 400.w : 330.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.menuStyle.background,
        borderRadius: BorderRadius.circular(widget.menuStyle.radius),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF000000).withAlpha(25),
            blurRadius: 8.w,
            spreadRadius: 1.w,
          ),
        ],
      ),
      child: Column(
        children: isTop ? aboveChildren() : belowChildren(),
      ),
    );
  }

  List<Widget> aboveChildren() {
    return [
      if (!openEmoji) _buildMenuGridView(),
      if (openEmoji)
        SizedBox(
          height: 8.w,
        ),
      if (openEmoji) _buildEmojiBox(),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        color: Color(0xFFF2F2F2),
        height: 1.w,
      ),
      _buildLatestEmojiBox(),
    ];
  }

  List<Widget> belowChildren() {
    return [
      _buildLatestEmojiBox(),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        color: Color(0xFFF2F2F2),
        height: 1.w,
      ),
      if (openEmoji) _buildEmojiBox(),
      if (openEmoji)
        SizedBox(
          height: 8.w,
        ),
      if (!openEmoji) _buildMenuGridView(),
    ];
  }

  Widget _buildLatestEmojiBox() {
    if (!widget.enableEmoji) {
      return Container();
    }
    List<String> latestEmojis = RecentlyUsedEmojiManager.getEmojiList();
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: DeviceUtil.instance.isPadOrTablet ? 58.w : 48.w),
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 10.w, 16.w, 16.w),
        physics: NeverScrollableScrollPhysics(),
        itemCount: latestEmojis.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 20.w,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Material(
            color: Colors.transparent,
            child: Ink(
              child: InkWell(
                onTap: () {
                  if (index < 6) {
                    RecentlyUsedEmojiManager.updateEmoji(latestEmojis[index]);
                    // setState(() {});
                    widget.controller.hideMenu();
                    if (widget.onTapEmoji != null)
                      widget.onTapEmoji!(latestEmojis[index]);
                  } else {
                    setState(() {
                      openEmoji = !openEmoji;
                    });
                  }
                },
                child: Center(
                  child: index < 6
                      ? ImageUtil.faceImage(
                          emojiFaces.values.elementAt(emojiFaces.keys
                              .toList()
                              .indexOf(latestEmojis[index])),
                          width:
                              DeviceUtil.instance.isPadOrTablet ? 37.w : 24.w,
                          height:
                              DeviceUtil.instance.isPadOrTablet ? 37.w : 24.w,
                        )
                      : ImageUtil.assetImage(
                          openEmoji ? "ic_video_close" : "title_but_add_dark",
                          color: Colors.black,
                          width: 20.w,
                          height: 20.w,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ConstrainedBox _buildEmojiBox() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 226.w),
      child: Container(
        // color: Colors.blueAccent,
        decoration: BoxDecoration(
          color: widget.menuStyle.background,
          // borderRadius: BorderRadius.circular(widget.menuStyle.radius),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: ChatEmojiView(
            onAddEmoji: (emojiName) {
              widget.controller.hideMenu();
              if (widget.onTapEmoji != null) widget.onTapEmoji!(emojiName);
            },
            onDeleteEmoji: null,
            controller: null,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 12.w,
            backColor: Colors.white,
            edgeInsets:
                EdgeInsets.fromLTRB(16.w, isTop ? 8.w : 16.w, 16.w, 44.w),
            size: DeviceUtil.instance.isPadOrTablet ? 37.w : 24.w,
            crossAxisCount: 7,
          ),
        ),
      ),
    );
  }

  GridView _buildMenuGridView() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 15.w),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.menuStyle.crossAxisCount,
        crossAxisSpacing: widget.menuStyle.crossAxisSpacing,
        mainAxisSpacing: widget.menuStyle.mainAxisSpacing,
      ),
      itemBuilder: (BuildContext context, int index) {
        MenuInfo info = widget.menus[index];
        return _menuItem(
          icon: info.icon,
          label: info.text,
          onTap: info.onTap,
          style: info.textStyle ??
              TextStyle(fontSize: 12.sp, color: Color(0xFF333333)),
        );
      },
      itemCount: widget.menus.length,
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
          widget.controller.hideMenu();
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
