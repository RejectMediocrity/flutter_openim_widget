import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// message content: @uid1 @uid2 xxxxxxx
///

enum ChatTextModel { match, normal }

class ChatAtText extends StatelessWidget {
  String text;
  final TextStyle? textStyle;
  final InlineSpan? prefixSpan;

  /// isReceived ? TextAlign.left : TextAlign.right
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double textScaleFactor;

  /// all user info
  /// key:userid
  /// value:username
  final Map<String, String> allAtMap;
  final List<String>? hasReadList;
  final List<MatchPattern> patterns;
  final ChatTextModel model;
  final bool needToTpliceContent;
  final InlineSpan? senderSpan;
  final TextSpan? faceReplySpan;
  // final TextAlign textAlign;
  ChatAtText({
    Key? key,
    required this.text,
    this.allAtMap = const <String, String>{},
    this.prefixSpan,
    this.patterns = const <MatchPattern>[],
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    // this.textAlign = TextAlign.start,
    this.textStyle,
    this.maxLines,
    this.needToTpliceContent = true,
    this.textScaleFactor = 1.0,
    this.model = ChatTextModel.match,
    this.senderSpan,
    this.faceReplySpan,
    this.hasReadList,
  }) : super(key: key);

  static var _textStyle = TextStyle(
    fontSize: 14.sp,
    color: Color(0xFF333333),
  );

  @override
  Widget build(BuildContext context) {
    List<String> uIds = _checkAtMatch();
    if (uIds.isNotEmpty) {
      return FutureBuilder(
        future: _replaceUIds(uIds),
        initialData: text,
        builder: (context, snapShort) {
          return _buildView();
        },
      );
    } else {
      return _buildView();
    }
  }

  _buildView() {
    final List<InlineSpan> children = <InlineSpan>[];
    if (faceReplySpan != null) {
      children.add(faceReplySpan!);
    }
    if (prefixSpan != null) {
      children.add(prefixSpan!);
    }
    if (senderSpan != null) {
      children.add(senderSpan!);
    }
    if (model == ChatTextModel.normal) {
      _normalModel(children);
    } else {
      _matchModel(children);
    }

    return Container(
      constraints: BoxConstraints(maxWidth: 0.65.sw),
      child: RichText(
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        textScaleFactor: textScaleFactor,
        text: TextSpan(children: children),
      ),
    );
  }

  _checkAtMatch() {
    final atReg = RegExp('$regexAt');
    List<RegExpMatch> match = atReg.allMatches(text).toList();
    List<String> uIds = [];
    match.forEach((element) {
      String des = element.group(0)!;
      String uid = des.replaceFirst("@", "").trim();
      if (!allAtMap.containsKey(uid)) {
        uIds.add(uid);
      }
    });
    return uIds;
  }

  Future<String> _replaceUIds(List<String> uIds) async {
    var userInfos =
        await OpenIM.iMManager.userManager.getUsersInfo(uidList: uIds);
    for (UserInfo info in userInfos) {
      text = text.replaceAll(" @${info.userID} ", "@${info.nickname!}");
    }
    return text;
  }

  _normalModel(List<InlineSpan> children) {
    var style = textStyle ?? _textStyle;
    children.add(TextSpan(text: text, style: style));
  }

  _matchModel(List<InlineSpan> children) {
    var style = textStyle ?? _textStyle;

    final _mapping = Map<String, MatchPattern>();

    patterns.forEach((e) {
      if (e.type == PatternType.AT) {
        _mapping[regexAt] = e;
      } else if (e.type == PatternType.ATME) {
        _mapping[regexAtMe] = e;
      } else if (e.type == PatternType.EMAIL) {
        _mapping[regexEmail] = e;
      } else if (e.type == PatternType.MOBILE) {
        _mapping[regexMobile] = e;
      } else if (e.type == PatternType.TEL) {
        _mapping[regexTel] = e;
      } else if (e.type == PatternType.URL) {
        _mapping[regexUrl] = e;
      } else {
        _mapping[e.pattern!] = e;
      }
    });

    var regexEmoji = emojiFaces.keys
        .toList()
        .join('|')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]');

    _mapping[regexEmoji] = MatchPattern(type: PatternType.EMOJI);

    final pattern;

    if (_mapping.length > 1) {
      pattern = '(${_mapping.keys.toList().join('|')})';
    } else {
      pattern = regexEmoji;
    }

    // match  text
    text.splitMapJoin(
      RegExp(pattern),
      onMatch: (Match match) {
        var matchText = match[0]!;
        var value = matchText;
        var inlineSpan;
        final mapping = _mapping[matchText] ??
            _mapping[_mapping.keys.firstWhere((element) {
              final reg = RegExp(element);
              return reg.hasMatch(matchText);
            }, orElse: () {
              return '';
            })];
        if (mapping != null) {
          if (mapping.type == PatternType.AT) {
            String uid = matchText.replaceFirst("@", "").trim();
            value = uid;
            if (allAtMap.containsKey(uid)) {
              bool? hasRead = hasReadList?.contains(uid);
              matchText = '@${allAtMap[uid]!}';
              inlineSpan = ExtendedWidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () => mapping.onTap!(
                      _getUrl(value, mapping.type), mapping.type),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$matchText',
                        style: mapping.style != null ? mapping.style : style,
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 2.w, right: 4.w, top: 4.w),
                        child: ImageUtil.assetImage(
                            hasRead == true ? "read_green" : "read_gray",
                            width: 6.w,
                            height: 6.w),
                      ),
                    ],
                  ),
                ),
                style: _mapping[regexAt]?.style,
                actualText: '$value',
                start: match.start,
              );
            }
          } else if (mapping.type == PatternType.ATME) {
            String uid = matchText.replaceFirst("@", "").trim();
            value = uid;
            if (allAtMap.containsKey(uid)) {
              matchText = '@${allAtMap[uid]!} ';
              inlineSpan = ExtendedWidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 5, 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF006DFA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(11.w),
                      ),
                    ),
                    child: Text(
                      '$matchText',
                      style: _mapping[regexAtMe]?.style,
                    ),
                  ),
                ),
                style: _mapping[regexAtMe]?.style,
                actualText: '$value',
                start: match.start,
              );
            }
          } else if (mapping.type == PatternType.EMOJI) {
            var size = textStyle?.fontSize ?? 14.w;
            inlineSpan = ImageSpan(ImageUtil.emojiImage(matchText),
                imageWidth: size + 4,
                imageHeight: size + 4,
                margin: EdgeInsets.symmetric(horizontal: 1));
          } else {
            inlineSpan = TextSpan(
              text: "$matchText",
              style: mapping.style != null ? mapping.style : style,
              recognizer: mapping.onTap == null
                  ? null
                  : (TapGestureRecognizer()
                    ..onTap = () => mapping.onTap!(
                        _getUrl(value, mapping.type), mapping.type)),
            );
          }
        } else {
          inlineSpan = TextSpan(text: "$matchText", style: style);
        }
        if (inlineSpan != null) {
          children.add(inlineSpan);
          children.add(
            TextSpan(text: "\u200B"),
          );
        }
        return '';
      },
      onNonMatch: (text) {
        text = CommonUtil.breakWord(text);
        print("$text");
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );
  }

  _getUrl(String text, PatternType type) {
    switch (type) {
      case PatternType.URL:
        return text.substring(0, 4) == 'http' ? text : 'http://$text';
      case PatternType.EMAIL:
        return text.substring(0, 7) == 'mailto:' ? text : 'mailto:$text';
      case PatternType.TEL:
      case PatternType.MOBILE:
        return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
      // case PatternType.PHONE:
      //   return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
      default:
        return text;
    }
  }
}

class MatchPattern {
  PatternType type;

  String? pattern;

  TextStyle? style;

  Function(String link, PatternType? type)? onTap;

  MatchPattern({required this.type, this.pattern, this.style, this.onTap});
}

enum PatternType { AT, EMAIL, MOBILE, TEL, URL, EMOJI, CUSTOM, ATME }

/// 空格@uid空格

String uid = OpenIM.iMManager.uid;
final regexAt = "\\s@(?!$uid)\\S+\\s";
final regexAtMe = "\\s@(?=$uid)\\S+\\s";

/// Email Regex - A predefined type for handling email matching
const regexEmail = r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b";

/// URL Regex - A predefined type for handling URL matching
const regexUrl =
    r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=%]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=%$]*)";

/// Phone Regex - A predefined type for handling phone matching
// const regexMobile =
//     r"(\+?( |-|\.)?\d{1,2}( |-|\.)?)?(\(?\d{3}\)?|\d{3})( |-|\.)?(\d{3}( |-|\.)?\d{4})";

/// Regex of exact mobile.
const String regexMobile =
    '^(\\+?86)?((13[0-9])|(14[57])|(15[0-35-9])|(16[2567])|(17[01235-8])|(18[0-9])|(19[1589]))\\d{8}\$';

/// Regex of telephone number.
const String regexTel = '^0\\d{2,3}[-]?\\d{7,8}';
