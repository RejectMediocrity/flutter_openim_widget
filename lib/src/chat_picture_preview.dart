import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/chat_video_player.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sp_util/sp_util.dart';

class PicInfo {
  final String? thumbUrl; // 视频或者图片的缩略图
  final String? url; // 适配或者图片的地址
  final File? file; // 图片文件
  final int? size; // 图片或者适配的大小
  bool? showSourcePic; // 是都点了查看原图
  final int? duration;
  final bool? isVideo; // 是否是视频
  final int? sendTime;
  int width;
  int height;
  final String? clientMsgId;

  PicInfo({
    this.clientMsgId,
    this.url,
    this.file,
    this.thumbUrl,
    this.size,
    this.showSourcePic = false,
    this.isVideo = false,
    this.duration,
    this.sendTime,
    int? width,
    int? height,
  })  : this.width = width ?? 1,
        this.height = height ?? 1;
}

class ChatPicturePreview extends StatefulWidget {
  ChatPicturePreview({
    Key? key,
    required this.picList,
    this.index = 0,
    this.tag,
    this.onDownload,
    this.onTap,
    this.showMenu,
    this.previewIndexChanged,
  })  : this.controller = ExtendedPageController(
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
  final Function(List<PicInfo>)? showMenu;
  final Future<List<PicInfo>> Function(int? index)? previewIndexChanged;

  @override
  State<ChatPicturePreview> createState() {
    PicInfo info = picList.elementAt(index);
    SpUtil.putBool("autoPlay", info.isVideo == true);
    return _ChatPicturePreviewState();
  }
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
      // 20220915 暂时去掉hero动画
      // child: widget.tag == null ? child : Hero(tag: widget.tag!, child: child),
      child: widget.tag == null ? child : Container(child: child),
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

  Widget _errorView() {
    return ImageUtil.assetImage(
      'ic_load_error',
      fit: BoxFit.cover,
    );
  }

  Widget _placeholderImage() {
    return ImageUtil.assetImage(
      "pic_place",
      fit: BoxFit.cover,
    );
  }

  Widget _urlView({required String url}) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (BuildContext context, String url) {
        return _placeholderImage();
      },
      errorWidget: (BuildContext context, String url, dynamic error) {
        return _errorView();
      },
      fit: BoxFit.fitWidth,
    );
  }

  Widget _pathView({required File file}) => Stack(
        children: [
          Image(
            image: FileImage(file),
            fit: BoxFit.fitWidth,
            errorBuilder: (_, error, stack) => _errorView(),
          ),
        ],
      );
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
    if (info.file != null) {
      return ExtendedImage.file(
        info.file!,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: false,
        loadStateChanged: (ExtendedImageState state) {
          _buildLoadStateChangedView(state, index);
        },
        initGestureConfigHandler: (ExtendedImageState state) {
          return _buildGestureConfig(state, info: info);
        },
      );
    } else if (info.thumbUrl != null && info.showSourcePic == false) {
      return ExtendedImage.network(
        info.thumbUrl!,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: false,
        handleLoadingProgress: true,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          _buildLoadStateChangedView(state, index);
        },
        initGestureConfigHandler: (ExtendedImageState state) {
          return _buildGestureConfig(state, info: info);
        },
      );
    } else if (info.url != null) {
      return ExtendedImage.network(
        info.url!,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        clearMemoryCacheWhenDispose: false,
        handleLoadingProgress: true,
        cache: true,
        loadStateChanged: (ExtendedImageState state) {
          _buildLoadStateChangedView(state, index);
        },
        initGestureConfigHandler: (ExtendedImageState state) {
          return _buildGestureConfig(state, info: info);
        },
      );
    } else {
      return _buildErrorView();
    }
  }

  GestureConfig _buildGestureConfig(ExtendedImageState state,
      {required PicInfo info}) {
    double scale = 1;
    if (info.width < info.height) {
      double realWidth = 1.sh / info.height * info.width;
      scale = 1.sw / realWidth;
    }
    return GestureConfig(
      //you must set inPageView true if you want to use ExtendedImageGesturePageView
      inPageView: true,
      initialScale: scale < 1 ? 1 : scale,
      maxScale: 10.0,
      animationMaxScale: 12.0,
      initialAlignment: InitialAlignment.topCenter,
    );
  }

  Widget? _buildLoadStateChangedView(ExtendedImageState state, int index) {
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
          int? width = state.extendedImageInfo?.image.width;
          int? height = state.extendedImageInfo?.image.height;
          picList.elementAt(index).width = width ?? 1;
          picList.elementAt(index).height = height ?? 1;
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
          reverse: widget.showMenu == null ? true : false,
          controller: widget.controller,
          itemCount: picList.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildChildView(index);
          },
          onPageChanged: (int index) {
            setState(() {
              currentPage = index;
            });
            if (index == 0) {
              widget.previewIndexChanged
                  ?.call(widget.picList.elementAt(index).sendTime)
                  .then((value) {
                setState(() {
                  picList.insertAll(0, value);
                  currentPage = value.length;
                });
              }).catchError((e) {
                print(e.toString());
              });
            }
          },
        ),
      );
  String _getVideoDurationFormat(int seconds) {
    var d = Duration(seconds: seconds);
    var minute = d.inMinutes >= 10 ? d.inMinutes : '0${d.inMinutes}';
    var sec =
        d.inSeconds % 60 >= 10 ? d.inSeconds % 60 : '0${d.inSeconds % 60}';
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
                : info.showSourcePic == true
                    ? Container(
                        width: 140.w,
                        height: 32.w,
                      )
                    : GestureDetector(
                        onTap: onViewOriginImg,
                        child: Container(
                          width: 140.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: Color(0xFF999999).withAlpha(76),
                            borderRadius: BorderRadius.circular(100.w),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "查看原图($sizeStr)",
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                        ),
                      ),
            widget.showMenu != null
                ? SizedBox(
                    width: 20.w,
                  )
                : Container(),
            widget.showMenu != null
                ? GestureDetector(
                    onTap: (){
                      widget.showMenu?.call(picList);
                    },
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
