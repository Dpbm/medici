import 'package:flutter/material.dart';

bool passedTime(TimeOfDay baseTime) {
  final now = TimeOfDay.now();
  if (now.hour > baseTime.hour) {
    return true;
  } else if (now.hour < baseTime.hour) {
    return false;
  } else if (now.minute > baseTime.minute) {
    return true;
  } else if (now.minute < baseTime.minute) {
    return false;
  }
  return false;
}

TimeOfDay parseStringTime(String time) {
  final List<String> splitTime = time.split(':');

  return TimeOfDay(
      hour: int.parse(splitTime[0]), minute: int.parse(splitTime[1]));
}

String buildTimeString(TimeOfDay time) {
  return time.hour.toString() + ":" + time.minute.toString();
}
