import 'dart:convert';

import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class SummaryUtil {

  /// 工作总结显示文案
  static String workSummaryText(String? summaryType) {
    if (summaryType == 'ref') {
      return '引用了你的工作总结，如未总结，请尽快完成';
    } else if (summaryType == 'self_reply') {
      return '回复了你的工作总结 立即查看';
    } else if (summaryType == 'other_reply') {
      return '在工作总结里回复了你 立即查看';
    } else {
      //默认是分享 summaryType == 'share'
      return '向你分享了工作总结 立即查看';
    }
  }

  /// 是否是工作总结
  static Map? isWorkSummary(String data) {
    /**
     * {
     * "type" : "report_week_assistant"
     *  "data" : {
     *      "im_user_id" : "4g839u4dff8qdpzo_f58xiaus7frnmqfz",
     *      "summary_id" : "CT7NICPFEOSN",
     *      "user_name" : "小麦"
     *      "summary_type" : "share|ref|self_reply|other_reply"
     *      "start":xxx,
     *      "end":xxx,
     *    }
     *  }
     */
    try {
      Map map = json.decode(data);
      String type = map["type"];
      if (type == "report_week_assistant") {
        return map;
      }
      return null;
    } on Exception catch (e) {
      return null;
    }
  }

  static bool isSummaryShare(Message message) {
    if (message.contentType == MessageType.custom) {
      try {
        String data = message.customElem?.data ?? "";
        Map map = json.decode(data);
        String type = map["type"];
        return type == "summary_share";
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}