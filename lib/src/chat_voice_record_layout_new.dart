import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:record/record.dart';

import 'chat_voice_record_circle.dart';

class ChatVoiceRecordLayoutNew extends StatefulWidget {
  const ChatVoiceRecordLayoutNew({
    Key? key,
    this.locale,
    this.onCompleted,
    this.onStart,
    this.onCompleteFail,
  }) : super(key: key);

  final Locale? locale;
  final Function(int sec, String path)? onCompleted;
  final Function()? onStart;
  final Function(int sec, String path)? onCompleteFail;

  @override
  _ChatVoiceRecordLayoutNewState createState() =>
      _ChatVoiceRecordLayoutNewState();
}

class _ChatVoiceRecordLayoutNewState extends State<ChatVoiceRecordLayoutNew> {
  var _selectedPressArea = true;
  var _showVoiceRecordView = false;
  var _showRecognizeFailed = false;
  var _startRecord = false;
  Timer? _timer;
  int _recordTime = 0;
  double _dbLevel = 0.0;
  var _lastTipTime = 0;
  late VoiceRecord? _record;
  String? _path;
  int _sec = 0;
  int maxDuration = 10 * 1000;
  int _lastTime = 5 * 1000;

  @override
  void initState() {
    UILocalizations.set(widget.locale);
    super.initState();
  }

  void callback(int sec, String path) {
    _sec = sec;
    _path = path;
    // 停止记录
    setState(() {
      cleanData();
      if (_selectedPressArea || sec == maxDuration / 1000) {
        _callback();
      }
      _showVoiceRecordView = false;
      _selectedPressArea = false;
      _startRecord = false;
    });
  }

  @override
  void dispose() {
    _record?.stop();
    super.dispose();
  }

  ChatVoiceRecordCircle _createSpeakBar() => ChatVoiceRecordCircle(
        onTap: () {},
        onLongPressMoveUpdate: (details) {
          if (_startRecord) {
            Offset global = details.globalPosition;
            setState(() {
              _selectedPressArea = global.dy >= 623.h;
            });
          }
        },
        onLongPressEnd: (details) async {
          await _record?.stop();
        },
        onLongPressStart: (details) {
          widget.onStart?.call();
          setState(() {
            // 开始记录
            _record = VoiceRecord(
              callback,
              context: context,
              maxDuration: maxDuration,
              onStartRecord: () {
                setState(() {
                  _startRecord = true;
                  _selectedPressArea = true;
                  _showVoiceRecordView = true;
                });
              },
              updateDuration: (int time, Amplitude? amplitude) {
                setState(() {
                  _recordTime = time;
                  if ((maxDuration - _recordTime) < _lastTime) {
                    _lastTipTime = (maxDuration - _recordTime);
                  } else {
                    _lastTipTime = 0;
                  }
                  _dbLevel = amplitude?.current ?? 0.0;
                  print("_dbLevel : ${amplitude?.current}");
                });
              },
            );
            _record?.start();
          });
        },
        backgroundColor: (!_startRecord || _selectedPressArea)
            ? Color(0xFF006DFA)
            : Color(0XFFFF4A4A),
      );

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: _startRecord ? 0 : null,
      bottom: 0,
      child: Container(
        height: _startRecord ? 270.h : 270.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFDDDDDD), width: 1.w),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 40.h,
              child: IgnorePointer(
                ignoring: !_showRecognizeFailed,
                child: Visibility(
                  visible: _showVoiceRecordView,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _selectedCancelAreaAnimationView(reverse: true),
                          Container(
                            width: 100,
                            child: Text(
                              getTimeStr(),
                              textAlign: TextAlign.center,
                              style: getTextStyle(),
                            ),
                          ),
                          _selectedCancelAreaAnimationView()
                        ],
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      Container(
                        child: Text(
                          getTipStr(),
                          textAlign: TextAlign.center,
                          style: getTipTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(bottom: 40, child: _createSpeakBar()),
          ],
        ),
      ),
    );
  }

  buildAmplitude(bool show) {
    return Container(
      width: 2.w,
      height: 20.w,
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      decoration: BoxDecoration(
        color: show ? Color(0xFF006DFA) : Color(0xFFDDDDDD),
        borderRadius: BorderRadius.all(Radius.circular(1.w)),
      ),
    );
  }

  getAmView(int maxIndex, bool? reverse) {
    var children = <Widget>[];
    for (var i = 0; i < 10; i++) {
      children.add(
          buildAmplitude(reverse != true ? maxIndex > i : maxIndex >= 10 - i));
    }
    return children;
  }

  getMaxIndex() {
    try {
      if (!_dbLevel.isNaN && !_dbLevel.isInfinite) {
        int sum = (_dbLevel.abs() / 6).round();
        return (10 - sum);
      }
      return 0;
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  Widget _selectedCancelAreaAnimationView({bool reverse = false}) => Visibility(
        visible: true,
        child: Row(
          children: getAmView(getMaxIndex(), reverse),
        ),
      );

  getTipStr() {
    if (_selectedPressArea) {
      if (_lastTipTime > 0) {
        return "${_lastTipTime / 1000}后将停止录音";
      }
      return "手指上滑，取消发送";
    } else {
      return "松开手机，取消发送";
    }
  }

  getTimeStr() {
    Duration d = Duration(milliseconds: _recordTime);
    List<String> parts = d.toString().split(':');
    return '${parts[1]}:${parts[2].substring(0, 5)}';
  }

  getTextStyle() {
    if (_lastTipTime > 0) {
      return TextStyle(
          color: Color(0xFFFF4A4A),
          fontSize: 16.sp,
          fontWeight: FontWeight.w600);
    }
    return TextStyle(
        color: Color(0xFF333333), fontSize: 16.sp, fontWeight: FontWeight.w600);
  }

  getTipTextStyle() {
    if (_lastTipTime > 0 || !_selectedPressArea) {
      return TextStyle(
        color: Color(0xFFFF4A4A),
        fontSize: 14.sp,
      );
    }
    return TextStyle(
      color: Color(0xFF333333),
      fontSize: 14.sp,
    );
  }

  getTipColor() {
    if (_lastTipTime > 0 || !_selectedPressArea) {
      return TextStyle(
        color: Color(0xFFFF4A4A),
        fontSize: 14.sp,
      );
    }
    return TextStyle(
      color: Color(0xFF333333),
      fontSize: 14.sp,
    );
  }

  cleanData() {
    _lastTipTime = 0;
    _startRecord = false;
  }

  void _callback() {
    if (_sec > 0 && null != _path) {
      widget.onCompleted?.call(_sec, _path!);
    } else {
      widget.onCompleteFail?.call(_sec, _path!);
    }
  }
}
