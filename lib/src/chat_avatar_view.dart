import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

List<String> get indexAvatarList => [
      'ic_avatar_01',
      'ic_avatar_02',
      'ic_avatar_03',
      'ic_avatar_04',
      'ic_avatar_05',
      'ic_avatar_06',
    ];

class ChatAvatarView extends StatelessWidget {
  const ChatAvatarView({
    Key? key,
    this.visible = true,
    this.size,
    this.onTap,
    this.url,
    this.onLongPress,
    this.isCircle = false,
    this.borderRadius,
    required this.text,
    this.textStyle,
    this.lowMemory = false,
    this.isNineGrid = false,
    this.nineGridUrls = const [],
    this.isChatFrom = false, // 会话列表或者聊天详情
    this.isGroup = false,
    this.innerBorder,
    this.defaultImg = "ic_conversation_group",
  }) : super(key: key);
  final bool visible;
  final double? size;
  final Function()? onTap;
  final Function()? onLongPress;
  final String? url;
  final bool isCircle;
  final BorderRadius? borderRadius;
  final String? text;
  final TextStyle? textStyle;
  final bool lowMemory;
  final List<String> nineGridUrls;
  final bool isNineGrid;
  final bool isChatFrom;
  final bool isGroup;
  final Border? innerBorder;
  final String? defaultImg;
  double get _size => size ?? 42.h;

  bool _isIndexAvatar() => null != url && indexAvatarList.contains(url);

  @override
  Widget build(BuildContext context) {
    var child = isNineGrid ? _nineGridAvatar() : _normalAvatar();
    return Container(
      decoration: BoxDecoration(
        border: innerBorder != null
            ? innerBorder
            : Border.all(color: Color(0xFFF2F2F2), width: 1.w),
        // boxShadow: [
        //   BoxShadow(color: Color(0xFFF2F2F2), blurRadius: 1, spreadRadius: 1),
        // ],
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
      child: Visibility(
        visible: visible,
        child: isCircle
            ? ClipOval(child: child)
            : ClipRRect(
                child: child,
                borderRadius: borderRadius ?? BorderRadius.circular(6),
              ),
      ),
    );
  }

  Widget _normalAvatar() => InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: _avatarView(
          size: _size,
          lowMemory: lowMemory,
          url: url,
          text: text,
        ),
      );

  Widget _avatarView(
          {required double size,
          String? url,
          String? text,
          required bool lowMemory}) =>
      null == url || url.isEmpty
          ? _defaultAvatar(size: size, text: text)
          : (_isIndexAvatar()
              ? _indexAvatar(size: size, url: url)
              : _networkImage(
                  url: url, lowMemory: lowMemory, width: size, height: size));

  Widget _indexAvatar({required double size, required String url}) => Container(
        width: size,
        height: size,
        child: ImageUtil.assetImage(url, width: size, height: size),
      );

  Widget _defaultAvatar({required double size, String? text}) {
    if (isGroup)
      return Container(
        child: ImageUtil.assetImage(
          defaultImg!,
          width: size,
          height: size,
          fit: BoxFit.fill,
        ),
      );
    if (text == null) text = "";
    final String cnExp = "[\u4e00-\u9fa5]";
    final String enExp = "[a-zA-Z]+";
    List<RegExpMatch>? cnMatchs = RegExp(cnExp).allMatches(text).toList();
    RegExpMatch? enMatch = RegExp(enExp).firstMatch(text);

    TextStyle? style;

    if (cnMatchs != null && cnMatchs.length > 0) {
      // String match = '';
      // if (cnMatchs.length > 1) {
      //   match = text.substring(cnMatchs[cnMatchs.length - 2].start,
      //       cnMatchs[cnMatchs.length - 2].end);
      // }
      // match = match + text.substring(cnMatchs.last.start, cnMatchs.last.end);
      // text = match;
      int start = text.length - 2;
      text = text.substring(start < 0 ? 0 : start, text.length);
      style = TextStyle(
          fontSize: (_size / 42.h) * 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w400);
    } else if (enMatch != null) {
      text = text.substring(enMatch.start, 1).toUpperCase();
      style = TextStyle(
          fontSize: (_size / 42.h) * 15.sp,
          color: Colors.white,
          fontWeight: FontWeight.w500);
    }
    if (style != null)
      return Container(
        color: Color(0xFF006DFA),
        child: Text(
          text,
          style: style,
        ),
        width: size,
        height: size,
        alignment: Alignment.center,
        // color: Colors.grey[400],
      );
    return Container(
      child: ImageUtil.assetImage(
        "msglist_icon_defult",
        width: size,
        height: size,
      ),
    );
  }

  Widget _networkImage({
    required bool lowMemory,
    required String url,
    required double width,
    required double height,
    int? cacheWidth,
    int? cacheHeight,
  }) =>
      lowMemory
          ? ImageUtil.lowMemoryNetworkImage(
              url: url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              loadProgress: false,
              cacheWidth: cacheWidth ?? (1.sw * .3).toInt(),
              cacheHeight: cacheHeight,
              defaultImage: _defaultAvatar(size: _size, text: text),
            )
          : ImageUtil.networkImage(
              url: url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              loadProgress: false,
              cacheWidth: cacheWidth ?? (1.sw * .3).toInt(),
              cacheHeight: cacheHeight,
              defaultImage: _defaultAvatar(size: _size, text: text),
            );

  Widget _nineGridAvatar() => Container(
        width: _size,
        height: _size,
        color: Colors.grey[300],
        padding: EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: _nineGridColumn(),
      );

  /// 9宫格列
  Widget _nineGridColumn() {
    var width;
    var margin = 2.0;
    var row1Length;
    var row2Length;
    var row3Length;
    var list = <Widget>[];
    switch (nineGridUrls.length) {
      case 1:
        width = _size;
        row1Length = 1;
        break;
      case 2:
        width = _size / 2;
        row1Length = 2;
        break;
      case 3:
        width = _size / 2;
        row1Length = 1;
        row2Length = 2;
        break;
      case 4:
        width = _size / 2;
        row1Length = 2;
        row2Length = 2;
        break;
      case 5:
        width = _size / 3;
        row1Length = 2;
        row2Length = 3;
        break;
      case 6:
        width = _size / 3;
        row1Length = 3;
        row2Length = 3;
        break;
      case 7:
        width = _size / 3;
        row1Length = 1;
        row2Length = 3;
        row3Length = 3;
        break;
      case 8:
        width = _size / 3;
        row1Length = 2;
        row2Length = 3;
        row3Length = 3;
        break;
      case 9:
        width = _size / 3;
        row1Length = 3;
        row2Length = 3;
        row3Length = 3;
        break;
    }
    if (row1Length > 0) {
      list.add(_nineGridRow(
        length: row1Length,
        start: 0,
        size: width,
        margin: margin,
      ));
    }
    if (row2Length > 0) {
      list.add(_nineGridRow(
        length: row2Length,
        start: row1Length,
        size: width,
        margin: margin,
      ));
    }
    if (row3Length > 0) {
      list.add(_nineGridRow(
        length: row3Length,
        start: row1Length + row2Length,
        size: width,
        margin: margin,
      ));
    }
    return Column(
      children: list,
    );
  }

  /// 9宫格行
  Widget _nineGridRow({
    required int length,
    required int start,
    required double size,
    required double margin,
  }) {
    var list = <Widget>[];
    for (var i = 0; i < length; i++) {
      start += i;
      list.add(_nineGridImage(nineGridUrls.elementAt(start), size));
      if (i != length - 1) {
        list.add(_nineGridLine(width: margin, height: size));
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  Widget _nineGridImage(String? url, double size) =>
      _avatarView(lowMemory: false, size: size, url: url);

  Widget _nineGridLine({
    double? width,
    double? height,
  }) =>
      Container(height: height, width: width, color: Colors.white);
}
