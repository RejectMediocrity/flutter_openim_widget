import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayer extends StatefulWidget {
  final String url;
  final String? thumbUrl;
  final Function(int position, int duration)? playCallback;
  ChatVideoPlayer({required this.url, this.thumbUrl, this.playCallback});
  @override
  State<StatefulWidget> createState() {
    return _VideoAppState();
  }
}

class _VideoAppState extends State<ChatVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
        if (widget.playCallback != null) {
          widget.playCallback!(_controller.value.position.inSeconds,
              _controller.value.duration.inSeconds);
        }
      })
      ..initialize().then((_) {
        if (widget.playCallback != null) {
          widget.playCallback!(_controller.value.position.inSeconds,
              _controller.value.duration.inSeconds);
        }
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: _isPlaying
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Image.network(
                  widget.thumbUrl!,
                  width: 1.sw,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
        ),
        _isPlaying
            ? Container()
            : GestureDetector(
                onTap: () {
                  _controller.play();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  child: ImageUtil.assetImage(
                    "vedio_but_play_big",
                    width: 46.w,
                    height: 46.w,
                  ),
                ),
              ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
