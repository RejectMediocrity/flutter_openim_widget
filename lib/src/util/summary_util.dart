import 'dart:convert';

class SummaryUtil {

  /// 工作总结显示文案
  static String workSummaryText(String? summaryType) {
    if (summaryType == 'ref') {
      return '引用了你的工作总结 立即查看';
    } else if (summaryType == 'self_reply') {
      return '回复了你的工作总结 立即查看';
    } else if (summaryType == 'other_reply') {
      return '在工作总结里回复了你 立即查看';
    } else {
      //默认是分享 summaryType == 'share'
      return '分享了一份周报给你 立即查看';
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
}