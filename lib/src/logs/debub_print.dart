import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart' show kDebugMode;

final dprint = DebugPrint();

class DebugPrint {
  DebugPrint._internal();
  static final DebugPrint _instance = DebugPrint._internal();

  static String? filterd;

  factory DebugPrint() {
    return _instance;
  }

  void call(
    dynamic message, {
    String? ref,
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
    bool alwaysLog = false,
  }) {
    final logMessage = ref != null ? "LOG($ref): $message" : message.toString();
    if (alwaysLog || kDebugMode) {
      log(
        logMessage,
        error: error,
        level: level,
        name: name,
        sequenceNumber: sequenceNumber,
        stackTrace: stackTrace,
        time: time,
        zone: zone,
      );
    }
  }

  void a(
    dynamic message, {
    String? ref,
    DateTime? time,
    int? sequenceNumber,
    int level = 0,
    String name = '',
    Zone? zone,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logMessage = ref != null ? "LOG($ref): $message" : message.toString();
    call(
      logMessage,
      error: error,
      level: level,
      name: name,
      sequenceNumber: sequenceNumber,
      stackTrace: stackTrace,
      time: time,
      zone: zone,
    );
  }
}
