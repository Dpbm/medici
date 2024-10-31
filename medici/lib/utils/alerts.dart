import 'package:flutter/material.dart';

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

String buildTimeString(TimeOfDay time) {
  return time.hour.toString() + ":" + time.minute.toString();
}
