import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//edit by wang.haoran at 2022-01-07

enum BubbleType {
  send,
  receiver,
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    this.constraints,
    this.backgroundColor,
    this.child,
    required this.bubbleType,
  }) : super(key: key);
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Widget? child;
  final BubbleType bubbleType;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 0, maxWidth: 270.w),
      //edit by wang.haoran at 2022-01-07
      //调整气泡尺寸
      // margin: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 2.h),
      // padding: EdgeInsets.symmetric(
      //   horizontal: 7.w,
      //   vertical: 7.h,
      // ),
      margin: EdgeInsets.only(right: 10.w, left: 10.w, bottom: 4.h),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 12.h,
      ),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2),
          topRight: Radius.circular(8),
          //edit by wang.haoran at 2022-01-07
          //使气泡只有左侧
          // topLeft: Radius.circular(bubbleType == BubbleType.send ? 8 : 1),
          // topRight: Radius.circular(bubbleType == BubbleType.send ? 1 : 8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: child,
    );
  }
}
