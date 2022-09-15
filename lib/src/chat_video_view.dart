import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class ChatVideoView extends StatefulWidget {
  final String? videoPath;
  final String? videoUrl;
  final String? snapshotUrl;
  final String? snapshotPath;
  final double? width;
  final double? height;
  final double widgetWidth;
  final bool isReceived;
  final String msgId;
  final Stream<MsgStreamEv<int>>? msgSenProgressStream;
  final int initMsgSendProgress;
  final int index;
  final Stream<int>? clickStream;

  const ChatVideoView({
    Key? key,
    required this.msgId,
    required this.isReceived,
    required this.index,
    this.clickStream,
    this.snapshotPath,
    this.snapshotUrl,
    this.videoPath,
    this.videoUrl,
    this.width,
    this.height,
    this.widgetWidth = 100,
    this.msgSenProgressStream,
    this.initMsgSendProgress = 100,
  }) : super(key: key);

  @override
  _ChatVideoViewState createState() => _ChatVideoViewState();
}

class _ChatVideoViewState extends State<ChatVideoView> {
  late double _trulyWidth;
  late double _trulyHeight;
  String? snapshotUrl;
  String? snapshotPath;
  String? url;
  String? path;

  @override
  void initState() {
    path = widget.videoPath;
    url = widget.videoUrl;
    snapshotUrl = widget.snapshotUrl;
    snapshotPath = widget.snapshotPath;

    var w = widget.width ?? 1.0;
    var h = widget.height ?? 1.0;

    _trulyWidth = widget.widgetWidth;
    _trulyHeight = _trulyWidth * h / w;
    /*if (widget.widgetWidth > w) {
      _trulyWidth = w;
      _trulyHeight = h;
    } else {
      _trulyWidth = widget.widgetWidth;
      _trulyHeight = _trulyWidth * h / w;
    }*/

    /*widget.clickStream?.listen((i) {
      if (!mounted) return;
      if (_isClickedLocation(i)) {
        if (null != widget.onClickVideo) {
          widget.onClickVideo!(url, path);
        }
      }
    });*/
    super.initState();
  }

  bool _isClickedLocation(i) => i == widget.index;

  Widget _buildThumbView() {
    if (widget.isReceived) {
      if (null != snapshotUrl && snapshotUrl!.isNotEmpty) {
        return CachedNetworkImage(
          imageUrl: snapshotUrl!,
          width: _trulyWidth,
          height: _trulyHeight,
          placeholder: (BuildContext context, String url) {
            return Container(
              width: _trulyWidth,
              height: _trulyHeight,
              color: Color(0xFFF9F9F9),
            );
          },
          errorWidget: (BuildContext context, String url, dynamic error) {
            return Container(
              width: _trulyWidth,
              height: _trulyHeight,
              color: Color(0xFFF9F9F9),
            );
          },
          fit: BoxFit.fitWidth,
        );
      }
    } else {
      if (null != snapshotPath &&
          snapshotPath!.isNotEmpty &&
          File(snapshotPath!).existsSync()) {
        return Image(
          image: FileImage(File(snapshotPath!)),
          height: _trulyHeight,
          width: _trulyWidth,
          fit: BoxFit.fitWidth,
          errorBuilder: (_, error, stack) => _errorIcon(),
        );
      } else {
        if (null != snapshotUrl && snapshotUrl!.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: snapshotUrl!,
            width: _trulyWidth,
            height: _trulyHeight,
            placeholder: (BuildContext context, String url) {
              return Container(
                width: _trulyWidth,
                height: _trulyHeight,
                color: Color(0xFFF9F9F9),
              );
            },
            errorWidget: (BuildContext context, String url, dynamic error) {
              return Container(
                width: _trulyWidth,
                height: _trulyHeight,
                color: Color(0xFFF9F9F9),
              );
            },
            fit: BoxFit.fitWidth,
          );
        }
      }
    }
    return Container(
      width: _trulyWidth,
      height: _trulyHeight,
      color: Color(0xFFF9F9F9),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 20220915 暂时去掉hero动画
    // return Hero(
    //     tag: widget.msgId,
    return Container(
      width: _trulyWidth,
      height: _trulyHeight,
      // color: Color(0xFFB3D7FF),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildThumbView(),
          ImageUtil.assetImage("vedio_but_play_small", width: 38, height: 38),
          ChatSendProgressView(
            height: _trulyHeight,
            width: _trulyWidth,
            msgId: widget.msgId,
            stream: widget.msgSenProgressStream,
            initProgress: widget.initMsgSendProgress,
          ),
        ],
      ),
    );
  }

  Widget _errorIcon() =>
      ImageUtil.error(width: _trulyWidth, height: _trulyHeight);
}
