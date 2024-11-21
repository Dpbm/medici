import 'package:medici/models/drug.dart';
import 'package:medici/utils/time.dart';

List<DrugsScheduling> filterData(List<DrugsScheduling> data) {
  List<DrugsScheduling> meds = data;

  meds = orderData(data);
  meds = orderStatus(data);
  meds = getUniqueAndLate(data);

  return meds;
}

List<DrugsScheduling> getUniqueAndLate(List<DrugsScheduling> data) {
  final List<int> ids = [];
  final List<DrugsScheduling> filteredData = [];

  for (final drug in data) {
    if (drug.alert.status == 'late') {
      filteredData.add(drug);
      continue;
    }

    if (!ids.contains(drug.id)) {
      ids.add(drug.id);
      filteredData.add(drug);
    }
  }

  return filteredData;
}

List<DrugsScheduling> orderData(List<DrugsScheduling> data) {
  data.sort(sortByHour);
  return data;
}

List<DrugsScheduling> orderStatus(List<DrugsScheduling> data) {
  data.sort(sortByStatus);
  return data;
}

int sortByStatus(DrugsScheduling drug1, DrugsScheduling drug2) {
  final String status1 = drug1.alert.status;
  final String status2 = drug2.alert.status;

  final firstIsLate = status1 == 'late';
  final secondIsLate = status2 == 'late';

  if (firstIsLate && !secondIsLate) {
    return -1;
  } else if (!firstIsLate && secondIsLate) {
    return 1;
  }

  return 0;
}

int sortByHour(DrugsScheduling drug1, DrugsScheduling drug2) {
  final DateTime parsedTime1 = parseStringTime(drug1.alert.time);
  final DateTime parsedTime2 = parseStringTime(drug2.alert.time);

  return parsedTime1.compareTo(parsedTime2);
}
