import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/util/recently_used_emoji_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  const ChatLongPressMenu({
    Key? key,
    required this.controller,
    required this.menus,
    this.menuStyle = const MenuStyle.base(),
  }) : super(key: key);

  @override
  State<ChatLongPressMenu> createState() => _ChatLongPressMenuState();
}

class _ChatLongPressMenuState extends State<ChatLongPressMenu> {
  bool openEmoji = false;
  @override
  void initState() {
    widget.menus.removeWhere((element) => element.enabled != true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.menus.length == 0) {
      return Container();
    }
    return Container(
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
        children: [
          if (!openEmoji) _buildMenuGridView(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            color: Color(0xFF999999),
            height: 1.w,
          ),
          if (openEmoji) _buildEmojiBox(),
          _buildLatestEmojiBox(),
        ],
      ),
    );
  }

  ConstrainedBox _buildLatestEmojiBox() {
    List<String> latestEmojis = RecentlyUsedEmojiManager.getEmojiList();
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 42.w),
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: latestEmojis.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
          mainAxisSpacing: 22.w,
          crossAxisSpacing: 22.w,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Material(
            color: Colors.transparent,
            child: Ink(
              child: InkWell(
                onTap: () {
                  if (index < 6) {
                    String emojiName = emojiFaces.keys.elementAt(index);
                    RecentlyUsedEmojiManager.updateEmoji(emojiName);
                  } else {
                    setState(() {
                      openEmoji = !openEmoji;
                    });
                  }
                },
                child: Center(
                  child: index < 6
                      ? ImageUtil.faceImage(
                          emojiFaces.values.elementAt(index),
                          width: 30.w,
                          height: 30.w,
                        )
                      : RotatedBox(
                          quarterTurns: openEmoji ? 90 : 0,
                          child: ImageUtil.assetImage(
                            "ic_video_close",
                            color: Colors.black,
                            width: 30.w,
                            height: 30.w,
                          ),
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
      constraints: BoxConstraints(maxHeight: 190.w),
      child: SingleChildScrollView(
        child: ChatEmojiView(
          onAddEmoji: (emo) {
            print(emo);
          },
          onDeleteEmoji: null,
          controller: null,
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
