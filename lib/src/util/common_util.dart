import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sprintf/sprintf.dart';

late String imCachePath;

class CommonUtil {
  /// path: image path
  static Future<String?> createThumbnail({
    required String path,
    required double minWidth,
    required double minHeight,
  }) async {
    if (!(await File(path).exists())) {
      return null;
    }
    String thumbPath = await createTempPath(path, flag: 'im');
    File destFile = File(thumbPath);
    if (!(await destFile.exists())) {
      await destFile.create(recursive: true);
    } else {
      return thumbPath;
    }
    var compressFile = await compressImage(
      File(path),
      targetPath: thumbPath,
      minHeight: minHeight ~/ 1,
      minWidth: minWidth ~/ 1,
    );
    return compressFile?.path;
  }

  static Future<String> createTempPath(
    String sourcePath, {
    String flag = "",
    String dir = 'pic',
  }) async {
    var path = (await getApplicationDocumentsDirectory()).path;
    var name =
        '${flag}_${sourcePath.substring(sourcePath.lastIndexOf('/') + 1)}';
    String dest = '$path/$dir/$name';

    return dest;
  }

  /// get Now Date Milliseconds.
  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  ///  compress file and get file.
  static Future<File?> compressImage(
    File? file, {
    required String targetPath,
    required int minWidth,
    required int minHeight,
    int? quality,
    int? sampleSize,
  }) async {
    if (null == file) return null;
    var path = file.path;
    var name = path.substring(path.lastIndexOf("/"));
    // var ext = name.substring(name.lastIndexOf("."));
    CompressFormat format = CompressFormat.jpeg;
    if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
      format = CompressFormat.jpeg;
    } else if (name.endsWith(".png")) {
      format = CompressFormat.png;
    } else if (name.endsWith(".heic")) {
      format = CompressFormat.heic;
    } else if (name.endsWith(".webp")) {
      format = CompressFormat.webp;
    }

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality ?? 70,
      inSampleSize: sampleSize ?? 2,
      minWidth: minWidth,
      minHeight: minHeight,
      format: format,
    );
    return result;
  }

  //fileExt 文件后缀名
  static String? getMediaType(final String filePath) {
    var fileName = filePath.substring(filePath.lastIndexOf("/") + 1);
    var fileExt = fileName.substring(fileName.lastIndexOf("."));
    switch (fileExt.toLowerCase()) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return "image/jpeg";
      case ".png":
        return "image/png";
      case ".bmp":
        return "image/bmp";
      case ".gif":
        return "image/gif";
      case ".json":
        return "application/json";
      case ".svg":
      case ".svgz":
        return "image/svg+xml";
      case ".mp3":
        return "audio/mpeg";
      case ".mp4":
        return "video/mp4";
      case ".mov":
        return "video/mov";
      case ".htm":
      case ".html":
        return "text/html";
      case ".css":
        return "text/css";
      case ".csv":
        return "text/csv";
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return "text/plain";
    }
    return null;
  }

  /// 将字节数转化为MB
  static String formatBytes(int bytes) {
    int kb = 1024;
    int mb = kb * 1024;
    int gb = mb * 1024;
    if (bytes >= gb) {
      return sprintf("%.1f GB", [bytes / gb]);
    } else if (bytes >= mb) {
      double f = bytes / mb;
      return sprintf(f > 100 ? "%.0f MB" : "%.1f MB", [f]);
    } else if (bytes > kb) {
      double f = bytes / kb;
      return sprintf(f > 100 ? "%.0f KB" : "%.1f KB", [f]);
    } else {
      return sprintf("%d B", [bytes]);
    }
  }

  /// Text 在中英文混排是会出现截取不完整的问题
  static String breakWord(String text) {
    RegExp regexp = RegExp(
        "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]");
    bool hasMatch = regexp.hasMatch(text);
    if (text.isEmpty || hasMatch) {
      return text;
    }
    String breakWord = '';
    text.runes.forEach((element) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    });
    return breakWord;
    return text;
  }

  static List<String> checkHasNoMatchUids(
      {required String content,
      required Map<String, String> atUserNameMappingMap,
      List<AtUserInfo>? atUserInfo}) {
    final atReg = RegExp('$regexAt|$regexAtMe');
    List<RegExpMatch> match = atReg.allMatches(content).toList();
    List<String> noMatchUids = [];
    for (RegExpMatch element in match) {
      String des = element.group(0)!;
      String uid = des.replaceFirst("@", "").trim();
      List<AtUserInfo>? currentUser = atUserInfo
          ?.where((element) =>
              element.atUserID == uid && element.groupNickname != null)
          .toList();
      if (!atUserNameMappingMap.containsKey(uid) &&
          (currentUser == null || currentUser.isEmpty)) {
        noMatchUids.add(uid);
      }
    }
    return noMatchUids;
  }

  static String replaceAtMsgIdWithNickName(
      {required String content,
      required Map<String, String> atUserNameMappingMap,
      List<AtUserInfo>? atUserInfo}) {
    final atReg = RegExp('$regexAt|$regexAtMe');
    List<RegExpMatch> match = atReg.allMatches(content).toList();
    String temp = '';
    match.forEach((element) {
      String des = element.group(0)!;
      String uid = des.replaceFirst("@", "").trim();
      List<AtUserInfo>? currentUser = atUserInfo
          ?.where((element) =>
              element.atUserID == uid && element.groupNickname != null)
          .toList();
      AtUserInfo? userInfo;
      if (currentUser != null && currentUser.length > 0) {
        userInfo = currentUser.first;
      }
      if (userInfo != null) {
        content = content.replaceAll(des, '@${userInfo.groupNickname} ');
      } else if (atUserNameMappingMap.containsKey(uid)) {
        content = content.replaceAll(des, '@${atUserNameMappingMap[uid]!} ');
      }
    });
    return content;
  }

  static bool didExceedMaxLines({
    required String content,
    required int maxLine,
    required double maxWidth,
    required TextStyle style,
  }) {
    TextPainter painter = TextPainter(
      locale: WidgetsBinding.instance.window.locale,
      maxLines: maxLine,
      textDirection: TextDirection.ltr,
      textScaleFactor: 1.0,
      text: TextSpan(text: content, style: style),
    );
    painter.layout(maxWidth: maxWidth);
    return painter.didExceedMaxLines;
  }

  static bool isDigit({
    required String s,
    int idx = 0,
  }) {
    int _zero = "0".codeUnits[0];
    int _nine = "9".codeUnits[0];
    int cuIdx = s.codeUnits[idx];
    return cuIdx >= _zero && cuIdx <= _nine;
  }
}
