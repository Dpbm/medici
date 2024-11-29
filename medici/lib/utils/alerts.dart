import 'package:medici/utils/time.dart';

const int timeTolerance = 3;

List<String> getAlerts(DateTime startingTime, int step) {
  List<String> alerts = [buildTimeString(startingTime)];

  int currentHour = nextHour(startingTime.hour, step);
  final DateTime now = DateTime.now();

  while (currentHour != startingTime.hour) {
    alerts.add(buildTimeString(DateTime(
        now.year, now.month, now.day, currentHour, startingTime.minute)));
    currentHour = nextHour(currentHour, step);
  }

  return alerts;
}

int nextHour(int hour, int step) {
  return (hour + step) % 24;
}

String getAlertStatus(String time) {
  final DateTime parsedTime = parseStringTime(time);
  final int diff = DateTime.now().difference(parsedTime).inMinutes;
  return diff >= 5 && diff <= (timeTolerance * 60) ? 'late' : 'pending';
}

bool itsTimeToTake(String time) {
  final DateTime parsedTime = parseStringTime(time);
  final DateTime now = DateTime.now();
  final int diff = DateTime.now().difference(parsedTime).inHours;
  return diff <= timeTolerance && now.compareTo(parsedTime) != -1;
}

bool passedTolerance(String time) {
  final DateTime parsedTime = parseStringTime(time);
  final int diff = DateTime.now().difference(parsedTime).inHours;
  return diff > timeTolerance;
}

bool hasAlreadyExpired(DateTime time, int offset) {
  final DateTime now = DateTime.now();
  return time.isBefore(time) ||
      (time.isAfter(now) && time.difference(now).inDays <= offset);
}
