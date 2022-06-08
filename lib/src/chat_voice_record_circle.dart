import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatVoiceRecordCircle extends StatefulWidget {
  const ChatVoiceRecordCircle({
    Key? key,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onLongPressMoveUpdate,
    required this.onTap,
    this.backgroundColor,
  }) : super(key: key);
  final Function(LongPressStartDetails details) onLongPressStart;
  final Function(LongPressEndDetails details) onLongPressEnd;
  final Function(LongPressMoveUpdateDetails details) onLongPressMoveUpdate;
  final Function() onTap;
  final Color? backgroundColor;

  @override
  _ChatVoiceRecordCircleState createState() => _ChatVoiceRecordCircleState();
}

class _ChatVoiceRecordCircleState extends State<ChatVoiceRecordCircle> {
  bool _pressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap(),
      onLongPressStart: (details) {
        widget.onLongPressStart(details);
        setState(() {
          _pressing = true;
        });
      },
      onLongPressEnd: (details) {
        widget.onLongPressEnd(details);
        setState(() {
          _pressing = false;
        });
      },
      onLongPressMoveUpdate: (details) {
        widget.onLongPressMoveUpdate(details);
        // Offset global = details.globalPosition;
        // Offset local = details.localPosition;
        // print('global:$global');
        // print('local:$local');
      },
      child: Stack(
        children: [
          Container(
            // constraints: BoxConstraints(minHeight: 40.h),
            width: 120.h,
            height: 120.h,
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? Color(0xFF006DFA),
              shape: BoxShape.circle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageUtil.assetImage("ic_inputbox_but_recording_solid",
                    width: 24.w, height: 24.w),
                SizedBox(height: 18.w,),
                Text(
                  _pressing
                      ? UILocalizations.releaseSend
                      : UILocalizations.pressSpeak,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFFFFFFFF),
                  ),
                )
              ],
            ),
          ),
          if (_pressing)
            Container(
              // constraints: BoxConstraints(minHeight: 40.h),
              width: 120.h,
              height: 120.h,
              decoration: BoxDecoration(
                // color: Color(0xFF006DFA).withOpacity(_pressing ? 0.3 : 1),
                color: Color(0xFF000000).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
