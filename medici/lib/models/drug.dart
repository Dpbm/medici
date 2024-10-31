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
      this.leaflet});

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
      'last_day': lastDay
    };
  }
}
