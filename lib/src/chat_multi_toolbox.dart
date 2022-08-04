import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMultiSelToolbox extends StatelessWidget {
  const ChatMultiSelToolbox(
      {Key? key,
      this.onDelete,
      this.onMergeForward,
      this.onForwardOneByOne,
      this.onAddMemo})
      : super(key: key);
  final Function()? onDelete;
  final Function()? onMergeForward;
  final Function()? onForwardOneByOne;
  final Function()? onAddMemo;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 88.h),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      color: Color(0xFFF2F2F2),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onMergeForward,
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 19.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageUtil.assetImage(
                    'msgpopup_btn_sharemore_bg',
                    width: 46.w,
                    height: 46.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    UILocalizations.mergeForward,
                    style: TextStyle(color: Color(0xFF333333), fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onForwardOneByOne,
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 19.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageUtil.assetImage(
                    'msgpopup_btn_share_bg',
                    width: 46.w,
                    height: 46.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    UILocalizations.mergeOneByOne,
                    style: TextStyle(color: Color(0xFF333333), fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
          if (onAddMemo != null)
            GestureDetector(
              onTap: onAddMemo,
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 19.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageUtil.assetImage(
                      'msgpopup_btn_memo_bg',
                      width: 46.w,
                      height: 46.w,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      UILocalizations.addMemo,
                      style:
                          TextStyle(color: Color(0xFF333333), fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
            ),
          GestureDetector(
            onTap: onDelete,
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 19.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageUtil.assetImage(
                    'msgpopup_btn_del_bg',
                    width: 46.w,
                    height: 46.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    UILocalizations.delete,
                    style: TextStyle(color: Color(0xFF333333), fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
