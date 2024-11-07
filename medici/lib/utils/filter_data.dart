import 'package:flutter/material.dart';
import 'package:medici/models/drug.dart';

List<DrugsScheduling> filterData(List<DrugsScheduling> data) {
  List<DrugsScheduling> medsForToday =
      data.where((DrugsScheduling drug) => !forTomorrow(drug)).toList();
  medsForToday = orderData(medsForToday);
  return medsForToday;
}

List<DrugsScheduling> orderData(List<DrugsScheduling> data) {
  data.sort(sortByHour);
  return data;
}

int sortByHour(DrugsScheduling drug1, DrugsScheduling drug2) {
  final List<String> splitDrug1Time = drug1.time.split(':');
  final List<String> splitDrug2Time = drug2.time.split(':');

  final drug1Hour = int.parse(splitDrug1Time[0]);
  final drug2Hour = int.parse(splitDrug2Time[0]);

  final drug1Minute = int.parse(splitDrug1Time[1]);
  final drug2Minute = int.parse(splitDrug2Time[1]);

  if (drug1Hour < drug2Hour) {
    return -1;
  } else if (drug1Hour > drug2Hour) {
    return 1;
  }

  if (drug1Minute < drug2Minute) {
    return -1;
  } else if (drug1Minute > drug2Minute) {
    return 1;
  }

  return 0;
}

bool forTomorrow(DrugsScheduling drug) {
  final int hour = int.parse(drug.time.split(':')[0]);
  return hour < TimeOfDay.now().hour;
}
