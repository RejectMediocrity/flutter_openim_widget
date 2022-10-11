import 'dart:convert';

import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class RevokeMessageHelper {
  static final RevokeMessageHelper _instance = RevokeMessageHelper._internal();
  factory RevokeMessageHelper() {
    return _instance;
  }
  /*
  * {
  *   id:msgId
  *   time: sendTime
  *   content: content
  *   type:msgType
  * }
  * */
  List<Map<String, dynamic>> revokeInfos = [];
  RevokeMessageHelper._internal();

  void saveInfo(
      {required String id,
      required int sendTime,
      required String content,
      required int type}) {
    Map<String, dynamic> info = {
      "id": id,
      "time": sendTime,
      "content": content,
      "type": type
    };
    revokeInfos.removeWhere((element) => element["id"] == id);
    revokeInfos.add(info);
  }

  bool canEdit(Message message) {
    String id = message.clientMsgID!;
    if (id.isEmpty) return false;
    if (message.contentType == MessageType.advancedRevoke &&
        message.ex!.length > 0) {
      var revokedInfoMap;
      if (message.ex!.length > 0) {
        revokedInfoMap = json.decode(message.ex!);
      } else if (message.content!.length > 0) {
        RevokedInfo revokedInfo =
            RevokedInfo.fromJson(json.decode(message.content!));
        revokedInfoMap = {
          "revoke_role": revokedInfo.revokerRole,
          "revoke_user_name": revokedInfo.revokerNickname,
          "revoke_user_id": revokedInfo.revokerID
        };
      } else {
        revokedInfoMap = {
          "revoke_role": 0,
          "revoke_user_id": "",
        };
      }
      if (revokedInfoMap['revoke_user_id'] != OpenIM.iMManager.uid ||
          message.sendID != OpenIM.iMManager.uid) {
        return false;
      }
      if (message.sendID != OpenIM.iMManager.uid) {
        return false;
      }
    }
    List elements =
        revokeInfos.where((element) => element["id"] == id).toList();
    if (elements.isEmpty) {
      /// 查找content为ID时的消息是否匹配
      id = message.content!;
      if (id.isEmpty) return false;
      elements = revokeInfos.where((element) => element["id"] == id).toList();
    }

    ///
    if (elements.isEmpty) return false;
    Map<String, dynamic> info = elements.first;
    if (info.isNotEmpty) {
      int sendTime = info['time'];
      int type = info['type'];
      int du = DateTime.now().millisecondsSinceEpoch - sendTime;
      return du < 120 * 1000 && type == MessageType.text;
    }
    return false;
  }

  int createTime(Message message) {
    String id = message.clientMsgID!;
    if (id.isEmpty) return 0;
    List elements =
        revokeInfos.where((element) => element["id"] == id).toList();
    if (elements.isEmpty) {
      /// 查找content为ID时的消息是否匹配
      id = message.content!;
      if (id.isEmpty) return 0;
      elements = revokeInfos.where((element) => element["id"] == id).toList();
    }
    if (elements.isEmpty) return 0;
    Map<String, dynamic> info = elements.first;
    if (info.isNotEmpty) {
      return info['time'];
    }
    return 0;
  }

  String? draftText(Message message) {
    String id = message.clientMsgID!;
    if (id.isEmpty) return null;
    List elements =
        revokeInfos.where((element) => element["id"] == id).toList();
    if (elements.isEmpty) {
      /// 查找content为ID时的消息是否匹配
      id = message.content!;
      if (id.isEmpty) return null;
      elements = revokeInfos.where((element) => element["id"] == id).toList();
    }
    if (elements.isEmpty) return null;
    Map<String, dynamic> info = elements.first;
    if (info.isNotEmpty) {
      return info['content'];
    }
    return null;
  }
}
