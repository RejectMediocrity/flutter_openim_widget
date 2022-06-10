import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatQuoteView extends StatelessWidget {
  ChatQuoteView(
      {Key? key,
      required this.message,
      this.onTap,
      this.allAtMap,
      this.patterns})
      : super(key: key);
  final Message message;
  final Function()? onTap;
  final _decoder = JsonDecoder();
  final Map<String, String>? allAtMap;
  final List<MatchPattern>? patterns;
  @override
  Widget build(BuildContext context) {
    var child;
    var name;
    var content;
    if (message.contentType == MessageType.quote) {
      var quoteMessage = message.quoteElem?.quoteMessage;
      if (null != quoteMessage) {
        name = quoteMessage.senderNickname;
        if (quoteMessage.contentType == MessageType.text) {
          content = quoteMessage.content;
        } else if (quoteMessage.contentType == MessageType.at_text) {
          content = CommonUtil.replaceAtMsgIdWithNickName(
              content: quoteMessage.atElem?.text ?? "",
              atUserNameMappingMap: allAtMap ?? {});
        } else if (quoteMessage.contentType == MessageType.picture) {
          var url1 = quoteMessage.pictureElem?.snapshotPicture?.url;
          var url2 = quoteMessage.pictureElem?.sourcePicture?.url;
          var path = quoteMessage.pictureElem?.sourcePath;
          if (url1 != null && url1.isNotEmpty) {
            child = ImageUtil.networkImage(
              url: url1,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.cover,
            );
          } else if (url2 != null && url2.isNotEmpty) {
            child = ImageUtil.networkImage(
              url: url2,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.cover,
            );
          } else if (path != null && path.isNotEmpty) {
            child = Image(
              image: FileImage(File(path)),
              height: 42.h,
              width: 42.h,
              fit: BoxFit.cover,
            );
          }
        } else if (quoteMessage.contentType == MessageType.video) {
          // var url = quoteMessage.videoElem?.snapshotUrl;
          // var path = quoteMessage.videoElem?.snapshotPath;
          // if (url != null && url.isNotEmpty) {
          //   child = _playIcon(
          //     child: ImageUtil.networkImage(
          //       url: url,
          //       width: 42.h,
          //       height: 42.h,
          //       fit: BoxFit.fill,
          //     ),
          //   );
          // } else if (path != null && path.isNotEmpty) {
          //   child = _playIcon(
          //     child: Image(
          //       image: FileImage(File(path)),
          //       height: 42.h,
          //       width: 42.h,
          //       fit: BoxFit.fill,
          //     ),
          //   );
          // }
          content = "[${UILocalizations.video}]";
        } else if (quoteMessage.contentType == MessageType.location) {
          var location = quoteMessage.locationElem;
          if (null != location) {
            var map = _decoder.convert(location.description!);
            var url = map['url'];
            var name = map['name'];
            var addr = map['addr'];
            content = '$name($addr)';
            child = ImageUtil.networkImage(
              url: url,
              width: 42.h,
              height: 42.h,
              fit: BoxFit.fill,
            );
          }
        } else if (quoteMessage.contentType == MessageType.file) {
          var file = quoteMessage.fileElem;
          content = "[${UILocalizations.file}]${file?.fileName}";
        } else if (quoteMessage.contentType == MessageType.merger) {
          content = quoteMessage.mergeElem?.title ?? "";
        }else if (quoteMessage.contentType == MessageType.voice) {
          content = "[${UILocalizations.voice}]";
        }
      }
    }
    String uidString = "";
    if(content!=null&&content.isNotEmpty){
      uidString = '${CommonUtil.replaceAtMsgIdWithNickName(
          content: content, atUserNameMappingMap: allAtMap??{})}';
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.65.sw),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(right: 4.w, top: 3.w),
              color: Color(0xFF999999),
              width: 2,
              height: 14,
            ),
            Flexible(
              child: ChatAtText(
                text: ' ${UILocalizations.reply} $name：$uidString',
                allAtMap: allAtMap ?? {},
                textStyle: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xFF666666),
                ),
                patterns: patterns ?? [],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                hasReadList: message
                    .attachedInfoElem?.groupHasReadInfo?.hasReadUserIDList,
              ),
            ),
            Container(
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _playIcon({required Widget child}) => Stack(
        alignment: Alignment.center,
        children: [
          child,
          ImageUtil.assetImage(
            'ic_video_play_small',
            width: 15.w,
            height: 15.h,
          ),
        ],
      );
}
