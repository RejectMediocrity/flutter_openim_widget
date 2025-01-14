import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_widget/src/wechat_camera_picker/lib/src/constants/config.dart';
import 'package:flutter_openim_widget/src/wechat_camera_picker/lib/src/widgets/camera_picker.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../flutter_openim_widget.dart';

class ChatCameraAssetPickerToolsView extends StatefulWidget {
  final int selectedMaximumAssets;
  final Function(
      {List<AssetEntity>? selectedEntityList,
      bool? isNeedOrigin,
      bool? isSendDirectly})? selectedCallback;

  const ChatCameraAssetPickerToolsView(
      {this.selectedCallback, this.selectedMaximumAssets = 9, Key? key})
      : super(key: key);

  @override
  State<ChatCameraAssetPickerToolsView> createState() =>
      _ChatCameraAssetPickerToolsViewState();
}

class _ChatCameraAssetPickerToolsViewState
    extends State<ChatCameraAssetPickerToolsView> {
  List<AssetEntity> entityList = [];
  List<AssetEntity> selectedEntityList = [];
  bool isNeedOrigin = false;
  final Color _themeColor = Color(0xFF006DFA);
  late final ThemeData theme = AssetPicker.themeData(_themeColor);
  late PermissionState _ps = PermissionState.authorized;

  Future<void> updatePhotosList() async {
    _ps = await PhotoManager.requestPermissionExtend();
    if (_ps.isAuth) {
      // Granted.
      // PhotoManager.openSetting
      final List<AssetPathEntity> paths =
          await PhotoManager.getAssetPathList(onlyAll: true);
      final List<AssetEntity> entities =
          await paths[0].getAssetListRange(start: 0, end: 9007199254740992);

      entityList = entities;
      if (entityList.isNotEmpty) {
        setState(() {});
      }
    } else {
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
      entityList = [];
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    updatePhotosList();
  }

  @override
  void dispose() {
    entityList = [];
    selectedEntityList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 200),
      child: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            _innerToolView(),
          ],
        ),
      ),
    );
  }

  Widget _innerToolView() {
    final Size size = MediaQuery.of(context).size;

    return Container(
      color: Colors.transparent,
      height: 270.w,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 1,
          ),
          Row(
            children: [
              Container(
                color: Color(0xFF333333),
                child: Column(
                  children: [
                    Container(
                      width: 60.w,
                      height: 110.w,
                      child: IconButton(
                        onPressed: () => checkCameraPermission(context),
                        color: Colors.white,
                        icon: ImageUtil.assetImage(
                          "file_but_camera",
                          width: 22.w,
                          height: 22.w,
                        ),
                      ),
                    ),
                    Container(
                      width: 60.w,
                      height: 110.w,
                      child: IconButton(
                        onPressed: () => checkPhotosPermission(context),
                        color: Colors.white,
                        icon: ImageUtil.assetImage(
                          "file_but_album",
                          width: 22.w,
                          height: 22.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: (size.width - 60.w),
                height: 220.w,
                child: _ps.isAuth
                    ? ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          AssetEntity entity = entityList[index];
                          // if (kDebugMode) {
                          //   print(entity.toString());
                          // }
                          return Container(
                            // constraints: BoxConstraints(
                            //   minWidth: 50.w,
                            //   minHeight: 220.w,
                            // ),
                            width:
                                220.w * (entity.width / entity.height) > 110.w
                                    ? 220.w * (entity.width / entity.height)
                                    : 110.w,
                            height: 220.w,
                            color: Colors.white,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    radius: 0.0,
                                    onTap: () =>
                                        previewSelectedAssets(context, index),
                                    child: Image(
                                      image: AssetEntityImageProvider(
                                        entity,
                                        isOriginal: !Platform.isAndroid,
                                        // isOriginal: entity.type != AssetType.video,
                                        // thumbnailSize:
                                        //     const ThumbnailSize.square(200),
                                        // thumbnailFormat: ThumbnailFormat.jpeg,
                                      ),
                                      fit: 220.w *
                                                  (entity.width /
                                                      entity.height) <
                                              50.w
                                          ? BoxFit.fitWidth
                                          : BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                                if (selectedEntityList.length >=
                                        widget.selectedMaximumAssets &&
                                    !selectedEntityList.contains(entity))
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.grey.withOpacity(0.8),
                                    ),
                                  )
                                else
                                  Container(),
                                if (entity.type == AssetType.video)
                                  Positioned(
                                    bottom: 10.w,
                                    left: 10.w,
                                    width: 45.w,
                                    height: 18.w,
                                    // child: _appleOSSelectButton(context, true, entity),
                                    child: Container(
                                      width: 38.w,
                                      height: 18.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          getVideoDurationFormat(
                                              entity.duration > 0
                                                  ? entity.duration
                                                  : 1),
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(),
                                Positioned(
                                  top: 10.w,
                                  right: 10.w,
                                  width: 26.w,
                                  height: 26.w,
                                  // child: _appleOSSelectButton(context, true, entity),
                                  child: InkWell(
                                    highlightColor: Colors.transparent,
                                    radius: 0.0,
                                    onTap: () {
                                      if (selectedEntityList.length >=
                                              widget.selectedMaximumAssets &&
                                          !selectedEntityList
                                              .contains(entity)) {
                                        int max = widget.selectedMaximumAssets;
                                        // print('最多只能选择$max张');
                                        showToast('最多只能选择$max张');
                                        return;
                                      }
                                      if (selectedEntityList.contains(entity)) {
                                        selectedEntityList.remove(entity);
                                      } else {
                                        selectedEntityList.add(entity);
                                      }
                                      setState(() {});
                                      sendSelectedEntityList(
                                          selectedEntityList, false);
                                    },
                                    child: selectedEntityList.contains(entity)
                                        ? Badge(
                                            toAnimate: false,
                                            animationType:
                                                BadgeAnimationType.fade,
                                            badgeColor: Color(0xFF006DFA),
                                            badgeContent: Center(
                                              child: Text(
                                                (selectedEntityList
                                                            .indexOf(entity) +
                                                        1)
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : ImageUtil.assetImage(
                                            "asset_but_unselected",
                                            width: 24.w,
                                            height: 24.w,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 220,
                            width: 2,
                          );
                        },
                        itemCount: entityList.length,
                        scrollDirection: Axis.horizontal,
                      )
                    : Container(
                        color: Color(0xFFF2F2F2),
                        child: Column(
                          children: [
                            Spacer(),
                            Text(
                              '照片被禁用，请在设置-隐私中开启',
                              style: TextStyle(
                                  color: Color(0xFF999999), fontSize: 14.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              highlightColor: Colors.transparent,
                              radius: 0.0,
                              child: Text(
                                '开启照片访问权限',
                                style: TextStyle(
                                    color: Color(0xFF006DFA), fontSize: 14.0),
                              ),
                              onTap: () {
                                PhotoManager.openSetting();
                              },
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Container(
            color: Colors.white,
            child: Row(
              children: [
                const Spacer(),
                InkWell(
                  highlightColor: Colors.transparent,
                  radius: 0.0,
                  onTap: () {
                    if (_ps.isAuth) {
                      isNeedOrigin = !isNeedOrigin;
                      setState(() {});
                    }
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      ImageUtil.assetImage(
                        isNeedOrigin
                            ? "user_agreement_but_selected"
                            : "user_agreement_but_unselected",
                        width: 16.w,
                        height: 16.w,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '原图',
                        style: TextStyle(
                            color: _ps.isAuth
                                ? Color(0xFF333333)
                                : Color(0xFFCCCCCC),
                            fontSize: 16.0),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getVideoDurationFormat(int seconds) {
    var d = Duration(seconds: seconds);
    // var hours = d.inHours > 10 ? d.inHours : '0${d.inHours}';
    // var minute =
    //     d.inMinutes % 60 > 10 ? d.inMinutes % 60 : '0${d.inMinutes % 60}';
    var minute = d.inMinutes >= 10 ? d.inMinutes : '0${d.inMinutes}';
    var sec =
        d.inSeconds % 60 >= 10 ? d.inSeconds % 60 : '0${d.inSeconds % 60}';
    return '$minute:$sec';
  }

  sendSelectedEntityList(
      List<AssetEntity>? selectedEntityList, bool isSendDirectly) {
    if (widget.selectedCallback != null) {
      widget.selectedCallback!(
        isSendDirectly: isSendDirectly,
        selectedEntityList: selectedEntityList ?? [],
        isNeedOrigin: isNeedOrigin,
      );
    }
  }

  checkMicrophonePermission(BuildContext context) {
    PermissionUtil.microphone(
      () async {
        pickFromCamera(context);
      },
      onFailed: (PermissionStatus status) async {
        PermissionStatus permissionStatus =
            await Permission.microphone.request();
        if (permissionStatus.isGranted) {
          pickFromCamera(context);
        }
      },
      onPermanently: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => MindIMDialog(
            title: Text("需获得麦克风权限"),
            content: Text("请在“设置-Mind”中打开麦克风权限，以便发送语音消息"),
            onTapCancel: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
            sureText: "前往设置",
            onTapSure: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await openAppSettings();
            },
          ),
        );
      },
    );
  }

  checkCameraPermission(BuildContext context) {
    PermissionUtil.camera(
      () async {
        checkMicrophonePermission(context);
      },
      onFailed: (PermissionStatus status) async {
        if (status == PermissionStatus.permanentlyDenied) {
          showDialog(
            context: context,
            builder: (BuildContext context) => MindIMDialog(
              title: Text("需获得相机权限"),
              content: Text("请在“设置-Mind”中打开相机权限，以便使用拍照功能"),
              onTapCancel: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
              sureText: "前往设置",
              onTapSure: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await openAppSettings();
              },
            ),
          );
        } else {
          await Permission.camera.request();
        }
      },
    );
  }

  checkPhotosPermission(BuildContext context) {
    PermissionUtil.photos(
      () async {
        pickFromAssets(context);
      },
      onFailed: (PermissionStatus status) async {
        if (status == PermissionStatus.permanentlyDenied ||
            status == PermissionStatus.limited) {
          showDialog(
            context: context,
            useSafeArea: false,
            builder: (BuildContext context) => Stack(
              children: [
                Positioned.fill(
                    child: Container(
                  color: Color(0xFF333333),
                )),
                Positioned(
                  top: 45.w,
                  left: 10.w,
                  width: 40.w,
                  height: 40.w,
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    radius: 0.0,
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      child: Center(
                        child: ImageUtil.assetImage(
                          "title_but_close_white",
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 228.w,
                  left: 0,
                  right: 0,
                  height: 34,
                  child: Container(
                    child: Center(
                      child: Text(
                        '无法访问相册中所有照片',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 282.w,
                  left: 0,
                  right: 0,
                  height: 22,
                  child: Container(
                    child: Center(
                      child: Text(
                        '请前往设置，允许mind访问所有照片',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 160.w,
                  left: 0,
                  right: 0,
                  height: 46.w,
                  child: Container(
                    child: Center(
                      child: MaterialButton(
                        elevation: 0,
                        minWidth: 250.w,
                        height: 46.w,
                        padding: const EdgeInsets.symmetric(horizontal: 27),
                        color: Color(0xFF006DFA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Container(
                          child: Text(
                            '前往设置',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: openAppSettings,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          PermissionStatus permissionStatus = await Permission.photos.request();
          if (permissionStatus.isGranted) {
            pickFromAssets(context);
          }
        }
      },
    );
  }

  Future<void> pickFromCamera(BuildContext context) async {
    List<AssetEntity>? entityList = [];
    final AssetEntity? result = await CameraPicker.pickFromCamera(
      context,
      pickerConfig: const CameraPickerConfig(
        enableRecording: true,
      ),
    );

    // print(
    //     '======================== pickFromCamera start ==============================');
    // print(DateTime.now().toString());
    if (result != null) {
      entityList.add(result);
      selectedEntityList = entityList;
      setState(() {});
      sendSelectedEntityList(selectedEntityList, true);
    } else {
      sendSelectedEntityList([], true);
    }
    selectedEntityList = [];
    // print(DateTime.now().toString());
    // print(
    //     '======================== pickFromCamera end ==============================');
  }

  Future<void> pickFromAssets(BuildContext context) async {
    if (_ps.isAuth) {
      final List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          pickerTheme: theme,
          selectedAssets: selectedEntityList,
          maxAssets: widget.selectedMaximumAssets,
          requestType: RequestType.common,
          gridCount: DeviceUtil.instance.isPadOrTablet ? 8 : 4,
        ),
      );
      selectedEntityList = result ?? [];
      setState(() {});
      sendSelectedEntityList(selectedEntityList, true);
      selectedEntityList = [];
    } else {
      // showToast('未开启权限');
    }
  }

  Future<void> previewSelectedAssets(BuildContext context, int index) async {
    final List<AssetEntity> selected = selectedEntityList;

    final List<AssetEntity>? result = await AssetPickerViewer.pushToViewer(
      context,
      previewAssets: entityList,
      currentIndex: index,
      selectedAssets: selected,
      themeData: theme,
      maxAssets: widget.selectedMaximumAssets,
      selectorProvider: DefaultAssetPickerProvider(
        selectedAssets: selected,
        maxAssets: widget.selectedMaximumAssets,
      ),
    );
    if (result == null) {
      selectedEntityList = [];
      setState(() {});
      reSetStatusBar();
    } else {
      selectedEntityList = result;
      setState(() {});
      reSetStatusBar();
    }
    sendSelectedEntityList(selectedEntityList, false);
  }

  reSetStatusBar() {
    var brightness = Brightness.light;
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarBrightness: brightness, statusBarIconBrightness: brightness);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else {
      Timer(Duration(milliseconds: 500), () {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarBrightness: brightness,
          statusBarIconBrightness: brightness,
        ));
      });
    }
  }

  showToast(String toastStr) {
    Fluttertoast.showToast(
        msg: toastStr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
