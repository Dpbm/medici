import 'package:flutter/widgets.dart';

const Map<String, String> debugColors = {
  'red': '\x1B[31m',
  'yellow': '\x1B[33m',
  'blue': '\x1B[34m',
  'green': '\x1B[32m',
  'reset': '\x1B[0m',
};

void warning(String text) {
  debugPrint("${debugColors['yellow']}[*] $text${debugColors['reset']}");
}

void logError(String text, Exception error) {
  debugPrint("${debugColors['red']}[!] $text${debugColors['reset']}");
  debugPrint("$error");
}

void simpleLog(String text) {
  debugPrint("${debugColors['blue']}[-] $text${debugColors['reset']}");
}

void successLog(String text) {
  debugPrint("${debugColors['green']}[@] $text${debugColors['reset']}");
}
