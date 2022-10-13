import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/revoke_message_helper.dart';
import 'package:sprintf/sprintf.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef OnTapRevokerCallback = Function(String uid);

class ChatRevokeView extends StatefulWidget {
  ChatRevokeView(
      {Key? key, required this.message, this.onTap, this.onTapRevokerCallback})
      : super(key: key);
  final Message message;
  final Function()? onTap;
  final OnTapRevokerCallback? onTapRevokerCallback;

  @override
  State<ChatRevokeView> createState() => _ChatRevokeViewState();
}

class _ChatRevokeViewState extends State<ChatRevokeView> {
  var timer;
  var revokedOver2Min;
  var revokedInfoMap;
  var revokerRoleLevel;
  String? revokerInfoStr;
  @override
  void initState() {
    // 撤回时间超过两分钟，不允许编辑
    if (RevokeMessageHelper().canEdit(widget.message)) {
      revokedOver2Min = false;
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
    } else {
      revokedOver2Min = true;
    }
    if (widget.message.contentType == MessageType.advancedRevoke) {
      if (widget.message.ex!.length > 0) {
        revokedInfoMap = json.decode(widget.message.ex!);
      } else if (widget.message.content!.length > 0) {
        RevokedInfo revokedInfo =
            RevokedInfo.fromJson(json.decode(widget.message.content!));
        revokedInfoMap = {
          "revoke_role": revokedInfo.revokerRole,
          "revoke_user_name": revokedInfo.revokerNickname,
          "revoke_user_id": revokedInfo.revokerID
        };
      } else {
        revokedInfoMap = {
          "revoke_role": 0,
        };
      }
      revokerRoleLevel = revokedInfoMap['revoke_role'];
      if (revokerRoleLevel == 2) {
        revokerInfoStr = sprintf(UILocalizations.revokedAMsgByOwner,
            ['@${revokedInfoMap['revoke_user_name']}']);
      } else if (revokerRoleLevel == 3) {
        revokerInfoStr = sprintf(UILocalizations.revokedAMsgByManager,
            ['@${revokedInfoMap['revoke_user_name']}']);
      } else {
        revokerInfoStr = UILocalizations.revokedAMsg;
      }
    } else {
      revokerInfoStr = UILocalizations.revokedAMsg;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var revokerInfoStrSegments = revokerInfoStr?.split(' ');
    // Text text = Text(
    //   revokerInfoStr ?? UILocalizations.revokedAMsg,
    //   style: TextStyle(color: Color(0xFF666666), fontSize: 15.sp),
    // );

    Widget textWidget;

    if (revokerInfoStrSegments != null && revokerInfoStrSegments.length > 1) {
      if (OpenIM.iMManager.uid == revokedInfoMap['revoke_user_id']) {
        textWidget = Row(
          children: [
            Text(
              revokerInfoStrSegments.first + ' ',
              style: TextStyle(color: Color(0xFF666666), fontSize: 15.sp),
            ),
            InkWell(
              onTap: () {
                widget.onTapRevokerCallback
                    ?.call(revokedInfoMap['revoke_user_id']);
              },
              child: Container(
                height: 20.w,
                decoration: BoxDecoration(
                  color: Color(0xFF006DFA),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: Center(
                  child: Text(
                    '  ${revokerInfoStrSegments.elementAt(1)}  ',
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                    strutStyle: StrutStyle(
                      fontSize: 15.sp,
                      leading: 0,
                      height: 1.1,
                      // 1.1更居中
                      forceStrutHeight: true, // 关键属性 强制改为文字高度
                    ),
                  ),
                ),
              ),
            ),
            Text(
              ' ' + revokerInfoStrSegments.last,
              style: TextStyle(color: Color(0xFF666666), fontSize: 15.sp),
            ),
          ],
        );
      } else {
        textWidget = RichText(
          text: TextSpan(
            text: revokerInfoStrSegments.first,
            style: TextStyle(color: Color(0xFF666666), fontSize: 15.sp),
            children: [
              TextSpan(
                text: ' ${revokerInfoStrSegments.elementAt(1)} ',
                style: TextStyle(
                    color: Color(0xFF006DFA),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    widget.onTapRevokerCallback
                        ?.call(revokedInfoMap['revoke_user_id']);
                  },
              ),
              TextSpan(
                text: revokerInfoStrSegments.last,
                style: TextStyle(color: Color(0xFF666666), fontSize: 15.sp),
              ),
            ],
          ),
        );
      }
    } else {
      textWidget = RichText(
        text: TextSpan(
          text: revokerInfoStr ?? UILocalizations.revokedAMsg,
          style: TextStyle(color: Color(0xFF666666), fontSize: 15.sp),
        ),
      );
    }

    return revokedOver2Min
        ? textWidget
        : Row(
            children: [
              Text(
                revokerInfoStr ?? UILocalizations.revokedAMsg,
                style: TextStyle(color: Color(0xFF666666), fontSize: 15.sp),
              ),
              SizedBox(
                width: 5.w,
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  UILocalizations.reEdit,
                  style: TextStyle(
                      color: Color(0xFF006DFA),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          );
  }
}
