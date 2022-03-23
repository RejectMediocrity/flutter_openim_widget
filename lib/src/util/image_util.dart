import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_openim_widget/src/chat_emoji_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageUtil {
  ImageUtil._();

  static String imageResStr(var name) => "assets/images/$name.webp";
  static String faceResStr(var name) => "assets/faces/$name";
  static AssetImage emojiImage(String key) => AssetImage(
        ImageUtil.faceResStr(emojiFaces[key]),
        package: 'flutter_openim_widget',
      );

  static Widget svg(
    String name, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return SvgPicture.asset(
      "assets/images/$name.svg",
      width: width,
      height: height,
      color: color,
      package: 'flutter_openim_widget',
    );
  }

  static Widget faceImage(
    String res, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      faceResStr(res),
      width: width,
      height: height,
      fit: fit,
      color: color,
      // cacheHeight: height?.toInt(),
      // cacheWidth: width?.toInt(),
      package: 'flutter_openim_widget',
    );
  }

  static Widget assetImage(
    String res, {
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
  }) {
    return Image.asset(
      imageResStr(res),
      width: width,
      height: height,
      fit: fit,
      color: color,
      // cacheHeight: height?.toInt(),
      // cacheWidth: width?.toInt(),
      package: 'flutter_openim_widget',
    );
  }

  static Widget back({Color color = const Color(0xFF333333)}) => assetImage(
        'ic_back',
        width: 12.w,
        height: 20.h,
        color: color,
      );

  static Widget add() => assetImage(
        "ic_add",
        width: 24.h,
        height: 24.h,
        color: Color(0xFF333333),
      );

  static Widget search() => assetImage(
        'ic_search',
        width: 24.h,
        height: 24.h,
        color: Color(0xFF333333),
      );

  static Widget play() => assetImage(
        'ic_video_play',
        width: 48.h,
        height: 48.h,
      );

  static Widget sendFailed() => assetImage(
        'msg_icon_error',
        width: 20.h,
        height: 20.h,
      );

  static Widget speak() => svg(
        'ic_speak',
        width: 26.h,
        height: 26.h,
      );

  static Widget tools() => svg(
        'ic_tools',
        width: 26.h,
        height: 26.h,
      );

  static Widget emoji() => svg(
        'ic_emoji',
        width: 26.h,
        height: 26.h,
      );

  static Widget keyboard() => svg(
        'ic_keyboard',
        width: 26.h,
        height: 26.h,
      );

  static Widget toolsAlbum() => assetImage(
        'ic_tools_album',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsCamera() => assetImage(
        'ic_tools_camera',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsCarte() => assetImage(
        'ic_tools_carte',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsFile() => assetImage(
        'ic_tools_file',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsLocation() => assetImage(
        'ic_tools_location',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsVideoCall() => assetImage(
        'ic_tools_video_call',
        width: 48.h,
        height: 48.h,
      );

  static Widget toolsVoiceInput() => assetImage(
        'ic_tools_voice_input',
        width: 48.h,
        height: 48.h,
      );

  static Widget menuCopy() =>
      assetImage('ic_menu_copy', width: 18.w, height: 18.w);

  static Widget menuDel() => assetImage(
        'ic_menu_del',
        width: 18.w,
        height: 18.w,
      );

  static Widget menuForward() => assetImage(
        'ic_menu_forward',
        width: 16.w,
        height: 16.w,
      );

  static Widget menuMultiChoice() => assetImage(
        'ic_menu_multichoice',
        width: 18.w,
        height: 18.w,
      );

  static Widget menuReply() => assetImage(
        'ic_menu_reply',
        width: 18.w,
        height: 18.w,
      );

  static Widget menuRevoke() => assetImage(
        'ic_menu_revoke',
        width: 18.w,
        height: 18.w,
      );

  static Widget menuDownload() => assetImage(
        'ic_menu_download',
        width: 18.w,
        height: 18.w,
      );

  static Widget menuTranslation() => assetImage(
        'ic_menu_translation',
        width: 18.w,
        height: 18.w,
      );

  static Widget menuAddEmoji() => assetImage(
        'ic_menu_add_emoji',
        width: 19.w,
        height: 19.w,
      );

  static Widget file() => assetImage(
        'ic_file',
        width: 22.w,
        height: 28.h,
      );

  static Widget delQuote() => assetImage(
        'ic_del_quote',
        width: 14.w,
        height: 15.w,
      );

  static Widget voiceInputNor() => assetImage(
        'ic_voice_input_nor',
        width: 88.h,
        height: 88.h,
        fit: BoxFit.cover,
      );

  static Widget error({
    double? width,
    double? height,
  }) =>
      assetImage(
        'ic_load_error',
        height: height,
        width: width,
      );

  static Widget notDisturb() => assetImage(
        'maglist_icon_newmsg_gray',
        width: 18.h,
        height: 18.h,
      );
  static Widget graterThan99() => assetImage(
        'maglist_icon_newmsg_red',
        width: 18.h,
        height: 18.h,
      );
  static Widget lowMemoryNetworkImage({
    required String url,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = true,
    bool lowMemory = true,
  }) =>
      ExtendedImage.network(
        url,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: lowMemory ? cacheWidth ?? (1.sw * .75).toInt() : null,
        cacheHeight: lowMemory ? cacheHeight : null,
        cache: true,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              {
                final ImageChunkEvent? loadingProgress = state.loadingProgress;
                final double? progress =
                    loadingProgress?.expectedTotalBytes != null
                        ? loadingProgress!.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null;
                // CupertinoActivityIndicator()
                return Container(
                  width: 15.0,
                  height: 15.0,
                  child: loadProgress
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            value: progress ?? 0,
                          ),
                        )
                      : null,
                );
              }
            case LoadState.completed:
              return null;
            case LoadState.failed:
              //remove memory cached
              state.imageProvider.evict();
              return error(width: width, height: height);
          }
        },
        // border: Border.all(color: Colors.red, width: 1.0),
        // shape: boxShape,
        // borderRadius: BorderRadius.all(Radius.circular(30.0)),
        // cancelToken: CancellationToken(),
      );

  static Widget networkImage({
    required String url,
    double? width,
    double? height,
    int? cacheWidth,
    int? cacheHeight,
    BoxFit? fit,
    bool loadProgress = true,
    bool clearMemoryCacheWhenDispose = false,
    bool lowMemory = true,
  }) =>
      lowMemoryNetworkImage(
        url: url,
        width: width,
        height: height,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
        fit: fit,
        loadProgress: loadProgress,
        clearMemoryCacheWhenDispose: clearMemoryCacheWhenDispose,
        lowMemory: lowMemory,
      );
/*CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth ?? (lowMemory ? (1.sw * .75).toInt() : null),
        memCacheHeight: cacheHeight,
        // placeholder: placeholder,
        progressIndicatorBuilder: (context, url, progress) => Container(
          width: 10.0,
          height: 10.0,
          child: loadProgress
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    value: progress.progress ?? 0,
                  ),
                )
              : null,
        ),
        errorWidget: (_, url, error) => error(width: width, height: height),
      );*/
}
