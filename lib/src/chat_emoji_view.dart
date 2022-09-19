import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/util/recently_used_emoji_manager.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

const emojiFaces = <String, String>{
  "[OK]": "emoji_ok_v2.png",
  "[赞]": "emoji_thumbsup.png",
  "[谢谢]": "emoji_thanks.png",
  "[加油]": "emoji_fighting.png",
  "[比心]": "emoji_fingerheart.png",
  "[鼓掌]": "emoji_applaud.png",
  "[碰拳]": "emoji_fistbump.png",
  "[加1]": "emoji_plusone.png",
  "[完成]": "emoji_done.png",
  "[微笑]": "emoji_smile.png",
  "[龇牙]": "emoji_grin.png",
  "[大笑]": "emoji_laugh.png",
  "[坏笑]": "emoji_smirk.png",
  "[笑哭]": "emoji_lol.png",
  "[捂脸]": "emoji_facepalm.png",
  "[送心]": "emoji_love.png",
  "[可爱]": "emoji_wink.png",
  "[得意]": "emoji_proud.png",
  "[灵光一闪]": "emoji_witty.png",
  "[机智]": "emoji_smart.png",
  "[惊呆]": "emoji_scowl.png",
  "[思考]": "emoji_thinking.png",
  "[流泪]": "emoji_sob.png",
  "[泣不成声]": "emoji_cry.png",
  "[黑线]": "emoji_errr.png",
  "[抠鼻]": "emoji_nosepick.png",
  "[酷拽]": "emoji_irritated_v2.png",
  "[打脸]": "emoji_slap.png",
  "[吐血]": "emoji_spitblood.png",
  "[衰]": "emoji_toasted.png",
  "[黑脸]": "emoji_blackface.png",
  "[看]": "emoji_glance.png",
  "[呆无辜]": "emoji_dull.png",
  "[玫瑰]": "emoji_rose.png",
  "[爱心]": "emoji_heart.png",
  "[撒花]": "emoji_party.png",
  "[无辜笑]": "emoji_innocentsmile.png",
  "[害羞]": "emoji_shy.png",
  "[偷笑]": "emoji_chuckle.png",
  "[笑]": "emoji_joyful.png",
  "[惊喜]": "emoji_wow.png",
  "[憨笑]": "emoji_trick.png",
  "[耶]": "emoji_yeah.png",
  "[我想静静]": "emoji_enough.png",
  "[泪奔]": "emoji_tears.png",
  "[尬笑]": "emoji_embarrassed.png",
  "[亲亲]": "emoji_kiss.png",
  "[飞吻]": "emoji_smooch.png",
  "[爱慕]": "emoji_drool.png",
  "[舔屏]": "emoji_obsessed.png",
  "[财迷]": "emoji_money.png",
  "[做鬼脸]": "emoji_tease.png",
  "[酷]": "emoji_showoff.png",
  "[摸头]": "emoji_comfort.png",
  "[欢呼]": "emoji_clap.png",
  "[强]": "emoji_praise.png",
  "[奋斗]": "emoji_strive.png",
  "[脸红]": "emoji_blush.png",
  "[闭嘴]": "emoji_silent.png",
  "[再见]": "emoji_wave.png",
  "[吃瓜群主]": "emoji_eating.png",
  "[什么？]": "emoji_what.png",
  "[皱眉]": "emoji_frown.png",
  "[凝视]": "emoji_dullstare.png",
  "[晕]": "emoji_dizzy.png",
  "[鄙视]": "emoji_lookdown.png",
  "[大哭]": "emoji_wail.png",
  "[抓狂]": "emoji_crazy.png",
  "[可怜]": "emoji_whimper.png",
  "[求抱抱]": "emoji_hug.png",
  "[快哭了]": "emoji_blubber.png",
  "[委屈]": "emoji_wronged.png",
  "[翻白眼]": "emoji_husky.png",
  "[嘘]": "emoji_shhh.png",
  "[撇嘴]": "emoji_smug.png",
  "[发怒]": "emoji_angry.png",
  "[敲打]": "emoji_hammer.png",
  "[震惊]": "emoji_shocked.png",
  "[惊恐]": "emoji_terror.png",
  "[石化]": "emoji_petrified.png",
  "[骷髅]": "emoji_skull.png",
  "[汗]": "emoji_sweat.png",
  "[无语]": "emoji_speechless.png",
  "[酣睡]": "emoji_sleep.png",
  "[困]": "emoji_drowsy.png",
  "[哈欠]": "emoji_yawn.png",
  "[戴口罩]": "emoji_sick.png",
  "[吐]": "emoji_puke.png",
  "[如花]": "emoji_bigkiss.png",
  "[背叛]": "emoji_betrayed.png",
  "[听歌]": "emoji_headset_v3.png",
  "[紫薇别走]": "emoji_donnotgo.png",
  "[吃饭]": "emoji_eatingfood_v2.png",
  "[敲键盘]": "emoji_typing.png",
  "[柠檬]": "emoji_lemon_v2.png",
  "[Get]": "emoji_get_v3.png",
  "[我看行]": "emoji_lgtm_v3.png",
  "[金币]": "emoji_gold.png",
  "[求关注]": "emoji_attention.png",
  "[去污粉]": "emoji_detergent.png",
  "[给力]": "emoji_goodjob.png",
  "[互粉]": "emoji_followme.png",
  "[抱拳]": "emoji_salute.png",
  "[握手]": "emoji_shake.png",
  "[击掌]": "emoji_highfive.png",
  "[点击]": "emoji_upperleft.png",
  "[踩]": "emoji_thumbsdown.png",
  "[白眼]": "emoji_slight.png",
  "[吐舌]": "emoji_tongue.png",
  "[不看]": "emoji_eyesclosed.png",
  "[啊？]": "emoji_bear.png",
  "[公牛]": "emoji_bull.png",
  "[小牛]": "emoji_calf.png",
  "[亲吻]": "emoji_lips.png",
  "[啤酒]": "emoji_beer.png",
  "[蛋糕]": "emoji_cake.png",
  "[礼物]": "emoji_gift.png",
  "[胡瓜]": "emoji_cucumber_v3.png",
  "[鸡腿]": "emoji_drumstick.png",
  "[辣椒]": "emoji_pepper.png",
  "[冰糖葫芦]": "emoji_candiedhaws.png",
  "[奶茶]": "emoji_bubbletea.png",
  "[咖啡]": "emoji_coffee_v2.png",
  "[Yes]": "emoji_yes_v2.png",
  "[No]": "emoji_no_v3.png",
  "[OKR]": "emoji_okr.png",
  "[勾号]": "emoji_checkmark.png",
  "[叉号]": "emoji_crossmark.png",
  "[-1]": "emoji_minusone_v3.png",
  "[100分]": "emoji_hundred.png",
  "[牛]": "emoji_awesomen_v2.png",
  "[图钉]": "emoji_pin.png",
  "[闹钟]": "emoji_alarm.png",
  "[喇叭]": "emoji_loudspeaker.png",
  "[奖杯]": "emoji_trophy.png",
  "[火]": "emoji_fire.png",
  "[彩虹]": "emoji_rainbowpuke_v2.png",
  "[音乐]": "emoji_music_v2.png",
  "[鞭炮]": "emoji_firecracker.png",
  "[666]": "emoji_awesome.png",
  "[贪钱]": "emoji_dollar.png",
  "[生气]": "emoji_mad.png",
  "[2022年]": "emoji_twentytwentytwo.png",
  "[COOL]": "emoji_socool_v2.png",
  "[红包]": "emoji_redpacket.png",
  "[发]": "emoji_fortune.png",
  "[福]": "emoji_luck.png",
  "[烟花]": "emoji_fireworks.png",
  "[威武]": "emoji_welldone.png",
  "[心碎]": "emoji_heartbroken.png",
  "[炸弹]": "emoji_bomb.png",
  "[便便]": "emoji_poop.png",
  "[18禁]": "emoji_eighteen.png",
  "[刀]": "emoji_cleaver_v2.png",
  "[足球]": "emoji_soccer.png",
  "[篮球]": "emoji_basketball.png",
  "[请勿打扰]": "emoji_generaldonotdisturb_v2.png",
  "[思考中]": "emoji_status_privatemessage.png",
  "[日程]": "emoji_generalInmeetingbusy_v2.png",
  "[精神补给]": "emoji_statusreading.png",
  "[灵光一现]": "emoji_statusflashofInspiration.png",
  "[出差]": "emoji_generalbusinesstrip_v2.png",
  "[在家办公]": "emoji_generalworkfromhome.png",
  "[美好生活]": "emoji_statusenjoylife.png",
  "[出行]": "emoji_generaltravellingcar.png",
  "[公交车]": "emoji_statusbus.png",
  "[飞行中]": "emoji_statusinflight.png",
  "[辛勤营业]": "emoji_generalsun.png",
  "[天色已晚]": "emoji_generalmoonrest_v2.png"
};

class ChatEmojiView extends StatefulWidget {
  const ChatEmojiView({
    Key? key,
    this.onAddEmoji,
    this.onDeleteEmoji,
    this.favoriteList = const [],
    this.onAddFavorite,
    this.onSelectedFavorite,
    this.controller,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.backColor,
    this.edgeInsets,
    this.size,
    this.showDelete,
    this.crossAxisCount,
  }) : super(key: key);
  final Function()? onDeleteEmoji;
  final Function(String emoji)? onAddEmoji;
  final List<String> favoriteList;
  final Function()? onAddFavorite;
  final Function(int index, String url)? onSelectedFavorite;
  final TextEditingController? controller;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final Color? backColor;
  final EdgeInsets? edgeInsets;
  final double? size;
  final bool? showDelete;
  final int? crossAxisCount;
  @override
  _ChatEmojiViewState createState() => _ChatEmojiViewState();
}

class _ChatEmojiViewState extends State<ChatEmojiView> {
  var _index = 0;
  var _enableDeleteEmoji = false;

  @override
  void initState() {
    if (widget.controller != null) {
      _enableDeleteEmoji = widget.controller!.text.isNotEmpty;

      widget.controller?.addListener(() {
        bool nextValue = widget.controller!.text.isNotEmpty;
        if (_enableDeleteEmoji != nextValue) {
          setState(() {
            _enableDeleteEmoji = nextValue;
          });
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 200),
      child: Container(
        // height: 190.h,
        color: Color(0xFFF2F2F2),
        // child: Column(
        //   children: [
        //     Stack(
        //       children: [
        //         if (_index == 0) _buildEmojiLayout(),
        //         if (_index == 1) _buildFavoriteLayout(),
        //       ],
        //     ),
        //     _buildTabView(),
        //   ],
        // ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            _buildEmojiLayout(),
            widget.showDelete == true
                ? Container(
                    constraints:
                        BoxConstraints(maxHeight: 106.w, maxWidth: 100.w),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                      ImageUtil.imageResStr("Mask_group_emoji"),
                      package: 'flutter_openim_widget',
                    ))),
                    padding: EdgeInsets.fromLTRB(35.w, 32.w, 16.w, 34.w),
                    child: GestureDetector(
                      onTap: _enableDeleteEmoji == true
                          ? widget.onDeleteEmoji
                          : null,
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.w, horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(6.w),
                          ),
                        ),
                        child: ImageUtil.assetImage(
                          _enableDeleteEmoji == true
                              ? "keyboard_but_delete_disable"
                              : "keyboard_but_delete",
                          width: 22.w,
                          height: 16.w,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() => Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 9.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(
              color: const Color(0xFFEAEAEA),
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildTabSelectedBgView(selected: _index == 0, index: 0),
            _buildTabSelectedBgView(selected: _index == 1, index: 1),
            Spacer(),
            if (_index == 0) _buildFaceDelBtn(),
          ],
        ),
      );

  Widget _buildFaceDelBtn() => GestureDetector(
        onTap: widget.onDeleteEmoji,
        child: Container(
          // width: 25.w,
          // height: 25.h,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 13.w),
          child: Center(
            child: ImageUtil.assetImage(
              'ic_del_face',
              width: 18.w,
              height: 16.h,
            ),
          ),
        ),
      );

  Widget _buildTabSelectedBgView({
    bool selected = false,
    int index = 0,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            _index = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 13.w),
          decoration: BoxDecoration(
            color: selected ? Color(0xFF000000).withOpacity(0.06) : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ImageUtil.assetImage(
              index == 0
                  ? (selected ? 'ic_face_sel' : 'ic_face_nor')
                  : (selected ? 'ic_favorite_sel' : 'ic_favorite_nor'),
              width: 19,
              height: 19),
        ),
      );

  Widget _buildEmojiLayout() => Container(
        color: widget.backColor ?? Colors.transparent,
        height: 270.w,
        child: GridView.builder(
          padding:
              widget.edgeInsets ?? EdgeInsets.fromLTRB(4.w, 8.w, 4.w, 90.w),
          itemCount: emojiFaces.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount ??
                (DeviceUtil.instance.isPadOrTablet ? 9 : 7),
            childAspectRatio: 1,
            // mainAxisSpacing: widget.mainAxisSpacing ?? 22.w,
            // crossAxisSpacing: widget.crossAxisSpacing ?? 22.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.transparent,
              child: Ink(
                child: InkWell(
                  onTap: () {
                    String emojiName = emojiFaces.keys.elementAt(index);
                    RecentlyUsedEmojiManager.updateEmoji(emojiName);
                    widget.onAddEmoji?.call(emojiName);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: ImageUtil.faceImage(
                      emojiFaces.values.elementAt(index),
                      width: widget.size ??
                          (DeviceUtil.instance.isPadOrTablet ? 37.w : 30.w),
                      height: widget.size ??
                          (DeviceUtil.instance.isPadOrTablet ? 37.w : 30.w),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildFavoriteLayout() => Container(
        // color: Colors.white,
        height: 270.w,
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          itemCount: widget.favoriteList.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 20.h,
            crossAxisSpacing: 37.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return GestureDetector(
                onTap: widget.onAddFavorite,
                child: Center(
                  child: ImageUtil.assetImage('ic_add_emoji'),
                ),
              );
            }
            var url = widget.favoriteList.elementAt(index - 1);
            return GestureDetector(
              onTap: () => widget.onSelectedFavorite?.call(index - 1, url),
              child: Center(
                child: ImageUtil.lowMemoryNetworkImage(
                  url: url,
                  width: 60.w,
                  cacheWidth: 60.w.toInt(),
                ),
              ),
            );
          },
        ),
      );
}
