import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

typedef RecordFc = Function(int sec, String path);
typedef UpdateDuration = Function(int time, Amplitude? dbLevel);
typedef OnStartRecord = Function();

class VoiceRecord {
  static const _dir = "voice";
  static const _ext = ".m4a";
  String _path = "";
  int _long = 0;
  late int _tag;
  RecordFc _callback;
  BuildContext? _context;
  int _maxDuration;
  OnStartRecord? _onStartRecord;
  UpdateDuration? _updateDuration;
  final _audioRecorder = Record();
  Timer? _timer;

  VoiceRecord(
    this._callback, {
    BuildContext? context,
    int maxDuration = 60 * 1000,
    OnStartRecord? onStartRecord,
    UpdateDuration? updateDuration,
  })  : _tag = _now(),
        _context = context,
        _maxDuration = maxDuration,
        _onStartRecord = onStartRecord,
        _updateDuration = updateDuration;

  start() async {
    PermissionUtil.microphone(
      () async {
        var path = (await getApplicationDocumentsDirectory()).path;
        _path = '$path/$_dir/$_tag$_ext';
        File file = File(_path);
        if (!(await file.exists())) {
          await file.create(recursive: true);
        }
        _long = _now();
        _audioRecorder.start(path: _path);
        _onStartRecord?.call();
        _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
          int duration = (_now() - _long);
          if (duration >= _maxDuration) {
            stop();
          }

          try {
            Amplitude amplitude = await _audioRecorder.getAmplitude();
            _updateDuration?.call(duration, amplitude);
          } catch (e) {
            _updateDuration?.call(duration, null);
          }
        });
      },
      onFailed: (PermissionStatus status) async {
        _callback(0, "");
        await Permission.microphone.request();
      },
      onPermanently: () {
        showDialog(
          context: _context!,
          builder: (BuildContext context) => MindIMDialog(
            title: Text("需获得麦克风权限"),
            content: Text("请在“设置-Mind”中打开麦克风权限，以便发送语音消息"),
            cancelWidget: CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                '取消',
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            sureWidget: CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                '前往设置',
                style: TextStyle(
                  color: Color(0xFF006DFA),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await openAppSettings();
              },
            ),
          ),
        );
      },
    );
  }

  stop() async {
    if (await _audioRecorder.isRecording()) {
      _audioRecorder.stop();
    }
    _long = (_now() - _long) ~/ 1000;
    _callback(_long, _path);
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  static int _now() => DateTime.now().millisecondsSinceEpoch;
}
