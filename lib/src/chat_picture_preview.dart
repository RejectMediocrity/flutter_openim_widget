import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/chat_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicInfo {
  final String? thumbUrl; // 视频或者图片的缩略图
  final String? url; // 适配或者图片的地址
  final File? file; // 图片文件
  final int? size; // 图片或者适配的大小
  bool? showSourcePic; // 是都点了查看原图
  final int? duration;
  final bool? isVideo; // 是否是视频
  final int? sendTime;
  PicInfo({
    this.url,
    this.file,
    this.thumbUrl,
    this.size,
    this.showSourcePic = false,
    this.isVideo = false,
    this.duration,
    this.sendTime,
  });
}

class ChatPicturePreview extends StatefulWidget {
  ChatPicturePreview(
      {Key? key,
      required this.picList,
      this.index = 0,
      this.tag,
      this.onDownload,
      this.onTap,
      this.showMenu})
      : this.controller = ExtendedPageController(
          initialPage: index,
          pageSpacing: 10,
        ),
        super(key: key);
  final List<PicInfo> picList;
  final int index;
  final String? tag;
  final ExtendedPageController controller;
  final Future<bool> Function(String, bool)? onDownload;
  final Function()? onTap;
  final Function()? showMenu;

  @override
  State<ChatPicturePreview> createState() => _ChatPicturePreviewState();
}

class _ChatPicturePreviewState extends State<ChatPicturePreview> {
  late int currentPage;
  late List<PicInfo> picList;
  int duration = 0;
  int postion = 0;
  @override
  void initState() {
    currentPage = widget.index;
    picList = List.from(widget.picList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var child = Stack(
      children: [
        _buildPageView(),
        _buildBackBtn(),
        _buildToolsView(onDownload: () {
          downLoadImg();
        }, onViewOriginImg: () {
          picList[currentPage].showSourcePic = true;
          setState(() {});
        }),
      ],
    );
    return Material(
      color: Color(0xFF000000),
      child: widget.tag == null ? child : Hero(tag: widget.tag!, child: child),
    );
  }

  void downLoadImg() {
    if (currentPage < picList.length) {
      PicInfo info = picList.elementAt(currentPage);
      widget.onDownload?.call(info.url!, info.isVideo == true);
    }
  }

  void close() {
    Navigator.pop(context);
  }

  Widget _buildBackBtn() {
    bool isVideo = picList[currentPage].isVideo == true;
    if (!isVideo) return Container();
    return Positioned(
      left: 16.w,
      top: MediaQuery.of(context).padding.top + 16.w,
      child: GestureDetector(
        onTap: close,
        child: ImageUtil.assetImage(
          "title_but_close_white",
          width: 20.w,
          height: 20.w,
        ),
      ),
    );
  }

  Widget _buildChildView(int index) {
    var info = picList.elementAt(index);
    if (info.isVideo == true) {
      return ChatVideoPlayer(
        url: info.url ?? "",
        thumbUrl: info.thumbUrl,
        playCallback: (int p, int d) {
          setState(() {
            postion = p;
            duration = d;
          });
        },
      );
    }
    String? url = info.url;
    if (info.file != null) {
      return ExtendedImage.file(
        info.file!,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: true,
        loadStateChanged: _buildLoadStateChangedView,
        initGestureConfigHandler: _buildGestureConfig,
      );
    } else if (url != null) {
      return ExtendedImage.network(
        url,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: true,
        handleLoadingProgress: true,
        loadStateChanged: _buildLoadStateChangedView,
        initGestureConfigHandler: _buildGestureConfig,
      );
    } else {
      return _buildErrorView();
    }
  }

  GestureConfig _buildGestureConfig(ExtendedImageState state) => GestureConfig(
        //you must set inPageView true if you want to use ExtendedImageGesturePageView
        inPageView: true,
        initialScale: 1.0,
        maxScale: 10.0,
        animationMaxScale: 12.0,
        initialAlignment: InitialAlignment.center,
      );

  Widget? _buildLoadStateChangedView(ExtendedImageState state) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        {
          final ImageChunkEvent? loadingProgress = state.loadingProgress;
          final double? progress = loadingProgress?.expectedTotalBytes != null
              ? loadingProgress!.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null;
          return Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: progress,
              ),
            ),
          );
        }
      case LoadState.completed:
        {
          ///if you don't want override completed widget
          ///please return null or state.completedWidget
          //return null;
          //return state.completedWidget;
          // return ExtendedRawImage(
          //   image: state.extendedImageInfo?.image,
          // );
          return null;
        }
      case LoadState.failed:
        //remove memory cached
        state.imageProvider.evict();
        return _buildErrorView();
    }
  }

  Widget _buildPageView() => GestureDetector(
        onTap: widget.onTap ?? close,
        child: ExtendedImageGesturePageView.builder(
          reverse: widget.showMenu==null?true:false,
          controller: widget.controller,
          itemCount: picList.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildChildView(index);
          },
          onPageChanged: (int index) {
            setState(() {
              currentPage = index;
            });
          },
        ),
      );
  String _getVideoDurationFormat(int seconds) {
    var d = Duration(seconds: seconds);
    // var hours = d.inHours > 10 ? d.inHours : '0${d.inHours}';
    // var minute =
    //     d.inMinutes % 60 > 10 ? d.inMinutes % 60 : '0${d.inMinutes % 60}';
    var minute = d.inMinutes > 10 ? d.inMinutes : '0${d.inMinutes}';
    var sec = d.inSeconds % 60 > 10 ? d.inSeconds % 60 : '0${d.inSeconds % 60}';
    return '$minute:$sec';
  }

  Widget _buildToolsView(
      {Function()? onViewOriginImg, Function()? onDownload}) {
    PicInfo info = picList[currentPage];
    bool isVideo = info.isVideo == true;
    int size = info.size ?? 0;
    String sizeStr = CommonUtil.formatBytes(size);
    Duration du = Duration(seconds: duration);
    Duration po = Duration(seconds: postion);
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16.w,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1.sw),
        child: Row(
          children: [
            SizedBox(
              width: isVideo
                  ? 20.w
                  : widget.showMenu == null
                      ? 170.w
                      : 118.w,
            ),
            isVideo
                ? Flexible(
                    child: Row(
                      children: [
                        Text(
                          _getVideoDurationFormat(po.inSeconds),
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.white),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: SliderTheme(
                            data: SliderThemeData().copyWith(
                              trackShape: null,
                              trackHeight: 2.w,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 6.w,
                              ),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 0),
                            ),
                            child: Slider(
                              value: duration == 0 ? 0 : postion / duration,
                              onChanged: (value) {},
                              activeColor: Color(0xFF006DFA),
                              inactiveColor: Color(0xFFDDDDDD),
                              thumbColor: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _getVideoDurationFormat(du.inSeconds),
                          style:
                              TextStyle(fontSize: 14.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: 140.w,
                    height: 32.w,
                    color: Colors.transparent,
                  ),
            widget.showMenu != null
                ? SizedBox(
                    width: 20.w,
                  )
                : Container(),
            widget.showMenu != null
                ? GestureDetector(
                    onTap: widget.showMenu,
                    child: ImageUtil.assetImage(
                      "preview_but_thumbnail_background",
                      width: 32.w,
                      height: 32.w,
                      fit: BoxFit.fill,
                    ),
                  )
                : Container(),
            SizedBox(
              width: 16.w,
            ),
            GestureDetector(
              onTap: onDownload,
              child: ImageUtil.assetImage(
                "preview_but_download_background",
                width: 32.w,
                height: 32.w,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() => Container(
        width: 375.w,
        color: Color(0xFF999999),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageUtil.error(width: 80.w, height: 70.h),
            SizedBox(
              height: 19.h,
            ),
            Text(
              UILocalizations.picLoadError,
              style: TextStyle(color: Colors.white, fontSize: 18.sp),
            )
          ],
        ),
      );
}
