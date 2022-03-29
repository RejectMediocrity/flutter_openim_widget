import 'package:flutter/material.dart';

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
    this.showBorder,
  }) : super(key: key);
  final BoxConstraints? constraints;
  final Color? backgroundColor;
  final Widget? child;
  final BubbleType bubbleType;
  final bool? showBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: showBorder ?? false
            ? Border.all(color: Color(0xFFDDDDDD), width: 1)
            : null,
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: child,
    );
  }
}
