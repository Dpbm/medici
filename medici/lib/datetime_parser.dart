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

  bool isEqualTo(DateTime time2) {
    return _time.compareTo(time2) == 0;
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
}

class TimeParser extends DateTimeParser {
  TimeParser(super.time);

  factory TimeParser.fromNow() {
    return TimeParser(DateTime.now());
  }

  factory TimeParser.fromString(String time) {
    return TimeParser(parseStringTime(time));
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
}
