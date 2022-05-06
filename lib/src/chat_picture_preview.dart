import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicInfo {
  final String? thumbUrl;
  final String? url;
  final File? file;
  final int? size;
  bool? showSourcePic; // 查看原图
  PicInfo({
    this.url,
    this.file,
    this.thumbUrl,
    this.size,
    this.showSourcePic = false,
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
  final Future<bool> Function(String)? onDownload;
  final Function()? onTap;
  final Function()? showMenu;

  @override
  State<ChatPicturePreview> createState() => _ChatPicturePreviewState();
}

class _ChatPicturePreviewState extends State<ChatPicturePreview> {
  late int currentPage;
  late List<PicInfo> picList;
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
      widget.onDownload?.call(picList.elementAt(currentPage).url!);
    }
  }

  void close() {
    Navigator.pop(context);
  }

  Widget _buildChildView(int index) {
    var info = picList.elementAt(index);
    String? url = info.showSourcePic == true ? info.url : info.thumbUrl;
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
          controller: widget.controller,
          itemCount: picList.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildChildView(index);
          },
          onPageChanged: (int index) {
            currentPage = index;
          },
        ),
      );

  Widget _buildToolsView(
      {Function()? onViewOriginImg, Function()? onDownload}) {
    int size = picList[currentPage].size ?? 0;
    String sizeStr = CommonUtil.formatBytes(size);
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16.w,
      child: Row(
        children: [
          SizedBox(
            width: 118.w,
          ),
          GestureDetector(
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
                style: TextStyle(fontSize: 12.sp, color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          GestureDetector(
            onTap: widget.showMenu,
            child: ImageUtil.assetImage(
              "preview_but_thumbnail_background",
              width: 32.w,
              height: 32.w,
              fit: BoxFit.fill,
            ),
          ),
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
