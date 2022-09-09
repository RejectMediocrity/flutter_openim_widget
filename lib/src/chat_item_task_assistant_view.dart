import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/model/task_assistant_model.dart';

class ChatItemTaskAssistantView extends StatelessWidget {
  final TaskAssistantModel assistantModel;
  final Function(String userId)? onTapDocOperator;
  ChatItemTaskAssistantView(
    this.assistantModel, {
    this.onTapDocOperator,
  });

  List<InlineSpan> createRichText() {
    String part1 = assistantModel.userName ?? "";
    String part2 = assistantModel.type != 3 ? "已将你设置成为" : "负责的任务";
    String part3 = assistantModel.sourceName ?? "";
    String part4 = assistantModel.type == 1
        ? "的任务执行人"
        : assistantModel.type == 2
            ? "的目标负责人"
            : "即将在${assistantModel.expire_time}之后到期";

    List<InlineSpan> children = [
      ExtendedWidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: () {
            if (onTapDocOperator != null)
              onTapDocOperator!(assistantModel.imUserId ?? "");
          },
          child: Text(
            part1,
            style: TextStyle(
              color: Color(0xFF006DFA),
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
      TextSpan(
        text: part2,
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 14.sp,
        ),
      ),
      TextSpan(
        text: part3,
        style: TextStyle(
          color: Color(0xFF006DFA),
          fontSize: 14.sp,
        ),
      ),
      TextSpan(
        text: part4,
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
            assistantModel.title ?? "",
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
