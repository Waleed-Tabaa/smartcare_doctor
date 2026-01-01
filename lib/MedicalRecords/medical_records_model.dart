class MedicalRecordModel {
  final int id;
  final int patientId;
  final int doctorId;
  final String visitDate;
  final String notes;
  final String assessment;
  final String plan;

  final String? patientName;
  final String? doctorName;

  MedicalRecordModel({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.visitDate,
    required this.notes,
    required this.assessment,
    required this.plan,
    this.patientName,
    this.doctorName,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      visitDate: json['visit_date'] ?? "",
      notes: json['notes'] ?? "",
      assessment: json['assessment'] ?? "",
      plan: json['plan'] ?? "",
      patientName: json['patient'] != null ? json['patient']['full_name'] : null,
      doctorName: json['doctor'] != null ? json['doctor']['full_name'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "patient_id": patientId,
      "doctor_id": doctorId,
      "visit_date": visitDate,
      "notes": notes,
      "assessment": assessment,
      "plan": plan,
    };
  }
}
