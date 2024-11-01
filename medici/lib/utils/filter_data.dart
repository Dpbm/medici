import 'package:flutter/material.dart';
import 'package:medici/models/drug.dart';

List<DrugsScheduling> filterData(List<DrugsScheduling> data) {
  return data.where((DrugsScheduling drug) => !forTomorrow(drug)).toList();
}

bool forTomorrow(DrugsScheduling drug) {
  final int hour = int.parse(drug.time.split(':')[0]);
  return hour < TimeOfDay.now().hour;
}
