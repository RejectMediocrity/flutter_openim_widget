import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

enum VoiceEvent {
  start,
  playing,
  pause,
  stop,
}

typedef OnData = void Function(bool event);

class AudioController extends NavigatorObserver with WidgetsBindingObserver {
  AudioPlayer? _voicePlayer;

  bool _isExistSource = false;
  String? playWaiting = "";
  String? playing = "";

  String pressKey = "";
  String pressKeyLast = "";
  Map<String, Function> listeners = {};

  static AudioController? _instance;

  static AudioController get instance {
    if (_instance == null) {
      _instance = AudioController();
      WidgetsBinding.instance.addObserver(_instance!);
    }

    return _instance!;
  }

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      AudioController.instance.stop();
    }
  }

  addListener(String key, OnData onData) {
    assert(key.isNotEmpty);
    listeners[key] = onData;
    if (playing == key) {
      onData(true);
    }
  }

  removeListener(String key, OnData onData) {
    listeners.remove(key);
  }

  Future _initSource(String? path, String? url) async {
    assert(_voicePlayer != null);
    var _existFile = false;
    if (path != null && path.trim().isNotEmpty) {
      var file = File(path);
      _existFile = await file.exists();
    }
    if (_existFile) {
      _isExistSource = true;
      playWaiting = path;
      return _voicePlayer?.setFilePath(path!);
    } else if (null != url && url.trim().isNotEmpty) {
      _isExistSource = true;
      playWaiting = url;
      return await _voicePlayer?.setUrl(url);
    }
  }

  bool _isClickedLocation() {
    return pressKey == pressKeyLast;
  }

  bool _isPlaying(String key) {
    if (playing?.isEmpty == true) {
      return false;
    }
    return playing == key;
  }

  play(
    String key, {
    String? source,
    String? url,
  }) {
    _play(key, source: source, url: url);
  }

  void _play(
    String key, {
    String? source,
    String? url,
  }) async {
    if (_voicePlayer == null) {
      _voicePlayer = AudioPlayer();
      _voicePlayer?.playerStateStream.listen((state) {
        switch (state.processingState) {
          case ProcessingState.idle:
          case ProcessingState.loading:
          case ProcessingState.buffering:
          case ProcessingState.ready:
            break;
          case ProcessingState.completed:
            stop();
            break;
        }
      });
    }

    await _initSource(source, url);
    if (!_isExistSource) {
      return;
    }
    // 设定关键key;
    pressKey = key;
    // 设定正在播放关键key
    if (_isClickedLocation()) {
      if (_isPlaying(key)) {
        stop();
        print('AudioController play stop $playing');
      } else {
        playing = key;
        pressKeyLast = pressKey;
        await _voicePlayer?.seek(Duration.zero);
        _voicePlayer?.play();
        emitListener(true);
        print('AudioController play start $playing');
      }
    } else {
      pressKeyLast = pressKey;
      if (_isPlaying(key)) {
        print('AudioController play stop [key = $playing]before play');
        await stop();
        _play(key, source: source, url: url);
      } else {
        _play(key, source: source, url: url);
      }
    }
    // 判定是否是当前的，正在录音，关闭，否则开启录音

    // 不是当前的直接关闭录音
  }

  emitListener(bool event) {
    if (listeners.isNotEmpty) {
      listeners.forEach((key, value) {
        try {
          value.call(event && _isPlaying(key));
        } catch(e) {
          print('AudioController key : $key event: $event');
        }
      });
    }
  }

  stop() async {
    playing = "";
    pressKeyLast = "";
    pressKey = "";
    emitListener(false);
    if (_voicePlayer != null) {
      await _voicePlayer?.stop();
      await _voicePlayer?.dispose();
      _voicePlayer = null;
    }
  }

  clear() async {
    await stop();
  }
}
