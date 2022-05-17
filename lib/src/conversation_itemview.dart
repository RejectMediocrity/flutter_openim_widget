import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final pinColors = [Color(0xFF87C0FF), Color(0xFF0060E7)];
final deleteColors = [Color(0xFFFFC84C), Color(0xFFFFA93C)];
final haveReadColors = [Color(0xFFC9C9C9), Color(0xFF7A7A7A)];

class ConversationItemView extends StatelessWidget {
  final List<SlideItemInfo> slideActions;
  final double avatarSize;
  final String? avatarUrl;
  final bool? isCircleAvatar;
  final BorderRadius? avatarBorderRadius;
  final String title;
  final TextStyle titleStyle;
  final String content;
  final TextStyle contentStyle;
  final String? contentPrefix;
  final TextSpan? faceReplySpan;
  final TextStyle? contentPrefixStyle;
  final String timeStr;
  final TextStyle timeStyle;
  final Color backgroundColor;
  final double height;
  final double contentWidth;
  final int unreadCount;
  final EdgeInsetsGeometry padding;
  final bool underline;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final Function()? onTap;
  final bool notDisturb;
  final double extentRatio;
  final bool needToTpliceContent;
  // final bool isPinned;
  final String nickName;
  final bool isGroupChat;
  final String? senderName;
  ConversationItemView({
    Key? key,
    this.slideActions = const [],
    required this.title,
    required this.content,
    required this.timeStr,
    this.contentPrefix,
    this.contentPrefixStyle,
    this.avatarSize = 48,
    this.avatarUrl,
    this.isCircleAvatar,
    this.avatarBorderRadius,
    this.backgroundColor = const Color(0xFFFFFF),
    this.height = 73,
    this.contentWidth = 200,
    this.unreadCount = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 22),
    this.underline = true,
    this.allAtMap = const {},
    this.patterns = const [],
    this.onTap,
    this.notDisturb = false,
    this.extentRatio = 0.5,
    // this.isPinned = false,
    this.titleStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFF333333),
      fontWeight: FontWeight.w600,
    ),
    this.contentStyle = const TextStyle(
      fontSize: 12,
      color: Color(0xFF666666),
      fontWeight: FontWeight.w600,
    ),
    this.timeStyle = const TextStyle(
      fontSize: 12,
      color: Color(0xFF999999),
      fontWeight: FontWeight.w600,
    ),
    this.needToTpliceContent = true,
    this.nickName = '',
    this.isGroupChat = false,
    this.senderName,
    this.faceReplySpan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      child: _ConversationView(
        nickName: nickName,
        title: title,
        content: content,
        timeStr: timeStr,
        contentPrefix: contentPrefix,
        contentPrefixStyle: contentPrefixStyle,
        avatarSize: avatarSize,
        avatarUrl: avatarUrl,
        isCircleAvatar: isCircleAvatar,
        avatarBorderRadius: avatarBorderRadius,
        backgroundColor: backgroundColor,
        height: height,
        contentWidth: contentWidth,
        unreadCount: unreadCount,
        padding: padding,
        underline: underline,
        allAtMap: allAtMap,
        patterns: patterns,
        titleStyle: titleStyle,
        contentStyle: contentStyle,
        timeStyle: timeStyle,
        onTap: onTap,
        notDisturb: notDisturb,
        needToTpliceContent: needToTpliceContent,
        isGroupChat: isGroupChat,
        senderName: senderName,
        faceReplySpan: faceReplySpan,
      ),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        extentRatio: extentRatio,
        children: slideActions.map((e) => _SlidableAction(item: e)).toList(),
      ),
    );
  }
}

class _ConversationView extends StatefulWidget {
  const _ConversationView({
    Key? key,
    required this.title,
    required this.content,
    required this.timeStr,
    required this.avatarSize,
    required this.backgroundColor,
    required this.height,
    required this.contentWidth,
    required this.unreadCount,
    required this.padding,
    this.underline = true,
    required this.allAtMap,
    required this.patterns,
    // this.isPinned = false,
    required this.titleStyle,
    required this.contentStyle,
    required this.timeStyle,
    this.avatarUrl,
    this.isCircleAvatar,
    this.avatarBorderRadius,
    this.contentPrefix,
    this.contentPrefixStyle,
    this.onTap,
    this.notDisturb = false,
    this.needToTpliceContent = true,
    this.nickName = '',
    this.isGroupChat = false,
    this.senderName,
    this.faceReplySpan,
  }) : super(key: key);
  final double avatarSize;
  final String? avatarUrl;
  final bool? isCircleAvatar;
  final BorderRadius? avatarBorderRadius;
  final String title;
  final TextStyle titleStyle;
  final String content;
  final TextStyle contentStyle;
  final String? contentPrefix;
  final TextSpan? faceReplySpan;
  final TextStyle? contentPrefixStyle;
  final String timeStr;
  final TextStyle timeStyle;
  final Color backgroundColor;
  final double height;
  final double contentWidth;
  final int unreadCount;
  final EdgeInsetsGeometry padding;
  final bool underline;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final Function()? onTap;
  final bool notDisturb;
  final bool needToTpliceContent;
  final String nickName;
  final bool isGroupChat;
  final String? senderName;

  @override
  State<_ConversationView> createState() => _ConversationViewState();
}

class _ConversationViewState extends State<_ConversationView> {
  String content = "";

  InlineSpan? _buildImgSpan(String? prefixStr) {
    if (null == widget.contentPrefix) {
      return null;
    }
    if (prefixStr?.startsWith(RegExp("img:"), 0) == true) {
      return ImageSpan(
        AssetImage(
          "assets/images/${prefixStr?.substring(4)}.webp",
          package: "flutter_openim_widget",
        ),
        imageWidth: 14.w,
        imageHeight: 14.w,
        margin: EdgeInsets.only(right: 4.w),
      );
    } else {
      return TextSpan(
        text: widget.contentPrefix,
        style: widget.contentPrefixStyle,
      );
    }
  }

  InlineSpan? _buildSendernameSpan(String? senderName) {
    if (null == senderName) {
      return null;
    }
    return TextSpan(
      text: senderName,
      style: widget.contentStyle,
    );
  }

  @override
  void initState() {
    super.initState();
    content = "${widget.content}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(),
      child: Container(
        constraints: BoxConstraints(maxHeight: 66.w),
        color: widget.backgroundColor,
        // height: height,
        padding: widget.padding,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                ChatAvatarView(
                  isGroup: widget.isGroupChat,
                  text: widget.nickName,
                  size: widget.avatarSize,
                  url: widget.avatarUrl,
                  isCircle: widget.isCircleAvatar ?? false,
                  borderRadius: widget.avatarBorderRadius,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: widget.underline
                        ? BoxDecoration(
                            border: BorderDirectional(
                              bottom: BorderSide(
                                  color: Color(0xFFE5EBFF), width: 1),
                            ),
                          )
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                CommonUtil.breakWord(widget.title),
                                style: widget.titleStyle,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                              widget.timeStr,
                              style: widget.timeStyle,
                            )
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Container(
                              width: widget.contentWidth,
                              child: buildChatAtText(),
                            ),
                            Spacer(),
                            UnreadCountView(
                              count: widget.unreadCount,
                              size: 18.w,
                              color: widget.notDisturb
                                  ? Color(0xFFDDDDDD)
                                  : Color(0xFFFF4A4A),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // if (notDisturb && unreadCount > 0)
            //   Align(
            //     alignment: Alignment.centerLeft,
            //     child: Container(
            //       width: avatarSize + 4,
            //       height: avatarSize + 4,
            //       alignment: Alignment.topRight,
            //       child: Container(
            //         width: 8,
            //         height: 8,
            //         decoration: BoxDecoration(
            //           color: Color(0xFFFF4A4A),
            //           shape: BoxShape.circle,
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget buildChatAtText() {
    List<String> noMatchUids = CommonUtil.checkHasNoMatchUids(
        content: content, atUserNameMappingMap: widget.allAtMap);
    return noMatchUids.length > 0
        ? FutureBuilder(
            builder: (context, snapshot) {
              return ChatAtText(
                allAtMap: widget.allAtMap,
                text: CommonUtil.replaceAtMsgIdWithNickName(
                    content: content, atUserNameMappingMap: widget.allAtMap),
                textStyle: widget.contentStyle,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                prefixSpan: _buildImgSpan(widget.contentPrefix),
                patterns: widget.patterns,
                needToTpliceContent: widget.needToTpliceContent,
                senderSpan: widget.isGroupChat == true
                    ? _buildSendernameSpan(widget.senderName)
                    : null,
                faceReplySpan: widget.faceReplySpan,
              );
            },
            future: _replaceUIds(noMatchUids),
            initialData: content,
          )
        : ChatAtText(
            allAtMap: widget.allAtMap,
            text: CommonUtil.replaceAtMsgIdWithNickName(
                content: content, atUserNameMappingMap: widget.allAtMap),
            textStyle: widget.contentStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            prefixSpan: _buildImgSpan(widget.contentPrefix),
            patterns: widget.patterns,
            needToTpliceContent: widget.needToTpliceContent,
            senderSpan: widget.isGroupChat == true
                ? _buildSendernameSpan(widget.senderName)
                : null,
            faceReplySpan: widget.faceReplySpan,
          );
  }

  Future<void> _replaceUIds(List<String> uIds) async {
    var userInfos =
        await OpenIM.iMManager.userManager.getUsersInfo(uidList: uIds);
    for (UserInfo info in userInfos) {
      content = content.replaceAll(" @${info.userID} ", "@${info.nickname!}");
    }
  }
}

class _SlidableAction extends StatelessWidget {
  final SlideItemInfo item;

  const _SlidableAction({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: item.flex,
      child: GestureDetector(
        onTap: () {
          item.onTap?.call();
          Slidable.of(context)?.close();
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: item.boxShadow ??
                [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.5),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  )
                ],
            gradient: LinearGradient(
              colors: item.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            // width: item.width,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              item.text,
              style: item.textStyle,
            ),
          ),
        ),
      ),
    );
  }

  // Here it is!
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

class SlideItemInfo {
  final String text;
  final TextStyle textStyle;
  final Function()? onTap;
  final List<Color> colors;
  final List<BoxShadow>? boxShadow;
  final double? width;
  final int flex;

  SlideItemInfo({
    required this.text,
    required this.colors,
    this.flex = 1,
    this.onTap,
    this.width,
    this.boxShadow,
    this.textStyle = const TextStyle(
      fontSize: 14,
      color: Colors.white,
    ),
  });
}
