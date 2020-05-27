import 'dart:async';
import 'dart:developer' as logger;
import 'dart:io';

import 'package:flutter/services.dart';

class FixedRateTimer {
  static const String TAG = "FIXED_RATE_TIMER";

  FixedRateTimer._();
  static FixedRateTimer _instance;
  static FixedRateTimer get instance {
    if (_instance == null) _instance = FixedRateTimer._();
    return _instance;
  }

  /// Set this to true if you want to see what's happening here on the debug log
  bool debug = false;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  _log(String message) {
    if (debug) logger.log("[$TAG] $message");
  }

  final MethodChannel _channel = const MethodChannel('fixed_rate_timer');

  Future<void> start(Duration duration, void Function() task) async {
    if (_isRunning) {
      _log("FixedRateTimer is already running, ignoring start()");
      return;
    }

    _channel.setMethodCallHandler((methodCall) async {
      if (methodCall.method == "task") {
        task?.call();
        _log("Called task");
      } else
        _log("Ignoring methodCall, isn't task as expected");
    });

    await _channel
        .invokeMethod("start",
            Platform.isIOS ? duration.inSeconds : duration.inMilliseconds)
        .then((_) => _isRunning = true)
        .catchError((error) => _log("Couldn't call start, error: $error"));
  }

  Future<void> stop() async {
    if (!_isRunning) {
      _log("FixedRateTimer is not running, ignoring stop()");
      return;
    }

    await _channel.invokeMethod("stop").then((_) {
      _channel.setMethodCallHandler(null);
      _isRunning = false;
    }).catchError((error) => _log("Couldn't call stop, error: $error"));
  }
}
