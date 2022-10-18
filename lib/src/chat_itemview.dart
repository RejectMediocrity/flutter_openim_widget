import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_openim_widget/src/chat_item_doc_assistant_view.dart';
import 'package:flutter_openim_widget/src/chat_item_task_assistant_view.dart';
import 'package:flutter_openim_widget/src/chat_revoke_view.dart';
import 'package:flutter_openim_widget/src/check_exceed_maxLines.dart';
import 'package:flutter_openim_widget/src/model/chat_doc_assistant_model.dart';
import 'package:flutter_openim_widget/src/model/cloud_doc_message_model.dart';
import 'package:flutter_openim_widget/src/model/task_assistant_model.dart';
import 'package:flutter_openim_widget/src/util/event_bus.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:rxdart/rxdart.dart';
import 'package:sprintf/sprintf.dart';

class MsgStreamEv<T> {
  final String msgId;
  final T value;

  MsgStreamEv({required this.msgId, required this.value});
}

typedef CustomItemBuilder = Widget? Function(
  BuildContext context,
  int index,
  Message message,
);

typedef ItemVisibilityChange = void Function(
  BuildContext context,
  int index,
  Message message,
  bool visible,
);

typedef OnTapRevokerCallback = Function(String uid);

///  chat item
///
class ChatItemView extends StatefulWidget {
  /// if current is group chat : false
  /// if current is single chat : true
  final bool isSingleChat;

  /// When you need to customize the message style,
  /// Whether to use a bubble container
  final bool isBubbleMsg;

  /// OpenIM [Message]
  final Message message;

  ///
  // final Message? quoteMessage;

  /// Customize the display style of messages,
  /// such as system messages or status messages such as withdrawal
  final CustomItemBuilder? customItemBuilder;

  /// listview index
  final int index;

  /// Message background on the left side of the chat window
  final Color leftBubbleColor;

  /// Message background on the right side of the chat window
  final Color rightBubbleColor;

  /// Click on the message to process voice playback, video playback, picture preview, etc.
  final Function(Message message, {bool? isFromMergePreview})? onItemClick;

  /// The status of message sending,
  /// there are two kinds of success or failure, true success, false failure
  final Subject<MsgStreamEv<bool>>? msgSendStatusSubject;

  /// The progress of sending messages, such as the progress of uploading pictures, videos, and files
  final Subject<MsgStreamEv<int>>? msgSendProgressSubject;

  /// Download progress of pictures, videos, and files
  // final Subject<MsgStreamEv<int>> downloadProgressSubject;

  /// Style of text content
  final TextStyle? textStyle;

  /// @ message style
  final TextStyle? atTextStyle;

  ///
  final TextStyle? urlTextStyle;

  ///
  final TextStyle? timeStyle;

  /// hint message style
  final TextStyle? hintTextStyle;

  /// Click on the avatar event on the left side of the chat window
  final Function()? onTapLeftAvatar;

  // LongPress on the avatar event on the left side of the chat window
  final Function()? onLongPressLeftAvatar;

  /// Click on the avatar event on the right side of the chat window
  final Function()? onTapRightAvatar;

  // LongPress on the avatar event on the right side of the chat window
  final Function()? onLongPressRightAvatar;

  /// Click the @ content
  final ValueChanged<String>? onClickAtText;

  ///
  // final ValueChanged<String>? onClickUrlText;

  /// Whether the current message item is visible,
  /// used to process whether the message has been read event
  final ItemVisibilityChange? visibilityChange;

  /// all user info
  /// key:userid，value:username
  final Map<String, String> allAtMap;

  // final double width;

  /// long press menu list
  final List<MenuInfo>? menus;

  /// menu list style
  final MenuStyle? menuStyle;

  ///
  final EdgeInsetsGeometry? padding;

  ///
  final EdgeInsetsGeometry? margin;

  ///
  final double? avatarSize;

  ///
  // final bool showTime;
  final String? timeStr;

  /// Click the copy button event on the menu
  final Function()? onTapCopyMenu;

  /// Click the delete button event on the menu
  final Function()? onTapDelMenu;

  /// Click the forward button event on the menu
  final Function()? onTapForwardMenu;

  /// Click the reply button event on the menu
  final Function()? onTapReplyMenu;

  /// Click the revoke button event on the menu
  final Function()? onTapRevokeMenu;

  /// Click the memo button event on the menu
  final Function()? onTapMemoMenu;

  ///
  final Function()? onTapMultiMenu;

  ///
  final Function()? onTapTranslationMenu;

  /// Click the copy button event on the menu
  final bool? enabledCopyMenu;

  /// Click the delete button event on the menu
  final bool? enabledDelMenu;

  /// Click the forward button event on the menu
  final bool? enabledForwardMenu;

  /// Click the reply button event on the menu
  final bool? enabledReplyMenu;

  /// Click the revoke button event on the menu
  final bool? enabledRevokeMenu;

  /// Click the memo button event on the menu
  final bool? enabledMemoMenu;

  ///
  final bool? enabledMultiMenu;

  ///
  final bool? enabledTranslationMenu;

  ///
  final bool multiSelMode;

  ///
  final Function(bool checked)? onMultiSelChanged;

  ///
  final List<Message> multiList;

  ///
  final Function()? onTapQuoteMsg;

  final List<MatchPattern> patterns;

  final bool delaySendingStatus;

  final bool enabledReadStatus;

  final bool? isExpanded;
  final Function()? onTapExpanded;
  final Function()? resendMsg;
  final Function(bool isTable, String? url, {String? content})? onTapMarkDown;
  final Function(String? url)? onTapMarkDownImg;
  final Function(int permission)? setPermission;
  final String? conversationName;
  final Function()? onTapCloudDoc;
  final int? memberCount;
  final Function()? onTapReadView;
  final int? hasReadCount;
  final Function(String emoji, int index, {bool? isResignReply})?
      onReplayWithFace;
  final Function(String uid)? onTapUser;
  final Function(int index)? onTapUnShowReplyUser;
  final bool isVoiceUnread;
  final bool groupArchived;
  final Function(String userId)? onTapDocOperator;
  final Function(
      {String? padUrl,
      String? code,
      bool? isFolder,
      int? type,
      String? title})? onTapDocUrl;
  final Function(int index)? onClickVoice;
  final Widget? fileIcon;
  final OnTapRevokerCallback? onTapRevokerCallback;

  const ChatItemView({
    Key? key,
    required this.index,
    required this.isSingleChat,
    required this.message,
    // this.quoteMessage,
    this.customItemBuilder,
    this.onItemClick,
    this.msgSendStatusSubject,
    this.msgSendProgressSubject,
    // required this.downloadProgressSubject,
    this.isBubbleMsg = true,
    // this.width = 100,
    this.leftBubbleColor = const Color(0xFFF0F0F0),
    this.rightBubbleColor = const Color(0xFFDCEBFE),
    this.onLongPressRightAvatar,
    this.onTapRightAvatar,
    this.onLongPressLeftAvatar,
    this.onTapLeftAvatar,
    this.visibilityChange,
    this.allAtMap = const {},
    this.onClickAtText,
    this.menus,
    this.menuStyle,
    this.padding,
    this.margin,
    this.textStyle,
    this.atTextStyle,
    this.urlTextStyle,
    this.timeStyle,
    this.hintTextStyle,
    this.avatarSize,
    // this.showTime = false,
    this.timeStr,
    this.onTapCopyMenu,
    this.onTapDelMenu,
    this.onTapForwardMenu,
    this.onTapReplyMenu,
    this.onTapRevokeMenu,
    this.onTapMemoMenu,
    this.onTapMultiMenu,
    this.onTapTranslationMenu,
    this.enabledCopyMenu,
    this.enabledMultiMenu,
    this.enabledDelMenu,
    this.enabledForwardMenu,
    this.enabledReplyMenu,
    this.enabledRevokeMenu,
    this.enabledMemoMenu,
    this.enabledTranslationMenu,
    this.multiSelMode = false,
    this.onMultiSelChanged,
    this.multiList = const [],
    this.onTapQuoteMsg,
    this.patterns = const [],
    this.delaySendingStatus = false,
    this.enabledReadStatus = true,
    this.isExpanded,
    this.onTapExpanded,
    this.resendMsg,
    this.onTapMarkDown,
    this.onTapMarkDownImg,
    this.conversationName,
    this.setPermission,
    this.onTapCloudDoc,
    this.memberCount,
    this.onTapReadView,
    this.hasReadCount,
    this.onReplayWithFace,
    this.onTapUser,
    this.onTapUnShowReplyUser,
    this.isVoiceUnread = false,
    this.groupArchived = false,
    this.onTapDocOperator,
    this.onTapDocUrl,
    this.onClickVoice,
    this.fileIcon,
    this.onTapRevokerCallback,
  }) : super(key: key);

  @override
  _ChatItemViewState createState() => _ChatItemViewState();
}

class _ChatItemViewState extends State<ChatItemView> {
  final _popupCtrl = CustomPopupMenuController();

  bool get _isFromMsg => widget.message.sendID != OpenIM.iMManager.uid;

  bool get _checked => widget.multiList.contains(widget.message);

  bool _isMarkDownFormat = false;
  bool _isTableElement = false;
  String _destination = "";
  bool _isAssistant = false; // 是否是机器人发的消息
  var _isHintMsg = false;
  String? imageDirectory;
  String? markDownContent;
  // String permisstionStr = "";

  bool isFullGroup = false;
  var _hintTextStyle = TextStyle(
    color: Color(0xFF999999),
    fontSize: 12.sp,
  );

  @override
  void initState() {
    // bus.on("doc_permisstion", (arg) {
    //   int permission = arg["p"];
    //   String id = arg["id"];
    //   if (id == widget.message.clientMsgID) {
    //     setState(() {
    //       if (permission == 1) {
    //         permisstionStr = UILocalizations.canRead;
    //       } else if (permission == 2) {
    //         permisstionStr = UILocalizations.canEdit;
    //       } else {
    //         permisstionStr = UILocalizations.canManage;
    //       }
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    // bus.off("doc_permisstion");
    _popupCtrl.dispose();
    super.dispose();
  }

  bool needHideMessage() {
    int type = widget.message.contentType ?? 0;
    bool isHideType = type == MessageType.memberInvitedNotification ||
        type == MessageType.memberEnterNotification ||
        type == MessageType.memberQuitNotification ||
        type == MessageType.memberKickedNotification;
    bool friendHandle =
        widget.message.contentType == MessageType.friendAddedNotification;
    bool profile = widget.message.contentType == 1398;
    if ((isFullGroup && isHideType) || friendHandle || profile) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget? child;
    // custom view
    var view = _customItemView();
    if (null != view) {
      if (widget.isBubbleMsg) {
        child = _buildCommonItemView(child: view);
      } else {
        child = view;
      }
    } else {
      child = _buildItemView();
    }
    // if (needHideMessage()) return Container();
    return FocusDetector(
      child: Container(
        color: _checked ? Color(0xFFF9F9F9) : Colors.white,
        padding: widget.padding ??
            EdgeInsets.fromLTRB(
              widget.multiSelMode && !_isHintMsg ? 0 : 22.w,
              0,
              22.w,
              _isHintMsg ? 5.h : 15.h,
            ),
        margin: widget.margin,
        child: child,
      ),
      onVisibilityLost: () {
        if (widget.visibilityChange != null) {
          widget.visibilityChange!(
            context,
            widget.index,
            widget.message,
            false,
          );
        }
      },
      onVisibilityGained: () {
        if (widget.visibilityChange != null) {
          widget.visibilityChange!(
            context,
            widget.index,
            widget.message,
            true,
          );
        }
      },
    );
  }

  bool didExceedMaxLines(Message message) {
    String? text;
    if (message.contentType == MessageType.text) {
      text = message.content;
      if (_isMarkDownFormat) {
        return false;
      }
    } else if (message.contentType == MessageType.quote) {
      text = message.quoteElem?.text;
    }
    return CommonUtil.didExceedMaxLines(
      content: text ?? "",
      maxLine: 10,
      maxWidth: .65.sw,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16.sp,
      ),
    );
  }

  Widget expandView(
    Widget bubleView, {
    required String text,
    required TextStyle textStyle,
    required List<MatchPattern> patterns,
    required Map<String, String> allAtMap,
    required List<String> hasReadList,
    required bool isSender,
  }) {
    // bool didExceedMaxLines = CheckExceedMaxLines.didExceedMaxLines(
    //   text: text,
    //   textStyle: textStyle,
    //   patterns: patterns,
    //   allAtMap: allAtMap,
    //   hasReadList: hasReadList,
    //   isSender: isSender,
    // );
    // bool show = didExceedMaxLines &&
    bool show = didExceedMaxLines(widget.message) &&
        widget.isExpanded == false &&
        (widget.message.contentType == MessageType.text ||
            widget.message.contentType == MessageType.quote);
    Widget child = show
        ? ConstrainedBox(
            child: bubleView,
            constraints: BoxConstraints(minWidth: 0.65.sw),
          )
        : bubleView;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        child,
        if (show)
          GestureDetector(
            onTap: widget.onTapExpanded,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 0.65.sw + 20.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                      ImageUtil.imageResStr("mask_group"),
                      package: 'flutter_openim_widget',
                    )),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.w),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                  ),
                  child: Text(
                    UILocalizations.spread,
                    style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          )
        else
          Container(),
      ],
    );
  }

  bool isMarkDownFormat(String content) {
    print("start=====${DateTime.now().millisecondsSinceEpoch}");
    final md.Document document = md.Document(
      inlineSyntaxes: (<md.InlineSyntax>[])..add(TaskListSyntax()),
      extensionSet: md.ExtensionSet.gitHubFlavored,
      encodeHtml: false,
    );

    final List<String> lines = const LineSplitter().convert(content);
    final List<md.Node> astNodes = document.parseLines(lines);
    List<String> _kBlockTags = <String>[
      'h1',
      'h2',
      'h3',
      'h4',
      'h5',
      'h6',
      'li',
      'blockquote',
      'pre',
      'ol',
      'ul',
      'hr',
      'table',
      'thead',
      'tbody',
      'tr'
    ];
    bool hasNode = false;
    astNodes.forEach((element) {
      try {
        md.Element ele = element as md.Element;
        if (_kBlockTags.contains(ele.tag)) {
          if ((ele.children is List) && ele.children!.length >= 1) {
            if (ele.children![0] is md.Element) {
              hasNode = (ele.children![0] as md.Element).children!.length > 0;
            } else {
              hasNode = true;
            }
          } else {
            hasNode = false;
          }
        }
        if (ele.tag == "table") {
          _isTableElement = true;
        }
        enumElement(ele);
      } catch (e) {}
    });
    print("end=====${DateTime.now().millisecondsSinceEpoch}");
    return hasNode;
  }

  void enumElement(md.Element element) {
    if (element.tag == 'a') {
      String temp = element.attributes['href'] ?? "";
      if (temp.isNotEmpty) _destination = temp;
      return;
    }
    if (element.children != null) {
      element.children!.forEach((ele) {
        if (ele.runtimeType == md.Element) enumElement(ele as md.Element);
      });
    }
  }

  Widget imageBuilder(Uri uri) {
    if (uri.scheme == 'http' || uri.scheme == 'https') {
      return Image.network(
        uri.toString(),
        width: .65.sw,
        fit: BoxFit.fitWidth,
      );
    } else if (uri.scheme == 'data') {
      final String mimeType = uri.data!.mimeType;
      if (mimeType.startsWith('image/')) {
        return Image.memory(
          uri.data!.contentAsBytes(),
          width: .65.sw,
          fit: BoxFit.fitWidth,
        );
      } else if (mimeType.startsWith('text/')) {
        return Text(uri.data!.contentAsString());
      }
      return const SizedBox();
    } else if (uri.scheme == 'resource') {
      return Image.asset(
        uri.path,
        width: .65.sw,
        fit: BoxFit.fitWidth,
      );
    } else {
      final Uri fileUri = imageDirectory != null
          ? Uri.parse(imageDirectory! + uri.toString())
          : uri;
      if (fileUri.scheme == 'http' || fileUri.scheme == 'https') {
        return Image.network(
          uri.toString(),
          width: .65.sw,
          fit: BoxFit.fitWidth,
        );
      } else {
        return Image.file(
          File.fromUri(uri),
          width: .65.sw,
          fit: BoxFit.fitWidth,
        );
      }
    }
  }

  Widget? _buildMarkDownWidget(String text) {
    markDownContent = replaceSpecialChar(text);
    Widget content = Container(
      constraints: _isTableElement
          ? BoxConstraints(maxWidth: 0.65.sw, maxHeight: 200.w)
          : BoxConstraints(maxWidth: 0.65.sw),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: MarkdownBody(
          imageDirectory: imageDirectory,
          fitContent: true,
          shrinkWrap: true,
          data: text,
          selectable: false,
          styleSheet: MarkdownStyleSheet(
              tableColumnWidth: FixedColumnWidth(.65.sw / 2.5),
              tableCellsPadding: EdgeInsets.all(10.w),
              tableBorder: TableBorder.all(
                color: Color(0xFF333333),
                width: 1.w,
              ),
              blockquoteDecoration: BoxDecoration(
                color: Colors.transparent,
              )),
          imageBuilder: (Uri uri, String? title, String? alt) {
            return GestureDetector(
              child: imageBuilder(uri),
              onTap: () {
                try {
                  widget.onTapMarkDownImg!(uri.toString());
                } catch (e) {}
              },
            );
          },
          onTapLink: (String text, String? href, String title) {
            print(text);
            widget.onTapMarkDown!(_isTableElement, href,
                content: markDownContent);
          },
        ),
      ),
    );
    Widget child = Column(
      children: [
        _buildCommonItemView(
            isBubbleBg: true,
            child:
                // _isTableElement
                //     ?
                GestureDetector(
              onTap: () {
                widget.onTapMarkDown!(_isTableElement, null,
                    content: markDownContent);
              },
              child: content,
            )
            // : content,
            ),
        SizedBox(
          height: 10.w,
        ),
        // if (!_isTableElement && _isAssistant)
        // Row(
        //   children: [
        //     Spacer(),
        //     Container(
        //       width: 90.w,
        //       height: 1.w,
        //       color: Color(0xFFDDDDDD),
        //     ),
        //     GestureDetector(
        //       onTap: () {
        //         widget.onTapMarkDown!(_isTableElement, _destination,
        //             content: markDownContent);
        //       },
        //       child: Container(
        //         alignment: Alignment.center,
        //         width: 90.w,
        //         height: 30.w,
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(18.w),
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.black.withAlpha(25),
        //                 blurRadius: 8.w,
        //                 spreadRadius: 1.w,
        //               ),
        //             ]),
        //         child: Text(
        //           "${UILocalizations.seeDetails}",
        //           style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
        //         ),
        //       ),
        //     ),
        //     Container(
        //       width: 90.w,
        //       height: 1.w,
        //       color: Color(0xFFDDDDDD),
        //     ),
        //     Spacer(),
        //   ],
        // ),
      ],
    );
    if (_isTableElement) {
      return Stack(alignment: Alignment.bottomRight, children: [
        child,
        GestureDetector(
          onTap: () {
            widget.onTapMarkDown!(_isTableElement, null,
                content: markDownContent);
          },
          child: Padding(
            padding: EdgeInsets.only(right: 45.w),
            child: ImageUtil.assetImage("msg_but_excel_full",
                width: 20.w, height: 20.w),
          ),
        ),
      ]);
    }
    return child;
  }

  Widget? _buildItemView() {
    Widget? child;
    switch (widget.message.contentType) {
      case MessageType.text:
        {
          _isMarkDownFormat = isMarkDownFormat(widget.message.content!);
          if (_isMarkDownFormat) {
            child = _buildMarkDownWidget(widget.message.content!);
          } else {
            child = _buildCommonItemView(
              child: ChatAtText(
                text: replaceSpecialChar(widget.message.content!),
                maxLines: widget.isExpanded == true ? null : 10,
                allAtMap: {},
                textStyle: widget.textStyle,
                patterns: widget.patterns,
                hasReadList: widget.message.attachedInfoElem?.groupHasReadInfo
                    ?.hasReadUserIDList,
                isSender: widget.message.sendID == OpenIM.iMManager.uid,
                atUserInfos: widget.message.atElem?.atUsersInfo,
              ),
            );
          }
        }
        break;
      case MessageType.at_text:
        {
          Map map = json.decode(widget.message.content!);
          var text = map['text'];
          child = _buildCommonItemView(
            child: ChatAtText(
              text: replaceSpecialChar(text),
              allAtMap: widget.allAtMap,
              textStyle: widget.textStyle,
              patterns: widget.patterns,
              hasReadList: widget.message.attachedInfoElem?.groupHasReadInfo
                  ?.hasReadUserIDList,
              isSender: widget.message.sendID == OpenIM.iMManager.uid,
              atUserInfos: widget.message.atElem?.atUsersInfo,
            ),
          );
        }
        break;
      case MessageType.picture:
        {
          var picture = widget.message.pictureElem;
          var width = picture?.sourcePicture?.width ?? 0;
          var height = picture?.sourcePicture?.height ?? 0;
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatPictureView(
              msgId: widget.message.clientMsgID!,
              isReceived: _isFromMsg,
              snapshotPath: null,
              snapshotUrl: picture?.snapshotPicture?.url,
              sourcePath: picture?.sourcePath,
              sourceUrl: picture?.sourcePicture?.url,
              width: width.toDouble(),
              height: height.toDouble(),
              widgetWidth: width > height ? 226.w : 100.w,
              msgSenProgressStream: widget.msgSendProgressSubject?.stream,
              initMsgSendProgress: 100,
              index: widget.index,
            ),
          );
        }
        break;
      case MessageType.voice:
        {
          var sound = widget.message.soundElem;
          child = _buildCommonItemView(
            child: ChatVoiceView(
              index: widget.index,
              // clickStream: widget.clickSubject.stream,
              isReceived: _isFromMsg,
              soundPath: sound?.soundPath,
              soundUrl: sound?.sourceUrl,
              duration: sound?.duration,
              onClick: widget.onClickVoice,
              ex: widget.message.ex,
              voiceUnreadView:
                  widget.isVoiceUnread == true ? _buildVoiceUnread() : null,
            ),
          );
        }
        break;
      case MessageType.video:
        {
          var video = widget.message.videoElem;
          var width = video?.snapshotWidth ?? 0;
          var height = video?.snapshotHeight ?? 0;
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatVideoView(
              msgId: widget.message.clientMsgID!,
              isReceived: _isFromMsg,
              snapshotPath: video?.snapshotPath,
              snapshotUrl: video?.snapshotUrl,
              videoPath: video?.videoPath,
              videoUrl: video?.videoUrl,
              width: width.toDouble(),
              height: height.toDouble(),
              widgetWidth: width > height ? 226.w : 100.w,
              msgSenProgressStream: widget.msgSendProgressSubject?.stream,
              initMsgSendProgress: 100,
              index: widget.index,
            ),
          );
        }
        break;
      case MessageType.file:
        {
          var file = widget.message.fileElem;
          child = _buildCommonItemView(
            child: ChatFileView(
              msgId: widget.message.clientMsgID!,
              fileName: file!.fileName!,
              // filePath: file.filePath!,
              // url: file.sourceUrl!,
              bytes: file.fileSize ?? 0,
              width: .65.sw,
              initProgress: 100,
              uploadStream: widget.msgSendProgressSubject?.stream,
              index: widget.index,
              fileIcon: widget.fileIcon,
            ),
          );
        }
        break;
      case MessageType.location:
        {
          var location = widget.message.locationElem;
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatLocationView(
              description: location!.description!,
              latitude: location.latitude!,
              longitude: location.longitude!,
            ),
          );
        }
        break;
      case MessageType.quote:
        {
          child = _buildCommonItemView(
            child: ChatAtText(
              text: replaceSpecialChar(widget.message.quoteElem?.text ?? ''),
              allAtMap: widget.allAtMap,
              textStyle: widget.textStyle,
              patterns: widget.patterns,
              maxLines: widget.isExpanded == true ? null : 10,
              hasReadList: widget.message.attachedInfoElem?.groupHasReadInfo
                  ?.hasReadUserIDList,
              isSender: widget.message.sendID == OpenIM.iMManager.uid,
              atUserInfos: widget.message.atElem?.atUsersInfo,
            ),
          );
        }
        break;
      case MessageType.merger:
        {
          child = _buildCommonItemView(
            child: ChatMergeMsgView(
              title: widget.message.mergeElem?.title ?? '',
              summaryList: widget.message.mergeElem?.abstractList ?? [],
            ),
          );
        }
        break;
      case MessageType.card:
        {
          var data = json.decode(widget.message.content!);
          child = _buildCommonItemView(
            isBubbleBg: false,
            child: ChatCarteView(
              name: data['name'],
              url: data['icon'],
            ),
          );
        }
        break;
      case MessageType.revoke:
        {
          child = _buildCommonItemView(
            child: ChatRevokeView(
              message: widget.message,
              onTap: () {
                widget.onItemClick?.call(widget.message);
              },
            ),
            isBubbleBg: true,
          );
        }
        break;
      case MessageType.advancedRevoke:
        {
          child = _buildCommonItemView(
            child: ChatRevokeView(
              message: widget.message,
              onTap: () {
                widget.onItemClick?.call(widget.message);
              },
              onTapRevokerCallback: (uid) =>
                  widget.onTapRevokerCallback?.call(uid),
            ),
            isBubbleBg: true,
          );
        }
        break;
      default:
        {
          try {
            _isHintMsg = true;
            var text;
            if (MessageType.revoke == widget.message.contentType) {
              var who = _isFromMsg
                  ? widget.message.senderNickname
                  : UILocalizations.you;
              text = '$who ${UILocalizations.revokeAMsg}';
            } else if (MessageType.advancedRevoke ==
                widget.message.contentType) {
              var advancedRevokedInfo;
              if (widget.message.ex!.length > 0) {
                advancedRevokedInfo = json.decode(widget.message.ex!);
              } else if (widget.message.content!.length > 0) {
                RevokedInfo revokedInfo =
                    RevokedInfo.fromJson(json.decode(widget.message.content!));
                advancedRevokedInfo = {
                  "revoke_role": revokedInfo.revokerRole,
                  "revoke_user_name": revokedInfo.revokerNickname,
                  "revoke_user_id": revokedInfo.revokerID
                };
              } else {
                advancedRevokedInfo = {
                  "revoke_role": 0,
                  "revoke_user_name": '',
                };
              }
              var who = advancedRevokedInfo['revoke_user_name'];
              text = '$who ${UILocalizations.revokeAMsg}';
            } else if (MessageType.custom == widget.message.contentType) {
              var result = parseCustomMsg();
              if (result.runtimeType == String) {
                text = result;
              } else {
                /// widget
                return result;
              }
            } else {
              try {
                var content = json.decode(widget.message.content!);
                text = content['defaultTips'];
                String jsonDetail = content["jsonDetail"];
                Map detail = json.decode(jsonDetail);
                try {
                  isFullGroup = detail["group"]["groupType"] == 1000;
                } catch (e) {}
              } catch (e) {
                text = UILocalizations.unsupportedMessage; // 避免打印消息体
              }
            }
            child = _buildCommonItemView(
              isBubbleBg: null == text ? true : false,
              isHintMsg: null == text ? false : true,
              child: ChatAtText(
                text: text ?? UILocalizations.unsupportedMessage,
                allAtMap: {},
                textAlign: TextAlign.center,
                // enabled: false,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                textStyle: null != text
                    ? widget.hintTextStyle ?? _hintTextStyle
                    : widget.textStyle,
                hasReadList: widget.message.attachedInfoElem?.groupHasReadInfo
                    ?.hasReadUserIDList,
                atUserInfos: widget.message.atElem?.atUsersInfo,
              ),
            );
          } catch (e) {
            print(e);
          }
        }
        break;
    }
    return child;
  }

  String replaceSpecialChar(String content) {
    var ampReg = RegExp(r'&amp;');
    return content.replaceAll(ampReg, '&');
  }

  dynamic parseCustomMsg() {
    try {
      String data = widget.message.customElem?.data ?? "";
      Map map = json.decode(data);
      String type = map["type"];
      Map<String, dynamic> opData;
      if (map["data"].runtimeType == String) {
        opData = json.decode(map["data"]);
      } else {
        opData = map["data"];
      }
      if (type == "add_administrator_notification") {
        String nickName1 = opData["opUser"]["nickname"];
        List adminUsers = opData["adminUser"];
        String nickName2 = "";
        adminUsers.forEach((element) {
          nickName2 += element["nickname"];
          if (element != adminUsers.last) nickName2 += ",";
        });
        return sprintf(UILocalizations.addAdmin, [nickName1, nickName2]);
      } else if (type == "remove_administrator_notification") {
        String nickName1 = opData["opUser"]["nickname"];
        List adminUsers = opData["adminUser"];
        String nickName2 = "";
        adminUsers.forEach((element) {
          nickName2 += element["nickname"];
          if (element != adminUsers.last) nickName2 += ",";
        });
        return sprintf(UILocalizations.removeAdmin, [nickName1, nickName2]);
      } else if (type == "webhook_del") {
        String nickName1 = opData["opUser"]["nickname"];
        List adminUsers = opData["webhookList"];
        String nickName2 = "";
        adminUsers.forEach((element) {
          nickName2 += element["displayName"];
          if (element != adminUsers.last) nickName2 += ",";
        });
        return sprintf(UILocalizations.removeFromGroup, [nickName1, nickName2]);
      } else if (type == "webhook_add") {
        String nickName1 = opData["opUser"]["nickname"];
        List adminUsers = opData["webhookList"];
        String nickName2 = "";
        adminUsers.forEach((element) {
          nickName2 += element["displayName"];
          if (element != adminUsers.last) nickName2 += ",";
        });
        return sprintf(UILocalizations.addToGroup, [nickName1, nickName2]);
      } else if (type == "cloud_doc") {
        return _buildCloudDocChildItem(opData,
            isSender: widget.message.sendID == OpenIM.iMManager.uid);
      } else if (type == "applet") {
      } else if (type == "webhook") {
        _isMarkDownFormat = isMarkDownFormat(opData["data"]);
        _isMarkDownFormat = true;
        if (_isMarkDownFormat) {
          _isAssistant = true;
          return _buildMarkDownWidget(opData["data"]);
        }
        return opData["data"];
      } else if (type.startsWith('task_')) {
        if ("task_assistant" == type) {
          TaskAssistantModel assistantModel =
              TaskAssistantModel.fromJson(opData);
          return _buildCommonItemView(
            isBubbleBg: false,
            child: ChatItemTaskAssistantView(
              assistantModel,
              onTapDocOperator: widget.onTapDocOperator,
            ),
          );
        }
        String nickName1 = opData["opUser"]["nickname"];
        return nickName1 + " " + opData["msg"];
      } else if (type.startsWith('goal_')) {
        String nickName1 = opData["opUser"]["nickname"];
        return nickName1 + " " + opData["msg"];
      } else if (type.startsWith('memo_')) {
        String nickName1 = widget.message.senderNickname ?? '';
        return nickName1 + " " + opData["noticeValue"]["memo_notice"];
      } else if (type == "cloud_doc_assistant") {
        ChatDocAssistantModel model = ChatDocAssistantModel.fromJson(opData);
        return _buildCommonItemView(
          isBubbleBg: false,
          child: ChatItemDocAssistantView(
            model,
            onTapDocOperator: widget.onTapDocOperator,
            onTapDocUrl: widget.onTapDocUrl,
          ),
        );
      } else if (type == "folderMessage" || type == "cloud_excel") {
        return _buildCloudDocChildItem(opData,
            isSender: widget.message.sendID == OpenIM.iMManager.uid,
            type: type);
      } else if (type == "bi_data") {
        return _buildCommonItemView(
          isBubbleBg: true,
          child: _buildBiDataItem(widget.message.content ?? ""),
        );
      } else if (type.startsWith('begin_meeting')) {
        String nickName1 = widget.message.senderNickname ?? '';
        return nickName1 + "发起了会议";
      } else if (type.startsWith('end_meeting')) {
        int min =
            ((widget.message.sendTime! - opData["beginTime"]) / 1000 ~/ 60 + 1)
                .ceil();
        return "会议已结束 时长$min分钟";
      } else if (type == 'report_week_assistant') {
        return "${opData["user_name"]}给你分享了一份周报，请到电脑上查看";
      }
    } catch (e) {
      print(e.toString());
    }
    return Container();
  }

  Widget _buildBiDataItem(String content) {
    Map js = json.decode(content);
    js = json.decode(js["data"]);
    js = js["data"]["bi_data"];
    String title = js["card_name"];
    String lastUpdateTime = "最后更新时间：${js["data_updated_at"]}";
    String publisher =
        "发布人：${js["creator"]}（${js["push_day"] + js["push_time"]}推送）";
    // String per_push = "推送频率：${js["push_day"] + js["push_time"]}";
    String snap_url = "${js["card_screenshot_url"]}";
    return Container(
      constraints: BoxConstraints(maxWidth: .65.sw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Color(0xFF333333),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
            maxLines: 10,
          ),
          SizedBox(
            height: 5.w,
          ),
          Text(
            "$lastUpdateTime\n$publisher",
            style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
            maxLines: 10,
          ),
          SizedBox(
            height: 5.w,
          ),
          GestureDetector(
            onTap: () {
              if (widget.onTapMarkDownImg != null)
                widget.onTapMarkDownImg!(snap_url);
            },
            child: CachedNetworkImage(
              imageUrl: snap_url,
              imageBuilder: (
                BuildContext context,
                ImageProvider imageProvider,
              ) {
                Image img = Image(
                  image: imageProvider,
                  fit: BoxFit.fill,
                );
                return Container(
                  width: .65.sw,
                  child: img,
                );
              },
            ),
          ),
          Container(
            height: 21,
            alignment: Alignment.center,
            child: Container(
              color: Color(0xFFDDDDDD),
              height: 1.w,
              width: .65.sw,
            ),
          ),
          Text(
            "更多详情，请使用Mind电脑端查看",
            style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildCloudDocChildItem(Map<String, dynamic> map,
      {required bool isSender, String? type}) {
    CloudDocMessageModel model = CloudDocMessageModel.fromJson(map);
    Map params;
    if (model.params is Map) {
      params = model.params!;
    } else {
      params = json.decode(model.params!);
    }
    String snapShot = params.keys.contains("padSnapshot") &&
            ((params['padSnapshot'] ?? '') as String).isNotEmpty
        ? params["padSnapshot"]
        : params["textSnapshot"];
    String remark = params['remark'] ?? "";
    int permission =
        model.permission?.permission ?? 1; // 0: 不可见 1: 可读 2: 可编辑 3: 所有权限（可设置权限）
    int recvPermission = model.recieverPermission ?? 1;
    int shareType =
        model.permission?.padConfigShareType ?? 0; // 0: 不分享，1:链接分享 2：协作者
    String? permissionStr;
    Widget? permissionWidget;

    String recieverDes =
        isSender ? widget.conversationName! : UILocalizations.you;
    if (recvPermission == 1) {
      permissionStr = recieverDes + UILocalizations.canRead;
    } else {
      permissionStr = recieverDes + UILocalizations.canEdit;
    }

    // if (isSender) {
    //   String recieverDes = widget.isSingleChat
    //       ?
    //       : UILocalizations.grantThisSessionMemberPermissions;
    //   if (permission == 0) {
    //     permissionWidget = Container();
    //   } else if (permission == 1) {
    //     if (recvPermission == 0)
    //       permissionWidget = Container();
    //     else if (recvPermission == 1) {
    //       permissionStr = recieverDes + UILocalizations.canRead;
    //     } else {
    //       permissionStr = recieverDes + UILocalizations.canEdit;
    //     }
    //   } else if (permission == 2 || permission == 3) {
    //     permissionWidget = Row(
    //       children: [
    //         Flexible(
    //           child: Text(
    //             recieverDes,
    //             overflow: TextOverflow.ellipsis,
    //             maxLines: 1,
    //             style: TextStyle(
    //               color: Color(0xFF333333),
    //               fontSize: 14.sp,
    //             ),
    //           ),
    //         ),
    //         SizedBox(
    //           width: 4.w,
    //         ),
    //         GestureDetector(
    //           onTap: () => widget.setPermission!(permission),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Text(
    //                 recvPermission == 1
    //                     ? UILocalizations.canRead
    //                     : UILocalizations.canEdit,
    //                 overflow: TextOverflow.ellipsis,
    //                 maxLines: 1,
    //                 style: TextStyle(
    //                   color: Color(0xFF006DFA),
    //                   fontSize: 14.sp,
    //                 ),
    //               ),
    //               ImageUtil.assetImage(
    //                 "msg_but_unfold",
    //                 width: 12.w,
    //                 height: 12.w,
    //               )
    //             ],
    //           ),
    //         )
    //       ],
    //     );
    //   }
    // } else {
    //   if (recvPermission == 0)
    //     permissionWidget = Container();
    //   else if (recvPermission == 1) {
    //     permissionStr = UILocalizations.you + UILocalizations.canRead;
    //   } else {
    //     permissionStr = UILocalizations.you + UILocalizations.canEdit;
    //   }
    // }
    return _buildCommonItemView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: .65.sw,
        ),
        child: GestureDetector(
          onTap: widget.onTapCloudDoc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (remark.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    remark,
                    style: TextStyle(color: Color(0xFF333333), fontSize: 16.sp),
                  ),
                ),
              Row(
                children: [
                  ImageUtil.assetImage(
                    type == "folderMessage"
                        ? "msg_icon_file"
                        : type == "cloud_excel"
                            ? "msg_icon_excel"
                            : "msg_icon_document",
                    width: 16.w,
                    height: 16.w,
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  Flexible(
                    child: Text(
                      model.permission?.title ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Color(0xFF006DFA),
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.w,
              ),
              Container(
                width: .65.sw,
                height: 214.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.w),
                ),
                padding: EdgeInsets.all(10.w),
                child: _buildContentView(
                    snapShot: snapShot,
                    permissionStr: permissionStr,
                    permissionWidget: permissionWidget,
                    isFolder: type == "folderMessage"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentView(
      {bool? isFolder,
      required String snapShot,
      String? permissionStr,
      Widget? permissionWidget}) {
    if (isFolder == true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: ImageUtil.assetImage(
                "folder_large",
                scale: 114 / 60,
              ),
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Container(
            color: Color(0xFFDDDDDD),
            height: 1.w,
          ),
          SizedBox(
            height: 10.w,
          ),
          permissionStr != null
              ? Text(
                  permissionStr,
                  style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
                )
              : permissionWidget!,
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: snapShot.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: snapShot,
                    fit: BoxFit.fill,
                  )
                : Text(
                    snapShot,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 100,
                    style: TextStyle(
                      color: Color(0XFF333333),
                      fontSize: 14.sp,
                    ),
                  ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Container(
            color: Color(0xFFDDDDDD),
            height: 1.w,
          ),
          SizedBox(
            height: 10.w,
          ),
          permissionStr != null
              ? Text(
                  permissionStr,
                  style: TextStyle(color: Color(0xFF333333), fontSize: 14.sp),
                )
              : permissionWidget!,
        ],
      );
    }
  }

  Widget _buildCommonItemView({
    required Widget child,
    bool isBubbleBg = true,
    bool isHintMsg = false,
  }) =>
      ChatSingleLayout(
        child: child,
        msgId: widget.message.clientMsgID!,
        index: widget.index,
        menuBuilder: _menuBuilder,
        onItemClick: () {
          widget.onItemClick?.call(widget.message);
        },
        sendStatusStream: widget.msgSendStatusSubject?.stream,
        popupCtrl: _popupCtrl,
        isReceivedMsg: _isFromMsg,
        isSingleChat: widget.isSingleChat,
        avatarSize: widget.avatarSize ?? 42.h,
        rightAvatar: OpenIM.iMManager.uInfo.faceURL ?? "",
        leftAvatar: widget.message.senderFaceUrl ?? "",
        leftName: widget.message.senderNickname ?? "",
        isUnread: widget.message.isRead != true,
        leftBubbleColor: widget.leftBubbleColor,
        rightBubbleColor: widget.rightBubbleColor,
        onLongPressRightAvatar: widget.onLongPressRightAvatar,
        onTapRightAvatar: widget.onTapRightAvatar,
        onLongPressLeftAvatar: widget.onLongPressLeftAvatar,
        onTapLeftAvatar: () {
          generateOnTapLeftAvatar();
        },
        isSendFailed: widget.message.status == MessageStatus.failed,
        isSending: widget.message.status == MessageStatus.sending,
        timeView: widget.timeStr == null ? null : _buildTimeView(),
        isBubbleBg: isBubbleBg,
        isHintMsg: isHintMsg,
        quoteView: widget.message.contentType == MessageType.quote
            ? ChatQuoteView(
                message: widget.message,
                onTap: widget.onTapQuoteMsg,
                allAtMap: widget.allAtMap,
                patterns: widget.patterns,
              )
            : null,
        showRadio: widget.multiSelMode,
        checked: _checked,
        onRadioChanged: widget.onMultiSelChanged,
        delaySendingStatus: widget.delaySendingStatus,
        enabledReadStatus: widget.enabledReadStatus,
        expandView: (bubleView) {
          return expandView(bubleView,
              text: replaceSpecialChar(widget.message.content ?? ""),
              textStyle: widget.textStyle ??
                  TextStyle(
                      color: Color(0xFF111111),
                      fontSize: 16.sp,
                      letterSpacing: .3),
              patterns: widget.patterns,
              allAtMap: widget.allAtMap,
              hasReadList: widget.message.attachedInfoElem?.groupHasReadInfo
                      ?.hasReadUserIDList ??
                  [],
              isSender: widget.message.sendID == OpenIM.iMManager.uid);
        },
        enableMultiSel: widget.message.contentType != MessageType.revoke &&
            widget.message.contentType != MessageType.advancedRevoke &&
            !isHintMsg,
        messageType: widget.message.contentType,
        resendMsg: widget.resendMsg,
        groupHaveReadCount:
            widget.message.attachedInfoElem?.groupHasReadInfo?.hasReadCount ??
                0,
        groupMemberCount: widget.memberCount ?? 0,
        onTapReadView: widget.onTapReadView,
        isSelfChat: widget.message.recvID == OpenIM.iMManager.uid,
        faceReplyView: _buildFaceReplyView(),
        voiceUnreadView:
            widget.isVoiceUnread == true ? _buildVoiceUnread() : null,
      );

  Widget _buildVoiceUnread() {
    var badgeWidth = 8.w;
    return Container(
      width: badgeWidth,
      height: badgeWidth,
      margin: EdgeInsets.symmetric(
        vertical: 15.w,
        horizontal: 4.w,
      ),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(badgeWidth / 2)),
      ),
    );
  }

  void generateOnTapLeftAvatar() {
    if (widget.message.contentType == MessageType.custom) {
      String data = widget.message.customElem?.data ?? "";
      Map map = json.decode(data);
      String type = map["type"];
      if (type == "cloud_doc_assistant" || type == "task_assistant") {
        return;
      }
    }
    widget.onTapLeftAvatar?.call();
  }

  Widget? _buildFaceReplyView() {
    ChatFaceReplyListModel listModel = ChatFaceReplyListModel(dataList: []);
    if (widget.message.ex != null &&
        widget.message.contentType != MessageType.revoke &&
        widget.message.contentType != MessageType.advancedRevoke) {
      try {
        var obj = json.decode(widget.message.ex ?? "");
        if (obj is Map) {
          if (obj.keys.contains("quick_reply"))
            listModel = ChatFaceReplyListModel.fromJson(obj["quick_reply"]);
        } else {
          listModel = ChatFaceReplyListModel.fromJson(obj);
        }
      } catch (e) {}
    }
    if (listModel.dataList.length <= 0) return null;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: .65.sw),
      child: Wrap(
        spacing: 6.w,
        runSpacing: 6.w,
        alignment: WrapAlignment.start,
        children: listModel.dataList
            .map((e) => _buildFaceReplyCell(e, listModel.dataList.indexOf(e)))
            .toList(),
      ),
    );
  }

  bool didReplyWithThisEmoji(String emojiName) {
    if (widget.message.ex == null || widget.message.ex!.isEmpty) return false;
    ChatFaceReplyListModel listModel =
        ChatFaceReplyListModel.fromString(widget.message.ex ?? "[]");
    if (listModel.dataList.length <= 0) return false;
    int index =
        listModel.dataList.indexWhere((element) => element.emoji == emojiName);
    if (index == -1) return false;
    ChatFaceReplyModel model = listModel.dataList.elementAt(index);
    int user =
        model.user!.indexWhere((element) => element.id == OpenIM.iMManager.uid);
    return user != -1;
  }

  Widget _buildFaceReplyCell(ChatFaceReplyModel replay, int index) {
    String? emoji = emojiFaces[replay.emoji];
    List<User> users = replay.user!;
    List<InlineSpan> children = [
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: widget.groupArchived
              ? null
              : () {
                  if (widget.onReplayWithFace != null)
                    widget.onReplayWithFace!(
                      replay.emoji!,
                      widget.index,
                      isResignReply: didReplyWithThisEmoji(replay.emoji!),
                    );
                },
          child: ImageUtil.faceImage(
            emoji ?? "",
            width: 18.w,
            height: 18.w,
          ),
        ),
      ),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Container(
            width: 1.w,
            height: 16.w,
            color: Color(0xFF333333).withAlpha(25),
          ),
        ),
      ),
    ];
    String userStr = '';
    int showCount = 0;
    List<User> userList =
        users.where((element) => element.id == OpenIM.iMManager.uid).toList();
    if (userList.isNotEmpty) {
      User user = userList.first;
      users.remove(user);
      users.insert(0, user);
    }
    for (int i = 0; i < users.length; i++) {
      User e = users[i];
      String name = e == users.last ? (e.name ?? '') : "${e.name ?? ''}, ";
      userStr = userStr + name;
      if (CommonUtil.didExceedMaxLines(
        content: userStr,
        maxLine: 1,
        maxWidth: 190.w,
        style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp),
      )) {
        // 判断加上剩余显示多少人后缀，是否溢出
        userStr = userStr.replaceRange(
            userStr.length - name.length, userStr.length, "");
        userStr += "+${users.length - showCount}人";
        if (CommonUtil.didExceedMaxLines(
          content: userStr,
          maxLine: 1,
          maxWidth: 190.w,
          style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp),
        )) {
          children.removeLast();
          showCount--;
        }
        children.add(TextSpan(
          text: "+${users.length - showCount}人",
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              if (widget.onTapUnShowReplyUser != null)
                widget.onTapUnShowReplyUser!(index);
            },
        ));
        break;
      }
      showCount++;
      children.add(TextSpan(
        text: CommonUtil.breakWord(name),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            if (widget.onTapUser != null) widget.onTapUser!(e.id!);
          },
      ));
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3.w, horizontal: 6.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: widget.message.sendID == OpenIM.iMManager.uid
            ? Color(0xFFAFD2FD)
            : Color(0xFFE4E4E4),
      ),
      child: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(color: Color(0xFF666666), fontSize: 12.sp),
          children: children,
        ),
      ),
    );
  }

  Widget _menuBuilder() => ChatLongPressMenu(
        controller: _popupCtrl,
        menus: widget.groupArchived
            ? [
                MenuInfo(
                  icon: ImageUtil.menuCopy(),
                  text: UILocalizations.copy,
                  enabled: _showCopyMenu,
                  textStyle: menuTextStyle,
                  onTap: widget.onTapCopyMenu,
                ),
              ]
            : (widget.menus ?? _menusItem()),
        menuStyle: widget.menuStyle ??
            MenuStyle(
              crossAxisCount: 6,
              mainAxisSpacing: 20.w,
              crossAxisSpacing: 0.w,
              radius: 6.w,
              background: const Color(0xFFFFFFFF),
            ),
        onTapEmoji: widget.groupArchived
            ? null
            : (emojiName) {
                if (widget.onReplayWithFace != null)
                  widget.onReplayWithFace!(emojiName, widget.index,
                      isResignReply: didReplyWithThisEmoji(emojiName));
              },
        enableEmoji: !widget.groupArchived,
      );

  Widget? _customItemView() => widget.customItemBuilder?.call(
        context,
        widget.index,
        widget.message,
      );

  Widget _buildTimeView() => Container(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Text(
          widget.timeStr!,
          style: widget.timeStyle ?? _hintTextStyle,
        ),
      );

  List<MenuInfo> _menusItem() => [
        MenuInfo(
          icon: ImageUtil.menuCopy(),
          text: UILocalizations.copy,
          enabled: _showCopyMenu,
          textStyle: menuTextStyle,
          onTap: widget.onTapCopyMenu,
        ),
        MenuInfo(
          icon: ImageUtil.menuDel(),
          text: UILocalizations.delete,
          enabled: _showDelMenu,
          textStyle: menuTextStyle,
          onTap: widget.onTapDelMenu,
        ),
        MenuInfo(
          icon: ImageUtil.menuForward(),
          text: UILocalizations.forward,
          enabled: _showForwardMenu,
          textStyle: menuTextStyle,
          onTap: widget.onTapForwardMenu,
        ),
        MenuInfo(
          icon: ImageUtil.menuReply(),
          text: UILocalizations.reply,
          enabled: _showReplyMenu,
          textStyle: menuTextStyle,
          onTap: widget.onTapReplyMenu,
        ),
        MenuInfo(
            icon: ImageUtil.menuRevoke(),
            text: UILocalizations.revoke,
            enabled: _showRevokeMenu,
            textStyle: menuTextStyle,
            onTap: widget.onTapRevokeMenu),
        MenuInfo(
            icon: ImageUtil.menuMemo(),
            text: UILocalizations.memo,
            enabled: _showMemoMenu,
            textStyle: menuTextStyle,
            onTap: widget.onTapMemoMenu),
        MenuInfo(
          icon: ImageUtil.menuMultiChoice(),
          text: UILocalizations.multiChoice,
          enabled: _showMultiChoiceMenu,
          textStyle: menuTextStyle,
          onTap: widget.onTapMultiMenu,
        ),
        // MenuInfo(
        //   icon: ImageUtil.menuTranslation(),
        //   text: UILocalizations.translation,
        //   enabled: _showTranslationMenu,
        //   textStyle: menuTextStyle,
        //   onTap: widget.onTapTranslationMenu,
        // ),
        // MenuInfo(
        //   icon: ImageUtil.menuDownload(),
        //   text: widget.localizations.download,
        //   enabled: true,
        //   textStyle: menuTextStyle,
        //   onTap: () {},
        // ),
      ];

  static var menuTextStyle = TextStyle(
    fontSize: 12.sp,
    color: Color(0xFF333333),
  );

  bool get _showCopyMenu =>
      widget.enabledCopyMenu ??
      widget.message.contentType == MessageType.text ||
          widget.message.contentType == MessageType.at_text ||
          widget.message.contentType == MessageType.quote;

  bool get _showDelMenu =>
      widget.enabledDelMenu ??
      (widget.message.contentType != MessageType.revoke &&
          widget.message.contentType != MessageType.advancedRevoke);

  bool get _showForwardMenu =>
      widget.enabledForwardMenu ??
      widget.message.contentType != MessageType.voice &&
          widget.message.contentType != MessageType.revoke &&
          widget.message.contentType != MessageType.advancedRevoke &&
          !_isCloudDoc() &&
          !_isDocAssistant();

  bool get _showReplyMenu {
    return widget.enabledReplyMenu ??
        widget.message.contentType == MessageType.text ||
            widget.message.contentType == MessageType.at_text ||
            widget.message.contentType == MessageType.video ||
            widget.message.contentType == MessageType.picture ||
            widget.message.contentType == MessageType.location ||
            widget.message.contentType == MessageType.quote ||
            widget.message.contentType == MessageType.voice ||
            _isCloudDoc();
  }

  bool _isCloudDoc() {
    if (widget.message.contentType == MessageType.custom) {
      try {
        String data = widget.message.customElem?.data ?? "";
        Map map = json.decode(data);
        String type = map["type"];
        return type == "cloud_doc" ||
            type == "folderMessage" ||
            type == "cloud_excel";
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  bool _isDocAssistant() {
    if (widget.message.contentType == MessageType.custom) {
      try {
        String data = widget.message.customElem?.data ?? "";
        Map map = json.decode(data);
        String type = map["type"];
        return type == "cloud_doc_assistant";
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  bool get _showRevokeMenu =>
      widget.enabledRevokeMenu ??
      widget.message.sendID == OpenIM.iMManager.uid &&
          widget.message.contentType != MessageType.revoke &&
          widget.message.contentType != MessageType.advancedRevoke;
  bool get _showMemoMenu {
    bool isCustomTypeNeedShow = false;
    if (widget.message.contentType == MessageType.custom) {
      Map msgContentMap = json.decode(widget.message.content ?? '');
      if (msgContentMap.containsKey('data')) {
        Map contentDataMap = json.decode(msgContentMap['data'] ?? '');
        // if (contentDataMap['type'] == 'cloud_doc') {
        if (_isCloudDoc()) {
          isCustomTypeNeedShow = true;
        }
      }
    }

    return widget.enabledMemoMenu ??
        (widget.message.contentType == MessageType.text ||
            widget.message.contentType == MessageType.at_text ||
            widget.message.contentType == MessageType.video ||
            widget.message.contentType == MessageType.picture ||
            widget.message.contentType == MessageType.location ||
            widget.message.contentType == MessageType.quote ||
            widget.message.contentType == MessageType.file ||
            widget.message.contentType == MessageType.merger ||
            widget.message.contentType == MessageType.card ||
            // widget.message.contentType == MessageType.voice ||
            isCustomTypeNeedShow ||
            widget.message.contentType == MessageType.custom_face);
  }

  bool get _showMultiChoiceMenu =>
      widget.enabledMultiMenu ??
      widget.message.contentType != MessageType.revoke &&
          widget.message.contentType != MessageType.advancedRevoke &&
          widget.message.contentType != MessageType.voice &&
          !_isCloudDoc() &&
          !_isDocAssistant();

  bool get _showTranslationMenu =>
      widget.enabledTranslationMenu ??
      widget.message.contentType == MessageType.text;
}
