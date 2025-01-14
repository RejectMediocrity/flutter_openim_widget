import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

import 'controller/audio_controller.dart';

class ChatVoiceView extends StatefulWidget {
  final int index;
  final Stream<int>? clickStream;
  final bool isReceived;
  final String? soundPath;
  final String? soundUrl;
  final int? duration;
  final bool? ownerRight;
  final Function(int index)? onClick;
  final String? ex;
  final Widget? voiceUnreadView;
  const ChatVoiceView({
    Key? key,
    required this.index,
    this.clickStream,
    required this.isReceived,
    this.soundPath,
    this.soundUrl,
    this.duration,
    this.ownerRight,
    this.onClick,
    this.ex,
    this.voiceUnreadView,
  }) : super(key: key);

  @override
  _ChatVoiceViewState createState() => _ChatVoiceViewState();
}

class _ChatVoiceViewState extends State<ChatVoiceView> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    String key = widget.soundPath ?? widget.soundUrl ?? "";
    AudioController.instance.addListener(key, this.voicePlayingState);
  }

  void voicePlayingState(event) {
    setState(() {
      print("AudioController voice view $event");
      _isPlaying = event;
    });
  }

  @override
  void dispose() {
    String key = widget.soundPath ?? widget.soundUrl ?? "";

    /// FIXME 当修复未知原因，频繁刷新dispose后需要执行此代码
    // AudioController.instance.removeListener(key, this.voicePlayingState);
    super.dispose();
  }

  bool get isOwnerRight => widget.ownerRight == true;

  Widget _buildVoiceAnimView() {
    var anim;
    var png;
    var turns;
    if (!isOwnerRight) {
      anim = 'assets/anim/voice_black.json';
      png = 'assets/images/ic_voice_black.webp';
      turns = 0;
    } else {
      anim = 'assets/anim/voice_blue.json';
      png = 'assets/images/ic_voice_blue.webp';
      turns = 90;
    }
    return GestureDetector(
      onTap: () {
        widget.onClick?.call(widget.index);
      },
      child: Directionality(
        textDirection: isOwnerRight ? TextDirection.rtl : TextDirection.ltr,
        child: widget.ex?.isNotEmpty == true
            ? Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: !widget.isReceived
                          ? Color(0xFFAFD2FD)
                          : Color(0xFFE4E4E4),
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    child: buildContent(turns, anim, png),
                  ),
                  if (widget.voiceUnreadView != null)
                    Padding(
                      child: widget.voiceUnreadView!,
                      padding: EdgeInsets.only(left: 6.w),
                    ),
                ],
              )
            : buildContent(turns, anim, png),
      ),
    );
  }

  Row buildContent(turns, anim, png) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _isPlaying
            ? RotatedBox(
                quarterTurns: turns,
                child: Lottie.asset(
                  anim,
                  height: 19.h,
                  width: 18.w,
                  package: 'flutter_openim_widget',
                ),
              )
            : Image.asset(
                png,
                height: 19.h,
                width: 18.w,
                package: 'flutter_openim_widget',
              ),
        SizedBox(
          width: 12.w,
        ),
        Text(
          "${widget.duration ?? 0}''",
          style: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFF333333),
          ),
        ),
        SizedBox(
          width: 132.w * (widget.duration! > 60 ? 60 : widget.duration!) / 60,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildVoiceAnimView();
  }
}
