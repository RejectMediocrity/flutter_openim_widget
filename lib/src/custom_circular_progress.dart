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
  late AnimationController anim;
  late Animation<double> animation;

  @override
  void initState() {
    anim =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    animation = CurvedAnimation(
      parent: anim,
      curve: Curves.linear,
    );
    animation =
        Tween<double>(begin: 0, end: 360 * widget.progress).animate(animation)
          ..addListener(() {
            if (mounted) setState(() {});
          })
          ..addStatusListener((status) {
            switch (status) {
              case AnimationStatus.completed:
                // anim.reverse();
                break;
              case AnimationStatus.dismissed:
                // anim.forward();
                break;
              default:
                break;
            }
          });
    super.initState();
    anim.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          painter: MyPainter(animation,
              size: widget.size,
              activeColor: widget.activeColor,
              backColor: widget.backColor,
              progress: widget.progress),
        ),
      ),
    );
  }

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }
}

class MyPainter extends CustomPainter {
  Animation animation;
  final double size;
  final Color activeColor;
  final Color backColor;
  final double progress;
  MyPainter(this.animation,
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
        animation.value * pi / 180,
        true,
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
