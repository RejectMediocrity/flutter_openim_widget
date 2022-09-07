import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/util/screen_util.dart';

enum PressType {
  longPress,
  singleClick,
}

class CustomPopupMenuController extends ChangeNotifier {
  bool menuIsShowing = false;
  late TapDownDetails details;
  void showMenu() {
    menuIsShowing = true;
    notifyListeners();
  }

  void hideMenu() {
    menuIsShowing = false;
    notifyListeners();
  }

  void toggleMenu() {
    menuIsShowing = !menuIsShowing;
    notifyListeners();
  }
}

class CopyCustomPopupMenu extends StatefulWidget {
  CopyCustomPopupMenu({
    required this.child,
    required this.menuBuilder,
    required this.pressType,
    this.controller,
    this.arrowColor = const Color(0xFF4C4C4C),
    this.showArrow = true,
    this.barrierColor = Colors.black12,
    this.arrowSize = 10.0,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
    this.isNeedFixOffsetOnPad = false,
    this.pressFunc,
    this.dismissCallback,
  });

  final Widget child;
  final PressType pressType;
  final bool showArrow;
  final Color arrowColor;
  final Color barrierColor;
  final double horizontalMargin;
  final double verticalMargin;
  final double arrowSize;
  final CustomPopupMenuController? controller;
  final Widget Function() menuBuilder;
  final bool isNeedFixOffsetOnPad;
  final Function()? pressFunc;
  final Function()? dismissCallback;

  @override
  _CopyCustomPopupMenuState createState() => _CopyCustomPopupMenuState();
}

class _CopyCustomPopupMenuState extends State<CopyCustomPopupMenu> {
  RenderBox? _childBox;
  RenderBox? _parentBox;
  OverlayEntry? _overlayEntry;
  CustomPopupMenuController? _controller;
  TapDownDetails? _tapDownDetails;

  _showMenu() {
    Widget arrow = ClipPath(
      child: Container(
        width: widget.arrowSize,
        height: widget.arrowSize,
        color: widget.arrowColor,
      ),
      clipper: _ArrowClipper(),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: <Widget>[
            GestureDetector(
              // onTap: () => _hideMenu(),
              onPanDown: (detail) => _hideMenu(),
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: widget.barrierColor,
              ),
            ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth:
                      _parentBox!.size.width - 2 * widget.horizontalMargin,
                  minWidth: 0,
                ),
                child: CustomMultiChildLayout(
                  delegate: _MenuLayoutDelegate(
                    tapDownDetails: _tapDownDetails,
                    anchorSize: _childBox!.size,
                    anchorOffset: _childBox!.localToGlobal(
                      Offset(-widget.horizontalMargin,
                          _tapDownDetails?.localPosition.dy ?? 0),
                    ),
                    verticalMargin: widget.verticalMargin,
                    isNeedFixOffsetOnPad: widget.isNeedFixOffsetOnPad,
                  ),
                  children: <Widget>[
                    // if (widget.showArrow)
                    //   LayoutId(
                    //     id: _MenuLayoutId.arrow,
                    //     child: arrow,
                    //   ),
                    // if (widget.showArrow)
                    //   LayoutId(
                    //     id: _MenuLayoutId.downArrow,
                    //     child: Transform.rotate(
                    //       angle: math.pi,
                    //       child: arrow,
                    //     ),
                    //   ),
                    LayoutId(
                      id: _MenuLayoutId.content,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Material(
                            child: widget.menuBuilder(),
                            color: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    if (_overlayEntry != null) {
      Overlay.of(context)!.insert(_overlayEntry!);
    }
  }

  _hideMenu() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      _tapDownDetails = null;
      widget.dismissCallback?.call();
    }
  }

  _updateView() {
    if (_controller?.menuIsShowing ?? false) {
      _showMenu();
    } else {
      _hideMenu();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    if (_controller == null) _controller = CustomPopupMenuController();
    _controller?.addListener(_updateView);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (!mounted) return;
      _childBox = context.findRenderObject() as RenderBox?;
      _parentBox =
          Overlay.of(context)!.context.findRenderObject() as RenderBox?;
    });
  }

  @override
  void dispose() {
    _hideMenu();
    _controller?.removeListener(_updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var child = Material(
      child: InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: widget.child,
        onTapDown: (TapDownDetails details) {
          _tapDownDetails = details;
          widget.controller?.details = details;
        },
        onTap: widget.pressType == PressType.singleClick
            ? () {
                if (widget.pressType == PressType.singleClick) {
                  _showMenu();
                  widget.pressFunc?.call();
                }
              }
            : null,
        onLongPress: widget.pressType == PressType.longPress
            ? () {
                if (widget.pressType == PressType.longPress) {
                  _showMenu();
                  FocusScope.of(context).requestFocus(FocusNode());
                  widget.pressFunc?.call();
                }
              }
            : null,
      ),
      color: Colors.transparent,
    );
    if (Platform.isIOS) {
      return child;
    } else {
      return WillPopScope(
        onWillPop: () {
          _hideMenu();
          return Future.value(true);
        },
        child: child,
      );
    }
  }
}

enum _MenuLayoutId {
  arrow,
  downArrow,
  content,
}

enum _MenuPosition {
  bottomLeft,
  bottomCenter,
  bottomRight,
  topLeft,
  topCenter,
  topRight,
}

class _MenuLayoutDelegate extends MultiChildLayoutDelegate {
  _MenuLayoutDelegate({
    required this.anchorSize,
    required this.anchorOffset,
    required this.verticalMargin,
    required this.tapDownDetails,
    this.isNeedFixOffsetOnPad = false,
  });

  final Size anchorSize;
  final Offset anchorOffset;
  final double verticalMargin;
  final TapDownDetails? tapDownDetails;
  final bool isNeedFixOffsetOnPad;

  @override
  void performLayout(Size size) {
    Size contentSize = Size.zero;
    Size arrowSize = Size.zero;
    Offset contentOffset = Offset(0, 0);
    Offset arrowOffset = Offset(0, 0);

    double anchorCenterX = anchorOffset.dx + anchorSize.width / 2;
    if (DeviceUtil.instance.isPadOrTablet && isNeedFixOffsetOnPad) {
      anchorCenterX = anchorOffset.dx + anchorSize.width / 4 - 0.45.sw;
    }
    double anchorTopY = anchorOffset.dy;
    double anchorBottomY = anchorTopY + anchorSize.height;
    _MenuPosition menuPosition = _MenuPosition.bottomCenter;

    if (hasChild(_MenuLayoutId.content)) {
      contentSize = layoutChild(
        _MenuLayoutId.content,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      arrowSize = layoutChild(
        _MenuLayoutId.arrow,
        BoxConstraints.loose(size),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      layoutChild(
        _MenuLayoutId.downArrow,
        BoxConstraints.loose(size),
      );
    }

    double free = 1.sh - (tapDownDetails?.globalPosition.dy ?? 0);
    bool isTop = free <= contentSize.height;
    if (!isTop) {
      var height = 275 / 667 * 1.sh;
      isTop = free <= height;
    }
    if (anchorCenterX - contentSize.width / 2 < 0) {
      menuPosition = isTop ? _MenuPosition.topLeft : _MenuPosition.bottomLeft;
    } else if (anchorCenterX + contentSize.width / 2 > size.width) {
      menuPosition = isTop ? _MenuPosition.topRight : _MenuPosition.bottomRight;
    } else {
      menuPosition =
          isTop ? _MenuPosition.topCenter : _MenuPosition.bottomCenter;
    }

    switch (menuPosition) {
      case _MenuPosition.bottomCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorBottomY + verticalMargin,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomLeft:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          0,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.bottomRight:
        arrowOffset = Offset(anchorCenterX - arrowSize.width / 2,
            anchorBottomY + verticalMargin);
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorBottomY + verticalMargin + arrowSize.height,
        );
        break;
      case _MenuPosition.topCenter:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          anchorCenterX - contentSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _MenuPosition.topLeft:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          0,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
      case _MenuPosition.topRight:
        arrowOffset = Offset(
          anchorCenterX - arrowSize.width / 2,
          anchorTopY - verticalMargin - arrowSize.height,
        );
        contentOffset = Offset(
          size.width - contentSize.width,
          anchorTopY - verticalMargin - arrowSize.height - contentSize.height,
        );
        break;
    }
    if (hasChild(_MenuLayoutId.content)) {
      double offsety = tapDownDetails?.localPosition.dy ?? 0;
      positionChild(
          _MenuLayoutId.content,
          isTop
              ? contentOffset
              : Offset(contentOffset.dx,
                  anchorTopY - verticalMargin - arrowSize.height));
    }
    bool isBottom = false;
    if (_MenuPosition.values.indexOf(menuPosition) < 3) {
      // bottom
      isBottom = true;
    }
    if (hasChild(_MenuLayoutId.arrow)) {
      positionChild(
        _MenuLayoutId.arrow,
        isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy + 0.1)
            : Offset(-100, 0),
      );
    }
    if (hasChild(_MenuLayoutId.downArrow)) {
      positionChild(
        _MenuLayoutId.downArrow,
        !isBottom
            ? Offset(arrowOffset.dx, arrowOffset.dy - 0.1)
            : Offset(-100, 0),
      );
    }
  }

  @override
  bool shouldRelayout(MultiChildLayoutDelegate oldDelegate) => false;
}

class _ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
