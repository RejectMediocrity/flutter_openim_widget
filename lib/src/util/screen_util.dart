
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_openim_widget/src/util/device_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenUtilSizeExtension on num {
  ///[ScreenUtil.setWidth]
  double get w => DeviceUtil.instance.isPadOrTablet ? ScreenUtil().setHeight(this) : ScreenUtil().setWidth(this);

  ///[ScreenUtil.setHeight]
  double get h => ScreenUtil().setHeight(this);

  ///[ScreenUtil.radius]
  double get r => ScreenUtil().radius(this);

  ///[ScreenUtil.setSp]
  double get sp => DeviceUtil.instance.isPadOrTablet ? (min(toDouble(), ScreenUtil().setSp(this)) + 3.0) : ScreenUtil().setSp(this);

  ///smart size :  it check your value - if it is bigger than your value it will set your value
  ///for example, you have set 16.sm() , if for your screen 16.sp() is bigger than 16 , then it will set 16 not 16.sp()
  ///I think that it is good for save size balance on big sizes of screen
  double get sm => min(toDouble(), sp);

  ///屏幕宽度的倍数
  ///Multiple of screen width
  double get sw => ScreenUtil().screenWidth * this;

  ///屏幕高度的倍数
  ///Multiple of screen height
  double get sh => ScreenUtil().screenHeight * this;

  ///[ScreenUtil.setHeight]
  Widget get verticalSpace => ScreenUtil().setVerticalSpacing(this);

  ///[ScreenUtil.setVerticalSpacingFromWidth]
  Widget get verticalSpaceFromWidth =>
      ScreenUtil().setVerticalSpacingFromWidth(this);

  ///[ScreenUtil.setWidth]
  Widget get horizontalSpace => ScreenUtil().setHorizontalSpacing(this);

  ///[ScreenUtil.radius]
  Widget get horizontalSpaceRadius =>
      ScreenUtil().setHorizontalSpacingRadius(this);

  ///[ScreenUtil.radius]
  Widget get verticalSpacingRadius =>
      ScreenUtil().setVerticalSpacingRadius(this);
}

// extension ScreenUtilEdgeInsetsExtension on EdgeInsets {
//   /// Creates adapt insets using r [SizeExtension].
//   EdgeInsets get r => copyWith(
//         top: top.r,
//         bottom: bottom.r,
//         right: right.r,
//         left: left.r,
//       );
// }

// extension ScreenUtilBorderRaduisExtension on BorderRadius {
//   /// Creates adapt BorderRadius using r [SizeExtension].
//   BorderRadius get r => copyWith(
//         bottomLeft: bottomLeft.r,
//         bottomRight: bottomRight.r,
//         topLeft: topLeft.r,
//         topRight: topRight.r,
//       );
// }

// extension ScreenUtilRaduisExtension on Radius {
//   /// Creates adapt Radius using r [SizeExtension].
//   Radius get r => Radius.elliptical(x.r, y.r);
// }

// extension ScreenUtilBoxConstraintsExtension on BoxConstraints {
//   /// Creates adapt BoxConstraints using r [SizeExtension].
//   BoxConstraints get r => this.copyWith(
//         maxHeight: maxHeight.r,
//         maxWidth: maxWidth.r,
//         minHeight: minHeight.r,
//         minWidth: minWidth.r,
//       );

//   /// Creates adapt BoxConstraints using h-w [SizeExtension].
//   BoxConstraints get hw => this.copyWith(
//         maxHeight: maxHeight.h,
//         maxWidth: maxWidth.w,
//         minHeight: minHeight.h,
//         minWidth: minWidth.w,
//       );
// }