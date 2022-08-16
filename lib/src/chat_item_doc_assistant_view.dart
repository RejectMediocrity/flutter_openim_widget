import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/model/chat_doc_assistant_model.dart';

class ChatItemDocAssistantView extends StatelessWidget {
  final ChatDocAssistantModel assistantModel;
  final Function(String userId)? onTapDocOperator;
  final Function(
      {String? padUrl,
      String? code,
      bool? isFolder,
      int? type,
      String? title})? onTapDocUrl;
  ChatItemDocAssistantView(
    this.assistantModel, {
    this.onTapDocOperator,
    this.onTapDocUrl,
  });

  List<InlineSpan> createRichText() {
    String des = assistantModel.textDescribe ?? "";

    RegExp match1 = RegExp("{to_im_user_name}");
    RegExp match2 = RegExp("{title}");

    String replace1 = "@${assistantModel.params?.toImUserName ?? ""}";
    String replace2 = "${assistantModel.params?.title ?? ""}";

    int start1 = des.indexOf(match1);
    int start2 = des.indexOf(match2);

    String pre = des.substring(0, start1);
    String middle = des.substring(match1.pattern.length + start1, start2);
    String end = des.substring(start2 + match2.pattern.length, des.length);
    List<InlineSpan> children = [
      TextSpan(
        text: pre,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 14.sp,
        ),
      ),
      ExtendedWidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: () {
            if (onTapDocOperator != null)
              onTapDocOperator!(assistantModel.params?.toImUserId ?? "");
          },
          child: Text(
            replace1,
            style: TextStyle(
              color: Color(0xFF006DFA),
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
      TextSpan(
        text: middle,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 14.sp,
        ),
      ),
      ExtendedWidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: () {
            if (onTapDocUrl != null) {
              onTapDocUrl!(
                padUrl: assistantModel.params?.toUrl,
                code: assistantModel.params?.folderCode,
                type: assistantModel.params?.type,
                isFolder: assistantModel.params?.noticeType == "folder",
                title: assistantModel.params?.title,
              );
            }
          },
          child: Text(
            replace2,
            style: TextStyle(
              color: Color(0xFF006DFA),
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
      TextSpan(
        text: end,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 14.sp,
        ),
      ),
    ];
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.w,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.w),
        border: Border.all(
          color: Color(0xFFDDDDDD),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            assistantModel.action ?? "",
            style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8.w,
          ),
          RichText(
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
            text: TextSpan(children: createRichText()),
          )
        ],
      ),
    );
  }
}
