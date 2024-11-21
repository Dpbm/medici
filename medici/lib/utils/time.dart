bool passedTime(DateTime baseTime) {
  return DateTime.now().difference(baseTime).inMinutes >= 4;
}

DateTime parseStringTime(String time) {
  final List<int> splitTime =
      time.split(':').map((part) => int.parse(part)).toList();

  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day, splitTime[0], splitTime[1]);
}

String buildTimeString(DateTime time) {
  return '${time.hour.toString()}:${time.minute.toString()}';
}

String buildDateString(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

DateTime parseStringDate(String date) {
  final List<int> splitTime =
      date.split('/').map((part) => int.parse(part)).toList();
  return DateTime(splitTime[2], splitTime[1], splitTime[0]);
}

bool passedAtLeastOneDay(DateTime lastInteraction) {
  return DateTime.now().difference(lastInteraction).inDays >= 1;
}

bool equalDate(DateTime date1, DateTime date2) {
  return buildDateString(date1) == buildDateString(date2);
}
