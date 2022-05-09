import 'package:sp_util/sp_util.dart';

class RecentlyUsedEmojiManager {
  static const RecentlyEmojiKey = "RecentlyEmojiKey";
  static const defaultEmojis = <String>[
    "[赞]",
    "[OK]",
    "[Get]",
    "[加1]",
    "[比心]",
    "[鼓掌]"
  ];

  static updateEmoji(String emojiName) {
    List<String> emojis = getEmojiList();
    if (emojis.contains(emojiName)) {
      emojis.remove(emojiName);
    } else {
      emojis.removeLast();
    }
    emojis.insert(0, emojiName);
    SpUtil.putStringList(RecentlyEmojiKey, emojis);
  }

  static List<String> getEmojiList() {
    List<String>? emojis = SpUtil.getStringList(RecentlyEmojiKey);
    if (emojis == null || emojis.length <= 0) {
      SpUtil.putStringList(RecentlyEmojiKey, defaultEmojis);
      return defaultEmojis;
    }
    return emojis;
  }
}
