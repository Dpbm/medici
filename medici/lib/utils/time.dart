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
  final List<int> splitTime =
      time.split(':').map((part) => int.parse(part)).toList();

  return TimeOfDay(hour: splitTime[0], minute: splitTime[1]);
}

String buildTimeString(TimeOfDay time) {
  return '${time.hour.toString()}:${time.minute.toString()}';
}

String buildDateString(DateTime date) {
  return '${date.day}-${date.month}-${date.year}';
}

DateTime parseStringDate(String date) {
  final List<int> splitTime =
      date.split('-').map((part) => int.parse(part)).toList();
  return DateTime(splitTime[2], splitTime[1], splitTime[0]);
}

bool passedAtLeastOneDay(DateTime lastInteraction) {
  final DateTime now = DateTime.now();

  return (now.year > lastInteraction.year ||
      now.month > lastInteraction.month ||
      now.day > lastInteraction.day);
}
