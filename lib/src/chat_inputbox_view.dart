import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

class ChatInputBoxView extends StatefulWidget {
  ChatInputBoxView({
    Key? key,
    required this.multiOpToolbox,
    required this.emojiView,
    required this.atAction,
    required this.picAction,
    this.allAtMap = const <String, String>{},
    this.atCallback,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.style,
    this.atStyle,
    this.atMeStyle,
    this.forceCloseToolboxSub,
    this.quoteContent,
    this.onClearQuote,
    this.multiMode = false,
    this.inputFormatters,
    this.hintText,
    this.isGroupChat = false,
    this.emojiViewState,
  }) : super(key: key);
  final Function() atAction;
  final Function() picAction;
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final Widget multiOpToolbox;
  final Widget emojiView;
  final TextStyle? style;
  final TextStyle? atStyle;
  final TextStyle? atMeStyle;
  final Subject? forceCloseToolboxSub;
  final String? quoteContent;
  final Function()? onClearQuote;
  final bool multiMode;
  final List<TextInputFormatter>? inputFormatters;
  final String? hintText;
  final bool? isGroupChat;
  final Function(bool visible)? emojiViewState;
  @override
  _ChatInputBoxViewState createState() => _ChatInputBoxViewState();
}

class _ChatInputBoxViewState extends State<ChatInputBoxView>
    with TickerProviderStateMixin {
  var _emojiVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    widget.focusNode?.addListener(() {
      if (widget.focusNode!.hasFocus) {
        setState(() {
          _emojiVisible = false;
          widget.emojiViewState!(_emojiVisible);
        });
      }
    });

    widget.forceCloseToolboxSub?.listen((value) {
      if (!mounted) return;
      setState(() {
        _emojiVisible = false;
        widget.emojiViewState!(_emojiVisible);
      });
    });

    widget.controller?.addListener(() {
      if (widget.controller!.text.isEmpty) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget.controller?.dispose();
    widget.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.multiMode ? widget.multiOpToolbox : buildView();
  }

  focus() => FocusScope.of(context).requestFocus(widget.focusNode);

  unfocus() => FocusScope.of(context).requestFocus(FocusNode());

  Widget buildView() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFDDDDDD),
                  width: 1,
                ),
              )),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// 引用（回复）消息
              if (widget.quoteContent != null && "" != widget.quoteContent)
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 6, 6, 0),
                  child: buildQuoteView(),
                ),

              /// 输入框
              Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: buildInputView(),
              ),

              /// bottomBar
              Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
                child: buildBottomBar(),
              ),
            ],
          ),
        ),
        Visibility(
          visible: _emojiVisible,
          child: widget.emojiView,
        ),
      ],
    );
  }

  Row buildBottomBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _emojiVisible = !_emojiVisible;
              widget.emojiViewState!(_emojiVisible);
              if (_emojiVisible) {
                unfocus();
              } else {
                focus();
              }
            });
          },
          child: ImageUtil.assetImage(
            _emojiVisible ? "Inputbox_but_emoji_high" : "Inputbox_but_emoji",
            width: 20,
            height: 20,
          ),
        ),
        SizedBox(
          width: 30,
        ),
        Visibility(
          child: GestureDetector(
            onTap: widget.atAction,
            child: ImageUtil.assetImage(
              "Inputbox_but_at",
              width: 20,
              height: 20,
            ),
          ),
          visible: widget.isGroupChat == true,
        ),
        Visibility(
          child: SizedBox(
            width: 30,
          ),
          visible: widget.isGroupChat == true,
        ),
        GestureDetector(
          onTap: widget.picAction,
          child: ImageUtil.assetImage(
            "Inputbox_but_pic",
            width: 20,
            height: 20,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        GestureDetector(
          onTap: () {
            if (!_emojiVisible) focus();
            if (null != widget.onSubmitted && null != widget.controller) {
              widget.onSubmitted!(widget.controller!.text.toString());
            }
          },
          child: ImageUtil.assetImage(
            widget.controller!.text.isNotEmpty &&
                    widget.controller!.text.trim()!.isNotEmpty
                ? "Inputbox_but_send"
                : "Inputbox_but_send_normal",
            width: 20,
            height: 20,
          ),
        ),
      ],
    );
  }

  Widget buildInputView() {
    return Container(
        constraints: BoxConstraints(minHeight: 16, maxHeight: 120),
        child: ChatTextField(
          style: widget.style ?? textStyle,
          atStyle: widget.atStyle ?? atStyle,
          atMeStyle: widget.atMeStyle ?? atMeStyle,
          atCallback: widget.atCallback,
          allAtMap: widget.allAtMap,
          focusNode: widget.focusNode,
          controller: widget.controller,
          inputFormatters: widget.inputFormatters,
          onSubmitted: (value) {
            focus();
            if (null != widget.onSubmitted) widget.onSubmitted!(value);
          },
          hintText: widget.hintText,
        ));
  }

  Container buildQuoteView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: widget.onClearQuote,
            child: Icon(
              Icons.close,
              color: Color(0xFF999999),
              size: 18,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            color: Color(0xFFDDDDDD),
            width: 1,
            height: 14,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.quoteContent!,
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  static var textStyle = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFF333333),
    textBaseline: TextBaseline.alphabetic,
  );

  static var atStyle = TextStyle(
    fontSize: 16.sp,
    color: Color(0xFF006DFA),
    textBaseline: TextBaseline.alphabetic,
  );
  static var atMeStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16.sp,
    textBaseline: TextBaseline.alphabetic,
  );
}
