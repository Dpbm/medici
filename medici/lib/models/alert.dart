import 'package:flutter/material.dart';

const Map<String, Color> statusesColors = {
  'pending': Colors.grey,
  'taken': Colors.green,
  'late': Colors.red,
  'aware': Colors.yellow
};

class Alert {
  final int? id;
  final int drugId;
  final String time, status, lastInteraction;

  const Alert(
      {this.id,
      required this.drugId,
      required this.time,
      required this.status,
      required this.lastInteraction});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'drug_id': drugId,
      'time': time,
      'status': status,
      'last_interaction': lastInteraction
    };
  }

  int getTimeDiff() {
    final int hour = int.parse(time.split(':')[0]);
    return hour - TimeOfDay.now().hour;
  }
}
