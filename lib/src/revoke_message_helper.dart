import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class RevokeMessageHelper {
  static final RevokeMessageHelper _instance = RevokeMessageHelper._internal();
  /*
  * {
  *   id:msgId
  *   time: sendTime
  *   content: content
  *   type:msgType
  * }
  * */
  static List<Map<String, dynamic>> revokeInfos = [];
  factory RevokeMessageHelper() {
    return _instance;
  }
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

  bool canEdit(String? id) {
    if (id!.isEmpty) return false;
    List elements =
        revokeInfos.where((element) => element["id"] == id).toList();
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

  int createTime(String? id) {
    if (id!.isEmpty) return 0;
    List elements =
        revokeInfos.where((element) => element["id"] == id).toList();
    if (elements.isEmpty) return 0;
    Map<String, dynamic> info = elements.first;
    if (info.isNotEmpty) {
      return info['time'];
    }
    return 0;
  }

  String? draftText(String id) {
    List elements =
        revokeInfos.where((element) => element["id"] == id).toList();
    if (elements.isEmpty) return null;
    Map<String, dynamic> info = elements.first;
    if (info.isNotEmpty) {
      return info['content'];
    }
    return null;
  }
}
