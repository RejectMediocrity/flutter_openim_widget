import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircularProgress extends StatefulWidget {
  final double size;
  final Color activeColor;
  final Color backColor;
  final double progress;
  CustomCircularProgress({
    required this.size,
    required this.activeColor,
    required this.backColor,
    required this.progress,
  });
  @override
  State<StatefulWidget> createState() {
    return CustomCircularProgressState();
  }
}

class CustomCircularProgressState extends State<CustomCircularProgress>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: widget.size,
        height: widget.size,
        child: RotatedBox(
          quarterTurns: 135,
          child: CustomPaint(
            painter: MyPainter(
                size: widget.size,
                activeColor: widget.activeColor,
                backColor: widget.backColor,
                progress: widget.progress),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class MyPainter extends CustomPainter {
  final double size;
  final Color activeColor;
  final Color backColor;
  final double progress;
  MyPainter(
      {required this.size,
      required this.activeColor,
      required this.backColor,
      required this.progress});

  @override
  void paint(Canvas canvas, Size pSize) {
    var paint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.w;
    canvas.drawCircle(Offset(size.w / 2, size.w / 2), size / 2, paint);

    paint
      ..color = activeColor
      ..style = PaintingStyle.fill;
    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.w / 2, size.w / 2),
            height: size - 4.w,
            width: size - 4.w),
        0,
        360 * progress * pi / 180,
        true,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
