import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatRevokeView extends StatelessWidget {
  ChatRevokeView({Key? key, required this.message, this.onTap})
      : revokedOver2Min =
            ((DateTime.now().millisecondsSinceEpoch - message.sendTime!) >
                    120 * 1000)
                .obs,
        super(key: key);
  final Message message;
  final Function()? onTap;
  var revokedOver2Min = false.obs;
  var timer;

  @override
  Widget build(BuildContext context) {
    // 撤回时间超过两分钟，不允许编辑
    int du = DateTime.now().millisecondsSinceEpoch - message.sendTime!;
    timer = this.revokedOver2Min.value
        ? null
        : Timer(Duration(seconds: 120 - du ~/ 1000), () {
            this.revokedOver2Min.value = true;
            timer.cancel();
          });
    Text text = Text(
      UILocalizations.revokedAMsg,
      style: TextStyle(color: Color(0xFF666666), fontSize: 16.sp),
    );
    return Obx(
      () => revokedOver2Min.value || message.contentType != MessageType.text
          ? text
          : Row(
              children: [
                text,
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    UILocalizations.reEdit,
                    style: TextStyle(color: Color(0xFF006DFA), fontSize: 16.sp),
                  ),
                )
              ],
            ),
    );
  }
}
