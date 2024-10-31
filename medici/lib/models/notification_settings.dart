const expirationOffsets = ["3", "4", "5"];
const quantityOffsets = ["4", "5", "10"];

class NotificationSettings {
  final int? id;
  final int drugId;
  final int expirationOffset;
  final int quantityOffset;

  const NotificationSettings(
      {this.id,
      required this.drugId,
      required this.expirationOffset,
      required this.quantityOffset});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'drug_id': drugId,
      'expiration_offset': expirationOffset,
      'quantity_offset': quantityOffset
    };
  }
}
