import 'package:medici/datetime_parser.dart';

const int timeTolerance = 3;

List<String> getAlerts(DateTime startingTime, int step) {
  List<String> alerts = [TimeParser(startingTime).getTimeString()];

  int currentHour = nextHour(startingTime.hour, step);

  while (currentHour != startingTime.hour) {
    TimeParser time = TimeParser.fromNow();
    time.setHour(currentHour);
    time.setMinute(startingTime.minute);

    alerts.add(time.getTimeString());
    currentHour = nextHour(currentHour, step);
  }

  return alerts;
}

int nextHour(int hour, int step) {
  return (hour + step) % 24;
}

String getAlertStatus(String time) {
  final TimeParser parsedTime = TimeParser.fromString(time);
  final int diff = parsedTime.differenceFromNow().inMinutes;
  return diff >= 5 && diff <= (timeTolerance * 60) ? 'late' : 'pending';
}

bool itsTimeToTake(String time) {
  final TimeParser parsedTime = TimeParser.fromString(time);
  final int diff = parsedTime.differenceFromNow().inHours;
  return diff <= timeTolerance && !parsedTime.isFuture();
}

bool passedTolerance(String time) {
  final TimeParser parsedTime = TimeParser.fromString(time);
  final int diff = parsedTime.differenceFromNow().inHours;
  return diff > timeTolerance;
}
