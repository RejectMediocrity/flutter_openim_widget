import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/revoke_message_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRevokeView extends StatefulWidget {
  ChatRevokeView({Key? key, required this.message, this.onTap})
      : super(key: key);
  final Message message;
  final Function()? onTap;

  @override
  State<ChatRevokeView> createState() => _ChatRevokeViewState();
}

class _ChatRevokeViewState extends State<ChatRevokeView> {
  var timer;
  var revokedOver2Min;
  @override
  void initState() {
    // 撤回时间超过两分钟，不允许编辑
    revokedOver2Min = !RevokeMessageHelper().canEdit(widget.message);
    if (!revokedOver2Min) {
      int duration = 120 -
          (DateTime.now().millisecondsSinceEpoch -
                  RevokeMessageHelper().createTime(widget.message)) ~/
              1000;
      Future.delayed(
          Duration(
            seconds: duration,
          ), () {
        setState(() {
          this.revokedOver2Min = true;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Text text = Text(
      UILocalizations.revokedAMsg,
      style: TextStyle(color: Color(0xFF666666), fontSize: 16.sp),
    );
    return revokedOver2Min
        ? text
        : Row(
            children: [
              text,
              SizedBox(
                width: 5.w,
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  UILocalizations.reEdit,
                  style: TextStyle(color: Color(0xFF006DFA), fontSize: 16.sp),
                ),
              )
            ],
          );
  }
}
