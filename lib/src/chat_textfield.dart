import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class ChatTextField extends StatelessWidget {
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final TextStyle? style;
  final TextStyle? atStyle;
  final TextStyle? atMeStyle;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final bool autofocus;
  const ChatTextField({
    Key? key,
    this.allAtMap = const {},
    this.atCallback,
    this.focusNode,
    this.controller,
    this.onSubmitted,
    this.style,
    this.atStyle,
    this.atMeStyle,
    this.inputFormatters,
    this.hintText,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedTextField(
      keyboardAppearance: Brightness.light,
      textAlignVertical: TextAlignVertical.center,
      style: style,
      specialTextSpanBuilder: MyRegExpSpecialTextSpanBuilder(
        preRegExps: <RegExpSpecialText>[
          RegExpMailText(),
          RegExpDollarText(),
          RegExpAtText(allAtMap: this.allAtMap, atTextStyle: atStyle),
          RegExpEmojiText(),
        ],
      ),
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.multiline,
      autofocus: autofocus,
      minLines: 1,
      maxLines: 5,
      textInputAction: TextInputAction.newline,
      showCursor: true,
      // onSubmitted: onSubmitted,
      decoration: InputDecoration(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintMaxLines: 1,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 16,
          color: Color(0xFF999999),
        ),
      ),
      inputFormatters: inputFormatters,
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
      },
    );
  }
}

class AtTextInputFormatter extends TextInputFormatter {
  final String? Function()? onTap;

  AtTextInputFormatter(this.onTap);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int end = newValue.selection.end;
    int start = oldValue.selection.baseOffset;
    if (oldValue.text.length <= newValue.text.length) {
      var newChar = newValue.text.substring(start, end);
      if (newChar == '@') {
        var result = onTap?.call();
        if (result != null) {
          var v1 = newValue.text.replaceRange(start, end, result);
          var offset = start + result.length;
          return TextEditingValue(
            text: v1,
            selection: TextSelection.collapsed(offset: offset),
          );
        }
      }
    }
    return newValue;
  }
}
