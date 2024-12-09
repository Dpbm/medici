import 'package:medici/utils/debug.dart';

abstract class DateTimeParser {
  late DateTime _time;
  late DateTime _now;
  late DateTime _today;

  DateTimeParser(DateTime time) {
    _time = time;
    _now = DateTime.now();
    _today = DateTime(_now.year, _now.month, _now.day);
  }

  int compareTo(DateTime time2) {
    return _time.compareTo(time2);
  }

  bool isFuture() {
    return _now.compareTo(_time) == -1;
  }

  bool isPast() {
    return _now.compareTo(_time) == 1;
  }

  bool isEqualTo(DateTime time2) {
    return compareTo(time2) == 0;
  }

  bool isToday() {
    return isEqualTo(_today);
  }

  bool passedToday() {
    return _today.isAfter(_time);
  }

  DateTime getTime() {
    return _time;
  }

  void setHour(int hour) {
    _time = DateTime(_time.year, _time.month, _time.day, hour, _time.minute);
  }

  void setMinute(int minute) {
    _time = DateTime(_time.year, _time.month, _time.day, _time.hour, minute);
  }

  Duration difference(DateTime time2) {
    return _time.difference(time2);
  }

  Duration differenceFromNow() {
    return _time.difference(_now);
  }

  Duration differenceFromToday() {
    return _today.difference(_time);
  }

  bool isAtMostToday() {
    return isToday() || isPast();
  }

  void add(Duration amount) {
    _time.add(amount);
  }

  String getCompleteTimeString() {
    return _time.toIso8601String();
  }

  int getAbsHoursDifferenceFromNow() {
    return differenceFromNow().inHours.abs();
  }
}

class TimeParser extends DateTimeParser {
  TimeParser(super.time);

  factory TimeParser.fromNow() {
    return TimeParser(DateTime.now());
  }

  factory TimeParser.fromString(String time) {
    return TimeParser(parseStringTime(time));
  }

  factory TimeParser.fromRaw(String time) {
    return TimeParser(DateTime.parse(time));
  }

  static DateTime parseStringTime(String time) {
    final List<int> splitTime =
        time.split(':').map((part) => int.parse(part)).toList();

    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, splitTime[0], splitTime[1]);
  }

  String getTimeString() {
    return '${_time.hour.toString()}:${_time.minute.toString()}';
  }

  bool passedHoursTolerance(int tolerance) {
    return !isFuture() ||
        (isFuture() && differenceFromNow().inHours <= tolerance);
  }
}

class DateParser extends DateTimeParser {
  DateParser(super.time);

  factory DateParser.fromNow() {
    return DateParser(DateTime.now());
  }

  factory DateParser.fromString(String date) {
    return DateParser(parseStringDate(date));
  }

  static DateTime parseStringDate(String date) {
    simpleLog("AAAAA $date");
    final List<int> splitTime =
        date.split('/').map((part) => int.parse(part)).toList();
    return DateTime(splitTime[2], splitTime[1], splitTime[0]);
  }

  String getTimeString() {
    return '${_time.day}/${_time.month}/${_time.year}';
  }

  bool passedDaysOffset(int offset) {
    return !isFuture() ||
        (isFuture() && differenceFromToday().inDays <= offset);
  }
}
