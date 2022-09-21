import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class CheckExceedMaxLines {
  static bool didExceedMaxLines({
    required String text,
    TextStyle? textStyle,
    List<MatchPattern>? patterns,
    Map<String, String>? allAtMap,
    List<String>? hasReadList,
    bool? isSender,
  }) {
    List<InlineSpan> children = [];
    final _mapping = Map<String, MatchPattern>();
    patterns?.forEach((e) {
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
            if (allAtMap?.containsKey(uid) == true) {
              bool? hasRead = hasReadList?.contains(uid);
              matchText = isSender == true
                  ? '@${allAtMap?[uid]!}'
                  : '@${allAtMap?[uid]!} ';
              inlineSpan = WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () =>
                      mapping.onTap!(getUrl(value, mapping.type), mapping.type),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: .6.sw),
                        child: Text(
                          '$matchText',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              mapping.style != null ? mapping.style : textStyle,
                        ),
                      ),
                      (uid == "all" || isSender == false)
                          ? Container()
                          : Container(
                              padding: EdgeInsets.only(
                                  left: 2.w, right: 4.w, top: 4.w),
                              child: ImageUtil.assetImage(
                                  hasRead == true ? "read_green" : "read_gray",
                                  width: 6.w,
                                  height: 6.w),
                            ),
                    ],
                  ),
                ),
                style: _mapping[regexAt]?.style,
              );
            } else {
              inlineSpan = TextSpan(
                text: "$matchText",
                style: textStyle,
              );
            }
          } else if (mapping.type == PatternType.ATME) {
            String uid = matchText.replaceFirst("@", "").trim();
            value = uid;
            if (allAtMap?.containsKey(uid) == true) {
              matchText = '@${allAtMap?[uid]!} ';
              inlineSpan = WidgetSpan(
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
              style: mapping.style != null ? mapping.style : textStyle,
              recognizer: mapping.onTap == null
                  ? null
                  : (TapGestureRecognizer()
                    ..onTap = () => mapping.onTap!(
                        getUrl(value, mapping.type), mapping.type)),
            );
          }
        } else {
          inlineSpan = TextSpan(text: "$matchText", style: textStyle);
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
        children.add(TextSpan(text: text, style: textStyle));
        return '';
      },
    );
    TextSpan span = TextSpan(children: children);
    TextPainter tp =
        TextPainter(text: span, maxLines: 10, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: .65.sw);
    return tp.didExceedMaxLines;
  }

  static getUrl(String text, PatternType type) {
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
