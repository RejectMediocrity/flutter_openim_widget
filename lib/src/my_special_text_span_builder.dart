import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../flutter_openim_widget.dart';

/// author: dongjunjie
/// created on: 2022/8/24 10:38
/// description:

class EmojiUitl {
  EmojiUitl._() {
    emojiFaces.forEach((key, value) => _emojiMap[key] = value);
  }

  final Map<String, String> _emojiMap = <String, String>{};

  Map<String, String> get emojiMap => _emojiMap;

  final String _emojiFilePath = 'assets';

  static EmojiUitl? _instance;
  static EmojiUitl get instance => _instance ??= EmojiUitl._();
}

class MyRegExpSpecialTextSpanBuilder extends RegExpSpecialTextSpanBuilder {
  final List<RegExpSpecialText> preRegExps;
  MyRegExpSpecialTextSpanBuilder({required this.preRegExps});
  @override
  List<RegExpSpecialText> get regExps => this.preRegExps;
}

class RegExpDollarText extends RegExpSpecialText {
  @override
  RegExp get regExp => RegExp(r'\$(.+)\$');

  @override
  InlineSpan finishText(int start, Match match,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    textStyle = textStyle?.copyWith(color: Colors.orange, fontSize: 16.0);

    final String value = '${match[0]}';

    return SpecialTextSpan(
      text: value.replaceAll('\$', ''),
      actualText: value,
      start: start,
      style: textStyle,
      recognizer: onTap != null
          ? (TapGestureRecognizer()
            ..onTap = () {
              onTap(value);
            })
          : null,
      mouseCursor: SystemMouseCursors.text,
      onEnter: (PointerEnterEvent event) {
        print(event);
      },
      onExit: (PointerExitEvent event) {
        print(event);
      },
    );
  }
}

class RegExpAtText extends RegExpSpecialText {
  final Map<String, String> allAtMap;
  final TextStyle? atTextStyle;
  RegExpAtText({required this.allAtMap, this.atTextStyle});
  @override
  RegExp get regExp => RegExp('$regexAt|$regexAtMe');

  @override
  InlineSpan finishText(int start, Match match,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    textStyle = atTextStyle ??
        textStyle?.copyWith(color: Color(0xFF006DFA), fontSize: 16.0);

    final String value = '${match[0]}';
    String id = value.replaceFirst("@", " ").trim();
    var name = value;
    if (allAtMap.containsKey(id)) {
      name = allAtMap[id]!;
    }
    return SpecialTextSpan(
      text: '@$name ',
      actualText: '$value',
      start: start,
      style: textStyle,
      recognizer: onTap != null
          ? (TapGestureRecognizer()
            ..onTap = () {
              onTap(value);
            })
          : null,
      mouseCursor: SystemMouseCursors.text,
      onEnter: (PointerEnterEvent event) {
        print(event);
      },
      onExit: (PointerExitEvent event) {
        print(event);
      },
    );
  }
}

class RegExpEmojiText extends RegExpSpecialText {
  @override
  RegExp get regExp {
    var regexEmoji = emojiFaces.keys
        .toList()
        .join('|')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]');
    return RegExp(regexEmoji);
  }

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    final String key = match.input.substring(match.start, match.end);

    /// widget span is not working on web
    if (EmojiUitl.instance.emojiMap.containsKey(key)) {
      //fontsize id define image height
      //size = 30.0/26.0 * fontSize
      const double size = 20.0;

      ///fontSize 26 and text height =30.0
      //final double fontSize = 26.0;
      return ImageSpan(
        ImageUtil.emojiImage(key),
        actualText: key,
        imageWidth: size,
        imageHeight: size,
        start: start,
        fit: BoxFit.fill,
        margin: const EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0),
        alignment: PlaceholderAlignment.middle,
      );
    }

    return TextSpan(text: toString(), style: textStyle);
  }
}

class RegExpMailText extends RegExpSpecialText {
  final TextStyle? mailTextStyle;

  RegExpMailText({
    this.mailTextStyle,
  });

  @override
  RegExp get regExp => RegExp(regexEmail);
  @override
  InlineSpan finishText(int start, Match match,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    textStyle = mailTextStyle ??
        textStyle?.copyWith(color: Colors.lightBlue, fontSize: 16.0);

    final String value = '${match[0]}';

    return ExtendedWidgetSpan(
      child: GestureDetector(
          child: const Icon(
            Icons.email,
            size: 16,
          ),
          onTap: () {
            if (onTap != null) {
              onTap(value);
            }
          }),
      actualText: value,
      start: start,
      style: textStyle,
    );
  }
}
