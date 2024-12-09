import 'package:medici/datetime_parser.dart';
import 'package:medici/utils/constants.dart';

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
  return parsedTime.passedHoursTolerance(TIME_TOLERANCE) ? 'late' : 'pending';
}
