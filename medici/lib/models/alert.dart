import 'package:flutter/material.dart';

class Alert {
  final int? id;
  final int drugId;
  final String time, status;

  const Alert(
      {this.id,
      required this.drugId,
      required this.time,
      required this.status});

  Map<String, Object?> toMap() {
    return {'id': id, 'drug_id': drugId, 'time': time, 'status': status};
  }

  int getTimeDiff() {
    final int hour = int.parse(time.split(':')[0]);
    return hour - TimeOfDay.now().hour;
  }
}
