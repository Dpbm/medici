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
      required this.status});

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
      'status': status
    };
  }
}

class DrugsScheduling {
  final int id;
  final int drugId;
  final String time;
  final String name;
  final String? image;
  final String doseType;
  final double dose;
  final String status;

  const DrugsScheduling(
      {required this.id,
      required this.drugId,
      required this.time,
      required this.name,
      this.image,
      required this.doseType,
      required this.dose,
      required this.status});
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
      super.image,
      super.lastDay,
      super.leaflet,
      required this.notification,
      required this.schedule});
}
