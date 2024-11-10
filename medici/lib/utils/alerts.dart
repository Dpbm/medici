import 'package:flutter/material.dart';
import 'package:medici/utils/time.dart';

List<String> getAlerts(TimeOfDay startingTime, int step) {
  List<String> alerts = [buildTimeString(startingTime)];

  int currentHour = nextHour(startingTime.hour, step);

  while (currentHour != startingTime.hour) {
    alerts.add(buildTimeString(
        TimeOfDay(hour: currentHour, minute: startingTime.minute)));
    currentHour = nextHour(currentHour, step);
  }

  return alerts;
}

int nextHour(int hour, int step) {
  return (hour + step) % 24;
}

String getAlertStatus(String time) {
  const int tolerance = -3;
  final TimeOfDay parsedTime = parseStringTime(time);
  final bool isOnTolerance =
      (parsedTime.hour - TimeOfDay.now().hour) >= tolerance;

  return passedTime(parsedTime) && isOnTolerance ? 'late' : 'pending';
}

bool itsTimeToTake(String time) {
  final TimeOfDay parsedTime = parseStringTime(time);
  final TimeOfDay now = TimeOfDay.now();
  final int diff = parsedTime.hour - now.hour;

  return diff <= 0 && diff.abs() <= 3;
}
