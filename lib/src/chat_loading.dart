import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class ChatLoading extends StatefulWidget {
  @override
  _ChatLoadingState createState() => _ChatLoadingState();
}

class _ChatLoadingState extends State<ChatLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      // upperBound: 180/360,
      duration: Duration(milliseconds: 1000),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
          _animationController.forward();
        }
      });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      child: RotationTransition(
        turns: _animationController,
        child: ImageUtil.assetImage(
          "msg_icon_loading",
        ),
      ),
    );
  }
}
