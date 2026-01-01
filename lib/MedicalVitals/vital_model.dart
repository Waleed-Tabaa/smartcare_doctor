class VitalReading {
  final int id;
  final int patientId;
  final String type;
  final String value;
  final String? auxValue;
  final String measuredAt;
  final String source;
  final String? note;

  VitalReading({
    required this.id,
    required this.patientId,
    required this.type,
    required this.value,
    this.auxValue,
    required this.measuredAt,
    required this.source,
    this.note,
  });

  factory VitalReading.fromJson(Map<String, dynamic> json) {
    return VitalReading(
      id: json['id'],
      patientId: json['patient_id'],
      type: json['type'],
      value: json['value'].toString(),
      auxValue: json['aux_value']?.toString(),
      measuredAt: json['measured_at'],
      source: json['source'],
      note: json['note'],
    );
  }
}
