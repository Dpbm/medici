class Alert {
  final int? id;
  final int drugId;
  final String time;

  const Alert({this.id, required this.drugId, required this.time});

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'drug_id': drugId,
      'time': time,
    };
  }
}
