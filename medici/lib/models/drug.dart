import 'package:medici/models/alert.dart';
import 'package:medici/models/notification_settings.dart';

const Map<String, int> frequencies = {
  '4 em 4h': 4,
  '6 em 6h': 6,
  '8 em 8h': 8,
  '12 em 12h': 12,
  '24 em 24h': 24
};

const doseTypes = ['comp.', 'ml'];

class Drug {
  final int? id;
  final String name;
  final String? image;
  final String expirationDate;
  final double quantity;
  final String doseType;
  final double dose;
  final String? leaflet;
  final bool recurrent;
  final String? lastDay;
  final String status;
  final String frequency;
  final String startingTime;

  const Drug(
      {this.id,
      required this.name,
      this.image,
      required this.expirationDate,
      required this.quantity,
      required this.doseType,
      required this.dose,
      required this.recurrent,
      this.lastDay,
      this.leaflet,
      required this.status,
      required this.frequency,
      required this.startingTime});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'expiration_date': expirationDate,
      'quantity': quantity,
      'dose_type': doseType,
      'dose': dose,
      'leaflet': leaflet,
      'recurrent': recurrent ? 1 : 0,
      'last_day': lastDay,
      'status': status,
      'frequency': frequency,
      'starting_time': startingTime
    };
  }
}

class DrugTinyData {
  final int id;
  final String name;
  final String? image;

  const DrugTinyData({required this.id, required this.name, this.image});
}

class DrugsScheduling {
  final int id;
  final String name;
  final String? image;
  final String doseType;
  final double dose;
  final String status;
  final Alert alert;
  final double quantity;

  const DrugsScheduling(
      {required this.id,
      required this.name,
      this.image,
      required this.doseType,
      required this.dose,
      required this.status,
      required this.alert,
      required this.quantity});
}

class FullDrug extends Drug {
  final NotificationSettings notification;
  final List<Alert> schedule;

  const FullDrug(
      {required super.dose,
      required super.doseType,
      required super.expirationDate,
      required super.name,
      required super.id,
      required super.quantity,
      required super.recurrent,
      required super.status,
      required super.frequency,
      required super.startingTime,
      super.image,
      super.lastDay,
      super.leaflet,
      required this.notification,
      required this.schedule});
}
