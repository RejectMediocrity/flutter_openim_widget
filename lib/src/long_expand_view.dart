import 'package:flutter/material.dart';

import '../flutter_openim_widget.dart';

/// author: dongjunjie
/// created on: 2022/9/22 17:20
/// description:

class LongExpandView extends StatefulWidget {
  final Widget child;
  final Function()? onTapExpanded;
  final bool? longExpand;
  final double maxHeight;

  const LongExpandView({
    Key? key,
    this.onTapExpanded,
    this.longExpand,
    required this.maxHeight,
    required this.child,
  }) : super(key: key);

  @override
  State<LongExpandView> createState() => _LongExpandViewState();
}

class _LongExpandViewState extends State<LongExpandView> {
  bool longView = false;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkLongHeight();
    });
    super.initState();
  }

  void checkLongHeight() {
    RenderBox? _childBox = context.findRenderObject() as RenderBox?;
    if (mounted &&
        !longView &&
        _childBox != null &&
        _childBox.hasSize &&
        _childBox.size.height > widget.maxHeight) {
      setState(() {
        longView = true;
      });
    }
  }

  @override
  void didUpdateWidget(covariant LongExpandView oldWidget) {
    // TODO: implement didUpdateWidget
    checkLongHeight();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget child = longView && widget.longExpand != true
        ? ConstrainedBox(
            child: widget.child,
            constraints: BoxConstraints(minWidth: 0.65.sw),
          )
        : widget.child;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        child,
        if (longView && widget.longExpand != true)
          GestureDetector(
            onTap: widget.onTapExpanded,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 0.65.sw + 20.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                      ImageUtil.imageResStr("mask_group"),
                      package: 'flutter_openim_widget',
                    )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.w),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    UILocalizations.spread,
                    style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          )
        else
          Container(),
      ],
    );
  }
}
