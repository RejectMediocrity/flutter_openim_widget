import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq_badge/qq_badge.dart';

class UnreadCountView extends StatelessWidget {
  final Color color;
  final double size;
  final Stream<int>? steam;
  final int? count;
  final bool qqBadge;
  final String maxBadge = '99';
  final bool isShowCountText;

  const UnreadCountView({
    Key? key,
    this.steam,
    this.color = const Color(0xFFFF4A4A),
    this.size = 18,
    this.count = 0,
    this.qqBadge = false,
    this.isShowCountText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (null == steam) {
      return _buildChild(count: count ?? 0);
    }
    return StreamBuilder(
      stream: steam,
      builder: (_, AsyncSnapshot<int> hot) => Visibility(
        visible: (hot.data ?? 0) > 0,
        child: qqBadge
            ? Container(
                width: size,
                height: size,
                child: QqBadge(
                  text: isShowCountText
                      ? '${(hot.data ?? 0) > 99 ? maxBadge : hot.data}'
                      : '',
                  radius: size / 2,
                  textStyle: TextStyle(
                    fontSize: 8.sp,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              )
            : Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isShowCountText
                      ? '${(hot.data ?? 0) > 99 ? maxBadge : hot.data}'
                      : '',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildChild({required int count}) => Visibility(
        visible: count > 0,
        child: qqBadge
            ? Container(
                width: size,
                height: size,
                child: QqBadge(
                  text:
                      isShowCountText ? '${count > 99 ? maxBadge : count}' : '',
                  radius: size / 2,
                  textStyle: TextStyle(
                    fontSize: 8.sp,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              )
            : Container(
                width: size,
                height: size,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  isShowCountText ? '${count > 99 ? maxBadge : count}' : '',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
      );
}
