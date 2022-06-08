import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MindIMDialog extends StatelessWidget {
  final Widget? title;
  final Widget content;
  final Widget? cancelWidget;
  final Widget? sureWidget;
  final Function()? onTapSure;
  final Function()? onTapCancel;
  MindIMDialog({
    required this.content,
    this.title,
    this.onTapCancel,
    this.onTapSure,
    this.cancelWidget,
    this.sureWidget,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Color(0x00000000),
      padding: EdgeInsets.symmetric(
        horizontal: 28.w,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (title != null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.w),
                      child: DefaultTextStyle(
                        child: title!,
                        style: ts_333333_16sp_w600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (content != null)
                    Padding(
                      padding: EdgeInsets.only(top: title != null ?  0: 8.w, bottom: 8.w),
                      child: DefaultTextStyle(
                        child: content,
                        style: ts_333333_16sp,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),

            Container(
              color: Color(0xFFDDDDDD),
              height: .5.w,
              // width: 300.w,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (cancelWidget != null)
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (onTapCancel != null) {
                          onTapCancel?.call();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: cancelWidget,
                    ),
                  ),
                Container(
                  color: Color(0xFFE7E7E7),
                  height: 56.w,
                  width: .5.w,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (onTapSure != null) {
                        onTapSure?.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: sureWidget,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  static var ts_006DFA_16sp_w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFF006DFA),
  );

  static var ts_333333_16sp = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFF333333),
  );

  static var ts_333333_16sp_w600 = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFF333333),
    fontWeight: FontWeight.w600,
  );

  static var ts_ED4040_16sp = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFFED4040),
  );
  static var ts_FF4A4A_16sp_w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Color(0xFFFF4A4A),
  );
}
