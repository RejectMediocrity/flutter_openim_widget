import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMergeMsgView extends StatelessWidget {
  const ChatMergeMsgView(
      {Key? key, required this.title, required this.summaryList})
      : super(key: key);
  final String title;
  final List<String> summaryList;

  List<Widget> _children() {
    var list = <Widget>[];
    list
      ..add(
        Row(
          children: [
            Container(
              width: 2.w,
              height: 16.w,
              color: Color(0xFF006DFA),
            ),
            SizedBox(
              width: 4.w,
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    for (var s in summaryList) {
      if (summaryList.length > 4 && summaryList.elementAt(4) == s) {
        break;
      }
      Map? map;
      try {
        map = json.decode(s);
      } catch (e) {}
      if (map != null) {
        String content = '';
        try {
          if (map["content"] is Map) {
            content = json.encode(map["content"]);
          } else {
            content = map["content"];
          }
        } catch (e) {
          
        }

        String name = map["name"] ?? '';
        list.add(
          Text(
            "$name:$content".trim(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16.sp,
            ),
          ),
        );
      } else {
        list.add(
          Text(
            s.trim(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 16.sp,
            ),
          ),
        );
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 0.65.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: _children(),
      ),
    );
  }
}
