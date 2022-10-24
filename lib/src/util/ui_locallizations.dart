import 'package:flutter/material.dart';

class UILocalizations {
  UILocalizations._();

  static void set(Locale? locale) {
    _locale = locale ?? const Locale('zh');
  }

  static String _value({required String key}) =>
      _localizedValues[_locale.languageCode]![key] ?? key;

  static Locale _locale = const Locale('zh');

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'top': 'Stick to Top',
      'cancelTop': 'Remove from Top',
      'remove': 'Delete',
      'markRead': 'Mark as Read',
      "album": "Album",
      "camera": "Camera",
      "videoCall": "Video Call",
      "picture": "Picture",
      "video": "Video",
      "voice": "Voice",
      "location": "Location",
      "file": "File",
      "carte": "Contact Card",
      "voiceInput": "Voice Input",
      'haveRead': 'Have read',
      'unread': 'Unread',
      'copy': 'Copy',
      "delete": "Delete",
      "forward": "Forward",
      "mergeForward": "Merge forward",
      "mergeOneByOne": "Merge one by one",
      "addMemo": "Add memo",
      "addMergedMemo": "Add merged memo",
      "reply": "Quote",
      "revoke": "Revoke",
      "memo": "Memo",
      "multiChoice": "Choice",
      "translation": "Translate",
      "download": "Download",
      "pressSpeak": "Hold to Talk",
      "releaseSend": "Release to send",
      "releaseCancel": "Cancel to send",
      "soundToWord": "Convert",
      "converting": "Converting...",
      "cancelVoiceSend": "Cancel",
      "confirmVoiceSend": "Send Voice",
      "convertFailTips": "Unable to recognize words",
      "confirm": "Confirm",
      "you": "You",
      "revokeAMsg": "revoke a message",
      "revokedAMsg": "Message retracted",
      "revokedAMsgByOwner": "Message retracted by owner %s ",
      "revokedAMsgByManager": "Message retracted by manager %s ",
      "memoSaved": "Memo saved",
      "reEdit": "Re-edit",
      "picLoadError": "Image failed to load",
      "fileSize": "File size: %s",
      "fileUnavailable": "The file has expired or has been cleaned up",
      "send": 'Send',
      "unsupportedMessage": '[Message types not supported]',
      "add": 'Add',
      "allRead": "allRead",
      "spread": "spread",
      "addAdmin": "%s have made %s an administrator",
      "removeAdmin": "%s have removed %s from the group moderator",
      "seeDetails": "see details",
      "canEdit": "can edit",
      "canRead": "can read",
      "grantThisSessionMemberPermissions":
          "Grant this session member permissions",
      "thisSessionMember": "this session member",
      "removeFromGroup": "%s have removed %s from the group chat",
      "addToGroup": "%s have added %s to the group chat",
      "canManage": "can manage",
      "cancel": "Cancel",
      "lastTimeTip": "Recording will stop after %d",
      "moveToCancel": "Slide your finger up to cancel sending",
      "releaseFingerSend": "Release your finger and cancel sending",
      "archived": 'Archived',
      "overallSummary": 'Overall summary',
      "goalSummary": 'Goal summary',
      "goalSummaryCountTips": 'Include %s goals',
      "noSummary": "No summary",
      "workSummary": "Work summary",
    },
    'zh': {
      'top': '置顶',
      'cancelTop': '取消置顶',
      'remove': '移除',
      'markRead': '标记为已读',
      "album": "相册",
      "camera": "拍摄",
      "videoCall": "视频通话",
      "picture": "图片",
      "video": "视频",
      "voice": "语音",
      "location": "位置",
      "file": "文件",
      "carte": "名片",
      "voiceInput": "语音输入",
      'haveRead': '已读',
      'unread': '未读',
      'copy': '复制',
      "delete": "删除",
      "forward": "转发",
      "mergeForward": "合并转发",
      "mergeOneByOne": "逐条转发",
      "addMemo": "添加备忘",
      "addMergedMemo": "合并备忘",
      "reply": "回复",
      "revoke": "撤回",
      "memo": "备忘",
      "multiChoice": "多选",
      "translation": "翻译",
      "download": "下载",
      "pressSpeak": "按住说话",
      "releaseSend": "松开发送",
      "releaseCancel": "取消发送",
      "soundToWord": "转文字",
      "converting": "转换中...",
      "cancelVoiceSend": "取消",
      "confirmVoiceSend": "发送原语音",
      "convertFailTips": "未识别到文字",
      "confirm": "确定",
      "you": "你",
      "revokeAMsg": "撤回了一条消息",
      "revokedAMsg": "此消息已撤回",
      "revokedAMsgByOwner": "此消息已被群主 %s 撤回",
      "revokedAMsgByManager": "此消息已被群管理员 %s 撤回",
      "memoSaved": "已备忘",
      "reEdit": "重新编辑",
      "picLoadError": "图片加载失败",
      "fileSize": "文件大小：%s",
      "fileUnavailable": "文件已过期或已被清理",
      "send": '发送',
      "unsupportedMessage": '[暂不支持的消息类型]',
      "add": '添加',
      "allRead": "全部已读",
      "spread": "展开",
      "addAdmin": "%s 已将 %s 添加为群管理员",
      "removeAdmin": "%s 已将 %s 从群管理员移除",
      "seeDetails": "查看详情",
      "canEdit": "可编辑",
      "canRead": "可阅读",
      "grantThisSessionMemberPermissions": "赋予本会话成员权限",
      "thisSessionMember": "本会话成员",
      "removeFromGroup": "%s 将 %s 移出群聊",
      "addToGroup": "%s 将 %s 加入群聊",
      "canManage": "可管理",
      "cancel": "取消",
      "lastTimeTip": "%d''后将停止录音",
      "moveToCancel": "手指上滑，取消发送",
      "releaseFingerSend": "松开手指，取消发送",
      "archived": '已归档',
      "overallSummary": '整体总结',
      "goalSummary": '目标总结',
      "goalSummaryCountTips": '包含%s个目标',
      "noSummary": "暂无总结",
      "workSummary": "工作总结",
    },
  };

  static String get top => _value(key: 'top');

  static String get cancelTop => _value(key: 'cancelTop');

  static String get remove => _value(key: 'remove');

  static String get markRead => _value(key: 'markRead');

  static String get album => _value(key: 'album');

  static String get camera => _value(key: 'camera');

  static String get videoCall => _value(key: 'videoCall');

  static String get picture => _value(key: 'picture');

  static String get video => _value(key: 'video');

  static String get voice => _value(key: 'voice');

  static String get location => _value(key: 'location');

  static String get file => _value(key: 'file');

  static String get carte => _value(key: 'carte');

  static String get voiceInput => _value(key: 'voiceInput');

  static String get haveRead => _value(key: 'haveRead');

  static String get unread => _value(key: 'unread');

  static String get copy => _value(key: 'copy');

  static String get delete => _value(key: 'delete');

  static String get forward => _value(key: 'forward');

  static String get mergeForward => _value(key: 'mergeForward');

  static String get mergeOneByOne => _value(key: 'mergeOneByOne');

  static String get addMemo => _value(key: 'addMemo');

  static String get addMergedMemo => _value(key: 'addMergedMemo');

  static String get reply => _value(key: 'reply');

  static String get revoke => _value(key: 'revoke');

  static String get memo => _value(key: 'memo');

  static String get multiChoice => _value(key: 'multiChoice');

  static String get translation => _value(key: 'translation');

  static String get download => _value(key: 'download');

  static String get pressSpeak => _value(key: 'pressSpeak');

  static String get releaseSend => _value(key: 'releaseSend');

  static String get releaseCancel => _value(key: 'releaseCancel');

  static String get soundToWord => _value(key: 'soundToWord');

  static String get converting => _value(key: 'converting');

  static String get cancelVoiceSend => _value(key: 'cancelVoiceSend');

  static String get confirmVoiceSend => _value(key: 'confirmVoiceSend');

  static String get convertFailTips => _value(key: 'convertFailTips');

  static String get confirm => _value(key: 'confirm');

  static String get you => _value(key: 'you');

  static String get revokeAMsg => _value(key: 'revokeAMsg');

  static String get memoSaved => _value(key: 'memoSaved');

  static String get picLoadError => _value(key: 'picLoadError');

  static String get fileSize => _value(key: 'fileSize');

  static String get fileUnavailable => _value(key: 'fileUnavailable');

  static String get acceptFriendHint => _value(key: 'acceptFriendHint');

  static String get addFriendHint => _value(key: 'addFriendHint');

  static String get send => _value(key: 'send');

  static String get unsupportedMessage => _value(key: 'unsupportedMessage');

  static String get add => _value(key: 'add');

  static String get allRead => _value(key: "allRead");

  static String get revokedAMsg => _value(key: "revokedAMsg");

  static String get revokedAMsgByOwner => _value(key: "revokedAMsgByOwner");

  static String get revokedAMsgByManager => _value(key: "revokedAMsgByManager");

  static String get reEdit => _value(key: "reEdit");

  static String get spread => _value(key: "spread");

  static String get addAdmin => _value(key: "addAdmin");

  static String get removeAdmin => _value(key: "removeAdmin");

  static String get seeDetails => _value(key: "seeDetails");

  static String get canEdit => _value(key: "canEdit");

  static String get canRead => _value(key: "canRead");

  static String get canManage => _value(key: "canManage");

  static String get grantThisSessionMemberPermissions =>
      _value(key: "grantThisSessionMemberPermissions");

  static String get thisSessionMember => _value(key: "thisSessionMember");

  static String get removeFromGroup => _value(key: "removeFromGroup");

  static String get addToGroup => _value(key: "addToGroup");

  static String get cancel => _value(key: "cancel");

  static String get lastTimeTip => _value(key: "lastTimeTip");

  static String get moveToCancel => _value(key: "moveToCancel");

  static String get releaseFingerSend => _value(key: "releaseFingerSend");

  static String get archived => _value(key: "archived");

  static String get overallSummary => _value(key: "overallSummary");

  static String get goalSummary => _value(key: "goalSummary");

  static String get goalSummaryCountTips => _value(key: "goalSummaryCountTips");

  static String get noSummary => _value(key: "noSummary");

  static String get workSummary => _value(key: "workSummary");

}
