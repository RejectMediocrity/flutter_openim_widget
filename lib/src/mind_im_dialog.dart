import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class MindIMDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final Widget? cancelWidget;
  final Widget? sureWidget;
  final String? sureText;
  final String? cancelText;
  final Function()? onTapSure;
  final Function()? onTapCancel;
  final TipType tipType;

  MindIMDialog({
    this.content,
    this.title,
    this.onTapCancel,
    this.onTapSure,
    this.cancelWidget,
    this.sureWidget,
    this.sureText,
    this.cancelText,
    this.tipType = TipType.Confirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Color(0x00000000),
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtil.instance.isPadOrTablet ? 328.w : 28.w,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 32.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (title != null)
                    DefaultTextStyle(
                      child: title!,
                      style: ts_333333_16sp_w600,
                      textAlign: TextAlign.center,
                    ),
                  if (content != null) ...[
                    if (title != null)
                      SizedBox(
                        height: 8.w,
                      ),
                    DefaultTextStyle(
                      child: content!,
                      style:
                          title == null ? ts_333333_16sp_w600 : ts_333333_16sp,
                      textAlign: TextAlign.center,
                    ),
                  ],
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
                tipType == TipType.NoneCancelBtn
                    ? Container()
                    : Expanded(
                        flex: 1,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (onTapCancel != null) {
                              onTapCancel?.call();
                            } else {
                              Navigator.of(context).pop(false);
                            }
                          },
                          child: cancelWidget ??
                              CupertinoDialogAction(
                                child: Text(
                                  cancelText ?? "取消",
                                  style: ts_333333_16sp,
                                ),
                                onPressed: () {
                                  if (onTapCancel != null) {
                                    onTapCancel?.call();
                                  } else {
                                    Navigator.of(context).pop(false);
                                  }
                                },
                              ),
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
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: sureWidget ??
                        CupertinoDialogAction(
                          child: Text(
                            sureText ?? "确定",
                            style: getSureTextStyle(tipType),
                          ),
                          onPressed: () {
                            if (onTapSure != null) {
                              onTapSure?.call();
                            } else {
                              Navigator.of(context).pop(true);
                            }
                          },
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextStyle getSureTextStyle(TipType tipType) {
    if (tipType == TipType.Delete) {
      return ts_FF4A4A_16sp;
    }
    return ts_006DFA_16sp_w400;
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
  static var ts_FF4A4A_16sp = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFFFF4A4A),
  );
  static var ts_FF4A4A_16sp_w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFF4A4A),
  );
}

enum TipType {
  Alert,
  Delete,
  Confirm,
  NoneCancelBtn,
}
