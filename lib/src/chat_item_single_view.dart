import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/chat_loading.dart';
import 'package:flutter_openim_widget/src/custom_circular_progress.dart';
import 'package:flutter_openim_widget/src/timing_view.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatSingleLayout extends StatelessWidget {
  final CustomPopupMenuController popupCtrl;
  final Widget child;
  final String msgId;
  final bool isSingleChat;
  final int index;
  final Function()? onItemClick;
  final Widget Function() menuBuilder;
  final Function()? onTapLeftAvatar;
  final Function()? onLongPressLeftAvatar;
  final Function()? onTapRightAvatar;
  final Function()? onLongPressRightAvatar;
  final String? leftAvatar;
  final String? leftName;
  final String rightAvatar;
  final double avatarSize;
  final bool isReceivedMsg;
  final bool? isUnread;
  final Color leftBubbleColor;
  final Color rightBubbleColor;
  final Stream<MsgStreamEv<bool>>? sendStatusStream;
  final bool isSendFailed;
  final bool isSending;
  final Widget? timeView;
  final Widget? quoteView;
  final bool isBubbleBg;
  final bool isHintMsg;
  final bool checked;
  final bool showRadio;
  final Function(bool checked)? onRadioChanged;
  final bool delaySendingStatus;
  final bool enabledReadStatus;
  final Function()? onStartDestroy;
  final int readingDuration;
  final int groupHaveReadCount;
  final int groupMemberCount;
  final Function()? viewMessageReadStatus;
  final Function()? failedResend;
  final Function(Widget bubleView)? expandView;
  final bool? enableMultiSel;
  final int? messageType;
  final Function()? resendMsg;
  final Function()? onTapReadView;
  final bool? isSelfChat; // 自己和自己聊天
  final Widget? faceReplyView;
  final Widget? voiceUnreadView;
  final bool showBorder;
  final bool isSummaryShareMsg;
  const ChatSingleLayout({
    Key? key,
    required this.child,
    required this.msgId,
    required this.index,
    required this.isSingleChat,
    required this.menuBuilder,
    this.onItemClick,
    required this.sendStatusStream,
    required this.popupCtrl,
    required this.isReceivedMsg,
    required this.rightAvatar,
    required this.leftAvatar,
    required this.leftName,
    this.avatarSize = 42.0,
    this.isUnread,
    this.leftBubbleColor = const Color(0xFFF0F0F0),
    this.rightBubbleColor = const Color(0xFFDCEBFE),
    this.onLongPressRightAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onTapLeftAvatar,
    this.isSendFailed = false,
    this.isSending = true,
    this.timeView,
    this.quoteView,
    this.isBubbleBg = true,
    this.isHintMsg = false,
    this.checked = false,
    this.showRadio = false,
    this.onRadioChanged,
    this.delaySendingStatus = false,
    this.enabledReadStatus = true,
    this.readingDuration = 0,
    this.onStartDestroy,
    this.groupHaveReadCount = 0,
    this.groupMemberCount = 0,
    this.viewMessageReadStatus,
    this.failedResend,
    this.expandView,
    this.enableMultiSel,
    this.messageType,
    this.resendMsg,
    this.onTapReadView,
    this.isSelfChat,
    this.faceReplyView,
    this.voiceUnreadView,
    this.showBorder = false,
    this.isSummaryShareMsg = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enableMultiSel == true && showRadio
          ? () => onRadioChanged?.call(!checked)
          : null,
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        ignoring: showRadio,
        child: _chatWidget(),
      ),
    );
  }

  Widget _chatWidget() {
    return isHintMsg
        ? child
        : Column(
            children: [
              if (timeView != null) timeView!,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 多选框
                  if (!isHintMsg)
                    ChatRadio(
                      checked: checked,
                      showRadio: showRadio,
                      enable: messageType != MessageType.revoke &&
                          messageType != MessageType.advancedRevoke &&
                          messageType != MessageType.voice &&
                          !isHintMsg &&
                          !isSummaryShareMsg,
                    ),
                  if (!showRadio)

                    /// 头像
                    _buildAvatar(
                      isReceivedMsg ? leftAvatar : rightAvatar,
                      isReceivedMsg
                          ? leftName
                          : OpenIM.iMManager.uInfo.nickname,
                      true,
                      onTap: isReceivedMsg ? onTapLeftAvatar : onTapRightAvatar,
                      onLongPress: isReceivedMsg
                          ? onLongPressLeftAvatar
                          : onLongPressRightAvatar,
                    ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// 群聊并且收到的消息，显示对方昵称
                          Visibility(
                            visible: !isSingleChat,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 8.w),
                              child: Text(
                                leftName ?? '',
                                style: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              /// 弹出框
                              CopyCustomPopupMenu(
                                controller: popupCtrl,
                                barrierColor: Colors.transparent,
                                arrowColor: Color(0xFF666666),
                                verticalMargin: 0,
                                isNeedFixOffsetOnPad: true,
                                // horizontalMargin: 0,
                                /// 聊天气泡&tips
                                child: isBubbleBg
                                    ? GestureDetector(
                                        onTap: () => onItemClick?.call(),
                                        child: ChatBubble(
                                          showBorder: showBorder ||
                                              messageType == MessageType.file,
                                          constraints: BoxConstraints(
                                              minHeight: avatarSize),
                                          bubbleType: isReceivedMsg
                                              ? BubbleType.receiver
                                              : BubbleType.send,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              /// 引用（回复）消息
                                              if (quoteView != null)
                                                Padding(
                                                  child: quoteView!,
                                                  padding: EdgeInsets.fromLTRB(
                                                      10.w, 10.w, 10.w, 0.w),
                                                ),

                                              /// 消息体
                                              if (expandView != null)
                                                expandView!(
                                                  Padding(
                                                    child: child,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            10.w,
                                                            10.w,
                                                            10.w,
                                                            10.w),
                                                  ),
                                                ),
                                              if (faceReplyView != null)
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10.w, 0.w, 10.w, 10.w),
                                                  child: faceReplyView,
                                                ),
                                            ],
                                          ),
                                          backgroundColor: _bubbleColor(),
                                        ))
                                    : _noBubbleBgView(),
                                menuBuilder: menuBuilder,
                                pressType: PressType.longPress,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),

                              /// 阅后即焚
                              _buildDestroyAfterReadingView(),

                              /// 发送中、发送成功、发送失败
                              if (delaySendingStatus &&
                                  sendStatusStream != null)
                                _delayedStatusView(),
                              if (!delaySendingStatus &&
                                  sendStatusStream != null)
                                Visibility(
                                  visible: isSending && !isSendFailed,
                                  child: ChatLoading(),
                                ),
                              ChatSendFailedView(
                                msgId: msgId,
                                isReceived: isReceivedMsg,
                                stream: sendStatusStream,
                                isSendFailed: isSendFailed,
                                onFailedResend: failedResend,
                                resend: resendMsg,
                              ),

                              /// 已读
                              if (isSingleChat &&
                                  !isSendFailed &&
                                  !isSending &&
                                  enabledReadStatus)
                                _buildReadStatusView(),
                              if (!isSingleChat &&
                                  !isSendFailed &&
                                  !isSending &&
                                  enabledReadStatus)
                                _buildGroupReadStatusView(),
                              if (faceReplyView == null &&
                                  voiceUnreadView != null)
                                voiceUnreadView!,
                            ],
                          ),

                          /// 暂时隐藏
                          // Padding(
                          //   padding: EdgeInsets.only(top: 6.w),
                          //   child: Row(
                          //     children: [
                          //       ImageUtil.assetImage("msg_icon_reply",
                          //           width: 12.w, height: 12.w),
                          //       SizedBox(
                          //         width: 4.w,
                          //       ),
                          //       Text(
                          //         "${20}条回复",
                          //         style: TextStyle(
                          //             color: Color(0xFF006DFA),
                          //             fontSize: 12.sp),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
  }

  Widget _noBubbleBgView() {
    Widget widget = Container(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: child,
        ),
        onTap: () {
          try {
            onItemClick?.call();
          } catch (e) {
            print(e.toString());
          }
        },
      ),
    );
    if (faceReplyView == null) return widget;
    return ChatBubble(
      showBorder: messageType == MessageType.file,
      constraints: BoxConstraints(minHeight: avatarSize),
      bubbleType: isReceivedMsg ? BubbleType.receiver : BubbleType.send,
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget,
            Padding(
              padding: EdgeInsets.only(top: 10.w),
              child: faceReplyView!,
            ),
          ],
        ),
      ),
      backgroundColor: _bubbleColor(),
    );
  }

  // BubbleNip _nip() =>
  //     isReceivedMsg ? BubbleNip.leftCenter : BubbleNip.rightCenter;

  Color _bubbleColor() => isReceivedMsg ? leftBubbleColor : rightBubbleColor;

  Widget _buildAvatar(
    String? url,
    String? text,
    bool show, {
    final Function()? onTap,
    final Function()? onLongPress,
  }) =>
      ChatAvatarView(
        isChatFrom: true,
        text: text,
        url: url,
        visible: show,
        onTap: onTap,
        onLongPress: onLongPress,
        size: avatarSize,
      );

  /// 单聊
  Widget _buildReadStatusView() {
    bool read = !isUnread!;
    return Visibility(
      visible: !isReceivedMsg && isSelfChat == false,
      child: read
          ? ImageUtil.assetImage("msg_icon_did_read", width: 20.w, height: 20.w)
          : ImageUtil.assetImage("msg_icon_unread", width: 20.w, height: 20.w),
    );
  }

  /// 群聊
  Widget _buildGroupReadStatusView() {
    bool isAllRead = groupHaveReadCount >= groupMemberCount - 1;
    double progress = groupHaveReadCount / (groupMemberCount - 1);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTapReadView,
      child: Visibility(
        visible: !isReceivedMsg,
        child: isAllRead
            ? ImageUtil.assetImage("msg_icon_did_read",
                width: 20.w, height: 20.w)
            : CustomCircularProgress(
                size: 16.w,
                activeColor: progress <= 0
                    ? Color(0xFFDDDDDD)
                    : Color.fromARGB(255, 0, 192, 155),
                backColor: Colors.white,
                progress: progress,
              ),
      ),
    );

    // int unreadCount = groupMemberCount - groupHaveReadCount;
    // bool isAllRead = unreadCount <= 0;
    // bool isAllUnRead = groupHaveReadCount == 0;
    // return Visibility(
    //   visible: !isReceivedMsg,
    //   child: GestureDetector(
    //     onTap: viewMessageReadStatus,
    //     behavior: HitTestBehavior.translucent,
    //     child: isAllRead
    //         ? ImageUtil.assetImage("msg_icon_did_read",
    //             width: 20.w, height: 20.w)
    //         : isAllUnRead
    //             ? ImageUtil.assetImage("msg_icon_unread",
    //                 width: 20.w, height: 20.w)
    //             : ImageUtil.assetImage("msg_icon_partread",
    //                 width: 20.w, height: 20.w),
    //   ),
    // );
  }

  Widget _buildQuoteMsgView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(2),
      ),
      child: quoteView,
    );
  }

  static var haveRead = TextStyle(
    fontSize: 12.sp,
    color: Color(0xFF006AFF),
  );
  static var unread = TextStyle(
    fontSize: 12.sp,
    color: Color(0xFF999999),
  );

  Widget _delayedStatusView() => FutureBuilder(
        future: Future.delayed(
          Duration(seconds: (isSending && !isSendFailed) ? 1 : 0),
          () => isSending && !isSendFailed,
        ),
        builder: (_, AsyncSnapshot<bool> hot) => Visibility(
          visible:
              index == 0 ? (hot.data == true) : (isSending && !isSendFailed),
          child: ChatLoading(),
        ),
      );

  /// 阅后即焚
  Widget _buildDestroyAfterReadingView() {
    bool haveRead = !isUnread!;
    return Visibility(
      visible: haveRead && readingDuration > 0,
      child: TimingView(
        sec: readingDuration,
        onFinished: onStartDestroy,
      ),
    );
  }
}
