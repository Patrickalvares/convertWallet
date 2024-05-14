// ignore_for_file: constant_identifier_names

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart' as foundation;

class Log {
  static void print(
    var message, {
    LogColor backgroundColor = LogColor.WHITE,
    LogColor textColor = LogColor.BLACK,
  }) {
    if (!foundation.kDebugMode) return;
    final String now = DateTime.now().toString().split(' ')[1].substring(0, 11);
    developer.log(
      '\x1B[36m$now\x1B[0m \x1B[37m- \x1B[0m${backgroundColor.backgroundColor}${textColor.textColor} ${message.toString()} \x1B[0m',
    );
  }
}

enum LogColor {
  BLACK(backgroundColor: '\x1B[40m', textColor: '\x1B[30m'),
  RED(backgroundColor: '\x1B[41m', textColor: '\x1B[31m'),
  GREEN(backgroundColor: '\x1B[42m', textColor: '\x1B[32m'),
  YELLOW(backgroundColor: '\x1B[43m', textColor: '\x1B[33m'),
  BLUE(backgroundColor: '\x1B[44m', textColor: '\x1B[34m'),
  MAGENTA(backgroundColor: '\x1B[45m', textColor: '\x1B[35m'),
  CYAN(backgroundColor: '\x1B[46m', textColor: '\x1B[36m'),
  WHITE(backgroundColor: '\x1B[47m', textColor: '\x1B[37m');

  const LogColor({required this.backgroundColor, required this.textColor});
  final String backgroundColor;
  final String textColor;
}
