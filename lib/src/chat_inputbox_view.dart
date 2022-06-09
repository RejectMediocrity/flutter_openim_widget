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
    required this.voiceView,
    required this.atAction,
    required this.assetPickerView,
    this.picAction,
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
    this.assetPickerViewState,
    this.voiceViewState,
    this.hideInputBox,
    this.selectedRecentlyAssetCount,
    this.onSubmittedAssets,
  }) : super(key: key);
  final Function() atAction;
  final Function()? picAction;
  final AtTextCallback? atCallback;
  final Map<String, String> allAtMap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final num? selectedRecentlyAssetCount;
  final Widget multiOpToolbox;
  final Widget emojiView;
  final Widget assetPickerView;
  final Widget voiceView;
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
  final Function(bool visible)? assetPickerViewState;

  final Function(bool visible)? voiceViewState;
  final bool? hideInputBox;
  final Function()? onSubmittedAssets;

  @override
  _ChatInputBoxViewState createState() => _ChatInputBoxViewState();
}

class _ChatInputBoxViewState extends State<ChatInputBoxView>
    with TickerProviderStateMixin {
  var _emojiVisible = false;
  var _assetPickerVisible = false;

  var _voiceVisible = false;
  var _startRecord = false;
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
        if (!mounted) return;
        setState(() {});
      });

    widget.focusNode?.addListener(() {
      if (!mounted) return;
      if (widget.focusNode!.hasFocus) {
        setState(() {
          _emojiVisible = false;
          widget.emojiViewState!(_emojiVisible);
          _assetPickerVisible = false;
          widget.assetPickerViewState!(_assetPickerVisible);
          _voiceVisible = false;
          widget.voiceViewState!(_voiceVisible);
        });
      }
    });

    widget.forceCloseToolboxSub?.listen((value) {
      if (!mounted) return;
      setState(() {
        _emojiVisible = false;
        widget.emojiViewState!(_emojiVisible);
        _assetPickerVisible = false;
        widget.assetPickerViewState!(_assetPickerVisible);
        _voiceVisible = false;
        widget.voiceViewState!(_voiceVisible);
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

  // 显示或隐藏资源选择工具栏(isForceHidden=true时为强制隐藏)
  _showOrHideAssetPickerView(bool isForceHidden) {
    print('_showOrHideAssetPickerView');
    if (!mounted) return;
    print('_showOrHideAssetPickerView');
    setState(() {
      if (isForceHidden) {
        _assetPickerVisible = false;
      } else {
        _assetPickerVisible = !_assetPickerVisible;
      }
      widget.assetPickerViewState!(_assetPickerVisible);

      print('_assetPickerVisible = $_assetPickerVisible');
      print('widget.picAction');
      print(widget.picAction);

      if (_emojiVisible) {
        _emojiVisible = !_emojiVisible;
        widget.emojiViewState!(_emojiVisible);
        unfocus();
      }

      if (_assetPickerVisible) {
        unfocus();
      } else {
        focus();
      }

      if (_voiceVisible) {
        _voiceVisible = !_voiceVisible;
        widget.voiceViewState!(_voiceVisible);
        unfocus();
      }
    });
  }

  Widget buildView() {
    print('sssss${widget.hideInputBox}');
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
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
            Stack(
              children: [
                Visibility(
                  visible: _assetPickerVisible,
                  child: widget.assetPickerView,
                ),
                Visibility(
                  visible: _emojiVisible,
                  child: widget.emojiView,
                ),
                Visibility(
                  visible: _voiceVisible,
                  child: SizedBox(
                    height: 270.h,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (_voiceVisible) widget.voiceView,
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
              _showOrHideAssetPickerView(true);
              _emojiVisible = !_emojiVisible;
              widget.emojiViewState!(_emojiVisible);
              _voiceVisible = false;
              widget.voiceViewState!(_voiceVisible);
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
        Visibility(
          visible: widget.isGroupChat == true,
          child: SizedBox(
            width: 30,
          ),
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
        // Visibility(
        //   child: SizedBox(
        //     width: 30,
        //   ),
        //   visible: widget.isGroupChat == true,
        // ),
        // GestureDetector(
        //   onTap: () {
        //     setState(() {
        //       _emojiVisible = false;
        //       widget.emojiViewState!(_emojiVisible);
        //       _assetPickerVisible = false;
        //       widget.assetPickerViewState!(_assetPickerVisible);
        //       _voiceVisible = !_voiceVisible;
        //       widget.voiceViewState!(_voiceVisible);
        //       if (_voiceVisible) {
        //         unfocus();
        //       } else {
        //         focus();
        //       }
        //     });
        //   },
        //   child: ImageUtil.assetImage(
        //       _voiceVisible
        //           ? "ic_inputbox_but_recording_selected"
        //           : "ic_inputbox_but_recording",
        //       width: 20,
        //       height: 20),
        // ),
        SizedBox(
          width: 30,
        ),
        GestureDetector(
          onTap: () {
            if (widget.picAction == null) {
              _showOrHideAssetPickerView(false);
            } else {
              widget.picAction!();
            }
          },
          child: ImageUtil.assetImage(
            _assetPickerVisible
                ? "Inputbox_but_pic_highlight"
                : "Inputbox_but_pic",
            width: 20,
            height: 20,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        GestureDetector(
          onTap: () {
            if (_assetPickerVisible &&
                (widget.selectedRecentlyAssetCount ?? 0) > 0) {
              if (null != widget.onSubmittedAssets) {
                widget.onSubmittedAssets!();
                return;
              }
            }

            if (!_emojiVisible) focus();
            if (null != widget.onSubmitted &&
                null != widget.controller &&
                widget.controller!.text.trim().isNotEmpty) {
              widget.onSubmitted!(widget.controller!.text.toString());
            }
          },
          child: ImageUtil.assetImage(
            (widget.controller!.text.isNotEmpty &&
                        widget.controller!.text.trim().isNotEmpty) ||
                    (widget.selectedRecentlyAssetCount ?? 0) > 0
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
